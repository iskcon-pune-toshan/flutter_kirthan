import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/firebasemessage_service.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/signin/signup.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:flutter_kirthan/services/notification_service_impl.dart';
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
  final _passwordcontroller = new TextEditingController();
  final TextEditingController username = new TextEditingController();
  String _uname, _password;
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

  final FirebaseAuth auth = FirebaseAuth.instance;



  getCurrentUID() async{
    final FirebaseUser user = await auth.currentUser();
    final String uid = user.uid;
    print(uid);
    return uid;
  }

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    print(email);
    return email;

  }



  @override
  void initState() {
    super.initState();
    users = UserLogin.getUsers();
    entitlements = UserAccess.getUserEntitlements();
    loadPref();

//    NotificationManager _config = new NotificationManager();
//    _config.initMessageHandler(context);

//    NotificationView _config = new NotificationView();
//    _config.initMessageHandler(context);
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

  /* void loggendInUser(FirebaseUser user) {
    List<String> listofUserdetails = new List<String>();
    listofUserdetails.add(user.displayName);
    listofUserdetails.add(user.photoUrl);
    listofUserdetails.add("email:" + user.email);
    listofUserdetails.add("providerId:" + user.providerId);
    //listofUserdetails.add("phoneNumber:" + (user.phoneNumber.isEmpty?0:1).toString());
    listofUserdetails.add("uid:" + user.uid);
    prefs.setStringList("LoginDetails", listofUserdetails);
    //print("LoginDetails Updated");
  }*/

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
              height: 1500,
              //color: Color.alphaBlend(BlendMode.color, BlendMode.colorDodge),
              child: Form(
                key: _formKey,
                child: Center(
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
                            width: 300,
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
                            width: 300,
                            height: 50.0,
                            child: /*DropdownButtonFormField<UserLogin>(
                                // Shouldnt this be a text field? Or are we planning on storing all
                                // the logged in users email at all times?
                                itemHeight: 50.0,
                                value: _selecteduser,
                                items: users
                                    .map((user) => DropdownMenuItem<UserLogin>(
                                        child: Text(user.username),
                                        value: user))
                                    .toList(),
                                onChanged: (input) {
                                  setState(() {
                                    _selecteduser = input;
                                  });
                                },
                              )*/
                            TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Please enter your Username",
                                labelText: "User Name*",
                              ),
                              controller: username,
                              validator: (input) =>
                              input.contains("*") ? "Not a Valid User" : null,
                              //onSaved: (input) => _uname = input,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Container(
                            width: 300,
                            height: 50.0,
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Please enter your Password",
                                labelText: "Password*",
                              ),
                              controller: _passwordcontroller,
                              validator: (input) => input.contains(
                                  "*") // need to hold a help icon if the password rule becomes too complicated
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
                                child: Text("SignUp"),
                                onPressed: () {
                                  /* if (_formKey.currentState.validate()) {
                                  _uname = _selecteduser.username;
                                  //print(_uname);
                                  //print(_passwordcontroller.text);
                                  //_formKey.currentState.save();
                                  signInService
                                      .signUpWithEmail(
                                          _uname, _passwordcontroller.text)
                                      .then(
                                          (FirebaseUser user) => populateData())
                                      .catchError((e) => print(e))
                                      .whenComplete(() => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUp())));*/

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));

                                }

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
                                  _uname = username.text;
                                  _password = _passwordcontroller.text;
                                  //   _formKey.currentState.save();
                                  print(_uname);
                                  print(_password);
                                  //print(_selecteduser.usertype);
                                  print("Entered siginIn email");

                                  signInService
                                      .signInWithEmail(_uname, _password)
                                      .then(
                                          (FirebaseUser user) => populateData())
                                      .catchError((e) => print(e))
                                      .whenComplete(() => authenticateService
                                      .autheticate()
                                      .whenComplete(() => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              App()))));
                                  print("Exit signIn email service");

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
                                  //print("Before");
                                  //print(signInService.firebaseAuth.currentUser() == null?true:false);
                                  //print(signInService.firebaseAuth
                                  //  .currentUser()
                                  //.then((onValue) =>
                                  //  print(onValue.displayName)));

                                  signInService
                                      .googSignIn(context)
                                  //.timeout(const Duration(seconds: 30),onTimeout: _onTimeout() => (FirebaseUser user))
                                      .then(
                                          (FirebaseUser user) => populateData())
                                      .catchError((e) => print(e))
                                      .whenComplete(() => authenticateService
                                      .autheticate().whenComplete(()  => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              App()))));

                                  //populateData();

                                  /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventView()));

                                   */
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
                                    .then((FirebaseUser user) => populateData())
                                    .catchError((e) => print(e))
                                    .whenComplete(() => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            App())));
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
          ),
        ));
  }
}
