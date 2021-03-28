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
import 'package:flutter_kirthan/views/pages/drawer/settings/preferences/perferences_create.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';

final PreferencesPageViewModel preferencesPageVM =
    PreferencesPageViewModel(apiSvc: PreferencesAPIService());

class PreferenceView extends StatefulWidget {
  Preferences preferencesrequest;
  PreferenceView({this.preferencesrequest});
  @override
  _PreferenceViewState createState() => _PreferenceViewState();
}

class _PreferenceViewState extends State<PreferenceView> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _updatedByController =
      new TextEditingController();
  String updatedBy;
  String arg1, arg2, arg3, arg4;
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  @override
  void initState() {
    _updatedByController.text = getCurrentUser().toString();
    return super.initState();
  }

  Widget _buildPreferencesWithData(Preferences data) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Divider(),
            Card(
              child: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => DropdownButtonFormField(
                  value: data.area,
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
                      arg1 = _value;
                      notifier.areaNotifier(arg1);
                      //preferencesrequest.area = _value;
                    });
                  },
                  onSaved: (_value) {
                    data.area = _value;
                  }, //notifier.area,
                  hint: Text(
                    'Area',
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
                        value: data.localAdmin,
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
                            arg2 = _value;
                            notifier.localAdminNotifier(arg2);
                          });
                        },
                        onSaved: (_value) {
                          data.localAdmin = _value;
                        },
                        hint: Text(
                          'Local Admin',
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                      )),
            ),
            Divider(),
            Card(
              child: Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => DropdownButtonFormField(
                  value: data.eventDuration.toString(),
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
                      arg3 = _value;
                      notifier.durationNotifier(arg3);
                      // print(notifier.duration);
                    });
                  },
                  onSaved: (_value) {
                    data.eventDuration = int.parse(_value);
                  },
                  hint: Text(
                    'Kirthan Duration',
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
                        value: data.requestAcceptance,
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
                            arg4 = _value;
                            notifier.requestAcceptanceNotifier(arg4);
                          });
                        },
                        onSaved: (_value) {
                          data.requestAcceptance = _value;
                        },
                        hint: Text(
                          'Request Acceptance',
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
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
                        data.userid = email;
                        _formKey.currentState.save();
                        String prefStr = jsonEncode(data.toStrJson());
                        await preferencesPageVM
                            .submitUpdatePreferences(prefStr);
                        print("Preference updated");
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perferences'),
      ),
      key: _scaffoldKey,
      body: FutureBuilder(
          future: preferencesPageVM.getPreferences(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data.isEmpty
                  ? Future.delayed(Duration.zero, () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreferenceWrite()));
                    })
                  : ListView.builder(
                      itemBuilder: (context, int index) =>
                          _buildPreferencesWithData(snapshot.data[0]),
                      itemCount: 1);
            } else if (snapshot.hasError) {
              print(snapshot);
              print(snapshot.error.toString() + " Error ");
              return Center(child: Text('Error loading notifications'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
