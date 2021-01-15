import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';

class contact_details_profile extends StatefulWidget {
  @override
  _contact_details_profileState createState() =>
      _contact_details_profileState();
}

class _contact_details_profileState extends State<contact_details_profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Divider(),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.phone_in_talk),
                labelText: "Phone Number",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
            ),
            Divider(),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "Email Id",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
            ),
            Divider(),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.home),
                labelText: "Address",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text('Save'),
                  color: Colors.green,
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text('Cancel'),
                  color: Colors.redAccent,
                  //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}