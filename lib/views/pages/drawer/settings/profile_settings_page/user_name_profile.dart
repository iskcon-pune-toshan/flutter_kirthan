import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class userName_profile extends StatefulWidget {
  @override
  _userName_profileState createState() => _userName_profileState();
}

class _userName_profileState extends State<userName_profile> {
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  String username;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('User name'),
      ),
      body: FutureBuilder(
          future: getEmail(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              String email = snapshot.data;
              return FutureBuilder(
                  future: userPageVM.getUserRequests(email),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      List<UserRequest> userList = snapshot.data;
                      UserRequest user = new UserRequest();
                      for (var u in userList) {
                        user = u;
                      }
                      return SingleChildScrollView(
                        child: Container(
                          //color: Colors.blueAccent,
                          child: Center(
                            child: Form(
                              key: _formKey,
                              autovalidate: true,
                              child: Column(
                                children: [
                                  Divider(),
                                  Card(
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      //color: Colors.black26,
                                      child: Consumer<ThemeNotifier>(
                                        builder: (context, notifier, child) =>
                                            TextFormField(
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
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
                                          validator: (input) {
                                            return user.userName != input
                                                ? 'Enter valid username'
                                                : null;
                                          },
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
                                        builder: (context, notifier, child) =>
                                            TextFormField(
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            icon: const Icon(
                                              Icons.perm_identity,
                                              color: Colors.grey,
                                            ),
                                            labelText: "New Username",
                                            hintText:
                                                "Please enter new username",
                                            labelStyle: TextStyle(
                                              fontSize: notifier.custFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey,
                                            ),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          onChanged: (input) {
                                            username = input;
                                          },
                                          onSaved: (input) {
                                            user.userName = input;
                                          },
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
                                        builder: (context, notifier, child) =>
                                            TextFormField(
                                          decoration: InputDecoration(
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.grey),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green),
                                            ),
                                            icon: const Icon(
                                              Icons.offline_pin,
                                              color: Colors.grey,
                                            ),
                                            labelText: "Confirm New Username",
                                            hintText:
                                                "Please confirm the New Username",
                                            labelStyle: TextStyle(
                                                fontSize: notifier.custFontSize,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey),
                                            hintStyle: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          validator: (input) {
                                            return username != input
                                                ? 'Username does not match'
                                                : null;
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      RaisedButton(
                                        child: Text('Save'),
                                        color: Colors.green,
                                        onPressed: () async {
                                          if (_formKey.currentState
                                              .validate()) {
                                            _formKey.currentState.save();
                                            String userrequestStr =
                                                jsonEncode(user.toStrJson());
                                            userPageVM
                                                .submitUpdateUserRequestDetails(
                                                    userrequestStr);
                                            SnackBar mysnackbar = SnackBar(
                                              content: Text(
                                                  "User details updated $successful"),
                                              duration:
                                                  new Duration(seconds: 4),
                                              backgroundColor: Colors.green,
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(mysnackbar);
                                          }
                                        },
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
                      );
                    }
                    return Container();
                  });
            }
            return Container();
          }),
    );
  }
}
