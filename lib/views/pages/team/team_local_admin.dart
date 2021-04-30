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
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
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

class TeamLocalAdmin extends StatefulWidget {
  TeamRequest teamrequest;
  List<String> selectedMembers;
  TeamLocalAdmin(
      {Key key, @required this.teamrequest, @required this.selectedMembers})
      : super(key: key);

  final String screenName = SCR_TEAM;

  @override
  _TeamLocalAdminState createState() => _TeamLocalAdminState();
}

class _TeamLocalAdminState extends State<TeamLocalAdmin> {
  Future<List<UserRequest>> Users;
  List<UserRequest> selectedUsers = new List<UserRequest>();
  Future<List<Temple>> Temples;
  Future<List<UserTemple>> UserTemples;
  List<UserRequest> userList = new List<UserRequest>();
  List<Temple> templeList = new List<Temple>();
  List<UserTemple> userTempleList = new List<UserTemple>();
  int _selectedtempleId;
  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    Temples = templePageVM.getTemples("All");
    UserTemples = userTemplePageVM.getUserTempleMapping("All");
    super.initState();
  }

  List<UserTemple> userTemples;
  final _formKey = GlobalKey<FormState>();
  String _selectedTempleArea;
  String _selectedLocalAdmin;
  List<TeamUser> listofTeamUsers = new List<TeamUser>();

  void addUser(
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
      teamUser.teamId = widget.teamrequest.id;
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 35),

                          FutureBuilder<List<Temple>>(
                              future: Temples,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<Temple>> snapshot) {
                                if (snapshot.data != null) {
                                  templeList = snapshot.data;
                                  List<String> templeArea = templeList
                                      .map((user) => user.area)
                                      .toSet()
                                      .toList();

                                  return DropdownButtonFormField<String>(
                                    value: _selectedTempleArea,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Temple Area',
                                        style: TextStyle(color: Colors.grey)),
                                    items: templeArea
                                        .map((templeArea) =>
                                            DropdownMenuItem<String>(
                                              value: templeArea,
                                              child: Text(templeArea),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedTempleArea = input;
                                        _selectedtempleId =
                                            templeList.indexWhere((element) =>
                                                    element.area ==
                                                    _selectedTempleArea) +
                                                1;
                                        print(_selectedtempleId);
                                        _selectedLocalAdmin = null;
                                      });
                                    },
                                    onSaved: (input) {
                                      widget.teamrequest.localAdminArea = input;
                                    },
                                  );
                                }
                                return Container();
                              }),
                          SizedBox(height: 35),
                          //UserTemple
                          FutureBuilder<List<UserTemple>>(
                              future: UserTemples,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserTemple>> snapshot) {
                                if (snapshot.data != null) {
                                  userTempleList = snapshot.data
                                      .where((element) =>
                                          element.templeId == _selectedtempleId)
                                      .toList();
                                  List<String> templeArea = userTempleList
                                      .map((user) => user.userName)
                                      .toSet()
                                      .toList();

                                  return DropdownButtonFormField<String>(
                                    value: _selectedLocalAdmin,
                                    icon: const Icon(Icons.account_circle),
                                    hint: Text('Select Local Admin',
                                        style: TextStyle(color: Colors.grey)),
                                    items: templeArea
                                        .map((templeArea) =>
                                            DropdownMenuItem<String>(
                                              value: templeArea,
                                              child: Text(templeArea),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedLocalAdmin = input;
                                        // _selectedtempleId =
                                        //     templeList.indexWhere((element) =>
                                        //         element.area ==
                                        //         _selectedTempleArea);
                                        print(_selectedtempleId);
                                      });
                                    },
                                    onSaved: (input) {
                                      widget.teamrequest.localAdminName = input;
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Error");
                                } else {
                                  return Text("Retrieved null values");
                                }
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

                        new Container(margin: const EdgeInsets.only(top: 40)),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            FutureBuilder<List<UserRequest>>(
                                future: Users,
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<UserRequest>> snapshot) {
                                  if (snapshot.data != null) {
                                    userList = snapshot.data;
                                    return MaterialButton(
                                        child: Text(
                                          "Send",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        color: KirthanStyles.colorPallete30,
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            int i = 0;
                                            for (var member
                                                in widget.selectedMembers) {
                                              addUser(userList, member, i);
                                              i++;
                                            }
                                            for (var user in selectedUsers) {
                                              TeamUser teamUser =
                                                  new TeamUser();
                                              teamUser.userId = user.id;
                                              teamUser.teamId =
                                                  widget.teamrequest.id;
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
                                            widget.teamrequest
                                                    .listOfTeamMembers =
                                                listofTeamUsers;
                                            Map<String, dynamic> teammap =
                                                widget.teamrequest.toJson();
                                            TeamRequest newteamrequest =
                                                await teamPageVM
                                                    .submitNewTeamRequest(
                                                        teammap);

                                            print(newteamrequest.id);
                                            String tid =
                                                newteamrequest.id.toString();
                                            SnackBar mysnackbar = SnackBar(
                                              content: Text(
                                                  "Team registered $successful with $tid"),
                                              duration:
                                                  new Duration(seconds: 4),
                                              backgroundColor: Colors.green,
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(mysnackbar);
                                          }
                                          setState(() {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeamView()),
                                            );
                                          });
                                        });
                                  }
                                  return Container();
                                }),
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
