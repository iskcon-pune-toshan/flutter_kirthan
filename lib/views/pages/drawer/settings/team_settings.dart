import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';

import 'profile_settings_page/description_profile_settings.dart';
import 'profile_settings_page/members_name_profile.dart';
import 'profile_settings_page/team_name.dart';

class Team_Settings extends StatefulWidget {
  @override
  _Team_SettingsState createState() => _Team_SettingsState();
}

class _Team_SettingsState extends State<Team_Settings> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => (Scaffold(
              appBar: AppBar(
                elevation: 0,
                title: Text(
                  'Team Settings',
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
                              Icons.group_outlined,
                              color: KirthanStyles.colorPallete30,
                            ),
                            title: Consumer<ThemeNotifier>(
                              builder: (context, notifier, child) => Text(
                                'Team Name',
                                style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                  color: notifier.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  //color: KirthanStyles.colorPallete30,
                                ),
                              ),
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
                        Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.black, width: 0.5),
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: Icon(
                              Icons.group_add_outlined,
                              color: KirthanStyles.colorPallete30,
                            ),
                            title: Consumer<ThemeNotifier>(
                              builder: (context, notifier, child) => Text(
                                'Members',
                                style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                  color: notifier.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  //color: KirthanStyles.colorPallete30,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => members_profile(
                                      show: false,
                                    ),
                                  ));
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
                              Icons.content_paste,
                              color: KirthanStyles.colorPallete30,
                            ),
                            title: Consumer<ThemeNotifier>(
                              builder: (context, notifier, child) => Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                  color: notifier.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  //color: KirthanStyles.colorPallete30,
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => description_profile(),
                                  ));
                            },
                            selected: true,
                          ),
                        ),
                      ],
                    )))),
              ),
            )));
  }
}
