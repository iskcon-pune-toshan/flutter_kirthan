import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/team/team_local_admin.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class TeamWrite extends StatefulWidget {
  TeamWrite({Key key}) : super(key: key);

  final String screenName = SCR_TEAM;

  @override
  _TeamWriteState createState() => _TeamWriteState();
}

class _TeamWriteState extends State<TeamWrite> {
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();

  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    super.initState();
  }

  List<UserRequest> selectedUsers;

  final _formKey = GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();

  List<String> _category = [
    'Bhajan',
    'Kirthan',
    'Bhajan & Kirthan',
    'Dance',
    'Music',
    'Lecture'
  ];

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
  List<String> _weekday = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
    'Anyday'
  ];
  List<String> _availableTime = [
    'Before 7am'
        '7am - 10am',
    '10am - 12pm',
    '12pm - 3pm',
    '3pm - 6pm',
    '6pm - 9pm',
    'After 9pm'
  ];
  String _selectedCategory;
  String _selectedAvailableTime;
  String _selectedWeekday;
  String _selectedLocation;
  String _selectedTeamLeadId;
  String _selectedTeamMember1;
  String _selectedTeamMember2;
  String _selectedTeamMember3;
  String _selectedTeamMember4;
  String _selectedTeamMember5;
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

  Widget addMember() {
    //Divider();
    String _selectedTeamMembernew;
    return Column(
      children: [
        SizedBox(
          height: 35,
        ),
        FutureBuilder<List<UserRequest>>(
            future: Users,
            builder: (BuildContext context,
                AsyncSnapshot<List<UserRequest>> snapshot) {
              if (snapshot.data != null) {
                userList = snapshot.data;
                List<String> _teamMember =
                    userList.map((user) => user.userName).toSet().toList();
                print(userList);
                DropdownButtonFormField<String>(
                  value: _selectedTeamMembernew,
                  icon: const Icon(Icons.account_circle),
                  hint: Text('Select Team Member',
                      style: TextStyle(color: Colors.grey)),
                  items: _teamMember
                      .map((teamMember) => DropdownMenuItem<String>(
                            value: teamMember,
                            child: Text(teamMember),
                          ))
                      .toList(),
                  onChanged: (input) {
                    setState(() {
                      _selectedTeamMembernew = input;
                    });
                  },
                  // onSaved: (input) {
                  //   teamrequest.teamMember = input ;
                  // },
                );
              }
              return Container();
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
        title: Text(
          'Add Team',
          style: TextStyle(color: KirthanStyles.colorPallete60),
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
                autovalidate: true,
                // readonly: true,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(margin: const EdgeInsets.only(top: 50)),
                    Card(
                      child: Container(
                        //color: Colors.white,
                        padding: new EdgeInsets.all(10),
                        child: TextFormField(
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
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            teamrequest.teamTitle = input;
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
                    Card(
                      child: Container(
                        //color: Colors.white,
                        padding: new EdgeInsets.all(10),
                        child: TextFormField(
                          //attribute: "Description",

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
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            teamrequest.teamDescription = input;
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
                    Card(
                      child: Container(
                        //color: Colors.white,
                        padding: new EdgeInsets.all(10),
                        child: TextFormField(
                          //attribute: "Description",

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
                        ),
                      ),
                      elevation: 5,
                    ),
                    Card(
                      child: Container(
                        //color: Colors.white,
                        padding: new EdgeInsets.all(10),
                        child: TextFormField(
                            //attribute: "Description",

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
                                labelText: "Phone Number",
                                hintText: "Add Phone Number",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                )),
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
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: <Widget>[
                          FutureBuilder<List<UserRequest>>(
                              future: Users,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  userList = snapshot.data;
                                  List<String> teamLeadId = userList
                                      .map((user) => user.email)
                                      .toSet()
                                      .toList();

                                  return DropdownButtonFormField<String>(
                                    value: _selectedTeamLeadId,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Team Lead Id',
                                        style: TextStyle(color: Colors.grey)),
                                    items: teamLeadId
                                        .map((teamLeadId) =>
                                            DropdownMenuItem<String>(
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
                                  );
                                }
                                return Container();
                              }),
                          SizedBox(height: 35),
                          DropdownButtonFormField<String>(
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
                              teamrequest.category = input;
                            },
                          ),
                          SizedBox(height: 35),
                          DropdownButtonFormField<String>(
                            value: _selectedWeekday,
                            icon: const Icon(Icons.calendar_today_rounded),
                            hint: Text(
                              'Select weekday ',
                              style: TextStyle(color: Colors.grey),
                            ),
                            items: _weekday
                                .map((weekday) => DropdownMenuItem(
                                      value: weekday,
                                      child: Text(weekday),
                                    ))
                                .toList(),
                            onChanged: (input) {
                              setState(() {
                                _selectedWeekday = input;
                              });
                            },
                            onSaved: (input) {
                              teamrequest.weekDay = input;
                            },
                          ),
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
                          SizedBox(
                            height: 35,
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedAvailableTime,
                            icon: const Icon(Icons.timer),
                            hint: Text('Select Available Time',
                                style: TextStyle(color: Colors.grey)),
                            items: _availableTime
                                .map((availableTime) => DropdownMenuItem(
                                      value: availableTime,
                                      child: Text(availableTime),
                                    ))
                                .toList(),
                            onChanged: (input) {
                              setState(() {
                                _selectedAvailableTime = input;
                              });
                            },
                            onSaved: (input) {
                              teamrequest.availableTime = input;
                            },
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          FutureBuilder<List<UserRequest>>(
                              future: Users,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  userList = snapshot.data;
                                  List<String> _teamMember = userList
                                      .map((user) => user.userName)
                                      .toSet()
                                      .toList();
                                  print(userList);
                                  return DropdownButtonFormField<String>(
                                    value: _selectedTeamMember1,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Team Member 1',
                                        style: TextStyle(color: Colors.grey)),
                                    items: _teamMember
                                        .map((teamMember) =>
                                            DropdownMenuItem<String>(
                                              value: teamMember,
                                              child: Text(teamMember),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedTeamMember1 = input;
                                        selectedUsers = userList
                                            .where((element) =>
                                                element.userName ==
                                                _selectedTeamMember1)
                                            .toList();
                                      });
                                    },
                                    // onSaved: (input) {
                                    //   teamrequest.teamMember = input  ;
                                    // },
                                  );
                                }
                                return Container();
                              }),
                          SizedBox(
                            height: 35,
                          ),
                          FutureBuilder<List<UserRequest>>(
                              future: Users,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  userList = snapshot.data;
                                  List<String> _teamMember = userList
                                      .map((user) => user.userName)
                                      .toSet()
                                      .toList();
                                  print(userList);
                                  return DropdownButtonFormField<String>(
                                    value: _selectedTeamMember2,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Team Member 2',
                                        style: TextStyle(color: Colors.grey)),
                                    items: _teamMember
                                        .map((teamMember) =>
                                            DropdownMenuItem<String>(
                                              value: teamMember,
                                              child: Text(teamMember),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedTeamMember2 = input;
                                        selectedUsers = selectedUsers +
                                            userList
                                                .where((element) =>
                                                    element.userName ==
                                                    _selectedTeamMember2)
                                                .toList();
                                      });
                                    },
                                    // onSaved: (input) {
                                    //   teamrequest.teamMember = input ;
                                    // },
                                  );
                                }
                                return Container();
                              }),
                          SizedBox(
                            height: 35,
                          ),
                          FutureBuilder<List<UserRequest>>(
                              future: Users,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  userList = snapshot.data;
                                  List<String> _teamMember = userList
                                      .map((user) => user.userName)
                                      .toSet()
                                      .toList();
                                  print(userList);
                                  return DropdownButtonFormField<String>(
                                    value: _selectedTeamMember3,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Team Member 3',
                                        style: TextStyle(color: Colors.grey)),
                                    items: _teamMember
                                        .map((teamMember) =>
                                            DropdownMenuItem<String>(
                                              value: teamMember,
                                              child: Text(teamMember),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedTeamMember3 = input;
                                        selectedUsers = selectedUsers +
                                            userList
                                                .where((element) =>
                                                    element.userName ==
                                                    _selectedTeamMember3)
                                                .toList();
                                      });
                                    },
                                    // onSaved: (input) {
                                    //   teamrequest.teamMember = input  ;
                                    // },
                                  );
                                }
                                return Container();
                              }),
                          SizedBox(
                            height: 35,
                          ),
                          FutureBuilder<List<UserRequest>>(
                              future: Users,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  userList = snapshot.data;
                                  List<String> _teamMember = userList
                                      .map((user) => user.userName)
                                      .toSet()
                                      .toList();
                                  print(userList);
                                  return DropdownButtonFormField<String>(
                                    value: _selectedTeamMember4,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Team Member 4',
                                        style: TextStyle(color: Colors.grey)),
                                    items: _teamMember
                                        .map((teamMember) =>
                                            DropdownMenuItem<String>(
                                              value: teamMember,
                                              child: Text(teamMember),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedTeamMember4 = input;
                                        selectedUsers = selectedUsers +
                                            userList
                                                .where((element) =>
                                                    element.userName ==
                                                    _selectedTeamMember4)
                                                .toList();
                                      });
                                    },
                                    // onSaved: (input) {
                                    //   teamrequest.teamMember = input ;
                                    // },
                                  );
                                }
                                return Container();
                              }),
                          SizedBox(
                            height: 35,
                          ),
                          FutureBuilder<List<UserRequest>>(
                              future: Users,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  userList = snapshot.data;
                                  List<String> _teamMember = userList
                                      .map((user) => user.userName)
                                      .toSet()
                                      .toList();
                                  print(userList);
                                  return DropdownButtonFormField<String>(
                                    value: _selectedTeamMember5,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Team Member 5',
                                        style: TextStyle(color: Colors.grey)),
                                    items: _teamMember
                                        .map((teamMember) =>
                                            DropdownMenuItem<String>(
                                              value: teamMember,
                                              child: Text(teamMember),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedTeamMember5 = input;
                                        selectedUsers = selectedUsers +
                                            userList
                                                .where((element) =>
                                                    element.userName ==
                                                    _selectedTeamMember5)
                                                .toList();
                                      });
                                    },
                                    // onSaved: (input) {
                                    //   teamrequest.teamMember = input ;
                                    // },
                                  );
                                }
                                return Container();
                              }),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // memberCount.length == 0
                        //     ? new ListView.builder(
                        //         itemCount: dynamicList.length,
                        //         itemBuilder: (_, index) => dynamicList[index],
                        //       )
                        //     : Text("Failed"),
                        RaisedButton.icon(
                          label: Text('Add'),
                          icon: const Icon(Icons.add_circle),
                          color: Colors.green,
                          onPressed: () {
                            setState(() {
                              return addMember();
                            });
                          },
                        ),
                        new Container(margin: const EdgeInsets.only(top: 40)),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            MaterialButton(
                              color: Colors.white,
                              child: Text("Cancel"),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                            MaterialButton(
                                child: Text(
                                  "Next",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: KirthanStyles.colorPallete30,
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    final FirebaseAuth auth =
                                        FirebaseAuth.instance;
                                    final FirebaseUser user =
                                        await auth.currentUser();
                                    final String email = user.email;
                                    List<TeamUser> listofTeamUsers =
                                        new List<TeamUser>();
                                    for (var user in selectedUsers) {
                                      TeamUser teamUser = new TeamUser();
                                      teamUser.userId = user.id;
                                      teamUser.teamId = teamrequest.id;
                                      teamUser.userName = user.userName;
                                      teamUser.createdBy = "SYSTEM";
                                      String dt = DateFormat(
                                              "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                          .format(DateTime.now());
                                      teamUser.createdTime = dt;
                                      teamUser.updatedBy = "SYSTEM";
                                      teamUser.updatedTime = dt;
                                      listofTeamUsers.add(teamUser);
                                    }
                                    print(listofTeamUsers);
                                    String dt =
                                        DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                            .format(DateTime.now());
                                    _formKey.currentState.save();

                                    final String teamTitle =
                                        teamrequest.teamTitle;
                                    teamrequest.isProcessed = false;
                                    teamrequest.createdBy = email;
                                    print(teamrequest.createdBy);
                                    teamrequest.createdTime = dt;
                                    teamrequest.updatedBy = null;
                                    teamrequest.updatedTime = null;
                                    teamrequest.approvalStatus = "approved";
                                    teamrequest.approvalComments =
                                        "Approved$teamTitle";
                                    teamrequest.listOfTeamMembers =
                                        listofTeamUsers;
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeamLocalAdmin(
                                                    teamrequest: teamrequest)),
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
    );
  }
}
