import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class LocalAdminProfile extends StatefulWidget {
  @override
  UserRequest userrequest;
  _LocalAdminProfileState createState() => _LocalAdminProfileState();
}

class _LocalAdminProfileState extends State<LocalAdminProfile> {
  //String teamTitle;
  String currUserName;

  //_localadmin_profileState(String teamTitle);
  _LocalAdminProfileState createState() => _LocalAdminProfileState();
  @override
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();

  String Email;
  int Phone;
  String username;

  @override
  initState() {
    Users = userPageVM.getUserRequests("A");

    super.initState();
  }

  Widget phone(String email) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) =>
        (FutureBuilder<List<UserRequest>>(
            future: Users,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                userList = snapshot.data;
                for (var user in userList) {
                  if (user.email == email) {
                    Phone = user.phoneNumber;
                    return Text(
                      ': ' + Phone.toString(),
                      style: TextStyle(
                          fontSize: notifier.custFontSize,
                          color: Colors.grey[400]),
                    );
                  }
                }
              }
              return CircularProgressIndicator();
            })));
  }

  bool UserRole(List<UserRequest> userList) {
    for (var user in userList) {
      currUserName = user.fullName;
    }
  }

  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var email = user.email;
    return email;
  }

  Future<String> getphonenumber() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var phoneNumber = user.phoneNumber;
    return phoneNumber;
  }

  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Scaffold(
        appBar: AppBar(
          title: Text('Profile',
              style: TextStyle(fontSize: notifier.custFontSize)),
        ),
        body: Container(
          // height: 500.0,
          // width: 400.0,
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Color(0xf0000000),
                        child: ClipOval(
                          child: Image(
                              image: AssetImage(
                                  'assets/images/default_profile_picture.png')),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(30.0, 50.0, 0, 0),
                        child: Column(
                          children: [
                            Text(
                              'Local Admin',
                              style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                  fontWeight: FontWeight.w500),
                            ),
                            FutureBuilder(
                                future: getEmail(),
                                builder: (context, snapshot) {
                                  if (snapshot.data != null) {
                                    int phone = 1;
                                    String uemail = snapshot.data;
                                    return FutureBuilder<List<UserRequest>>(
                                        future: Users,
                                        builder: (context, snapshot) {
                                          if (snapshot.data != null) {
                                            userList = snapshot.data;
                                            for (var uname in userList) {
                                              if (uname.email == uemail) {
                                                phone = uname.phoneNumber;

                                                return Row(
                                                  children: [
                                                    Text(
                                                      uname.fullName,
                                                      style: TextStyle(
                                                          fontSize: notifier
                                                              .custFontSize),
                                                    ),
                                                  ],
                                                );
                                              }
                                            }
                                          }
                                        });
                                  }
                                  return Container();
                                }),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            " Area:",
                            style: TextStyle(
                              fontSize: notifier.custFontSize,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                " Team initiated:",
                                style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FutureBuilder(
                            future: getEmail(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                int phone = 1;
                                String uemail = snapshot.data;
                                return FutureBuilder<List<UserRequest>>(
                                    future: Users,
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        userList = snapshot.data;
                                        for (var uname in userList) {
                                          if (uname.email == uemail) {
                                            phone = uname.phoneNumber;

                                            return Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Row(
                                                children: [
                                                  Text("  "),
                                                  Text(
                                                    "Call: ",
                                                    style: TextStyle(
                                                      fontSize:
                                                      notifier.custFontSize,
                                                      decoration: TextDecoration
                                                          .underline,
                                                    ),
                                                  ),
                                                  Text(" "),
                                                  Text(
                                                    uname.phoneNumber
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: notifier
                                                            .custFontSize),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    });
                              }
                              return Container();
                            }),
                        FutureBuilder(
                            future: getEmail(),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                final String currUserEmail =
                                snapshot.data.toString();
                                return FutureBuilder<List<UserRequest>>(
                                    future: Users,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<UserRequest>>
                                        snapshot) {
                                      if (snapshot.data != null) {
                                        userList = snapshot.data
                                            .where((element) =>
                                        element.email == currUserEmail)
                                            .toList();

                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Text("  "),
                                              Text(
                                                "Email Id:",
                                                style: TextStyle(
                                                  fontSize:
                                                  notifier.custFontSize,
                                                  decoration:
                                                  TextDecoration.underline,
                                                ),
                                              ),
                                              Text(" "),
                                              Text(
                                                currUserEmail,
                                                style: TextStyle(
                                                    fontSize:
                                                    notifier.custFontSize),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      //return Container();
                                    });
                              }
                              return Container();
                            }),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
