import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';

class userName_profile extends StatefulWidget {
  @override
  _userName_profileState createState() => _userName_profileState();
}

class _userName_profileState extends State<userName_profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('User name'),
      ),
      body: SingleChildScrollView(
        child: Container(
          //color: Colors.blueAccent,
          child: Center(
            child: Form(
              autovalidate: true,
              child: Column(
                children: [
                  Divider(),
                  Card(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      //color: Colors.black26,
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: const Icon(Icons.account_circle),
                            labelText: "Current Username",
                            labelStyle: TextStyle(
                                fontSize: MyPrefSettingsApp.custFontSize,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Divider(),
                  Card(
                    child: Container(
                      //color: Colors.black26,
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                            icon: const Icon(Icons.perm_identity),
                            labelText: "New Username",
                            hintText: "Please enter new username",
                            labelStyle: TextStyle(
                                fontSize: MyPrefSettingsApp.custFontSize,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Divider(),
                  Card(
                    child: Container(
                      //color: Colors.black26,
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                        decoration: InputDecoration(
                          icon: const Icon(Icons.offline_pin),
                            labelText: "Confirm New Username",
                            hintText: "Please confirm the New Username",
                            labelStyle: TextStyle(
                                fontSize: MyPrefSettingsApp.custFontSize,
                                fontWeight: FontWeight.bold)),
                      ),
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
          ),
        ),
      ),
    );
  }
}
