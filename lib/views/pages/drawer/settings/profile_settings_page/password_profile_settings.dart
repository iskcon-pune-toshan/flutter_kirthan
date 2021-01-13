import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class password_profile extends StatefulWidget {
  UserRequest userrequest;
  @override
  _password_profileState createState() => _password_profileState();
}

class _password_profileState extends State<password_profile> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  final TextEditingController _password = new TextEditingController();
  final TextEditingController _confirmpassword = new TextEditingController();

  void initState() {
    _password.text = widget.userrequest.password;
    _confirmpassword.text = widget.userrequest.password;
    return super.initState();
  }

  String password;
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
              decoration: InputDecoration(
                  labelText: "New Password", hintText: "Enter new password"),
              obscureText: true,
              controller: _password,
              validator: (input) => input.contains(
                      "*") // need to hold a help icon if the password rule becomes too complicated
                  ? "Not a Valid Password"
                  : null,
            ),
            Divider(),
            TextFormField(
              decoration: InputDecoration(
                  labelText: "Confirm Password",
                  hintText: "Confirm the password"),
              obscureText: true,
              controller: _confirmpassword,
              validator: (val) {
                if (val.isEmpty) return 'Empty';
                if (val != _password.text) return "Not Match";
                return null;
              },
              onSaved: (input) => password = input,
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text('Cancel'),
                  color: Colors.red,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  child: Text('Save'),
                  color: Colors.green,
                  //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                  onPressed: () {
                    _formKey.currentState.save();
                    Navigator.pop(context);
                    print(widget.userrequest.userName);
                    print(widget.userrequest.password);
                    print(widget.userrequest.firstName);
                    print(widget.userrequest.lastName);

                    String userrequestStr =
                        jsonEncode(widget.userrequest.toStrJson());
                    userPageVM.submitUpdateUserRequest(userrequestStr);
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
