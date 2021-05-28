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

class contact_details_profile extends StatefulWidget {
  @override
  _contact_details_profileState createState() =>
      _contact_details_profileState();
}

class _contact_details_profileState extends State<contact_details_profile> {
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  String _isValidPhone(String value) {
    final phoneRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10}$)');
    if (!phoneRegExp.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }

  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
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
                            autovalidate: true,
                            child: Column(
                              children: [
                                Divider(),
                                TextFormField(
                                  initialValue: user.phoneNumber.toString(),
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    icon: Icon(
                                      Icons.phone_in_talk,
                                      color: Colors.grey,
                                    ),
                                    labelText: "Phone Number",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.phoneNumber = int.parse(input);
                                  },
                                  validator: _isValidPhone,
                                ),
                                Divider(),
                                TextFormField(
                                  initialValue: user.city,
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
                                    labelText: "Address",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.city = input;
                                  },
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
                                ),
                                Divider(),
                                TextFormField(
                                  initialValue: user.addLineOne,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    //icon: Icon(Icons.home, color: Colors.grey),
                                    labelText: "address",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.addLineOne = input;
                                  },
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
                                ),
                                Divider(),
                                TextFormField(
                                  initialValue: user.addLineTwo,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    //icon: Icon(Icons.home, color: Colors.grey),
                                    labelText: "address",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.addLineTwo = input;
                                  },
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
                                ),
                                Divider(),
                                TextFormField(
                                  initialValue: user.addLineThree,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    //icon: Icon(Icons.home, color: Colors.grey),
                                    labelText: "address",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.addLineThree = input;
                                  },
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
                                ),
                                Divider(),
                                TextFormField(
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
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
                                ),
                                Divider(),
                                TextFormField(
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
                                    icon:
                                        Icon(Icons.public, color: Colors.grey),
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
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
                                ),
                                Divider(),
                                TextFormField(
                                  initialValue: user.govtIdType,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    icon: Icon(Icons.insert_drive_file_outlined,
                                        color: Colors.grey),
                                    labelText: "Govt. Id type",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.govtIdType = input;
                                  },
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
                                ),
                                Divider(),
                                TextFormField(
                                  initialValue: user.govtId,
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    icon: Icon(Icons.insert_drive_file_outlined,
                                        color: Colors.grey),
                                    labelText: "Govt. Id",
                                    labelStyle: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color: Colors.grey,
                                    ),
                                    hintText: "",
                                  ),
                                  onSaved: (input) {
                                    user.govtId = input;
                                  },
                                  validator: (input) => input.isEmpty
                                      ? "Please enter some text"
                                      : null,
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
