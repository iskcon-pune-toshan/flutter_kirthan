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

class location_profile extends StatefulWidget {
  @override
  _location_profileState createState() => _location_profileState();
}

class _location_profileState extends State<location_profile> {
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, notifier, child) =>(
        Scaffold(
          appBar: AppBar(
            title: Text("Location",style: TextStyle(
                fontSize: notifier.custFontSize)),
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
                            padding: const EdgeInsets.all(16.0),
                            child: Consumer<ThemeNotifier>(
                              builder: (context, notifier, child) => Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    Divider(),
                                    TextFormField(
                                      style: TextStyle(fontSize: notifier.custFontSize),
                                      initialValue: user.state,
                                      decoration: InputDecoration(
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    icon: Icon(Icons.home, color: Colors.grey),
                                    labelText: "State",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.state = input;
                                  },
                                ),
                                Divider(),
                                TextFormField(
                                  style: TextStyle(fontSize: notifier.custFontSize),
                                  initialValue: user.country,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                        ),
                                        icon: Icon(Icons.home, color: Colors.grey),
                                        labelText: "Country",
                                        labelStyle: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: Colors.grey,
                                        ),
                                        hintText: "",
                                      ),
                                      onSaved: (input) {
                                        user.country = input;
                                      },
                                    ),
                                    Divider(),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        RaisedButton(
                                          child: Text('Save', style: TextStyle(
                                            fontSize: notifier.custFontSize,
                                          ),),
                                          color: Colors.green,
                                          onPressed: () async {
                                            if (_formKey.currentState.validate()) {
                                              _formKey.currentState.save();
                                              String userrequestStr =
                                              jsonEncode(user.toStrJson());
                                              userPageVM
                                                  .submitUpdateUserRequestDetails(
                                                  userrequestStr);
                                              SnackBar mysnackbar = SnackBar(
                                                content: Text(
                                                    "User details updated $successful", style: TextStyle(
                                                  fontSize: notifier.custFontSize,
                                                )),
                                                duration: new Duration(seconds: 4),
                                                backgroundColor: Colors.green,
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(mysnackbar);
                                            }
                                          },
                                        ),
                                        RaisedButton(
                                          child: Text('Cancel', style: TextStyle(
                                            fontSize: notifier.custFontSize,
                                          )),
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
                          );
                        }
                        return Container();
                      });
                }
                return Container();
              }),
        )
    ),
    );
  }
}
