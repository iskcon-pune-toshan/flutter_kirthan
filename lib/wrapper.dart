import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/models/user.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  List<UserLogin> users;
  List<UserAccess> entitlements;
  UserLogin _selecteduser;
  UserAccess _userAccess;
  SharedPreferences prefs;
  SignInService signInService = SignInService();
  AutheticationAPIService authenticateService = AutheticationAPIService();
  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    //prefs.setString("My Name", "Manjunath Bijinepalli");
  }

  @override
  void initState() {
    super.initState();
    users = UserLogin.getUsers();
    entitlements = UserAccess.getUserEntitlements();
    loadPref();
  }

  void populateData() {
    _userAccess = entitlements
        .singleWhere((access) => access.userType == _selecteduser.usertype);
    _userAccess.role.forEach((k, v) {
      prefs.setStringList(k, v);
    });
    prefs.setString("userName", _selecteduser.username);
    prefs.setString("userType", _selecteduser.usertype);
    prefs.setString("dataEnt", _userAccess.dataEntitlement);
  }

  @override
  Widget build(BuildContext context) {
    //return either home or authenticate widget
    final User user = Provider.of<User>(context);
    if (user == null) {
      return LoginApp();
    } else {
      populateData();
      Navigator.push(context, MaterialPageRoute(builder: (context) => App()));
    }
  }
}
