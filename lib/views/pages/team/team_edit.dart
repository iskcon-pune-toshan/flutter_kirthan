import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:intl/intl.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
    CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

class EditTeam extends StatefulWidget {
  TeamRequest teamrequest;
  final String screenName = SCR_TEAM;

  EditTeam({Key key, @required this.teamrequest}) : super(key: key);

  @override
  _EditTeamState createState() => new _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();

  List<String> _location = [
    'Kant',
    'Adilabad',
    'Delhi',
    'Ahmednagar',
    'Anantapur',
    'Chittoor',
    'Kakinada',
    'Guntur',
    'Hyderabad'
  ];

  List<String> _teamLeadId = [];
  String _selectedCategory;
  String _selectedLocation;
  String _selectedTeamLeadId;

  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  final TextEditingController _teamTitleController =
      new TextEditingController();
  String teamTitle;
  final TextEditingController _teamDescriptionController =
      new TextEditingController();
  String teamDescription;
  final TextEditingController _teamupdatedBy = new TextEditingController();
  String teamupdatedBy;
  final TextEditingController _teamExperienceController =
      new TextEditingController();
  String teamExperience;
  final TextEditingController _teamPhoneNumberController =
      new TextEditingController();
  String teamPhoneNumber;
  final TextEditingController _availableTimeFromController =
      new TextEditingController();
  String availableTimeFrom;
  final TextEditingController _availableTimeToController =
      new TextEditingController();
  String availableTimeTo;

  @override
  void initState() {
    _teamTitleController.text = widget.teamrequest.teamTitle;
    _teamDescriptionController.text = widget.teamrequest.teamDescription;
    _teamExperienceController.text = widget.teamrequest.experience;
    _teamPhoneNumberController.text = widget.teamrequest.phoneNumber.toString();
    _teamupdatedBy.text = getCurrentUser().toString();
    // _availableTimeFromController.text = widget.teamrequest.availableFrom;
    // _availableTimeToController.text = widget.teamrequest.availableTo;
    return super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    widget.teamrequest.updatedBy = email;
    print(email);
    return email;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final DateTime today = new DateTime.now();
    return new Scaffold(
        appBar:
            new AppBar(title: const Text('Edit Profile'), actions: <Widget>[]),
        body: new Form(
            key: _formKey,
            autovalidate: true,
            //onWillPop: _warnUserAboutInvalidData,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "TeamTitle",
                        hintText: "What do people call this event?",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    controller: _teamTitleController,
                    onSaved: (String value) {
                      widget.teamrequest.teamTitle = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Description",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    controller: _teamDescriptionController,
                    onSaved: (String value) {
                      widget.teamrequest.teamDescription = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Experience",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    controller: _teamExperienceController,
                    onSaved: (String value) {
                      widget.teamrequest.experience = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Phone Number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    controller: _teamPhoneNumberController,
                    onSaved: (String value) {
                      widget.teamrequest.phoneNumber = int.parse(value);
                    },
                  ),
                ),
                // new Container(
                //   child: new TextFormField(
                //     decoration: const InputDecoration(
                //         enabledBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.grey),
                //         ),
                //         focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.green),
                //         ),
                //         labelText: "Available Time (From)",
                //         hintStyle: TextStyle(
                //           color: Colors.grey,
                //         ),
                //         labelStyle: TextStyle(
                //           color: Colors.grey,
                //         )),
                //     autocorrect: false,
                //     controller: _availableTimeFromController,
                //     onSaved: (String value) {
                //       widget.teamrequest.availableFrom = value;
                //     },
                //   ),
                // ),
                // new Container(
                //   child: new TextFormField(
                //     decoration: const InputDecoration(
                //         enabledBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.grey),
                //         ),
                //         focusedBorder: UnderlineInputBorder(
                //           borderSide: BorderSide(color: Colors.green),
                //         ),
                //         labelText: "Available Time (To)",
                //         hintStyle: TextStyle(
                //           color: Colors.grey,
                //         ),
                //         labelStyle: TextStyle(
                //           color: Colors.grey,
                //         )),
                //     autocorrect: false,
                //     controller: _availableTimeToController,
                //     onSaved: (String value) {
                //       widget.teamrequest.availableTo = value;
                //     },
                //   ),
                // ),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                  child: Column(
                    children: <Widget>[
                      DropdownButtonFormField<String>(
                        value: _selectedTeamLeadId,
                        icon: const Icon(Icons.account_circle),
                        hint: Text('Select Team Lead Id',
                            style: TextStyle(color: Colors.grey)),
                        items: _teamLeadId
                            .map((teamLeadId) => DropdownMenuItem<String>(
                                  value: teamLeadId,
                                  child: Text(teamLeadId),
                                ))
                            .toList(),
                        onChanged: (input) {
                          setState(() {
                            _selectedTeamLeadId = input;
                          });
                        },
                        onSaved: (input) {
                          teamrequest.teamLeadId = input;
                        },
                      ),
                      SizedBox(height: 35),
                      FutureBuilder(
                          future: commonLookupTablePageVM.getCommonLookupTable(
                              "lookupType:Event-type-Category"),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              List<CommonLookupTable> cltList = snapshot.data;
                              List<CommonLookupTable> currCategory = cltList
                                  .where((element) =>
                                      element.id == teamrequest.category)
                                  .toList();

                              for (var i in currCategory) {
                                _selectedCategory = i.description;
                              }
                              List<String> _category = cltList
                                  .map((user) => user.description)
                                  .toSet()
                                  .toList();
                              return DropdownButtonFormField<String>(
                                value: _selectedCategory,
                                icon: const Icon(Icons.category),
                                hint: Text('Select Category',
                                    style: TextStyle(color: Colors.grey)),
                                items: _category
                                    .map((category) => DropdownMenuItem<String>(
                                          value: category,
                                          child: Text(category),
                                        ))
                                    .toList(),
                                onChanged: (input) {
                                  setState(() {
                                    _selectedCategory = input;
                                  });
                                },
                                onSaved: (input) {
                                  _selectedCategory = input;
                                },
                              );
                            } else {
                              return Container();
                            }
                          }),
                      SizedBox(height: 35),
                      DropdownButtonFormField<String>(
                        value: _selectedLocation,
                        icon: const Icon(Icons.location_city),
                        hint: Text('Select Location',
                            style: TextStyle(color: Colors.grey)),
                        items: _location
                            .map((location) => DropdownMenuItem(
                                  value: location,
                                  child: Text(location),
                                ))
                            .toList(),
                        onChanged: (input) {
                          setState(() {
                            _selectedLocation = input;
                          });
                        },
                        onSaved: (input) {
                          teamrequest.location = input;
                        },
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.blueGrey,
                      child: Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Container(
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
                        child: new MaterialButton(
                          color: Colors.blue,
                          textColor: themeData.secondaryHeaderColor,
                          child: new Text('Save'),
                          onPressed: () async {
                            // _handleSubmitted();
                            List<CommonLookupTable> selectedCategory =
                                await commonLookupTablePageVM
                                    .getCommonLookupTable(
                                        "description:" + _selectedCategory);
                            for (var i in selectedCategory)
                              teamrequest.category = i.id;
                            _formKey.currentState.save();
                            Navigator.pop(context);
                            print(widget.teamrequest.teamTitle);
                            print(widget.teamrequest.teamDescription);
                            String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                .format(DateTime.now());

                            _teamupdatedBy.text =
                                widget.teamrequest.updatedTime = dt;

                            String teamrequestStr =
                                jsonEncode(widget.teamrequest.toStrJson());
                            teamPageVM.submitUpdateTeamRequest(teamrequestStr);
                            //apiSvc?.submitUpdateTeamRequest
                            (teamrequestStr);
                          },
                        )),
                  ],
                ),
              ],
            )));
  }
}
