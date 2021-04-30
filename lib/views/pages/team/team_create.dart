import 'dart:core';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
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
  String _selectedCategory;
  String _selectedWeekday;
  String _selectedLocation;
  String _selectedTeamLeadId;
  String _selectedTeamMember1;
  String _selectedTeamMember2;
  String _selectedTeamMember3;
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

  //check if user in User is registered
  // bool containUserName(List<UserRequest> userList, String _selectedTeamMember) {
  //   if (userList
  //       .where((element) => element.userName == _selectedTeamMember)
  //       .toList()
  //       .isNotEmpty) {
  //     print("true");
  //     return true;
  //   } else {
  //     print("false");
  //     return false;
  //   }
  // }

  //Add user if not registered
  // void addUser(String _selectedTeamMember) {
  //   TeamUser teamUser = new TeamUser();
  //   teamUser.userId = 0;
  //   teamUser.teamId = teamrequest.id;
  //   teamUser.userName = _selectedTeamMember;
  //   teamUser.createdBy = "SYSTEM";
  //   String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
  //   teamUser.createdTime = dt;
  //   teamUser.updatedBy = "SYSTEM";
  //   teamUser.updatedTime = dt;
  //   listofTeamUsers.add(teamUser);
  //   print("add unregistered user executed");
  // }

  // void addRegisteredUser(
  //     List<UserRequest> userList, String _selectedTeamMember) {
  //   selectedUsers = selectedUsers +
  //       userList
  //           .where((element) => element.userName == _selectedTeamMember)
  //           .toList();
  //   print("add Registered user executed");
  // }

  Widget addMember() {
    //Divider();
    String _selectedTeamMembernew;
    return FutureBuilder<List<UserRequest>>(
        future: Users,
        builder:
            (BuildContext context, AsyncSnapshot<List<UserRequest>> snapshot) {
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
        });
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
                          FutureBuilder<List<TeamRequest>>(
                              future: teamPageVM.getTeamRequests("Approved"),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<TeamRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  List<TeamRequest> teamList = snapshot.data;
                                  return FutureBuilder<List<UserRequest>>(
                                      future: Users,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<UserRequest>>
                                          snapshot) {
                                        if (snapshot.data != null) {
                                          List<UserRequest> tempUserList =
                                              snapshot.data;
                                          userList = getTeamLeads(
                                              teamList, tempUserList);
                                          List<String> teamLeadId = userList
                                              .map((user) => user.email)
                                              .toSet()
                                              .toList();

                                          return DropdownButtonFormField<
                                              String>(
                                            value: _selectedTeamLeadId,
                                            icon: const Icon(
                                                Icons.account_circle),
                                            hint: Text('Select Team Lead Id',
                                                style: TextStyle(
                                                    color: Colors.grey)),
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
                                      });
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
                          Container(
                            padding: new EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Available From",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                DateTimeField(
                                  format: DateFormat("HH:mm"),
                                  onShowPicker: (context, currentValue) async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return DateTimeField.convert(time);
                                  },
                                  onSaved: (input) {
                                    teamrequest.availableFrom =
                                        DateFormat("HH:mm")
                                            .format(input)
                                            .toString();
                                  },
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return "Please enter some text";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            padding: new EdgeInsets.all(10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  "Available To",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(color: Colors.grey),
                                ),
                                DateTimeField(
                                  format: DateFormat("HH:mm"),
                                  onShowPicker: (context, currentValue) async {
                                    final time = await showTimePicker(
                                      context: context,
                                      initialTime: TimeOfDay.fromDateTime(
                                          currentValue ?? DateTime.now()),
                                    );
                                    return DateTimeField.convert(time);
                                  },
                                  onSaved: (input) {
                                    teamrequest.availableTo =
                                        DateFormat("HH:mm")
                                            .format(input)
                                            .toString();
                                  },
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return "Please enter some text";
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 35,
                          ),
                          FutureBuilder<List<UserRequest>>(
                              future: Users,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserRequest>> snapshot) {
                                if (snapshot.data != null) {
                                  print(userList);
                                  userList = snapshot.data;
                                  return Card(
                                    child: Container(
                                      //color: Colors.white,
                                      padding: new EdgeInsets.all(10),
                                      child: TextFormField(
                                        //attribute: "Description",

                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            /*icon: const Icon(
                                Icons.description,
                                color: Colors.grey,
                              ),*/
                                            labelText: "Add Team Member1",
                                            hintText: "Add Team Member",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            )),
                                        onChanged: (input) {
                                          setState(() {
                                            _selectedTeamMember1 = input;
                                          });
                                        },
                                        // onEditingComplete: () {
                                        //   setState(() {
                                        //     containUserName(userList,
                                        //             _selectedTeamMember1)
                                        //         ? selectedUsers = userList
                                        //             .where((element) =>
                                        //                 element.userName ==
                                        //                 _selectedTeamMember1)
                                        //             .toList()
                                        //         : addUser(_selectedTeamMember1);
                                        //   });
                                        // },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please enter some text";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    elevation: 5,
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
                                  return Card(
                                    child: Container(
                                      //color: Colors.white,
                                      padding: new EdgeInsets.all(10),
                                      child: TextFormField(
                                        //attribute: "Description",

                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            /*icon: const Icon(
                                Icons.description,
                                color: Colors.grey,
                              ),*/
                                            labelText: "Add Team Member2",
                                            hintText: "Add Team Member",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            )),
                                        onChanged: (input) {
                                          setState(() {
                                            _selectedTeamMember2 = input;
                                          });
                                        },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please enter some text";
                                          }
                                          return null;
                                        },
                                        // onEditingComplete: () {
                                        //   setState(() {
                                        //     containUserName(userList,
                                        //             _selectedTeamMember2)
                                        //         ? addRegisteredUser(userList,
                                        //             _selectedTeamMember2)
                                        //         : addUser(_selectedTeamMember2);
                                        //   });
                                        // },
                                      ),
                                    ),
                                    elevation: 5,
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
                                  print(userList);
                                  return Card(
                                    child: Container(
                                      //color: Colors.white,
                                      padding: new EdgeInsets.all(10),
                                      child: TextFormField(
                                        //attribute: "Description",

                                        decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            /*icon: const Icon(
                                Icons.description,
                                color: Colors.grey,
                              ),*/
                                            labelText: "Add Team Member3",
                                            hintText: "Add Team Member",
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                            labelStyle: TextStyle(
                                              color: Colors.grey,
                                            )),
                                        onChanged: (input) {
                                          setState(() {
                                            _selectedTeamMember3 = input;
                                          });
                                        },
                                        // onEditingComplete: () {
                                        //   containUserName(userList,
                                        //           _selectedTeamMember3)
                                        //       ? addRegisteredUser(userList,
                                        //           _selectedTeamMember3)
                                        //       : addUser(_selectedTeamMember3);
                                        // },
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Please enter some text";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                    elevation: 5,
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
                        RaisedButton.icon(
                          label: Text('Add'),
                          icon: const Icon(Icons.add_circle),
                          color: Colors.green,
                          onPressed: () async {
                            setState(() {
                              addMember();
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
                                  List<String> selectedMembers = [
                                    _selectedTeamMember1,
                                    _selectedTeamMember2,
                                    _selectedTeamMember3
                                  ];
                                  print(selectedMembers);
                                  if (_formKey.currentState.validate()) {
                                    final FirebaseAuth auth =
                                        FirebaseAuth.instance;
                                    final FirebaseUser user =
                                    await auth.currentUser();
                                    final String email = user.email;
                                    // for (var user in selectedUsers) {
                                    //   TeamUser teamUser = new TeamUser();
                                    //   teamUser.userId = user.id;
                                    //   teamUser.teamId = teamrequest.id;
                                    //   teamUser.userName = user.userName;
                                    //   teamUser.createdBy = "SYSTEM";
                                    //   String dt = DateFormat(
                                    //           "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                    //       .format(DateTime.now());
                                    //   teamUser.createdTime = dt;
                                    //   teamUser.updatedBy = "SYSTEM";
                                    //   teamUser.updatedTime = dt;
                                    //   listofTeamUsers.add(teamUser);
                                    // }
                                    // print(listofTeamUsers);
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
                                    // teamrequest.listOfTeamMembers =
                                    //     listofTeamUsers;
                                    setState(() {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TeamLocalAdmin(
                                                  teamrequest: teamrequest,
                                                  selectedMembers:
                                                  selectedMembers,
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
    );
  }
}
