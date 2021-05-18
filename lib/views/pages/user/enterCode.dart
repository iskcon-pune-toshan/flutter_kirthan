import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/user/inviteUser.dart' as inU;
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';

TextEditingController _textController = TextEditingController();
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final ProspectiveUserPageViewModel prospectiveUserPageVM =
    ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());

class EnterCode extends StatefulWidget {
  @override
  _EnterCodeState createState() => _EnterCodeState();
}

class _EnterCodeState extends State<EnterCode> {
  String userType;
  UserRequest userrequest = UserRequest();
  Future<List<ProspectiveUserRequest>> ProspectiveUsers;
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = List<UserRequest>();

  List<ProspectiveUserRequest> prospectiveList = List<ProspectiveUserRequest>();
  ProspectiveUserRequest prospectiveUserRequest = ProspectiveUserRequest();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String email;

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    email = user.email;
    setState(() {
      userType = "uEmail:" + email;
    });
    setState(() {
      ProspectiveUsers =
          prospectiveUserPageVM.getProspectiveUserRequests(userType);
    });

    print(userType);
    print(email);
  }

  @override
  void initState() {
    super.initState();
    Users = userPageVM.getUserRequests("Approved");
    getCurrentUser();
    //getList();
  }

  @override
  Widget build(BuildContext context) {
    //getCurrentUser();
    //getList();
    return FutureBuilder<List<ProspectiveUserRequest>>(
      future: ProspectiveUsers,
      builder: (BuildContext context,
          AsyncSnapshot<List<ProspectiveUserRequest>> snapshot) {
        if (snapshot.hasData) {
          prospectiveList = snapshot.data;
          print("NO DATA");
          print(prospectiveList.length);
          if (prospectiveList != null) {
            for (var puser in prospectiveList) {
              if (puser.userEmail == email) {
                if (puser.isProcessed == true) {

                  return App();
                } else {

                  return Scaffold(
                    key: _scaffoldKey,
                    appBar: AppBar(),
                    body: Container(
                      child: Column(
                        children: [
                          TextField(
                            controller: _textController,
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          RaisedButton(
                            onPressed: () async {
                              userList = await Users;

                              String userType = "uEmail:" + email;
                              print(userType);
                              userList = await Users;
                              for (var users in userList) {
                                if (users.email == email) {
                                  userrequest = users;
                                }
                              }
                              if (prospectiveList.length != 0) {
                                for (var puser in prospectiveList) {
                                  if (puser.userEmail == email &&
                                      puser.inviteCode ==
                                          _textController.text) {
                                    if (puser.inviteType == 'local_admin') {
                                      userrequest.email = email;
                                      userrequest.roleId = 2;
                                      String userrequestStr =
                                          jsonEncode(userrequest.toStrJson());
                                      userPageVM.submitUpdateUserRequest(
                                          userrequestStr);
                                      prospectiveUserRequest = puser;
                                      prospectiveUserRequest.isProcessed = true;
                                      String prospectiveStr = jsonEncode(
                                          prospectiveUserRequest.toStrJson());
                                      inU.prospectiveUserPageVM
                                          .submitUpdateProspectiveUserRequest(
                                              prospectiveStr);
                                      SnackBar mysnackbar = SnackBar(
                                        content: Text("You are local Admin"),
                                        duration: new Duration(seconds: 4),
                                        backgroundColor: Colors.green,
                                      );
                                      _scaffoldKey.currentState
                                          .showSnackBar(mysnackbar);
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => //App()
                                                  App()));
                                    } else {
                                      print("else");
                                    }
                                  } else {
                                    print("2nd else");
                                    SnackBar mysnackbar = SnackBar(
                                      content: Text("Invalid Code"),
                                      duration: new Duration(seconds: 4),
                                      backgroundColor: Colors.red,
                                    );
                                    _scaffoldKey.currentState
                                        .showSnackBar(mysnackbar);
                                  }
                                }
                              } else {
                                print("sorry bro");
                                SnackBar mysnackbar = SnackBar(
                                  content: Text("Invalid Code"),
                                  duration: new Duration(seconds: 4),
                                  backgroundColor: Colors.red,
                                );
                                _scaffoldKey.currentState
                                    .showSnackBar(mysnackbar);
                              }
                            },
                            child: Text("Login"),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                          ),
                          RaisedButton.icon(
                            icon: Icon(
                              Icons.navigate_next,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => //App()
                                      App()));
                            },
                            label: Text("Skip"),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              return Container();
            }
          }
          return App();
        }
        return Container();
        print("sorry");
        print(prospectiveList);
      },
    );
  }
}
