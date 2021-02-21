import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/entitlements_settings.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/CommonBottomNavigationBar.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/tabItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/firebasemessage_service.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/aboutus.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/rateus.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/settings_list_item.dart';
import 'package:flutter_kirthan/views/pages/event/event_create.dart';
//import 'package:flutter_kirthan/views/pages/event/event_search.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/widgets/event/event_panel.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'faq.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String photoUrl;
  String name;
  void loadPref() async {
    SignInService().firebaseAuth.currentUser().then((onValue) {
      photoUrl = onValue.photoUrl;
      name = onValue.displayName;
      print(name);
      print(photoUrl);
    });
    //print(userdetails.length);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Drawer(
              child: ListView(
                children: <Widget>[
                  Card(
                    child: ListTile(
// title: Text("Profile"),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          CircleAvatar(
                            child: photoUrl != null
                                ? Image.network(
                                    photoUrl,
                                    fit: BoxFit.contain,
                                  )
                                : Image.network(
                                    'assets/images/login_user.jpg',
                                    fit: BoxFit.scaleDown,
                                  ),
                          ),
                          Expanded(
                            child: Text(
                              name != null ? name : "AA",
                              style: TextStyle(
                                fontSize: notifier.custFontSize,
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: null,
                      onTap: () {},
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        "Participated Teams",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                      trailing: Icon(Icons.phone_in_talk),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: Text(
                        "Entitlements",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                      trailing: Icon(Icons.list),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Entitlements()));
                      },
                    ),
                  ),
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
                  Card(
                    child: ListTile(
                      title: Text(
                        "Share app",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                      trailing: Icon(Icons.share),
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext bc) {
                              return Container(
                                child: new Wrap(
                                  children: <Widget>[
                                    new ListTile(
                                        leading: new Icon(Icons.apps),
                                        title: new Text(
                                          'WhatsApp',
                                          style: TextStyle(
                                              fontSize: notifier.custFontSize),
                                        ),
                                        onTap: () => {}),
                                    new ListTile(
                                      leading: new Icon(Icons.mail),
                                      title: new Text(
                                        'Mail',
                                        style: TextStyle(
                                            fontSize: notifier.custFontSize),
                                      ),
                                      onTap: () => {},
                                    ),
                                    new ListTile(
                                      leading: new Icon(Icons.message),
                                      title: new Text(
                                        'Sms',
                                        style: TextStyle(
                                            fontSize: notifier.custFontSize),
                                      ),
                                      onTap: () => {},
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                    ),
                  ),
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
                                  print("onSubmitPressed: rating = $rating");
                                },
                                onAlternativePressed: () {
                                  print("onAlternativePressed: do something");
                                },
                              );
                            });
/*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RateUsApp()));*/
                      },
                    ),
                  ),
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
                  Card(
                    child: ListTile(
                      title: Text(
                        "FAQs",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                      trailing: Icon(Icons.question_answer),
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => FaqApp()));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                        title: Text(
                          "Logout",
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
                                                        print(onValue))
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
}
