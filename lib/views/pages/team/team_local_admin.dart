import 'dart:convert';
import 'dart:core';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/team/non_user_team_invite.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flushbar/flushbar_helper.dart';

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
final ProspectiveUserPageViewModel prospectiveUserPageViewModel =
    ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());

class TeamLocalAdmin extends StatefulWidget {
  TeamRequest teamrequest;
  List<String> selectedMembers;
  UserRequest user;
  TeamLocalAdmin(
      {Key key,
      @required this.teamrequest,
      @required this.selectedMembers,
      @required this.user})
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
    //getLocalAdminTemple();
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
        .where((element) => element.fullName == _selectedTeamMember)
        .toList()
        .isNotEmpty) {
      if (index == 0) {
        selectedUsers = userList
            .where((element) => element.fullName == _selectedTeamMember)
            .toList();
      } else {
        selectedUsers = selectedUsers +
            userList
                .where((element) => element.fullName == _selectedTeamMember)
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
                          FutureBuilder<List<UserTemple>>(
                              future: UserTemples,
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<UserTemple>> snapshot) {
                                if (snapshot.data != null) {
                                  userTempleList = snapshot.data.toList();
                                  if (widget.user != null) {
                                    List<UserTemple> templeArea = userTempleList
                                        .where((user) =>
                                            user.userId == widget.user.id)
                                        .toList();
                                    for (var temple in templeArea) {
                                      _selectedtempleId = temple.templeId;
                                    }
                                  }
                                  return FutureBuilder<List<Temple>>(
                                      future: Temples,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<Temple>>
                                              snapshot) {
                                        if (snapshot.data != null) {
                                          if (widget.user == null) {
                                            templeList = snapshot.data;
                                          } else {
                                            templeList = snapshot.data
                                                .where((element) =>
                                                    element.id ==
                                                    _selectedtempleId)
                                                .toList();
                                            for (var temple in templeList) {
                                              _selectedTempleArea = temple.area;
                                            }
                                          }
                                          List<String> templeArea = snapshot
                                              .data
                                              .map((user) => user.area)
                                              .toSet()
                                              .toList();
                                          return DropdownButtonFormField<
                                              String>(
                                            value: _selectedTempleArea,
                                            icon: const Icon(
                                                Icons.account_circle),
                                            hint: Text('Select Temple Area',
                                                style: TextStyle(
                                                    color: Colors.grey)),
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
                                                _selectedtempleId = templeList
                                                        .indexWhere((element) =>
                                                            element.area ==
                                                            _selectedTempleArea) +
                                                    1;
                                                print(_selectedtempleId);
                                                _selectedLocalAdmin = null;
                                              });
                                            },
                                            onSaved: (input) {
                                              widget.teamrequest
                                                  .localAdminArea = input;
                                            },
                                          );
                                        }
                                        return Container();
                                      });
                                } else if (snapshot.hasError) {
                                  return Text("Error");
                                } else {
                                  return Container();
                                }
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
                                  if (widget.user != null) {
                                    _selectedLocalAdmin = widget.user.fullName;
                                  }
                                  return DropdownButtonFormField<String>(
                                    disabledHint:
                                        Text("No Local Admin Available"),
                                    value: widget.user == null
                                        ? _selectedLocalAdmin
                                        : widget.user.fullName,
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
                                        // print(_selectedtempleId);
                                      });
                                    },
                                    onSaved: (input) {
                                      widget.teamrequest.localAdminName = input;
                                    },
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Error");
                                } else {
                                  return Container();
                                }
                              }),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
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
                                          List<TeamRequest> tempTeamList =
                                              await teamPageVM.getTeamRequests(
                                                  "teamLead:"+
                                                      widget.teamrequest.teamLeadId);
                                          if (tempTeamList.isNotEmpty) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content:
                                                  Text('Team already exits'),
                                              backgroundColor: Colors.red,
                                            ));
                                          } else if (widget
                                                  .teamrequest.teamLeadId ==
                                              null) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Team lead cannot be null'),
                                              backgroundColor: Colors.red,
                                            ));
                                          } else if (_selectedLocalAdmin ==
                                              null) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Local Admin cannot be null'),
                                              backgroundColor: Colors.red,
                                            ));
                                          } else if (_selectedTempleArea ==
                                              null) {
                                            Scaffold.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Local Admin Area cannot be null'),
                                              backgroundColor: Colors.red,
                                            ));
                                          } else {
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
                                                teamUser.userName =
                                                    user.fullName;
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
                                              List<ProspectiveUserRequest>
                                                  puReq =
                                                  await prospectiveUserPageVM
                                                      .getProspectiveUserRequests(
                                                          "uEmail:" +
                                                              widget.teamrequest
                                                                  .teamLeadId);
                                              if (puReq.isNotEmpty) {
                                                for (var user in puReq) {
                                                  if (user.inviteType == 4) {
                                                    ProspectiveUserRequest
                                                        purequest =
                                                        new ProspectiveUserRequest();
                                                    user.isProcessed = true;
                                                    purequest = user;
                                                    String prospectiveStr =
                                                        jsonEncode(purequest
                                                            .toStrJson());
                                                    prospectiveUserPageVM
                                                        .submitUpdateProspectiveUserRequest(
                                                            prospectiveStr);
                                                  }
                                                }
                                              }
                                              if (widget.user != null) {
                                                widget.teamrequest
                                                        .approvalStatus =
                                                    "Approved";
                                              } else {
                                                widget.teamrequest
                                                    .approvalStatus = "Waiting";
                                              }
                                              Map<String, dynamic> teammap =
                                                  widget.teamrequest.toJson();
                                              TeamRequest newteamrequest =
                                                  await teamPageVM
                                                      .submitNewTeamRequest(
                                                          teammap)
                                                      .whenComplete(() =>
                                                          showFlushBar(
                                                              context));
                                            }
                                          }
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

void showFlushBar(BuildContext context) {
  Flushbar(
    messageText: Text(
      'Your team request sent for approval',
      style: TextStyle(color: Colors.white),
    ),
    backgroundColor: Colors.green,
    duration: Duration(seconds: 3),
  )..show(context).whenComplete(() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => EventView())));
}
