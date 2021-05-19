import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

final TeamUserPageViewModel teamUserPageVM =
    TeamUserPageViewModel(apiSvc: TeamUserAPIService());
final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class members_profile extends StatefulWidget {
  @override
  _members_profileState createState() => _members_profileState();
}

class _members_profileState extends State<members_profile> {
  int counter = 3;
  List<String> uMail = new List<String>();
  final _formKey = GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  List<TeamUser> listofTeamUsers = new List<TeamUser>();
  List<UserRequest> selectedUsers = new List<UserRequest>();
  void updateTeamUser(
      List<UserRequest> userList, String _selectedTeamMember, int index) {
    if (userList
        .where((element) => element.userName == _selectedTeamMember)
        .toList()
        .isNotEmpty) {
      if (index == 0) {
        selectedUsers = userList
            .where((element) => element.userName == _selectedTeamMember)
            .toList();
      } else {
        selectedUsers = selectedUsers +
            userList
                .where((element) => element.userName == _selectedTeamMember)
                .toList();
      }
    } else {
      TeamUser teamUser = new TeamUser();
      teamUser.userId = 0;
      teamUser.teamId = teamrequest.id;
      teamUser.userName = _selectedTeamMember;
      teamUser.createdBy = "SYSTEM";
      String dt =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
      teamUser.createdTime = dt;
      teamUser.updatedBy = "SYSTEM";
      teamUser.updatedTime = dt;
      listofTeamUsers.add(teamUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit members"),
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
                        return SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: Form(
                                key: _formKey,
                                child: Consumer<ThemeNotifier>(
                                  builder: (context, notifier, child) => Column(
                                    children: [
                                      Text("Members",
                                          style: TextStyle(
                                              fontSize: notifier.custFontSize,
                                              fontWeight: FontWeight.bold)),
                                      addmember(counter),
                                      Divider(),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          RaisedButton.icon(
                                            label: Text('Add'),
                                            icon: const Icon(Icons.add_circle),
                                            color: Colors.green,
                                            onPressed: () {
                                              //addmember();
                                              setState(() {
                                                counter++;
                                              });
                                            },
                                          ),
                                          RaisedButton(
                                            child: Text('Get Approved'),
                                            //color: Colors.redAccent,
                                            //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                int i = 0;
                                                List<UserRequest> userList =
                                                    await userPageVM
                                                        .getUserRequests(
                                                            "Approved");
                                                for (var member in uMail) {
                                                  updateTeamUser(
                                                      userList, member, i);
                                                  i++;
                                                }
                                                for (var user
                                                    in selectedUsers) {
                                                  TeamUser teamUser =
                                                      new TeamUser();
                                                  teamUser.userId = user.id;
                                                  teamUser.teamId =
                                                      teamrequest.id;
                                                  teamUser.userName =
                                                      user.userName;
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
                                                teamrequest.updatedBy = email;
                                                teamrequest.listOfTeamMembers =
                                                    listofTeamUsers;
                                                String teamrequestStr =
                                                    jsonEncode(teamrequest
                                                        .toStrJson());
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
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )),
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

  //print("Entered");
  Widget addmember(int counter) {
    var i = 1;
    return Card(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Column(
          children: [
            for (int i = 1; i <= counter; i++)
              Container(
                //color: Colors.black26,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          icon: Icon(Icons.people_outline, color: Colors.grey),
                          suffixIcon: FlatButton(
                            onPressed: () {},
                            child: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                          labelText: "Member " + i.toString(),
                          hintText: "Please enter the name of the member",
                          labelStyle: TextStyle(
                            fontSize: notifier.custFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      onSaved: (input) {
                        uMail.add(input);
                        print(uMail);
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
}
