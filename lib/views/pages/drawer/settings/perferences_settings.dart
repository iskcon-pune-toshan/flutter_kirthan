import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
//import'package:flutter_kirthan/views/pages/drawer/settings/impl_perferences.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';

class PerferenceSettings extends StatefulWidget {
  @override
  _PerferenceSettingsState createState() => _PerferenceSettingsState();
}

class _PerferenceSettingsState extends State<PerferenceSettings> {
  SharedPreferences prefs;

  String dropdownValue = '';
  String arg1 = null;

  String arg2 = null;
  String arg3 = null;
  String arg4 = null;

  List<String> event;
  final baseUrl = 'http://164.52.202.127:8080'; //Rahul

  http.Client client1 = http.Client();

  final int userId = 4;

  set client(http.Client value) => client1 = value;
  Future getprefevent(String data) async {
    String requestBody = '';
    requestBody = '{"eventDuration" : "1"}';
    String token = AutheticationAPIService().sessionJWTToken;
    print("search service");
    var response = await client1.put('$baseUrl/api/event/getevents',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(eventrequestsData);
      List<String> events =
          eventrequestsData.map((event) => event.toString()).toList();
      //events = events.where((element) => element.contains(data));
      // print(events);
      // print(events);
      // event = events;
      // print(event);
      // int len = event.length;
      // print(len);
      print(events);
      return events;
    } else {
      throw Exception('Failed to get data');
    }
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
                    });
                  }, //notifier.area,
                  hint: Text(
                    arg1 == null ? 'Area' : arg1,
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
                            value: "Local Admin 1",
                            child: Text(
                              "Local Admin 1",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "Local Admin 2",
                            child: Text(
                              "Local Admin 2",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "Local Admin 3",
                            child: Text(
                              "Local Admin 3",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                          ),
                          DropdownMenuItem<String>(
                            value: "Local Admin 4",
                            child: Text(
                              "Local Admin 4",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                          ),
                        ],
                        onChanged: (_value) {
                          setState(() {
                            dropdownValue = _value;
                            print(_value);
                            arg2 = _value;
                            notifier.localAdminNotifier(arg2);
                          });
                        },
                        hint: Text(
                          arg2 == null ? 'Local Admin' : arg2,
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
                        "60 minutes",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "2",
                      child: Text(
                        "120 minutes",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                    DropdownMenuItem<String>(
                      value: "0",
                      child: Text(
                        "less 60 minutes",
                        style: TextStyle(fontSize: notifier.custFontSize),
                      ),
                    ),
                  ],
                  onChanged: (_value) {
                    setState(() {
                      dropdownValue = _value;
                      print(_value);
                      arg3 = _value;
                      notifier.durationNotifier(arg3);
                    });
                  },
                  hint: Text(
                    arg3 == null ? 'Kirthan Duration' : arg3,
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
                          });
                        },
                        hint: Text(
                          arg4 == null ? 'Request Acceptance' : arg4,
                          style: TextStyle(fontSize: notifier.custFontSize),
                        ),
                      )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => RaisedButton(
                    onPressed: () {
                      Navigator.pop(context, notifier.duration);
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
