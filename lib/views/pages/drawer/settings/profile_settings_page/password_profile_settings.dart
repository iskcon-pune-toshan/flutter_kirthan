import 'dart:convert';
import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class password_profile extends StatefulWidget {
  @override
  _password_profileState createState() => _password_profileState();
}

class _password_profileState extends State<password_profile> {
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirm = TextEditingController();

  String currentPassword;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Password '),
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
                        currentPassword= user.password;
                      }
                      print("user password" + user.password);
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          autovalidate: true,
                          child: Column(
                            children: [
                              Divider(),
                              TextFormField(
                                controller: _password,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green),
                                    ),
                                    labelText: "New Password",
                                    hintText: "Enter new password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    )),
                                obscureText: true,
                                // onChanged: (input) {
                                //
                                //   password = input;
                                // },
                                onSaved: (input) {
                                  //user.password = input;
                                },
                                validator: (value) {
                                  // ignore: missing_return
                                  if (value.isEmpty)
                                    return 'Please enter a value';

                                  if (value.length < 8)
                                    return 'Must contain 8-30 characters';

                                  if(currentPassword == value)
                                    return 'New password cannot be same as current password';
                                  return null;
                                },
                              ),
                              Divider(),
                              TextFormField(
                                controller: _passwordConfirm,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                      BorderSide(color: Colors.green),
                                    ),

                                    labelText: "Confirm Password",
                                    hintText: "Confirm the password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    )),
                                obscureText: true,
                                validator: (input) {
                                  return _password.text != input
                                      ?"Passwords do no match"
                                      :null;
                                  // return password != input
                                  //     ? 'Passwords do not match'
                                  //     : null;
                                },
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
                                      if (_formKey.currentState.validate()) {
                                        FirebaseUser s = await FirebaseAuth
                                            .instance
                                            .currentUser();

                                        //Pass in the password to updatePassword.
                                        s.updatePassword(_password.text).then((_) {
                                          print(
                                              "Successfully changed password");
                                        }).catchError((error) {
                                          print("Password can't be changed" +
                                              error.toString());
                                          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                                        });
                                        _formKey.currentState.save();
                                        String userrequestStr =
                                        jsonEncode(user.toStrJson());
                                        userPageVM
                                            .submitUpdateUserRequestDetails(
                                            userrequestStr);
                                        SnackBar mysnackbar = SnackBar(
                                          content: Text(
                                              "User details updated $successful"),
                                          duration: new Duration(seconds: 4),
                                          backgroundColor: Colors.green,
                                        );
                                        Scaffold.of(context)
                                            .showSnackBar(mysnackbar);
                                      }
                                    },
                                  ),
                                  RaisedButton(
                                    child: Text('Reset'),
                                    color: Colors.redAccent,
                                    //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                    onPressed: () {
                                      _passwordConfirm.clear();
                                      _password.clear();
                                    },
                                  ),
                                ],
                              ),
                            ],
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
