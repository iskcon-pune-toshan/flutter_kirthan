import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:intl/intl.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

final CommonLookupTablePageViewModel commonLookupTablePageVM =
    CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

class description_profile extends StatefulWidget {
  @override
  _description_profileState createState() => _description_profileState();
}

class _description_profileState extends State<description_profile> {
  String _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
      body: FutureBuilder(
          future: getEmail(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              String email = snapshot.data;
              return FutureBuilder(
                  future: teamPageVM.getTeamRequests("teamLead:" + email),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      List<TeamRequest> teamList = snapshot.data;
                      if (teamList.isNotEmpty) {
                        for (var u in teamList) {
                          teamrequest = u;
                        }
                        return Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Form(
                            key: _formKey,
                            autovalidate: true,
                            child: Column(
                              children: [
                                Card(
                                  child: Container(
                                    //color: Colors.black26,
                                    padding: const EdgeInsets.all(10),
                                    child: Consumer<ThemeNotifier>(
                                      builder: (context, notifier, child) =>
                                          TextFormField(
                                        initialValue:
                                            teamrequest.teamDescription,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          labelText: "Enter team description",
                                          hintText:
                                              "Please enter the team description",
                                          labelStyle: TextStyle(
                                              fontSize: notifier.custFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return "Enter valid description";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                FutureBuilder(
                                    future: commonLookupTablePageVM
                                        .getCommonLookupTable(
                                            "lookupType:Event-type-Category"),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        List<CommonLookupTable> cltList =
                                            snapshot.data;
                                        List<CommonLookupTable> currCategory =
                                            cltList
                                                .where((element) =>
                                                    element.id ==
                                                    teamrequest.category)
                                                .toList();
                                        for (var i in currCategory) {
                                          _selectedCategory = i.description;
                                        }

                                        List<String> _category = cltList
                                            .map((user) => user.description)
                                            .toSet()
                                            .toList();
                                        return Padding(
                                          padding: EdgeInsets.only(
                                              bottom: 20.0,
                                              top: 20.0,
                                              left: 10.0,
                                              right: 10.0),
                                          child:
                                              DropdownButtonFormField<String>(
                                            value: _selectedCategory,
                                            //icon: const Icon(Icons.category),
                                            hint: Text('Select Category',
                                                style: TextStyle(
                                                    color: Colors.grey)),
                                            items: _category
                                                .map((category) =>
                                                    DropdownMenuItem<String>(
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
                                          ),
                                        );
                                      } else if (snapshot.hasError) {
                                        return Container();
                                      } else {
                                        return Container(
                                          padding: new EdgeInsets.all(10),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: Text(
                                                      "It seems like you don't have a team.")),
                                              Center(
                                                  child: Text(
                                                      "Click on the button below to create one")),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              FlatButton(
                                                textColor: KirthanStyles
                                                    .colorPallete60,
                                                color: KirthanStyles
                                                    .colorPallete30,
                                                child: Text("Create team"),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              TeamWrite(
                                                                userRequest:
                                                                    null,
                                                                localAdmin:
                                                                    null,
                                                              )));
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    }),
                                Card(
                                  child: Container(
                                    padding: new EdgeInsets.all(10),
                                    child: TextFormField(
                                      initialValue: teamrequest.experience,
                                      decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.green),
                                          ),
                                          /*icon: const Icon(
                                Icons.description,
                                color: Colors.grey,
                              ),*/
                                          labelText: "Experience",
                                          hintText: "Add experience",
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                          labelStyle: TextStyle(
                                            color: Colors.grey,
                                          )),
                                      onSaved: (input) {
                                        teamrequest.experience = input;
                                      },
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return "Please enter some text";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  elevation: 5,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Divider(
                                      thickness: 100.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: RaisedButton(
                                          color: KirthanStyles.colorPallete30,
                                          child: Text('Submit'),
                                          onPressed: () async {
                                            if (_formKey.currentState
                                                .validate()) {
                                              _formKey.currentState.save();
                                              List<CommonLookupTable>
                                                  selectedCategory =
                                                  await commonLookupTablePageVM
                                                      .getCommonLookupTable(
                                                          "description:" +
                                                              _selectedCategory);
                                              for (var i in selectedCategory) {
                                                teamrequest.category = i.id;
                                              }
                                              String dt = DateFormat(
                                                      "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                                  .format(DateTime.now());
                                              teamrequest.updatedTime = dt;
                                              teamrequest.updatedBy = email;
                                              String teamrequestStr =
                                                  jsonEncode(
                                                      teamrequest.toStrJson());
                                              teamPageVM
                                                  .submitUpdateTeamRequest(
                                                      teamrequestStr);
                                              SnackBar mysnackbar = SnackBar(
                                                content: Text(
                                                    "Team details updated $successful"),
                                                duration:
                                                    new Duration(seconds: 4),
                                                backgroundColor: Colors.green,
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(mysnackbar);
                                            }
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(width: 2)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: RaisedButton(
                                          color: Colors.redAccent,
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                              side: BorderSide(width: 2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: new EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                      "It seems like you don't have a team.")),
                              Center(
                                  child: Text(
                                      "Click on the button below to create one")),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton(
                                textColor: KirthanStyles.colorPallete60,
                                color: KirthanStyles.colorPallete30,
                                child: Text("Create team"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TeamWrite(
                                                userRequest: null,
                                                localAdmin: null,
                                              )));
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return Container();
                  });
            }
            return Container();
          }),
    );
  }
}
