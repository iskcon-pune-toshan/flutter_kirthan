/*
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';

class contact_details_profile extends StatefulWidget {
  @override
  _contact_details_profileState createState() =>
      _contact_details_profileState();
}

class _contact_details_profileState extends State<contact_details_profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Divider(),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.phone_in_talk),
                labelText: "Phone Number",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
            ),
            Divider(),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "Email Id",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
            ),
            Divider(),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.home),
                labelText: "Address",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
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
    );
  }
}*/


import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class UserEdit extends StatefulWidget {
  final String screenName = SCR_REGISTER_USER;
  UserRequest userrequest;
  UserEdit({Key key, @required this.userrequest}) : super(key: key);

  @override
  _UserEditState createState() => new _UserEditState();
}

class _UserEditState extends State<UserEdit> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //final IKirthanRestApi apiSvc = new RestAPIServices();

  String _selectedState;
  String state;
  var _states = ["GOA", "GUJ", "MAH"];
  // controllers for form text controllers
  final TextEditingController _userUserNameController =
  new TextEditingController();
  String userName;
  final TextEditingController _userPasswordController =
  new TextEditingController();
  String password;
  final TextEditingController _userFirstNameController =
  new TextEditingController();
  String firstName;
  final TextEditingController _userLastNameController =
  new TextEditingController();
  String lastName;
  final TextEditingController _userEmailController =
  new TextEditingController();
  String email;
  final TextEditingController _userAddressController =
  new TextEditingController();
  String address;
  final TextEditingController _userPhoneNumberController =
  new TextEditingController();
  String phoneNumber;
  final TextEditingController _linetwoController = new TextEditingController();
  String lineTwo;
  final TextEditingController _linethreeController =
  new TextEditingController();
  String lineThree;
  final TextEditingController _cityController = new TextEditingController();
  String city;
  final TextEditingController _pincodeController = new TextEditingController();
  String pinCode;
  final TextEditingController _userupdatedBy = new TextEditingController();
  String userupdatedBy ;
  final TextEditingController _createdTime = new TextEditingController();

  @override
  void initState() {
    _userUserNameController.text = widget.userrequest.userName;
    _userPasswordController.text = widget.userrequest.password;
    _userFirstNameController.text = widget.userrequest.firstName;
    _userLastNameController.text = widget.userrequest.lastName;
    _userEmailController.text = widget.userrequest.email;
    _userPhoneNumberController.text = widget.userrequest.phoneNumber.toString();
    _userAddressController.text = widget.userrequest.addLineOne;
    _linetwoController.text = widget.userrequest.addLineTwo;
    _linethreeController.text = widget.userrequest.addLineThree;
    _pincodeController.text = widget.userrequest.pinCode.toString();
    _selectedState = "GUJ";
    _cityController.text = widget.userrequest.city;
    _createdTime.text = widget.userrequest.createdTime;
    print(widget.userrequest.createdTime);
    _userupdatedBy.text = getCurrentUser().toString();
    return super.initState();
  }


  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    widget.userrequest.updatedBy = email;
    print(email);
    return email;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final DateTime today = new DateTime.now();

    return Scaffold(
        appBar:  AppBar(title: const Text('Edit Profile'), actions: <Widget>[
           Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
              child:  MaterialButton(
                color: themeData.primaryColor,
                textColor: themeData.secondaryHeaderColor,
                hoverColor: Colors.white,
                child: new Text('Save'),
                onPressed: () {
                  // _handleSubmitted();
                  _formKey.currentState.save();
                  Navigator.pop(context);
                  print(widget.userrequest.userName);
                  print(widget.userrequest.password);
                  print(widget.userrequest.firstName);
                  print(widget.userrequest.lastName);


                  String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
                  _userupdatedBy.text = widget.userrequest.updatedTime = dt;
                  String userrequestStr =
                  jsonEncode(widget.userrequest.toStrJson());
                  userPageVM.submitUpdateUserRequest(userrequestStr);
                },
              ))
        ]),
        body: Form(
            key: _formKey,
            autovalidate: true,
            //onWillPop: _warnUserAboutInvalidData,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        labelText: "Username", hintText: "alternate name?"),
                    autocorrect: false,
                    controller: _userUserNameController,
                    onSaved: (String value) {
                      widget.userrequest.userName = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Password"),
                    autocorrect: false,
                    controller: _userPasswordController,
                    onSaved: (String value) {
                      widget.userrequest.password = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "First name"),
                    autocorrect: false,
                    controller: _userFirstNameController,
                    onSaved: (String value) {
                      widget.userrequest.firstName = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Last name"),
                    autocorrect: false,
                    controller: _userLastNameController,
                    onSaved: (String value) {
                      widget.userrequest.lastName = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Email"),
                    autocorrect: false,
                    controller: _userEmailController,
                    onSaved: (String value) {
                      widget.userrequest.email = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration:
                    const InputDecoration(labelText: "Phone number"),
                    autocorrect: false,
                    controller: _userPhoneNumberController,
                    onSaved: (String value) {
                      widget.userrequest.phoneNumber = int.parse(value);
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Line 1"),
                    autocorrect: false,
                    controller: _userAddressController,
                    onSaved: (String value) {
                      widget.userrequest.addLineTwo = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Line 2"),
                    autocorrect: false,
                    controller: _linetwoController,
                    onSaved: (String value) {
                      widget.userrequest.addLineTwo = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Line 3"),
                    autocorrect: false,
                    controller: _linethreeController,
                    onSaved: (String value) {
                      widget.userrequest.addLineThree = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "PinCode"),
                    autocorrect: false,
                    controller: _pincodeController,
                    onSaved: (String value) {
                      widget.userrequest.pinCode = int.parse(value);
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "City"),
                    autocorrect: false,
                    controller: _cityController,
                    onSaved: (String value) {
                      widget.userrequest.city = value;
                    },
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedState,
                  icon: const Icon(Icons.location_city),
                  hint: Text('Select State'),
                  items: _states
                      .map((state) => DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  ))
                      .toList(),
                  onChanged: (input) {
                    setState(() {
                      _selectedState = input;
                    });
                  },
                  onSaved: (input) {
                    widget.userrequest.state = input;
                  },
                ),

              ],
            )));
  }
}

