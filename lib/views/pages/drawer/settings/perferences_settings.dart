import 'package:flutter/material.dart';
//import 'package:flutter_kirthan/views/pages/drawer/settings/impl_perferences.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/impl_perferences.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PerferenceSettings extends StatefulWidget {
  @override
  _PerferenceSettingsState createState() => _PerferenceSettingsState();
}

class _PerferenceSettingsState extends State<PerferenceSettings> {


  SharedPreferences sp ;


  String dropdownValue = '';
  String arg1 = null ;

  String arg2 = null ;
  String arg3 = null ;
  String arg4 = null ;


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
                child: Consumer<SettingsNotifier>(
              builder: (context, notifier, child) => DropdownButton<String>(
                items: [
                  DropdownMenuItem<String>(
                    value: "NVCC",
                    child: Text(
                      "NVCC",
                      style:
                          TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "Katraj",
                    child: Text(
                      "Katraj",
                      style:
                          TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "Camp",
                    child: Text(
                      "Camp",
                      style:
                          TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                    ),
                  ),
                  DropdownMenuItem<String>(
                    value: "Koregaon",
                    child: Text(
                      "Koregaon",
                      style:
                          TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                    ),
                  ),
                ],
                onChanged: (val) {
                  /*setState(() {
                    dropdownValue = _value;
                    print(_value);
                    arg1 = _value;
                  });

                   */

                  notifier.selectArea();
                  print(val);
                  arg1 = val;
                }, value: notifier.area,
                hint: Text(
                  arg1 == null ? 'Area' : arg1,
                  style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                ),
              ),
                )),
            Divider(),
            Card(
                child: DropdownButton<String>(
              items: [
                DropdownMenuItem<String>(
                  value: "Local Admin 1",
                  child: Text(
                    "Local Admin 1",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Local Admin 2",
                  child: Text(
                    "Local Admin 2",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Local Admin 3",
                  child: Text(
                    "Local Admin 3",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "Local Admin 4",
                  child: Text(
                    "Local Admin 4",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
              ],
              onChanged: (_value) {
                setState(() {
                  dropdownValue = _value;
                  print(_value);
                  arg2 = _value;
                });
              },
              hint: Text(
                arg2 == null ? 'Local Admin' : arg2,
                style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
              ),
            )),
            Divider(),
            Card(
                child: DropdownButton<String>(
              items: [
                DropdownMenuItem<String>(
                  value: "60 minutes",
                  child: Text(
                    "60 minutes",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "120 minutes",
                  child: Text(
                    "120 minutes",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "less 60 minutes",
                  child: Text(
                    "less 60 minutes",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
              ],
              onChanged: (_value) {
                setState(() {
                  dropdownValue = _value;
                  print(_value);
                  arg3 = _value;
                });
              },
              hint: Text(
                arg3 ==null ?'Kirthan Duration' : arg3,
                style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
              ),
            )),
            Divider(),
            Card(
                child: DropdownButton<String>(
              items: [
                DropdownMenuItem<String>(
                  value: "One week before",
                  child: Text(
                    "One week before",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "15 days before",
                  child: Text(
                    "15 days before",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
                DropdownMenuItem<String>(
                  value: "1 month before",
                  child: Text(
                    "1 month before",
                    style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                  ),
                ),
              ],
              onChanged: (_value) {
                setState(() {
                  dropdownValue = _value;
                  print(_value);
                  arg4 = _value;
                });
              },
              hint: Text(
                arg4 == null ? 'Request Acceptance' : arg4,
                style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
