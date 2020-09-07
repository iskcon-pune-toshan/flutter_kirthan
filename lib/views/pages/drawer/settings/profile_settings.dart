import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/contact_details_profile_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/description_profile_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/members_name_profile.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/password_profile_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/profile_picture.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/team_name.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/user_name_profile.dart';

class MyProfileSettings extends StatefulWidget {
  @override
  _MyProfileSettingsState createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends State<MyProfileSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Settings'),
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
                leading: Icon(Icons.account_circle),
                title: Text(
                  'Profile Picture',
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => profilePicture(),
                      ));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.people),
                title: Text(
                  'Team Name',
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => teamName(),
                      ));


                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.perm_identity),
                title: Text(
                  'User Name',
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => userName_profile(),
                      ));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.content_paste),
                title: Text(
                  'Description/Type',
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => description_profile(),
                  ));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.group_add),
                title: Text(
                  'Members',
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                      builder: (context) => members_profile(),

                  ));
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.contacts),
                title: Text(
                  'Contact Details',
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => contact_details_profile(),

                  )
                  );
                },
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.my_location),
                title: Text(
                  'Location',
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
                onTap: () {},
                selected: true,
              ),
            ),
            Divider(),
            Card(
              child: ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                leading: Icon(Icons.keyboard),
                title: Text(
                  'Password',
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => password_profile()),

                  );
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
