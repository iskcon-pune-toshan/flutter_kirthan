import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

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
                      child: Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) => TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            icon: const Icon(
                              Icons.account_circle,
                              color: Colors.grey,
                            ),
                            labelText: "Current Username",
                            labelStyle: TextStyle(
                              fontSize: notifier.custFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Card(
                    child: Container(
                      //color: Colors.black26,
                      padding: const EdgeInsets.all(10),
                      child: Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) => TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            icon: const Icon(
                              Icons.perm_identity,
                              color: Colors.grey,
                            ),
                            labelText: "New Username",
                            hintText: "Please enter new username",
                            labelStyle: TextStyle(
                              fontSize: notifier.custFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  Card(
                    child: Container(
                      //color: Colors.black26,
                      padding: const EdgeInsets.all(10),
                      child: Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) => TextFormField(
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            icon: const Icon(
                              Icons.offline_pin,
                              color: Colors.grey,
                            ),
                            labelText: "Confirm New Username",
                            hintText: "Please confirm the New Username",
                            labelStyle: TextStyle(
                                fontSize: notifier.custFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ),
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
