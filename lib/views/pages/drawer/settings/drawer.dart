import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/aboutus.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/settings_list_item.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/signin/signup.dart';
import 'package:flutter_kirthan/views/pages/team/request_code.dart';
import 'package:flutter_kirthan/views/pages/team/team_profile_page.dart';
import 'package:flutter_kirthan/views/pages/user/inviteLocalAdmin.dart';
import 'package:flutter_kirthan/views/pages/user/localadmin_profile.dart';
import 'package:flutter_kirthan/views/pages/user/user_profile_page.dart';
import 'package:flutter_kirthan/views/pages/user/inviteLocalAdmin.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:share/share.dart';
import 'faq.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  List<UserRequest> userRequest = List<UserRequest>();
  int role_id;
  String photoUrl;
  String name;
  Future<List<UserRequest>> Users;
  String currUserName;
  String currUserRole;
  String currUserEmail;
  String team_title;
  Future<List<TeamRequest>> Teams;
  List<TeamRequest> teamList = new List<TeamRequest>();
  List<UserRequest> userList = new List<UserRequest>();
  void loadPref() async {
    SignInService().firebaseAuth.currentUser().then((onValue) {
      photoUrl = onValue.photoUrl;
      name = onValue.displayName;
      //print(name);
      //print(photoUrl);
    });
    //print(userdetails.length);
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

  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    Teams = teamPageVM.getTeamRequests('Approved');
    getUserId();
    getRoleId();
    super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  getTeamTitle(List<TeamRequest> teamList, String currUserEmail) {
    for (var team in teamList) {
      if (team.teamLeadId == currUserEmail) {
        team_title = team.teamTitle;
      }
    }
  }

  bool UserRole(List<UserRequest> userList) {
    for (var user in userList) {
      currUserName = user.fullName;
     // print("In User Role function, role id is");
     // print(user.roleId);
      if (user.id == currentUserId) {
        if (user.roleId == 1) {
          currUserRole = "Admin";
        } else if (user.roleId == 2) {
          currUserRole = "Local Admin";
        } else if (user.roleId == 3) {
          currUserRole = "User";
        } else if (user.roleId == 4) {
          currUserRole = "Team lead";
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
    return FutureBuilder(
        future: getEmail(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            String _email = snapshot.data + '.jpg';
           /* print("\n\n\n\n\n\n\n\n\n\n\n Email : " +
                _email +
                "\n\n\n\n\n\n\n\n");*/
            final ref = FirebaseStorage.instance.ref().child(_email);
            return FutureBuilder(
                future: ref.getDownloadURL(),
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    return new Image.network(snapshot.data, fit: BoxFit.fill);
                  }
                  return Image.asset(
                    "assets/images/default_profile_picture.png",
                    fit: BoxFit.fill,
                  );
                });
          }
          return Row(
            children: [
              Image.asset(
                "assets/images/default_profile_picture.png",
                fit: BoxFit.fill,
              ),
              Text("No user"),
            ],
          );
        });
  }

  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Drawer(
              child: ListView(
                //shrinkWrap: true,
                children: <Widget>[
                  Card(
                    child: ListTile(
                      title: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xf0000000),
                            child: ClipOval(
                              child: new SizedBox(
                                  // width: 100.0,
                                  // height: 100.0,
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width: MediaQuery.of(context).size.width * 1,
                                  child: (photoUrl != null)
                                      ? Image.network(
                                          photoUrl,
                                          fit: BoxFit.contain,
                                        )
                                      : ProfilePages()),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
                                                    // print(
                                                    //     'yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyaaayyyyyyyyyyyyyy' +
                                                    //         team_title);
                                                    return Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        UserRole(userList)
                                                            ? Text(
                                                                currUserRole,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        notifier
                                                                            .custFontSize),
                                                              )
                                                            : Text("No role"),
                                                        Text(
                                                          currUserName,
                                                          style: TextStyle(
                                                              fontSize: 14),
                                                        ),
                                                      ],
                                                    );
                                                  }
                                                  return Container();
                                                });
                                          }
                                        }
                                        return Container();
                                      });
                                }
                                return Text(
                                  "No user",
                                  style: TextStyle(color: Colors.blue),
                                );
                              }),
                        ],
                      ),
                      trailing: null,
                      onTap: () {
                        if (currUserRole == 'Team lead') {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeamProfilePage(
                                        teamTitle: team_title,
                                      )));
                          // } else if (currUserRole == 'Local Admin') {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //           builder: (context) => LocalAdminProfile()));
                        } else if (currUserRole == 'Admin' ||
                            currUserRole == "User"||currUserRole=="Local Admin") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserProfile(
                                        UserName: currUserName,
                                      )));
                        }
                      },
                    ),
                  ),
                  if (role_id == 1)
                    Card(
                      child: ListTile(
                        title: Text(
                          "Create a Local admin",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: Icon(Icons.people_outline_outlined),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InviteLocalAdmin()));
                        },
                      ),
                    ),
                  if (role_id == 1 || role_id == 2)
                    Card(
                      child: ListTile(
                        title: Text(
                          "Events",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: Icon(Icons.event),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyEventView()));
                        },
                      ),
                    ),
                  if (role_id == 3 || role_id == 4)
                    Card(
                      child: ListTile(
                        title: Text(
                          "Create a Team",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: Icon(Icons.phone_in_talk),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RequestCode()));
                        },
                      ),
                    ),
                  // Card(
                  //   child: ListTile(
                  //     title: Text(
                  //       "Participated Teams",
                  //       style: TextStyle(fontSize: notifier.custFontSize),
                  //     ),
                  //     trailing: Icon(Icons.phone_in_talk),
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => Participated_Team()));
                  //     },
                  //   ),
                  // ),
                  // Card(
                  //   child: ListTile(
                  //     title: Text(
                  //       "Interested Events",
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     trailing: Icon(Icons.event),
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => Interested_events()));
                  //     },
                  //   ),
                  // ),
                  // Card(
                  //   child: ListTile(
                  //     title: Text(
                  //       "Entitlements",
                  //       style: TextStyle(fontSize: notifier.custFontSize),
                  //     ),
                  //     trailing: Icon(Icons.list),
                  //     onTap: () {
                  //       Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //               builder: (context) => Entitlements()));
                  //     },
                  //   ),
                  // ),
                  Card(
                    child: ListTile(
                      title: Text(
                        "Settings",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                      trailing: Icon(Icons.settings),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MySettingsApp()));
                      },
                    ),
                  ),
                  if (role_id != 1)
                    Card(
                      child: ListTile(
                        title: Text(
                          "Rate Us",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: const Icon(Icons.rate_review),
                        onTap: () {
                          showDialog(
                              context: context,
                              barrierDismissible:
                                  true, // set to false if you want to force a rating
                              builder: (context) {
                                return RatingDialog(
                                  icon: Icon(Icons.rate_review),
                                  title: "Rate Us",
                                  description:
                                      "Tap a star to set your rating. Add more description here if you want.",
                                  submitButton: "SUBMIT",
                                  alternativeButton:
                                      "Contact us instead?", // optional
                                  positiveComment:
                                      "We are so happy to hear :)", // optional
                                  negativeComment:
                                      "We're sad to hear :(", // optional
                                  accentColor: Colors.red, // optional
                                  onSubmitPressed: (int rating) {
                                   // print("onSubmitPressed: rating = $rating");
                                  },
                                  onAlternativePressed: () {
                                   // print("onAlternativePressed: do something");
                                  },
                                );
                              });
/*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RateUsApp()));*/
                        },
                      ),
                    ),
                  if (role_id != 1)
                    Card(
                      child: ListTile(
                        title: Text(
                          "About Us",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: Icon(Icons.info),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUsApp()));
                        },
                      ),
                    ),
                  if (role_id == 1)
                    Card(
                      child: ListTile(
                        title: Text(
                          "About Us/Problems",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: Icon(Icons.info),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AboutUsApp()));
                        },
                      ),
                    ),
                  Card(
                    child: ListTile(
                      title: Text(
                        "Share the app",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                      trailing: Icon(Icons.share),
                      onTap: () {
                        Share.share(
                            "Please visit      https://drive.google.com/file/d/1HR4NYkhIbbjgFB4RFF-JidjFkb0HwdGQ/view?usp=sharing",
                            subject: "Kirtan App");
                      },
                    ),
                  ),
                  if (role_id != 1)
                    Card(
                      child: ListTile(
                        title: Text(
                          "FAQs",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: Icon(Icons.question_answer),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FaqApp()));
                        },
                      ),
                    ),
                  Card(
                    child: ListTile(
                        title: Text(
                          "Sign out",
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                        trailing: Icon(
                          Icons.settings_power,
                          color: Colors.lightBlue,
                        ),
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0)), //this right here
                                  child: Container(
                                    height: 200,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Consumer<ThemeNotifier>(
                                              builder:
                                                  (context, notifier, child) =>
                                                      Text(
                                                'Do you want to Logout?',
                                                style: TextStyle(
                                                  fontSize:
                                                      notifier.custFontSize,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 320.0,
                                            child: RaisedButton(
                                              onPressed: () {
                                                SignInService()
                                                    .signOut()
                                                    .then((onValue) =>
                                                        print(''))
                                                    .whenComplete(() =>
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        LoginApp())));
//Navigator.pop(context);
                                              },
                                              child: Text(
                                                "yes",
                                                style: TextStyle(
//fontSize: MyPrefSettingsApp.custFontSize,
                                                    color: Colors.white),
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
                                              child: Text(
                                                "No",
                                                style: TextStyle(
//fontSize: MyPrefSettingsApp.custFontSize,
                                                    color: Colors.white),
                                              ),
                                              color: const Color(0xFF1BC0C5),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              });
                        }),
                  ),
                ],
              ),
            ));
  }

  getRoleId() async {
    final FirebaseUser user = await auth.currentUser();
    userRequest = await userPageVM.getUserRequests("Approved");
    for (var users in userRequest) {
      //("HELLOHELLOHELLOHELLOHELLO");
     // print(users.email);
     // print(user.email);
      if (users.email == user.email) {
        setState(() {
          role_id = users.roleId;
        });
      }
    }
   // print("HELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLO");
    //print(email);
   // print(role_id.toString());
  }
}
