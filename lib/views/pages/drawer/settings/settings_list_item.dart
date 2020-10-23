import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/perferences_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySettingsApp extends StatefulWidget {
  @override
  //static double custFontSize = 16;
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.perm_contact_calendar),

                title: Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
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
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.check_circle_outline),

                title: Text(
                  "Perferences",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PerferenceSettings()));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.brightness_4),

                title: Text(
                  "Display",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
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
            Divider(),
            Card(
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
                title: Text("Notifications",style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),),
                onChanged: (value) {
                  setState(() {
                    getNotification();
                    _v = value;
                  });


                },
                value: _v,
                secondary: Icon(Icons.notifications_active),
              ),
            ),


          ],
        ),
      ),
    );
  }

  _showMaterialDialog() {

    /*showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Notifications"),
          content: new Text("Do you want to get notifications on phone?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));


     */
  bool _v = false;
  /*return SwitchListTile(
    onChanged: (value) {
      setState(() {
        getNotification();
        _v = value;
      });


    },
    value: _v,

  );
*/

  }

}
