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

  TextEditingController _oldPassword = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _passwordConfirm = TextEditingController();

  String currentPassword;
  String oldPassword;
  String errMessage;
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
                        currentPassword = user.password;
                      }
                     // print("user password" + user.password);
                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          autovalidate: true,
                          child: Column(
                            children: [
                              Divider(),
                              TextFormField(
                                autovalidate: false,
                                controller: _oldPassword,
                                decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    labelText: "Old Password",
                                    hintText: "Enter current password",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    labelStyle: TextStyle(
                                      color: Colors.grey,
                                    )),
                                obscureText: true,
                                // onSaved: (input) {
                                //   _current
                                // },
                                // onChanged: (input) async {
                                //   // FirebaseUser firebaseUser =
                                //   //     await FirebaseAuth.instance.currentUser();
                                //   // var authCredentials =
                                //   //     EmailAuthProvider.getCredential(
                                //   //         email: firebaseUser.email,
                                //   //         password: _oldPassword.text);
                                //   // var authResult = await firebaseUser
                                //   //     .reauthenticateWithCredential(
                                //   //         authCredentials);
                                //   // if (authResult.user != null) {
                                //   //   setState(() {
                                //   //     _validate = true;
                                //   //   });
                                //   // }
                                // },
                                validator: (value) {
                                  if (value.isEmpty ) {
                                    return "Please select password";
                                  } else
                                    return null;
                                }
                                /*value.isNotEmpty
                                    ? null
                                    : "Please enter a value"*/,
                              ),
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
                                  if (value!=_password.text)
                                    return 'Please enter correct password';

                                  if (value.length < 8 && _password.text==null)
                                    return 'Must contain 8-30 characters';

                                  if (_password.text == _oldPassword.text)
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
                                      ? "Passwords do no match"
                                      : null;
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

                                        // //Pass in the password to updatePassword.
                                        // SignInService signIn = new SignInService();
                                        // signIn.validatePassword(_oldPassword.text).whenComplete(() => null);
                                        var authCredentials =
                                            EmailAuthProvider.getCredential(
                                                email: s.email,
                                                password: _oldPassword.text);
                                        try {
                                          var authResult = await s
                                              .reauthenticateWithCredential(
                                                  authCredentials);
                                          if (authResult.user != null) {
                                            s
                                                .updatePassword(_password.text)
                                                .then((_) {
                                              print(
                                                  "");
                                            }).catchError((error) {
                                              print(
                                                 '');
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
                                              duration:
                                                  new Duration(seconds: 4),
                                              backgroundColor: Colors.green,
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(mysnackbar);
                                          }
                                        } catch (e) {
                                          if (e.toString() == null) {
                                            errMessage = null;
                                          }
                                          if (e.code ==
                                              'ERROR_USER_NOT_FOUND') {
                                            errMessage = 'No user Found';
                                          } else if (e.code ==
                                              'ERROR_WRONG_PASSWORD') {
                                            errMessage =
                                                'Old password is wrong. Try Again!';
                                          }
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(errMessage),
                                            backgroundColor: Colors.red,
                                          ));
                                        }
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
