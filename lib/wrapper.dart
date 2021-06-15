import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  //List<UserLogin> users;

  List<UserAccess> entitlements;
  UserLogin _selecteduser;
  UserAccess _userAccess;
  SharedPreferences prefs;
  //SignInService signInService = SignInService();
  AutheticationAPIService authenticateService = AutheticationAPIService();
  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    //prefs.setString("My Name", "Manjunath Bijinepalli");
  }

  @override
  void initState() {
    super.initState();
    //users = UserLogin.getUsers();
    getEntitlement();
    loadPref();
  }

  void getEntitlement() async {
    entitlements = await UserAccess.getUserEntitlements();
  }

  void populateData() {
    print("Entitlements");
    print(entitlements);
    print(_selecteduser);
    _userAccess = entitlements
        .singleWhere((access) => access.userType == _selecteduser.usertype);
    _userAccess.role.forEach((k, v) {
      prefs.setStringList(k, v);
    });
    prefs.setString("userName", _selecteduser.username);
    prefs.setString("userType", _selecteduser.usertype);
    prefs.setString("dataEnt", _userAccess.dataEntitlement);
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseAuth auth = await FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    // print(email);
    // print("USERUSER");
    // print(user.email);
    return user;
  }

  @override
  Widget build(BuildContext context) {
    //return either home or authenticate widget
    final User user = Provider.of<User>(context);
    //final user = context.watch<User>();
    if (user == null) {
      return LoginApp();
    } else {
      // print("user");
      // print(user.uid);
      //populateData();
      print(authenticateService.sessionJWTToken);
      getCurrentUser()
          .then((value) => SignInService().fireUser = value)
          .whenComplete(() => {
        authenticateService.autheticate().whenComplete(() => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => App()))
        })
      });

      // print("session token");
      // print(authenticateService.sessionJWTToken);
      // return Center(
      //   child: Container(
      //       width: MediaQuery.of(context).size.width,
      //       height: MediaQuery.of(context).size.height,
      //       color: Colors.white,
      //       child: CircularProgressIndicator()),
      // );
      return EventView();
    }
  }
}
