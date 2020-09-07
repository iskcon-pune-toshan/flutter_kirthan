import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';

class members_profile extends StatefulWidget {
  @override
  _members_profileState createState() => _members_profileState();
}

class _members_profileState extends State<members_profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit members"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                Text("Members",
                    style: TextStyle(
                        fontSize: MyPrefSettingsApp.custFontSize,
                        fontWeight: FontWeight.bold)),
                Divider(),
                Card(
                  child: Container(
                    //color: Colors.black26,
                    padding: const EdgeInsets.all(10),
                    child: TextFormField(

                      decoration: InputDecoration(
                        icon: Icon(Icons.people_outline),
                          labelText: "Member 1",
                          hintText: "Please enter the name of the member",
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
                          icon: Icon(Icons.people_outline),
                          labelText: "Member 2",
                          hintText: "Please enter the name of the member",
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
                          icon: Icon(Icons.people_outline),
                          labelText: "Member 3",
                          hintText: "Please enter the name of the member",
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
                          icon: Icon(Icons.people_outline),
                          labelText: "Member 4",
                          hintText: "Please enter the name of the member",
                          labelStyle: TextStyle(
                              fontSize: MyPrefSettingsApp.custFontSize,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton.icon(
                      label: Text('Add'),
                      icon:const Icon(Icons.add_circle),
                      color: Colors.green,
                      onPressed: () {},
                    ),
                    RaisedButton(
                      child: Text('Get Approved'),
                      //color: Colors.redAccent,
                      //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}