import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/preferences/perferences_create.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/team_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettingsApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MySettingsApp> {
  final String _allowNotification = "";
  bool _v = false;

  Future<bool> setNotifcation(bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.setBool(_allowNotification, value);
  }

  Future<bool> getNotification() async {
    print("Entered");
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_allowNotification);
  }

  @override
  void initState() {
    getNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => (Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: Text(
                'Settings',
                style: TextStyle(fontSize: notifier.custFontSize),
              ),
            ),
            body: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => ((SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(
                          Icons.perm_contact_calendar,
                          size: 30,
                          color: KirthanStyles.colorPallete30,
                        ),
                        title: Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Text(
                            'Profile',
                            style: TextStyle(
                              fontSize: notifier.custFontSize,
                              color: notifier.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyProfileSettings()));
                        },
                        selected: true,
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(
                          Icons.group_outlined,
                          size: 30,
                          color: KirthanStyles.colorPallete30,
                        ),
                        title: Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Text(
                            'Team',
                            style: TextStyle(
                              fontSize: notifier.custFontSize,
                              color: notifier.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Team_Settings()));
                        },
                        selected: true,
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(
                          Icons.done,
                          size: 30,
                          color: KirthanStyles.colorPallete30,
                        ),
                        title: Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Text(
                            "Preferences",
                            style: TextStyle(
                              fontSize: notifier.custFontSize,
                              color: notifier.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        onTap: () async {
                          //List<UserRequest> uList
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Preference(
                                    user: null,
                                  )));
                        },
                        selected: true,
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: Icon(
                          Icons.brightness_4,
                          size: 30,
                          color: KirthanStyles.colorPallete30,
                        ),
                        title: Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Text(
                            "Display",
                            style: TextStyle(
                              fontSize: notifier.custFontSize,
                              color: notifier.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyPrefSettingsApp()));
                        },
                        selected: true,
                      ),
                    ),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 0.5),
                          borderRadius: BorderRadius.circular(8)),
                      /*child: ListTile(
                    leading: Icon(Icons.notifications_active),

                    title: Text(
                      "Notifications",

                      style: TextStyle(
                        fontSize: MyPrefSettingsApp.custFontSize,
                      ),
                    ),
                    onTap: () {
                      _showMaterialDialog();

                    },
                    selected: true,
                  ),

                   */
                      child: SwitchListTile(
                        activeColor: Colors.cyan,
                        title: Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Text(
                            "Notification",
                            style: TextStyle(
                              fontSize: notifier.custFontSize,
                              color: notifier.darkTheme
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          return showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Notifications'),
                                  content: Text(
                                      'Do you want to get notifications on phone?'),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          getNotification();
                                          _v = true;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('Yes'),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          _v = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Text('No'),
                                    ),
                                  ],
                                );
                              });
                        },
                        value: _v,
                        secondary: Icon(
                          Icons.notifications_outlined,
                          size: 30,
                          color: KirthanStyles.colorPallete30,
                        ),
                      ),
                    ),
                  ],
                ),
              ))),
            ))));
  }

//   _showMaterialDialog() {
//     showDialog(
//         context: context,
//         builder: (_) => new AlertDialog(
//           title: new Text("Notifications"),
//           content: new Text("Do you want to get notifications on phone?"),
//           actions: <Widget>[
//             FlatButton(
//               child: Text('Yes'),
//               onPressed: () {
//                 return true;
//               },
//             ),
//             FlatButton(
//               child: Text('No'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         ));
//   //   bool _v = false;
//   //   return SwitchListTile(
//   //   onChanged: (value) {
//   //     setState(() {
//   //       getNotification();
//   //       _v = value;
//   //     });
//   //
//   //
//   //   },
//   //   value: _v,
//   //
//   // );
//
//   }
}
