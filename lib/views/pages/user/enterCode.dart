import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/user/inviteUser.dart' as inU;
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';

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
                    extendBody: false,
                    extendBodyBehindAppBar: true,
                    appBar: AppBar(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                    ),
                    body: SingleChildScrollView(
                      child: Container(
                        //color: Colors.red,
                        height: MediaQuery.of(context).size.height,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              margin: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.width / 4),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Have a code ?",
                                style: TextStyle(
                                    fontSize: 30, fontFamily: 'OpenSans'),
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            TextField(
                              cursorColor: KirthanStyles.colorPallete30,
                              style: TextStyle(fontFamily: 'OpenSans'),
                              textCapitalization: TextCapitalization.characters,
                              controller: _textController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: "Enter code to become local admin",
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      borderSide: BorderSide(
                                        color: KirthanStyles.colorPallete30,
                                      )),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.white))),
                            ),
                            SizedBox(
                              height: 80,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      MediaQuery.of(context).size.width / 4,
                                  vertical: 10),
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
                                        prospectiveUserRequest.isProcessed =
                                            true;
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
                              child: Container(
                                  child: Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18, fontFamily: 'OpenSans'),
                              )),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height / 5,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 20),
                                //color: Colors.black,
                                alignment: Alignment.bottomRight,
                                child: RaisedButton.icon(
                                  icon: Icon(
                                    Icons.navigate_next,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => //App()
                                                App()));
                                  },
                                  label: Text("Skip"),
                                ),
                              ),
                            ),
                          ],
                        ),
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
