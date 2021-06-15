import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:url_launcher/url_launcher.dart';

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());
final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());
int user_id;
String user_name;

class TeamInitiateUserDetails extends StatefulWidget {
  String UserName;
  TeamInitiateUserDetails({this.UserName});
  @override
  _TeamInitiateUserDetailsState createState() =>
      _TeamInitiateUserDetailsState(UserName);
}

class _TeamInitiateUserDetailsState extends State<TeamInitiateUserDetails> {
  String UserName;
  String currUserRole;
  _TeamInitiateUserDetailsState(this.UserName);
  String Email;
  int Phone;
  String photoUrl;
  String message;
  String inviteCode = randomAlphaNumeric(6);
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  UserRequest userrequest = new UserRequest();

  void loadPref() async {
    SignInService().firebaseAuth.currentUser().then((onValue) {
      photoUrl = onValue.photoUrl;
      //print(photoUrl);
    });
    //print(userdetails.length);
  }

  @override
  void initState() {
    Users = userPageVM.getUserRequests('Approved');
    getUserId();
    super.initState();
  }

  String currentUserName;
  getUserName() async {
    final FirebaseUser user = await auth.currentUser();
    userList = await userPageVM.getUserRequests("Approved");
    for (var users in userList) {
      if (users.email == user.email) {
        user_name = users.fullName;
        currentUserName = user_name;
      }
    }
  }

  int currentUserId;
  getUserId() async {
    final FirebaseUser user = await auth.currentUser();
    userList = await userPageVM.getUserRequests("Approved");
    for (var users in userList) {
      //  print("Role Id is");
      if (users.email == user.email) {
        setState(() {
          user_id = users.id;
          currentUserId = user_id;
        });
      }
    }
  }

  bool UserRole(List<UserRequest> userList) {
    for (var user in userList) {
      // UserName = user.userName;
      // print("In User Role function, role id is");
      // print(user.roleId);
      if (user.fullName == UserName) {
        if (user.roleId == 1) {
          currUserRole = "Admin";
        } else if (user.roleId == 2) {
          currUserRole = "Local Admin";
        } else if (user.roleId == 3) {
          currUserRole = "User";
        }
      }
      // print("User role $currUserRole");
    }
    if (currUserRole != null)
      return true;
    else
      return false;
  }

  Widget ProfilePages() {
    return FutureBuilder<List<UserRequest>>(
        future: Users,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            userList = snapshot.data;
            for (var uname in userList)
              if (uname.fullName == UserName) {
                String _email = uname.email;
                String _photoName = _email + '.jpg';
                final ref = FirebaseStorage.instance.ref().child(_photoName);
                return FutureBuilder(
                    future: ref.getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return new Image.network(snapshot.data,
                            fit: BoxFit.fill);
                      }
                      return Image.asset(
                        "assets/images/default_profile_picture.png",
                        fit: BoxFit.fill,
                      );
                    });
              }
          }
          return Image.asset(
            "assets/images/default_profile_picture.png",
            fit: BoxFit.fill,
          );
        });
  }

  TeamRequest teamrequest = new TeamRequest();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
          title: Text(
            'User Details',
            style: TextStyle(color: KirthanStyles.colorPallete60),
          ),
          backgroundColor: KirthanStyles.colorPallete30,
        ),
        body: Consumer<ThemeNotifier>(
          builder:(context, notifier, child)=>
              FutureBuilder<List<UserRequest>>(
              future: Users,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  userList = snapshot.data;
                  for (var uname in userList) {
                    if (uname.fullName == UserName) {
                      Email = uname.email;
                      Phone = uname.phoneNumber;
                      return Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          FractionallySizedBox(
                            alignment: Alignment.topCenter,
                            heightFactor: 0.2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: KirthanStyles.colorPallete30,
                              ),
                            ),
                          ),
                          FractionallySizedBox(
                            alignment: Alignment.bottomCenter,
                            heightFactor: 0.95,
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20)),
                                color:notifier.darkTheme?Colors.grey[800]:Colors.white,
                              ),
                              child: SingleChildScrollView(
                                child: Column(children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Color(0xf0000000),
                                        child: ClipOval(
                                          child: new SizedBox(
                                            width: 100.0,
                                            height: 100.0,
                                            child: (photoUrl != null)
                                                ? Image.network(
                                              photoUrl,
                                              fit: BoxFit.contain,
                                            )
                                                : ProfilePages(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 30,
                                      ),
                                      Container(width: MediaQuery.of(context).size.width*0.5,
                                        margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: <Widget>[
                                            UserRole(userList)
                                                ? Container(width:220,

                                                  child: Text(
                                              currUserRole,
                                              style: TextStyle(
                                                    fontSize: 19+notifier.custFontSize,
                                                    fontWeight:
                                                    FontWeight.w800),
                                            ),
                                                )
                                                : Text("No User"),
                                            Divider(),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(
                                              width: 220,
                                              child: Text(
                                                UserName,
                                                style: TextStyle(fontSize: 2+notifier.custFontSize),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(20, 0, 5, 5),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      'Contact Details:',
                                      style: TextStyle(
                                          fontSize: 2+notifier.custFontSize,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.call,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        ': ' + Phone.toString(),
                                        style: TextStyle(fontSize: notifier.custFontSize),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.mail,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Container(width: 320,
                                        child: Text(
                                          ':' + Email,
                                          style: TextStyle(fontSize: notifier.custFontSize),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Divider(
                                        thickness: 3,
                                      ),
                                      SizedBox(height: 5),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.pin_drop,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Center(
                                        child: Container(
                                          padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
                                          width: MediaQuery.of(context).size.width *
                                              0.7,
                                          height: 40,
                                          margin:
                                          EdgeInsets.fromLTRB(10, 10, 20, 0),
                                          decoration: BoxDecoration(
                                              color: Colors.grey[500],
                                              border: Border.all(
                                                style: BorderStyle.solid,
                                              )),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              uname.locality,
                                              style: TextStyle(color: Colors.black,fontSize: notifier.custFontSize),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Divider(
                                    thickness: 1,
                                  ),
                                  SizedBox(height: 20),
                                  // Align(
                                  //   alignment: Alignment.centerLeft,
                                  //   child: TextField(
                                  //     decoration: InputDecoration(
                                  //         fillColor: Colors.grey[700],
                                  //         border: OutlineInputBorder(),
                                  //         hintText: 'Add a message',
                                  //         icon: Icon(Icons.add)),
                                  //     style: TextStyle(color: Colors.white70,fontSize: notifier.custFontSize),
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                  RaisedButton(
                                      color: KirthanStyles.colorPallete30,
                                      child: Text('Send invite'),
                                      onPressed: () async {
                                        List<TeamRequest> checkTeamPresent =
                                        await teamPageVM.getTeamRequests(
                                            "teamLeadId:" + Email);
                                        if (checkTeamPresent.isEmpty) {
                                          setState(() {
                                            uname.invitedBy = currentUserId;
                                            String userrequestStr =
                                            jsonEncode(uname.toStrJson());
                                            userPageVM
                                                .submitInitiateTeam(userrequestStr)
                                                .whenComplete(() =>
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                  content: Text(
                                                      'Invite sent $successful'),
                                                  backgroundColor: Colors.green,
                                                )));
                                          });
                                        } else {
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                '${uname.fullName} already has a team'),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
                                      })
                                ]),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  }
                }
                return Container();
              }),
        ),
      );
  }
}