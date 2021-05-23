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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
  int showOnce = 1;
  bool torefresh = false;
  Future<List<TeamUser>> TeamUserRequest;
  String dummy;
  List<TeamRequest> teamList = new List<TeamRequest>();
  List<TeamUser> teamUserList = List<TeamUser>();
  int counter = 0;
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
    listofTeamUsers.clear();
    print("userlist in updateteamuser");
    print(userList.length);
    // if (userList
    //     .where((element) =>
    //         element.userName.toLowerCase() == _selectedTeamMember.toLowerCase())
    //     .toList()
    //     .isNotEmpty) {

    // if (index == 0) {
    //   selectedUsers = userList
    //       .where((element) => element.userName == _selectedTeamMember)
    //       .toList();
    // } else {
    //   selectedUsers = selectedUsers +
    //       userList
    //           .where((element) => element.userName == _selectedTeamMember)
    //           .toList();
    // }
    int count = 0;
    for (var teamUser in teamUserList) {
      print("for loop");
      print(teamUser.teamId);
      print(teamrequest.id);
      if (teamUser.userName.toLowerCase() ==
          _selectedTeamMember.toLowerCase()) {
        break;
      }
      count++;
    }
    if (count == teamUserList.length) {
      TeamUser teamUser = new TeamUser();
      if (userList.indexWhere(
              (element) => element.fullName == _selectedTeamMember) ==
          -1) {
        teamUser.userId = 0;
      } else {
        teamUser.userId = userList[userList.indexWhere(
                (element) => element.fullName == _selectedTeamMember)]
            .id;
      }

      teamUser.teamId = teamrequest.id;
      teamUser.userName = _selectedTeamMember;
      teamUser.createdBy = "SYSTEM";
      String dt =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
      teamUser.createdTime = dt;
      teamUser.updatedBy = "SYSTEM";
      teamUser.updatedTime = dt;
      listofTeamUsers.add(teamUser);

      teamUserPageVM.submitNewTeamUserMapping(listofTeamUsers);
      if (showOnce == 1) {
        SnackBar mysnackbar = SnackBar(
          content: Text("New Team Members added & Sent for Aprroval"),
          duration: new Duration(seconds: 4),
          backgroundColor: Colors.green,
        );
        _scaffoldKey.currentState.showSnackBar(mysnackbar);
        showOnce = 2;
      }
    } else {
      SnackBar mysnackbar = SnackBar(
        content: Text("$_selectedTeamMember is already present in the team"),
        duration: new Duration(seconds: 4),
        backgroundColor: Colors.red,
      );
      _scaffoldKey.currentState.showSnackBar(mysnackbar);
    }
    // } else {
    //   SnackBar mysnackbar = SnackBar(
    //     content: Text("User with username $_selectedTeamMember not found"),
    //     duration: new Duration(seconds: 4),
    //     backgroundColor: Colors.red,
    //   );
    //   _scaffoldKey.currentState.showSnackBar(mysnackbar);
    // }
  }

  @override
  void initState() {
    selectedRadio = 0;
    selectedRadioTile = 0;
    super.initState();
  }

  int selectedRadio;
  int selectedRadioTile;

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  int _groupValue = -1;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future loadData() async {
    await teamUserPageVM.getTeamUserMappings(teamrequest.id.toString());
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      loadData();
      //counter = 0;
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    List<TeamUser> finalTeamUserList = new List<TeamUser>();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Edit members"),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
              future: getEmail(),
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  String email = snapshot.data;
                  print("EMAIL");
                  print(email);
                  return FutureBuilder(
                      future: teamPageVM.getTeamRequests("teamLead:" + email),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          teamList = snapshot.data;
                          print("Team list data");
                          print(teamList);
                          if (teamList.isNotEmpty) {
                            for (var u in teamList) {
                              // print("UUUU");
                              // print(u.id);
                              teamrequest = u;
                            }
                            return FutureBuilder<List<TeamUser>>(
                              future: teamUserPageVM.getTeamUserMappings(
                                  teamrequest.id.toString()),
                              builder: (BuildContext context,
                                  AsyncSnapshot<List<TeamUser>> snapshot) {
                                finalTeamUserList.clear();
                                if (snapshot.hasData) {
                                  teamUserList = snapshot.data;
                                  for (var teamUser in teamUserList) {
                                    if (teamUser.teamId == teamrequest.id) {
                                      // print("HELLO");
                                      // print(teamrequest.id);
                                      // print(teamUser.teamId);
                                      finalTeamUserList.contains(teamUser)
                                          ? null
                                          : finalTeamUserList.add(teamUser);
                                    }
                                  }
                                  return SingleChildScrollView(
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Form(
                                          key: _formKey,
                                          child: Consumer<ThemeNotifier>(
                                            builder:
                                                (context, notifier, child) =>
                                                    Column(
                                              children: [
                                                Text("Members",
                                                    style: TextStyle(
                                                        fontSize: notifier
                                                            .custFontSize,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                addmember(
                                                    counter, finalTeamUserList),
                                                Divider(),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        RaisedButton.icon(
                                                          label: Text('Add'),
                                                          icon: const Icon(
                                                              Icons.add_circle),
                                                          color: Colors.green,
                                                          onPressed: () {
//addmember();
                                                            setState(() {
                                                              counter++;
                                                            });
                                                          },
                                                        ),
                                                        RaisedButton.icon(
                                                            label:
                                                                Text('Remove'),
                                                            icon: const Icon(
                                                                Icons.cancel),
                                                            color: Colors.red,
                                                            onPressed: () {
                                                              return showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return StatefulBuilder(builder:
                                                                        (context,
                                                                            setState) {
                                                                      return Dialog(
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20.0)), //this right here
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              400,
                                                                          child:
                                                                              SingleChildScrollView(
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(12.0),
                                                                              child: Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  TextField(
                                                                                    decoration: InputDecoration(border: InputBorder.none, hintText: 'Remove Member?'),
                                                                                  ),
                                                                                  Container(
                                                                                    child: Column(
                                                                                      children: [
                                                                                        for (int i = 0; i < finalTeamUserList.length; i++)
                                                                                          RadioListTile(
                                                                                            value: i,
                                                                                            groupValue: _groupValue,
                                                                                            onChanged: (value) {
                                                                                              setState(() {
                                                                                                print(value);

                                                                                                print(finalTeamUserList[i].userName);

                                                                                                _groupValue = value;
                                                                                              });
                                                                                            },
                                                                                            title: Consumer<ThemeNotifier>(
                                                                                              builder: (context, notifier, child) => Text(finalTeamUserList[i].userName, style: TextStyle(fontSize: notifier.custFontSize)),
                                                                                            ),
                                                                                          ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 320.0,
                                                                                    child: RaisedButton(
                                                                                      onPressed: () {
                                                                                        List<TeamUser> teamUserToBeDeleted = new List<TeamUser>();
                                                                                        teamUserToBeDeleted.add(finalTeamUserList[_groupValue]);
                                                                                        teamUserPageVM.submitDeleteTeamUserMapping(teamUserToBeDeleted);

                                                                                        // teamrequestmap["id"] =
                                                                                        //     permissionsrequest?.id;
                                                                                        // permissionsPageVM
                                                                                        //     .deletePermissions(teamrequestmap);
                                                                                        SnackBar mysnackbar = SnackBar(
                                                                                          content: Text("Member $delete "),
                                                                                          duration: new Duration(seconds: 4),
                                                                                          backgroundColor: Colors.red,
                                                                                        );
                                                                                        _scaffoldKey.currentState.showSnackBar(mysnackbar);
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Consumer<ThemeNotifier>(
                                                                                        builder: (context, notifier, child) => Text(
                                                                                          "Remove",
                                                                                          style: TextStyle(fontSize: notifier.custFontSize, color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                      color: const Color(0xFF1BC0C5),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 320.0,
                                                                                    child: RaisedButton(
                                                                                      onPressed: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Consumer<ThemeNotifier>(
                                                                                        builder: (context, notifier, child) => Text(
                                                                                          "Back",
                                                                                          style: TextStyle(fontSize: notifier.custFontSize, color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                      color: const Color(0xFF1BC0C5),
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    });
                                                                  });
                                                            }),
                                                      ],
                                                    ),
                                                    RaisedButton(
                                                      child:
                                                          Text('Get Approved'),
//color: Colors.redAccent,
//padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                                      onPressed: () async {
                                                        if (_formKey
                                                            .currentState
                                                            .validate()) {
                                                          _formKey.currentState
                                                              .save();
                                                          int i = 0;
                                                          List<UserRequest>
                                                              userList =
                                                              await userPageVM
                                                                  .getUserRequests(
                                                                      "Approved");
                                                          print(
                                                              "umail inside button");
                                                          print(uMail);
                                                          print("userlist");
                                                          print(userList);
                                                          if (uMail.isEmpty) {
                                                            SnackBar
                                                                mysnackbar =
                                                                SnackBar(
                                                              content: Text(
                                                                  "Keep Patience !! Already Sent for Approval"),
                                                              duration:
                                                                  new Duration(
                                                                      seconds:
                                                                          4),
                                                              backgroundColor:
                                                                  Colors.green,
                                                            );
                                                            _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    mysnackbar);
                                                          } else {
                                                            for (var member
                                                                in uMail) {
                                                              updateTeamUser(
                                                                  userList,
                                                                  member,
                                                                  i);
                                                              i++;
                                                            }
                                                          }

                                                          // for (var user
                                                          //     in selectedUsers) {
                                                          //   TeamUser teamUser =
                                                          //       new TeamUser();
                                                          //   teamUser.userId =
                                                          //       user.id;
                                                          //   teamUser.teamId =
                                                          //       teamrequest.id;
                                                          //   teamUser.userName =
                                                          //       user.userName;
                                                          //   teamUser.createdBy =
                                                          //       "SYSTEM";
                                                          //   String dt = DateFormat(
                                                          //           "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                                          //       .format(DateTime
                                                          //           .now());
                                                          //   teamUser.createdTime =
                                                          //       dt;
                                                          //   teamUser.updatedBy =
                                                          //       "SYSTEM";
                                                          //   teamUser.updatedTime =
                                                          //       dt;
                                                          //   listofTeamUsers
                                                          //       .add(teamUser);
                                                          // }
                                                          // print(listofTeamUsers);
                                                          // teamrequest.updatedBy =
                                                          //     email;
                                                          // teamrequest
                                                          //         .listOfTeamMembers =
                                                          //     listofTeamUsers;
                                                          // String teamrequestStr =
                                                          //     jsonEncode(teamrequest
                                                          //         .toStrJson());
                                                          // teamPageVM
                                                          //     .submitUpdateTeamRequest(
                                                          //         teamrequestStr);
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
                                }
                                return Center(
                                  child: Container(
                                    child: Text("No members to display"),
                                  ),
                                );
                              },
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
        ),
        onRefresh: refreshList,
      ),
    );
  }

  //print("Entered");
  Widget addmember(int counter, List<TeamUser> finalTeamUserList) {
    List<TextEditingController> textEditingController =
        new List<TextEditingController>(finalTeamUserList.length);
    print(finalTeamUserList.length);
    int y = 0;
    return Card(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Column(
          children: [
            for (y = 0; y < finalTeamUserList.length; y++)
              Container(
                //color: Colors.black26,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      enabled: false,
                      initialValue: finalTeamUserList[y].userName.toString(),
                      controller: textEditingController[y],
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          icon: Icon(Icons.people_outline, color: Colors.grey),
                          labelText: "Member " + (y + 1).toString(),
                          hintText: "Please enter the name of the member",
                          labelStyle: TextStyle(
                            fontSize: notifier.custFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                      onFieldSubmitted: (input) {
                        if (uMail.contains(input)) {
                          print("it contains");
                        } else {
                          uMail.add(input);
                          print("uMail");
                          print(uMail);
                        }
                      },
                    ),
                    Divider()
                  ],
                ),
              ),
            for (int i = 0; i < this.counter; i++)
              Container(
                //color: Colors.black26,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      //initialValue: finalTeamUserList[i].userName.toString(),
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          icon: Icon(Icons.people_outline, color: Colors.grey),
                          labelText: "Member " +
                              (i + 1 + finalTeamUserList.length).toString(),
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
                        if (uMail.contains(input)) {
                          print("it contains");
                        } else {
                          uMail.add(input);
                          print("uMail");
                          print(uMail);
                        }
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
