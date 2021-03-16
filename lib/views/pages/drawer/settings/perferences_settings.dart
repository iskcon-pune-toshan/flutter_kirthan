import 'dart:convert';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/preferences.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/preferences_service_impl.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/preference_page_view_model.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
//import'package:flutter_kirthan/views/pages/drawer/settings/impl_perferences.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';

final TemplePageViewModel templePageVM =
    TemplePageViewModel(apiSvc: TempleAPIService());
final PreferencesPageViewModel preferencesPageVM =
    PreferencesPageViewModel(apiSvc: PreferencesAPIService());
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

class PreferenceSettings extends StatefulWidget {
  // PreferenceSettings(
  //     {@required this.preferencerequest, @required this.preferencePageVM});
  final String screenName = "Preferences";
  @override
  _PreferenceSettingsState createState() => _PreferenceSettingsState();
}

class _PreferenceSettingsState extends State<PreferenceSettings> {
  final Preferences preferencesrequest = new Preferences();
  SharedPreferences prefs;

  String dropdownValue = '';
  String arg1 = null;

  String arg2 = null;
  String arg3 = null;
  String arg4 = null;

  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
            access.elementAt(1).toLowerCase() == "true" ? true : false;
      });
      preferencesPageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await preferencesPageVM.setPreferences("19");
  }

  @override
  void initState() {
    super.initState();
    loadData();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perferences'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Divider(),
            Card(
              child: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => DropdownButton<String>(
                  items: [
                    DropdownMenuItem<String>(
                      value: "NVCC",
                      child: Text(
                        "NVCC",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "Katraj",
                      child: Text(
                        "Katraj",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "Camp",
                      child: Text(
                        "Camp",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "Koregaon",
                      child: Text(
                        "Koregaon",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                  ],
                  onChanged: (_value) {
                    setState(() {
                      dropdownValue = _value;
                      print(_value);
                      arg1 = _value;
                      notifier.areaNotifier(arg1);
                      preferencesrequest.area = _value;
                    });
                  }, //notifier.area,
                  hint: Text(
                    // widget.preferencerequest.eventDuration == " "
                    //     ? 'Area'
                    //     : widget.preferencerequest.eventDuration,
                    notifier.area == " " ? 'Area' : notifier.area,
                    style: TextStyle(fontSize: notifier.custFontSize),
                  ),
                ),
              ),
            ),
            Divider(),
            Card(
              child: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => DropdownButton<String>(
                        items: <String>[
                          'Local Admin 1',
                          'Local Admin 2',
                          'Local Admin 3',
                          'Local Admin 4'
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_value) {
                          setState(() {
                            dropdownValue = _value;
                            print(_value);
                            arg2 = _value;
                            notifier.localAdminNotifier(arg2);
                            preferencesrequest.localAdmin = _value;
                          });
                        },
                        hint: Text(
                          notifier.localAdmin == " "
                              ? 'Local Admin'
                              : notifier.localAdmin,
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                      )),
            ),
            Divider(),
            Card(
              child: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => DropdownButton<String>(
                  items: [
                    DropdownMenuItem<String>(
                      value: "1",
                      child: Text(
                        "1 hour",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "2",
                      child: Text(
                        "2 hours",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "0",
                      child: Text(
                        "less than 1 hour",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "2",
                      child: Text(
                        "greater than 1 hour",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                  ],
                  onChanged: (_value) {
                    setState(() {
                      dropdownValue = _value;
                      //print(_value);
                      arg3 = _value;
                      notifier.durationNotifier(arg3);
                      print(notifier.duration);
                      preferencesrequest.eventDuration = int.parse(_value);
                    });
                  },
                  hint: Text(
                    notifier.duration == " "
                        ? 'Kirthan Duration'
                        : notifier.duration,
                    style: TextStyle(fontSize: notifier.custFontSize),
                  ),
                ),
              ),
            ),
            Divider(),
            Card(
              child: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => DropdownButton<String>(
                        items: [
                          DropdownMenuItem<String>(
                            value: "One week before",
                            child: Text(
                              "One week before",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "15 days before",
                            child: Text(
                              "15 days before",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "1 month before",
                            child: Text(
                              "1 month before",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                          ),
                        ],
                        onChanged: (_value) {
                          setState(() {
                            dropdownValue = _value;
                            print(_value);
                            arg4 = _value;
                            notifier.requestAcceptanceNotifier(arg4);
                            preferencesrequest.requestAcceptance = _value;
                          });
                        },
                        hint: Text(
                          notifier.requestAcceptance == " "
                              ? 'Request Acceptance'
                              : notifier.duration,
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                      )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => RaisedButton(
                    onPressed: () async {
                      Map<String, dynamic> usermap =
                          preferencesrequest.toJson();
                      print(usermap);
                      Preferences newscreensrequest =
                          await preferencesPageVM.submitNewPreferences(usermap);
                      print(newscreensrequest.id);
                      print("Preference added");
                    },
                    child: Text('Submit'),
                    padding: const EdgeInsets.all(16.0),
                    elevation: 10.0,
                    color: Colors.green,
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                  padding: const EdgeInsets.all(16.0),
                  elevation: 10.0,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
