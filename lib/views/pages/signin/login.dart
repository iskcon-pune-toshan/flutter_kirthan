import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_create.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_kirthan/views/pages/signin/kirthan_signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

//final MainPageViewModel mainPageVM =
//  MainPageViewModel(apiSvc: RestAPIServices());

class LoginApp extends StatefulWidget {
  //final MainPageViewModel viewModel;
  //LoginApp({Key key,this.viewModel}): super(key: key);
  LoginApp({Key key}) : super(key: key);

  final String title = "Login";
  final String screenName = SCR_LOGIN_SCREEN;

  @override
  _LoginAppState createState() => _LoginAppState();
}

class _LoginAppState extends State<LoginApp> {
  final _formKey = GlobalKey<FormState>();
  String _uname, _password;
  List<UserLogin> users;
  List<UserAccess> entitlements;
  UserLogin _selecteduser;
  UserAccess _userAccess;
  SharedPreferences prefs;

  SignInService signInService = new SignInService();
  //FirebaseUser user;
  //final MainPageViewModel mainPageVM;

  //_LoginAppState({this.mainPageVM});

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("My Name", "Manjunath Bijinepalli");
  }

  @override
  void initState() {
    super.initState();
    users = UserLogin.getUsers();
    entitlements = UserAccess.getUserEntitlements();
    loadPref();
    print(entitlements);
    //_userAccess = entitlements.singleWhere((access) => access.userType ==  _selecteduser.usertype);
  }

  void populateData() {
    //print(prefs.getString("My Name"));
    _userAccess = entitlements
        .singleWhere((access) => access.userType == _selecteduser.usertype);
    _userAccess.role.forEach((k, v) {
      //print("Key: $k");
      //print("Values: $v");
      prefs.setStringList(k, v);
    });
    prefs.setString("userName", _selecteduser.username);
    prefs.setString("userType", _selecteduser.usertype);
    prefs.setString("dataEnt", _userAccess.dataEntitlement);
  }

  void populateUser(FirebaseUser user) {
    List<String> firebaseUser = new List<String>();
    firebaseUser.add(user.displayName);
    firebaseUser.add(user.photoUrl);
    firebaseUser.add(user.email);
    firebaseUser.add(user.providerId);
    firebaseUser.add(user.phoneNumber);
    firebaseUser.add(user.uid);
  }

  @override
  Widget build(BuildContext context) {
    //_userAccess = entitlements
    //  .singleWhere((access) => access.userType == _selecteduser.usertype);
    //print(_userAccess);
    return MaterialApp(
        title: "Login Page",
        home: Scaffold(
          body: Center(
            child: Container(
              alignment: Alignment.center,
              width: 300,
              height: 1000,
              //color: Color.alphaBlend(BlendMode.color, BlendMode.colorDodge),
              child: Form(
                key: _formKey,
                child: Column(
                  verticalDirection: VerticalDirection.down,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  //mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 300.0,
                          height: 50.0,
                          child: Image(
                            image: AssetImage('assets/images/login_user.jpg'),
                            //centerSlice: Rect.fromCircle(
                            //  center: const Offset(1.0, 2.0), radius: 5.0),
                            //height: 50,
                            //width: 50,
                            //alignment: Alignment.center,
                            //fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 50.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                            width: 300.0,
                            height: 50.0,
                            child: DropdownButtonFormField<UserLogin>(
                              itemHeight: 50.0,
                              value: _selecteduser,
                              items: users
                                  .map((user) => DropdownMenuItem<UserLogin>(
                                      child: Text(user.username), value: user))
                                  .toList(),
                              onChanged: (input) {
                                setState(() {
                                  _selecteduser = input;
                                });
                              },
                            )
                            /*TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please enter your Username",
                              labelText: "User Name*",
                            ),
                            validator: (input) =>
                                input.contains("*") ? "Not a Valid User" : null,
                            onSaved: (input) => _uname = input,
                          ),*/
                            ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Container(
                          width: 300.0,
                          height: 50.0,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              hintText: "Please enter your Password",
                              labelText: "Password*",
                            ),
                            validator: (input) => input.contains("*")
                                ? "Not a Valid Password"
                                : null,
                            onSaved: (input) => _password = input,
                            obscureText: true,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 150,
                          height: 50,
                          child: FlatButton(
                            child: Text("New User?"),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                print(_uname);
                                print(_password);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserWrite()));
                              }
                            },
                          ),
                        ),
                        Container(
                          width: 150,
                          height: 50,
                          child: FlatButton(
                            child: Text("Forgot Password?"),
                            onPressed: null,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            //color: Color(0xffffffff),
                            color: Colors.lightBlueAccent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.solidEnvelope,
                                  color: Color(0xffCE107C),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Sign in with Email',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                ),
                              ],
                            ),
                            onPressed: () {
                              if (_formKey.currentState.validate()) {
                                //   _formKey.currentState.save();
                                //print(_uname);
                                //print(_password);
                                //print(_selecteduser.usertype);
                                populateData();
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventView()));
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50,
                          child: GoogleSignInButton(
                              darkMode: true,
                              borderRadius: 20,
                              onPressed: () {
                                signInService
                                    .googSignIn(context)
                                    .then((FirebaseUser user) => print(user))
                                    .catchError((e) => print(e));

                                populateData();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventView()));
                              }),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          width: 300,
                          height: 50,
                          child: FacebookSignInButton(
                            borderRadius: 10,
                            onPressed: () {
                              signInService
                                  .facebookSignIn(context)
                                  .then((FirebaseUser user) => print(user))
                                  .catchError((e) => print(e));

                              populateData();

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventView()));
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
