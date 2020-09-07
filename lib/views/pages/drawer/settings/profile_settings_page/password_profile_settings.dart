import 'package:flutter/material.dart';

class password_profile extends StatefulWidget {
  @override
  _password_profileState createState() => _password_profileState();
}

class _password_profileState extends State<password_profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password '),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Divider(),
            TextFormField(
              decoration:InputDecoration(

                labelText: "New Password",
                hintText: "Enter new password"
              ),
              obscureText: true,
            ),
            Divider(),
            TextFormField(
              decoration:InputDecoration(

                  labelText: "Confirm Password",
                  hintText: "Confirm the password"
              ),
              obscureText: true,
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
                  child: Text('Reset'),
                  color: Colors.redAccent,
                  //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                  onPressed: () {},
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}