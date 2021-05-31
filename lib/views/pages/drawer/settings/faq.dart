import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:screen/screen.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class FaqApp extends StatefulWidget {
  @override
  static double custFontSize = 16;
  _FaqAppState createState() => new _FaqAppState();
}

class _FaqAppState extends State<FaqApp> {
  String email;
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  double _brightness = 1.0;

  void changeFontSize() async {
    setState(() {
      FaqApp.custFontSize += 2;
    });
  }

  @override
  initState() {
    Users = userPageVM.getUserRequests("A");
    super.initState();
    //initPlatformState();
  }

  // initPlatformState() async {
  //   double brightness = await Screen.brightness;
  //   setState(() {
  //     _brightness = brightness;
  //   });
  // }

  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    email = user.email;
    return email;
  }

  Future<String> getphonenumber() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var phoneNumber = user.phoneNumber;
    return phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FAQs'),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: Text("Frequently Asked Questions",
                              style: TextStyle(
                                  //fontFamily: 'Sacramento',
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      Container(
                        child: ExpansionTile(
                          title: Text(
                            'How to create new event? ',
                            style: TextStyle(fontSize: 16),
                          ),
                          children: <Widget>[
                            ListTile(
                              title: Text(
                                "1.Login with your preferred ID\n\n2.Click on + on Event-View page.\n\n3. Fill in the details and click on submit button.",
                                style: TextStyle(fontSize: 14),
                              ),
                            )
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ExpansionTile(
                        title: Text(
                          'How to create your own team?   ',
                          style: TextStyle(fontSize: 16),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "1.Log in with your Id\n\n2.Request gets approved by the Local Admin\n\n3.Enter code given by local admin\n\n4.On Team-view, click on the + icon at the bottom\n\n5.Fill the details.\n\n6.Select submit button\n\n7.Wait for the approval by the local admin.",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ExpansionTile(
                        title: Text(
                          'How to add a team member?                        ',
                          style: TextStyle(fontSize: 16),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ExpansionTile(
                        title: Text(
                          'How to become local admin?                        ',
                          style: TextStyle(fontSize: 16),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "1.First login to your account\n\n2.Request for the code to become local admin\n\n3.Enter the code received to become local admin",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ExpansionTile(
                        title: Text(
                          'How to send an invite to a team?                 ',
                          style: TextStyle(fontSize: 16),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ExpansionTile(
                        title: Text(
                          'How to Update an event?  ',
                          style: TextStyle(fontSize: 16),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "1. Go to the team profile screen\n\n2.Click on the three dots, and select edit\n\n3.Update information and send an update request\n\n4.Request get approved or Rejected by admin\n\n5.If admin approves request information is updated\n\n6.If admin rejects request user gets rejection status for update",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      ExpansionTile(
                        title: Text(
                          'How to change the theme to mode              '
                          '\n'
                          'Light/Dark mode and adjust text size?',
                          style: TextStyle(fontSize: 16),
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              "1.Select hamburger menu from home page.\n\n2.Select setting.\n\n3.Select display.\n\n4.You can select dark mode and light mode.\n\n5.Select preference size for the font.",
                              style: TextStyle(fontSize: 14),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: Colors.white,
                        thickness: 1,
                      ),
                      FutureBuilder<List<UserRequest>>(
                          future: Users,
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              userList = snapshot.data;
                              List<String> localAdminNameList =
                                  userList.map((e) => e.fullName).toList();
                              List<int> localAdminPhoneList =
                                  userList.map((e) => e.phoneNumber).toList();
                              //  print(
                              //   '***************************************');
                              //print(localAdminList);

                              // String CurrentUserName = "string";
                              // String uemail = snapshot.data;
                              return ExpansionTile(
                                title: Container(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text("Local Admin list")),
                                children: [
                                  ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: localAdminPhoneList.length,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          padding: EdgeInsets.only(bottom: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                localAdminNameList[index],
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey[400]),
                                              ),
                                              Text(
                                                localAdminPhoneList[index]
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.grey[400]),
                                              ),
                                            ],
                                          ),
                                        );
                                      })
                                ],
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
