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
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';

final TemplePageViewModel templePageVM =
    TemplePageViewModel(apiSvc: TempleAPIService());
final PreferencesPageViewModel preferencesPageVM =
    PreferencesPageViewModel(apiSvc: PreferencesAPIService());
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

class PreferenceWrite extends StatefulWidget {
  final String screenName = SCR_PREF;
  @override
  _PreferenceWriteState createState() => _PreferenceWriteState();
}

class _PreferenceWriteState extends State<PreferenceWrite> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Preferences preferencesrequest = new Preferences();

  String dropdownValue = '';
  String arg1;
  String arg2;
  String arg3;
  String arg4;

  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    preferencesrequest.userid = email;
    //print(email);
    return email;
  }

  Widget _buildPreferences() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perferences'),
      ),
      key: _scaffoldKey,
      body: Form(
        key: _formKey,
        autovalidate: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Divider(),
              Card(
                child: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) =>
                      DropdownButtonFormField(
                    //value: arg1,
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
                        arg1 = _value;
                        notifier.areaNotifier(arg1);
                        //preferencesrequest.area = _value;
                      });
                    },
                    onSaved: (_value) {
                      preferencesrequest.area = _value;
                    }, //notifier.area,
                    hint: Text(
                      notifier.area == " " ? 'Area' : notifier.area,
                      style: TextStyle(fontSize: notifier.custFontSize),
                    ),
                  ),
                ),
              ),
              Divider(),
              Card(
                child: Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) =>
                        DropdownButtonFormField(
                          //value: arg2,
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
                              //print(_value);
                              arg2 = _value;
                              notifier.localAdminNotifier(arg2);
                            });
                          },
                          onSaved: (_value) {
                            preferencesrequest.localAdmin = _value;
                          },
                          hint: Text(
                            notifier.localAdmin == " "
                                ? 'Local Admin'
                                : notifier.localAdmin,
                            style: TextStyle(fontSize: notifier.custFontSize),
                          ),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Local Admin';
                          //   }
                          //   return null;
                          // },
                        )),
              ),
              Divider(),
              Card(
                child: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) =>
                      DropdownButtonFormField(
                    //value: arg3,
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
                        value: "3",
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
                        // print(notifier.duration);
                      });
                    },
                    onSaved: (_value) {
                      preferencesrequest.eventDuration = int.parse(_value);
                    },
                    hint: Text(
                      notifier.duration == " "
                          ? 'Kirthan Duration'
                          : notifier.duration,
                      style: TextStyle(fontSize: notifier.custFontSize),
                    ),
                    // validator: (value) {
                    //   if (value.isEmpty) {
                    //     return 'Event Duration';
                    //   }
                    //   return null;
                    // },
                  ),
                ),
              ),
              Divider(),
              Card(
                child: Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) =>
                        DropdownButtonFormField(
                          //value: arg4,
                          items: [
                            DropdownMenuItem<String>(
                              value: "One week before",
                              child: Text(
                                "One week before",
                                style:
                                    TextStyle(fontSize: notifier.custFontSize),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "15 days before",
                              child: Text(
                                "15 days before",
                                style:
                                    TextStyle(fontSize: notifier.custFontSize),
                              ),
                            ),
                            DropdownMenuItem<String>(
                              value: "1 month before",
                              child: Text(
                                "1 month before",
                                style:
                                    TextStyle(fontSize: notifier.custFontSize),
                              ),
                            ),
                          ],
                          onChanged: (_value) {
                            setState(() {
                              dropdownValue = _value;
                              //print(_value);
                              arg4 = _value;
                              notifier.requestAcceptanceNotifier(arg4);
                            });
                          },
                          onSaved: (_value) {
                            preferencesrequest.requestAcceptance = _value;
                          },
                          hint: Text(
                            notifier.requestAcceptance == " "
                                ? 'Request Acceptance'
                                : notifier.requestAcceptance,
                            style: TextStyle(fontSize: notifier.custFontSize),
                          ),
                          // validator: (value) {
                          //   if (value.isEmpty) {
                          //     return 'Request Acceptance';
                          //   }
                          //   return null;
                          // },
                        )),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) => MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          final FirebaseUser user = await auth.currentUser();
                          final String email = user.email;
                          preferencesrequest.userid = email;
                          _formKey.currentState.save();
                          Map<String, dynamic> usermap =
                              preferencesrequest.toJson();
                          print(usermap);
                          Preferences newscreensrequest =
                              await preferencesPageVM
                                  .submitNewPreferences(usermap);
                          print(newscreensrequest.id);
                          String eid = newscreensrequest.id.toString();
                          print("Preference added");
                          SnackBar mysnackbar = SnackBar(
                            content:
                                Text("Preference added $successful with $eid"),
                            duration: new Duration(seconds: 4),
                            backgroundColor: Colors.green,
                          );
                          _scaffoldKey.currentState.showSnackBar(mysnackbar);
                        }
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildPreferences();
  }
}
