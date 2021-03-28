import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'file:///D:/AndroidStudioProjects/flutter_kirthan/lib/views/pages/drawer/settings/preferences/perferences_create.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Entitlements extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<Entitlements> {
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
        title: Text('Entitlements'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: KirthanStyles.colorPallete30,
                ),
                leading: Icon(
                  Icons.account_box,
                  color: KirthanStyles.colorPallete30,
                ),
                title: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Text(
                    "Temple",
                    style: TextStyle(
                      fontSize: notifier.custFontSize,
                      color: KirthanStyles.colorPallete30,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => TempleView()));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: KirthanStyles.colorPallete30,
                ),
                leading: Icon(
                  Icons.account_box,
                  color: KirthanStyles.colorPallete30,
                ),
                title: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Text(
                    "User Temple",
                    style: TextStyle(
                      fontSize: notifier.custFontSize,
                      color: KirthanStyles.colorPallete30,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserTempleView()));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: KirthanStyles.colorPallete30,
                ),
                leading: Icon(Icons.fullscreen_exit,
                    color: KirthanStyles.colorPallete30),
                title: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Text(
                    'Roles Screen View',
                    style: TextStyle(
                      fontSize: notifier.custFontSize,
                      color: KirthanStyles.colorPallete30,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RoleScreenView()));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: KirthanStyles.colorPallete30,
                ),
                leading: Icon(
                  Icons.person_outline,
                  color: KirthanStyles.colorPallete30,
                ),
                title: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Text(
                    "Roles",
                    style: TextStyle(
                      fontSize: notifier.custFontSize,
                      color: KirthanStyles.colorPallete30,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RolesView()));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: KirthanStyles.colorPallete30,
                ),
                leading: Icon(
                  Icons.fullscreen,
                  color: KirthanStyles.colorPallete30,
                ),
                title: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Text(
                    "Screens",
                    style: TextStyle(
                      fontSize: notifier.custFontSize,
                      color: KirthanStyles.colorPallete30,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ScreensView()));
                },
                selected: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
