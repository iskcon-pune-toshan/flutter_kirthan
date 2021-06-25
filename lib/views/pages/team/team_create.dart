import 'dart:core';

import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/team/initiate_team_userdetails.dart';
import 'package:flutter_kirthan/views/pages/team/team_local_admin.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:intl/intl.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());
final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());
final TeamUserPageViewModel teamUserPageVM =
TeamUserPageViewModel(apiSvc: TeamUserAPIService());
final TemplePageViewModel templePageVM =
TemplePageViewModel(apiSvc: TempleAPIService());
final UserTemplePageViewModel userTemplePageVM =
UserTemplePageViewModel(apiSvc: UserTempleAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());
int role_id;

class TeamWrite extends StatefulWidget {
  UserRequest userRequest;
  UserRequest localAdmin;

  TeamWrite({Key key, this.userRequest, this.localAdmin}) : super(key: key);

  final String screenName = SCR_TEAM;

  @override
  _TeamWriteState createState() => _TeamWriteState();
}

class _TeamWriteState extends State<TeamWrite> {
  Future<List<UserRequest>> Users;
  int counter = 0;
  String team_title;
  int _currentvalue = 0;
  String currUserEmail;
  String currUserName;
  String currUserRole;
  String country, state;
  FocusNode myFocusNode = new FocusNode();
  List<UserRequest> userList = new List<UserRequest>();
  Future<List<TeamRequest>> Teams;
  List<TeamRequest> teamList = new List<TeamRequest>();
  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    Teams = teamPageVM.getTeamRequests('Approved');
    getRoleId();
    super.initState();
  }

  List<UserRequest> getTeamLeads(
      List<TeamRequest> teamList, List<UserRequest> tempList) {
    List<String> uMail = new List<String>();
    for (var user in teamList) {
      if (user.teamLeadId != null) uMail.add(user.teamLeadId);
    }
    for (var mail in uMail) {
      tempList.removeWhere((element) => element.email == mail);
    }
    return tempList;
  }

  int roleid;
  final FirebaseAuth auth = FirebaseAuth.instance;
  List<UserRequest> userRequest;
  List<UserRequest> userRequestList = List<UserRequest>();
  String email;
  getRoleId() async {
    final FirebaseUser user = await auth.currentUser();
    userRequest = await userPageVM.getUserRequests("Approved");
    for (var users in userRequest) {
      email = user.email;
      if (users.email == user.email) {
        setState(() {
          role_id = users.roleId;
          roleid = role_id;
        });
      }
    }
  }

  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  int currentUserId;
  getUserId() async {
    final FirebaseUser user = await auth.currentUser();
    userList = await userPageVM.getUserRequests("Approved");
    for (var users in userList) {
      // print("Role Id is");
      if (users.email == user.email) {
        setState(() {
          user_id = users.id;
          currentUserId = user_id;
        });
      }
    }
    //print(email);
    // print(role_id.toString());
  }

  getTeamTitle(List<TeamRequest> teamList, String currUserEmail) {
    for (var team in teamList) {
      if (team.teamLeadId == currUserEmail) {
        team_title = team.teamTitle;
      }
    }
  }

  final _formKey = GlobalKey<FormState>();
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
    'Hyderabad',
    'Pune',
    'Mumbai'
  ];
  String _selectedCategory;
  String _selectedLocation;
  String _selectedTeamLeadId;
  String validateMobile(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  Future _showIntegerDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeNotifier>(
            builder: (context, notifier, child) =>
            new NumberPickerDialog.integer(
              selectedTextStyle: TextStyle(
                fontSize: notifier.custFontSize,
                fontWeight: FontWeight.bold,
                color: KirthanStyles.titleColor,
              ),
              textStyle: TextStyle(
                fontSize: notifier.custFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              minValue: 0,
              maxValue: 10,
              initialIntegerValue: _currentvalue,
              title: new Text("Experience: "),
            ));
      },
    ).then(_handleValueChanged);
  }

  _handleValueChanged(num value) {
    if (value != null) {
      if (value is int) {
        setState(() => _currentvalue = value);
      } else {
        setState(() => _currentvalue = value);
      }
    }
  }

  List<String> selectedMembers = new List<String>();
  Widget addmember(int counter) {
    List<TextEditingController> _member =
    new List<TextEditingController>(this.counter);
    return Card(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Column(
          children: [
            for (int i = 0; i < this.counter; i++)
              Container(
                //color: Colors.black26,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      //controller: _member[i],
                      //initialValue: finalTeamUserList[i].userName.toString(),
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          icon: Icon(Icons.people_outline, color: Colors.grey),
                          suffixIcon: i == counter - 1
                              ? InkWell(
                              onTap: () {
                                setState(() {
                                  this.counter--;
                                });
                              },
                              child: Container(
                                child: Icon(Icons.cancel_outlined),
                              ))
                              : null,
                          labelText: "Member " + (i + 1).toString(),
                          hintText: "Please enter the name of the member",
                          labelStyle: TextStyle(
                            fontSize: notifier.custFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),

                      onSaved: (value) {
                        setState(() {
                          selectedMembers.add(value);
                        });
                      },
                      validator: (value) {
                        if (value.trimLeft().isEmpty) {
                          return "Please enter some text";
                        }
                        return null;
                      },
                    ),
                    Divider()
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Do you really want to discard the changes?'),
            actions: <Widget>[
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => App()));
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Scaffold(
          //resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                _onBackPressed();
              },
            ),
            title: Text(
              'Add Team',
              style: TextStyle(
                  color: KirthanStyles.colorPallete60,
                  fontSize: notifier.custFontSize),
            ),
            backgroundColor: KirthanStyles.colorPallete30,
          ),
          body: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Container(
                child: Center(
                  child: Form(
                    // context,
                    key: _formKey,
                    autovalidate: false,
                    // readonly: true,
                    child: Column(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(margin: const EdgeInsets.only(top: 50)),
                        Card(
                          child: Container(
                            //color: Colors.white,
                            padding: new EdgeInsets.all(10),
                            child: TextFormField(
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              style: TextStyle(fontSize: notifier.custFontSize),
                              focusNode: myFocusNode,
                              //attribute: "eventTitle",
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  /*icon: const Icon(
                                    Icons.title,
                                    color: Colors.grey,
                                  ),*/
                                  labelText: "Title",
                                  hintText: "Add a title",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: notifier.custFontSize),
                                  labelStyle: TextStyle(
                                      color: myFocusNode.hasFocus
                                          ? Colors.black
                                          : Colors.grey,
                                      fontSize: notifier.custFontSize)),
                              onSaved: (input) {
                                teamrequest.teamTitle = input;
                              },
                              validator: (value) {
                                if (value.trimLeft().isEmpty) {
                                  return "Please enter some text";
                                }
                                return null;
                              },
                            ),
                          ),
                          elevation: 5,
                        ),
                        Card(
                          child: Container(
                            //color: Colors.white,
                            padding: new EdgeInsets.all(10),
                            child: TextFormField(
                              //controller: title,
                              style: TextStyle(fontSize: notifier.custFontSize),
                              //attribute: "Description",
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  /*icon: const Icon(
                                    Icons.description,
                                    color: Colors.grey,
                                  ),*/
                                  labelText: "Description",
                                  hintText: "Add a description",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: notifier.custFontSize),
                                  labelStyle: TextStyle(
                                    fontSize: notifier.custFontSize,
                                    color: Colors.grey,
                                  )),
                              onSaved: (input) {
                                teamrequest.teamDescription = input;
                              },
                              validator: (value) {
                                if (value.trimLeft().isEmpty) {
                                  return "Please enter some text";
                                }
                                return null;
                              },
                            ),
                          ),
                          elevation: 5,
                        ),
                        //   SizedBox(height: 35),
                        FutureBuilder(
                            future:
                            commonLookupTablePageVM.getCommonLookupTable(
                                "lookupType:Event-type-Category"),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                List<CommonLookupTable> cltList = snapshot.data;
                                List<String> _category = cltList
                                    .map((user) => user.description)
                                    .toSet()
                                    .toList();
                                return Card(
                                  child: Container(
                                    padding: new EdgeInsets.all(10),
                                    child: DropdownButtonFormField<String>(
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize + 10),
                                      value: _selectedCategory,
                                      icon: const Icon(Icons.category),
                                      hint: Text('Select Category',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: notifier.custFontSize)),
                                      items: _category
                                          .map((category) =>
                                          DropdownMenuItem<String>(
                                            value: category,
                                            child: Text(
                                              category,
                                              style: TextStyle(
                                                  fontSize:
                                                  notifier.custFontSize,
                                                  color: notifier.darkTheme
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
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
                                      validator: (value) {
                                        if (value == null) {
                                          return "Please select team category";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                );
                              } else {
                                return Container();
                              }
                            }),
                        Card(
                          child: Container(
                            width: double.infinity,

                            //color: Colors.white,
                            padding: new EdgeInsets.all(10),
                            child: SizedBox(
                                width: double.infinity,
                                child: Consumer<ThemeNotifier>(
                                    builder: (context, notifier, child) =>
                                        FlatButton(
                                          focusColor: myFocusNode.hasFocus
                                              ? Colors.black
                                              : Colors.grey,
                                          focusNode: myFocusNode,
                                          onPressed: () => _showIntegerDialog(),
                                          child: new Align(
                                            alignment: Alignment.bottomLeft,
                                            child: new Text(
                                                "Team Experience: $_currentvalue",
                                                style: TextStyle(
                                                  fontSize:
                                                  notifier.custFontSize,
                                                  fontWeight: FontWeight.bold,
                                                  //color: KirthanStyles.colorPallete60
                                                )),
                                          ),
                                        )) // color: Colors.grey,
                            ),
                            /*TextFormField(
                            //attribute: "Description",

                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                */ /*icon: const Icon(
                                  Icons.description,
                                  color: Colors.grey,
                                ),*/ /*
                                labelText: "Experience",
                                hintText: "Add Experience",
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
                          ),*/
                          ),
                          elevation: 5,
                        ),
                        Card(
                          child: Container(
                            //color: Colors.white,
                            padding: new EdgeInsets.all(10),
                            child: TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                style:
                                TextStyle(fontSize: notifier.custFontSize),
                                //attribute: "Description",
                                keyboardType: TextInputType.number,
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
                                    labelText: "Phone Number",
                                    hintText: "Add Phone Number",
                                    hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: notifier.custFontSize),
                                    labelStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: notifier.custFontSize)),
                                onSaved: (input) {
                                  teamrequest.phoneNumber = int.parse(input);
                                },
                                validator: validateMobile
                              //     (value) {
                              //   if (value.isEmpty) {
                              //     return "Please enter some text";
                              //   }
                              //   return null;
                              // },
                            ),
                          ),
                          elevation: 5,
                        ),
                        // SizedBox(
                        //    height: 30,
                        //  ),
                        Column(
                          children: <Widget>[
                            /* FutureBuilder<List<TeamRequest>>(
                              future: teamPageVM.getTeamRequests("Approved"),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<TeamRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  List<TeamRequest> teamListAppr =
                                      snapshot.data;
                                  return role_id == 3
                                      ? Card(
                                    child: Container(
                                      //color: Colors.white,
                                      padding: new EdgeInsets.all(10),
                                      child: TextFormField(
                                        style: TextStyle(
                                            fontSize: notifier.custFontSize),
                                        //attribute: "Description",
                                        // keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                            enabledBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder:
                                            UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            /*icon: const Icon(
                                Icons.description,
                                color: Colors.grey,
                              ),*/
                                            enabled: false,
                                            labelText: "TeamLead",
                                            hintText: email,
                                            hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: notifier
                                                    .custFontSize
                                            ),
                                            labelStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: notifier
                                                    .custFontSize
                                            )),
                                        initialValue: email,
                                        onSaved: (input) {
                                          teamrequest.teamLeadId =
                                              email;
                                        },
                                        //     (value) {
                                        //   if (value.isEmpty) {
                                        //     return "Please enter some text";
                                        //   }
                                        //   return null;
                                        // },
                                      ),
                                    ),
                                    elevation: 5,
                                  )

                                 : Container();

                                }
                              }),*/

                            FutureBuilder(
                                future: getEmail(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    currUserEmail = snapshot.data.toString();
                                    return FutureBuilder<List<UserRequest>>(
                                        future: Users,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<UserRequest>>
                                            snapshot) {
                                          if (snapshot.data != null) {
                                            userList = snapshot.data
                                                .where((element) =>
                                            element.email ==
                                                currUserEmail)
                                                .toList();
                                            for (var username in userList) {
                                              currUserName = username.fullName;
                                              return FutureBuilder<
                                                  List<TeamRequest>>(
                                                  future: Teams,
                                                  builder: (context, snapshot) {
                                                    if (snapshot.data != null) {
                                                      teamList = snapshot.data;
                                                      getTeamTitle(teamList,
                                                          currUserEmail);
                                                    }
                                                    return Card(
                                                      child: Container(
                                                        height: 90,
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width,
                                                        padding:
                                                        new EdgeInsets.all(
                                                            10),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              Text("Team Lead",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .grey,
                                                                      fontSize:
                                                                      notifier
                                                                          .custFontSize)),
                                                              SizedBox(
                                                                height: 10,
                                                              ),
                                                              Text(
                                                                  currUserEmail,
                                                                  textAlign:
                                                                  TextAlign
                                                                      .left,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      notifier
                                                                          .custFontSize)),
                                                            ]),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white)),
                                                      ),
                                                      elevation: 5,
                                                    );
                                                  });
                                            }
                                          }
                                          return Container();
                                        });
                                  }

                                  return Container();
                                }),

                            // DropdownButtonFormField<String>(
                            //   value: _selectedWeekday,
                            //   icon: const Icon(Icons.calendar_today_rounded),
                            //   hint: Text(
                            //     'Select weekday ',
                            //     style: TextStyle(color: Colors.grey),
                            //   ),
                            //   items: _weekday
                            //       .map((weekday) => DropdownMenuItem(
                            //             value: weekday,
                            //             child: Text(weekday),
                            //           ))
                            //       .toList(),
                            //   onChanged: (input) {
                            //     setState(() {
                            //       _selectedWeekday = input;
                            //     });
                            //   },
                            //   onSaved: (input) {
                            //     teamrequest.weekDay = input;
                            //   },
                            // ),

                            /*Card(
                            child: Container(
                              //padding: new EdgeInsets.all(10),
                              child: DropdownButtonFormField<String>(
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
                                validator: (value) {
                                  if (value == null) {
                                    return "Please select location";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),*/
                            Container(
                              padding: EdgeInsets.all(30.0),
                              //TODO:added search bar
                              child: CSCPicker(
                                disabled: notifier.darkTheme ? false : true,
                                onCountryChanged: (value) {
                                  setState(() {
                                    country = value;
                                  });
                                },
                                onStateChanged: (value) {
                                  setState(() {
                                    state = value;
                                  });
                                },
                                onCityChanged: (value) {
                                  setState(() {
                                    teamrequest.location = value;
                                  });
                                },
                              ),
                            ),
                            TextFormField(
                              style: TextStyle(fontSize: notifier.custFontSize),
                              autovalidateMode:
                              AutovalidateMode.onUserInteraction,
                              readOnly: true,
                              decoration: InputDecoration(
                                isCollapsed: true,
                                errorBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide:
                                  BorderSide(color: Colors.transparent),
                                ),
                              ),
                              validator: (value) {
                                if (teamrequest.location == null) {
                                  if (state == null) {
                                    if (country == null) {
                                      return "Please select country, state & city";
                                    }
                                    return "Please select state & city";
                                  }
                                  return "Please select city";
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 35,
                            ),

                            addmember(counter),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            new Container(
                                margin: const EdgeInsets.only(top: 40)),
                            RaisedButton.icon(
                              label: Text(
                                'Add team members',
                                style:
                                TextStyle(fontSize: notifier.custFontSize),
                              ),
                              icon: const Icon(Icons.add_circle),
                              color: Colors.green,
                              onPressed: () {
//addmember();
                                setState(() {
                                  counter++;
                                });
                              },
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                MaterialButton(
                                  color: Colors.white,
                                  child: Text(
                                    "Cancel",
                                    style: TextStyle(
                                        fontSize: notifier.custFontSize),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                MaterialButton(
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: notifier.custFontSize),
                                    ),
                                    color: KirthanStyles.colorPallete30,
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        final FirebaseAuth auth =
                                            FirebaseAuth.instance;
                                        final FirebaseUser user =
                                        await auth.currentUser();
                                        final String email = user.email;
                                        List<CommonLookupTable>
                                        selectedCategory =
                                        await commonLookupTablePageVM
                                            .getCommonLookupTable(
                                            "description:" +
                                                _selectedCategory);
                                        for (var i in selectedCategory)
                                          teamrequest.category = i.id;
                                        String dt = DateFormat(
                                            "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                            .format(DateTime.now());
                                        _formKey.currentState.save();
                                        final String teamTitle =
                                            teamrequest.teamTitle;
                                        //teamrequest.isProcessed = false;
                                        teamrequest.createdBy = email;
                                        //print(teamrequest.createdBy);
                                        teamrequest.createdTime = dt;
                                        teamrequest.updatedBy = null;
                                        teamrequest.updatedTime = null;
                                        teamrequest.teamLeadId = currUserEmail;
                                        setState(() {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                widget.userRequest == null
                                                    ? TeamLocalAdmin(
                                                  teamrequest:
                                                  teamrequest,
                                                  selectedMembers:
                                                  selectedMembers,
                                                  user: null,
                                                )
                                                    : TeamLocalAdmin(
                                                  teamrequest:
                                                  teamrequest,
                                                  selectedMembers:
                                                  selectedMembers,
                                                  user: widget
                                                      .localAdmin,
                                                )),
                                          );
                                        });
                                      }
                                      //String s = jsonEncode(userrequest.mapToJson());
                                      //service.registerUser(s);
                                      //print(s);
                                    }),
                                /*MaterialButton(
                          child: Text("Reset",style: TextStyle(color:
Colors.white),),
                          color: Colors.pink,
                          onPressed: () {
                            _fbKey.currentState.reset();
                          },
                        ),*/
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

/* : FutureBuilder<List<TeamRequest>>(
                                        future: teamPageVM
                                            .getTeamRequests("Approved"),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<TeamRequest>>
                                            snapshot) {
                                          if (snapshot.data != null) {
                                            List<TeamRequest> teamList =
                                                teamListAppr + snapshot.data;


                                            return FutureBuilder<
                                                List<TeamRequest>>(
                                                future: Teams,
                                                builder: (BuildContext
                                                context,
                                                    AsyncSnapshot<
                                                        List<TeamRequest>>
                                                    snapshot) {
                                                  if (snapshot.data != null) {
                                                    List<TeamRequest>
                                                    tempUserList =
                                                    new List<
                                                        TeamRequest>();
                                                    if (teamrequest.teamLeadId ==
                                                        null) {
                                                      tempUserList =
                                                          snapshot.data;
                                                    } else if (teamList
                                                        .where((element) =>
                                                    element
                                                        .teamLeadId ==
                                                        teamrequest.teamLeadId)
                                                        .toList()
                                                        .isEmpty) {
                                                     // tempUserList.add(
                                                    //      widget.userRequest);
                                                      _selectedTeamLeadId =
                                                          teamrequest.teamLeadId;
                                                              //.email;
                                                    }
                                                  /*  userList = getTeamLeads(
                                                        teamList,
                                                        tempUserList);*/
                                                    List<String> teamLeadId =
                                                    teamList
                                                        .map((teamLeadId) =>
                                                        teamLeadId.teamLeadId)
                                                        .toSet()
                                                        .toList();
                                                    return DropdownButtonFormField<
                                                        String>(

                                                      value: teamrequest.teamLeadId ==
                                                          null
                                                          ? _selectedTeamLeadId
                                                          : teamrequest.teamLeadId,
                                                        //  .email,
                                                      icon: const Icon(Icons
                                                          .account_circle),
                                                      hint: Text(
                                                          'Select Team Lead Id',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .grey)),
                                                      items: teamLeadId
                                                          .map((teamLeadId) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                            value:
                                                            teamLeadId,
                                                            child: Text(
                                                              teamLeadId,style: TextStyle(fontSize: notifier.custFontSize),),
                                                          ))
                                                          .toList(),
                                                      onChanged: (input) {
                                                        setState(() {
                                                          _selectedTeamLeadId =
                                                              input;
                                                        });
                                                      },
                                                      onSaved: (input) {
                                                        teamrequest
                                                            .teamLeadId =
                                                            input;
                                                      },
                                                      validator: (value) {
                                                        if (value == null) {
                                                          return "Please select team lead";
                                                        }
                                                        return null;
                                                      },
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    Text(
                                                        "You already have a team");
                                                  }
                                                  return Container();
                                                });
                                          }
                                          return Container();
                                        });
                                  }*/
