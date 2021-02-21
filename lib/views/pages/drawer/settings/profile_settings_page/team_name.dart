import 'package:flutter/material.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';

class teamName extends StatefulWidget {
  @override
  _teamNameState createState() => _teamNameState();
}

class _teamNameState extends State<teamName> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Team name'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: 20.0, top: 20.0, left: 10.0, right: 10.0),
            child: TextFormField(
                style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                decoration: buildInputDecoration(
                    Icons.group, "Enter the team name", "Team's Name")),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
            child: TextFormField(
                style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                decoration: buildInputDecoration(Icons.person_pin,
                    "Please enter the admin's name", "Team Admin Name")),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20.0, left: 10.0, right: 10.0),
            child: TextFormField(
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                decoration: buildInputDecoration(Icons.add_circle_outline,
                    "Please enter the no. of members", "No. of Team members")),
          ),
          Row(
            children: [
              Divider(
                thickness: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.lightGreen,
                    child: Text('Submit'),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue, width: 2)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.redAccent,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue, width: 2)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  InputDecoration buildInputDecoration(
      IconData icons, String hinttext, String labeltext) {
    return InputDecoration(
      labelText: labeltext,
      labelStyle: TextStyle(color: Colors.grey),
      hintText: hinttext,
      hintStyle: TextStyle(color: Colors.grey),
      prefixIcon: Icon(
        icons,
        color: Colors.grey,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(color: Colors.green, width: 1.5),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.5,
        ),
      ),
    );
  }
}
