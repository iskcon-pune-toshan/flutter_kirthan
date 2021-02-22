import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:screen/screen.dart';

class FaqApp extends StatefulWidget {
  @override
  static double custFontSize = 16;
  _FaqState createState() => new _FaqState();
}

class _FaqState extends State<FaqApp> {
  double _brightness = 1.0;

  void changeFontSize() async {
    setState(() {
      FaqApp.custFontSize += 2;
    });
  }

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    double brightness = await Screen.brightness;
    setState(() {
      _brightness = brightness;
    });
  }

  String dropdownValue = 'Select q';
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Card(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: <Widget>[
                      Row(children: <Widget>[
                        Center(
                          child: Text("   Frequently Asked Questions",
                              style: TextStyle(
                                //fontFamily: 'Sacramento',
                                  fontSize: 25,

                                  fontWeight: FontWeight.bold)),
                        ),
                      ]),

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
                              "1.First login to your account\n\n2.Request for the code to become local admin\n\n3.Enter the code recieved to become local admin",
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

                      // SizedBox(
                      //   height: 10,
                      // ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
