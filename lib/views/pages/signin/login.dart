import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/user/enterCode.dart';
import 'package:flutter_kirthan/views/pages/signin/signup.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_route.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';

//final MainPageViewModel mainPageVM =
//  MainPageViewModel(apiSvc: RestAPIServices());

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

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
  var errMessage = 'ellomate';
  Future<List<UserRequest>> Userreq;
  List<UserRequest> userList = new List<UserRequest>();
  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    //prefs.setString("My Name", "Manjunath Bijinepalli");
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUID() async {
    final FirebaseUser user = await auth.currentUser();
    final String uid = user.uid;
   // print(uid);
    return uid;
  }

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
   // print(email);
    return email;
  }

  @override
  void initState() {
    super.initState();
    //users = UserLogin.getUsers();
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
  bool ispresent = false;
  checkUser(String uname) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser u = await auth.currentUser();
    if (u.email == uname) {
      ispresent = true;
    } else
      () {
        ispresent == false;
      };
    return ispresent;
  }

  UserRequest user = new UserRequest();
  addUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser s = await auth.currentUser();
    String pass = s.uid;
    String email = s.email;
    String userName = s.displayName;

   // print("signup uid");
    //print(pass);
    //print(email);
    //print(userName);

    if (_formKey.currentState.validate()) {
      String dt =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());

      // user.firstName = userName;
      // user.lastName = userName;
      user.email = email;
      user.password = pass;
      user.phoneNumber = 12345678;
      user.fullName = userName;
      user.addLineOne = "xyz";
      user.addLineTwo = "abc";
      user.addLineThree = "pqr";
      user.locality = "Pune";
      user.city = "Pune";
      user.pinCode = 400001;
      user.state = "Maharashtra";
      user.country = "India";
      user.govtIdType = "Aadhaar";
      user.govtId = "Aadhaar";
      //user.isProcessed = true;
      // user.approvalComments = "Waiting";
      user.approvalStatus = "Waiting";
      user.roleId = 3;
      user.createdBy = email;
      user.updatedBy = " ";
      user.createdTime = dt;
      user.updatedTime = null;

      Map<String, dynamic> usermap = user.toJson();
      UserRequest userRequest = await userPageVM.submitNewUserRequest(usermap);
    }
  }

  userCheck() async {}

  Widget _buildEmailTF() {
    return Form(
      key: _formKey,
      //autovalidate: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /*Text(
            'Email',
            style: kLabelStyle,
          ),*/
          SizedBox(height: 10.0),
          Container(
            alignment: Alignment.centerLeft,
            decoration: kBoxDecorationStyle,
            height: 60.0,
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'OpenSans',
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14.0),
                prefixIcon: Icon(
                  Icons.email,
                  color: KirthanStyles.colorPallete30,
                ),
                hintText: 'Email address',
                hintStyle: kHintTextStyle,
              ),
              controller: username,
              validator: (input) =>
                  EmailValidator.validate(input) ? null : "Not a Valid User",
            ),
          ),
          Divider(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              /*Text(
                'Password',
                style: kLabelStyle,
              ),*/
              SizedBox(height: 10.0),
              Container(
                alignment: Alignment.centerLeft,
                decoration: kBoxDecorationStyle,
                height: 60.0,
                child: TextFormField(
                  obscureText: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'OpenSans',
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(top: 14.0),
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Color(0xFF61bcbc),
                    ),
                    hintText: 'Password',
                    hintStyle: kHintTextStyle,
                  ),
                  controller: _passwordcontroller,
                  validator: (input) => input.length <
                          8 // need to hold a help icon if the password rule becomes too complicated
                      ? "Not a Valid Password"
                      : null,
                  onSaved: (input) => _password = input,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text(
          'Forgot Password?',
          style: kLabelStyle,
        ),
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _uname = username.text;
            _password = _passwordcontroller.text;
            //   _formKey.currentState.save();
          //  print(_uname);
            //print(_password);
            signInService
                .signInWithEmail(_uname, _password)
                .then((FirebaseUser user) => populateData())
                .catchError((e) {
              if (e.toString() == null) {
                errMessage = null;
              }
              if (e.code == 'ERROR_USER_NOT_FOUND') {
                errMessage = 'No user Found';
                showFlushBar(context, errMessage);
                // errMessage ="ellomate";
              } else if (e.code == 'ERROR_INVALID_EMAIL' ||
                  e.code == 'ERROR_WRONG_PASSWORD') {
                errMessage = 'INVALID EMAIL OR PASSWORD';
                showFlushBar(context, errMessage);
                // errMessage='elloMate';
              }
            }).whenComplete(
                    () => authenticateService.autheticate().whenComplete(() {
                        //  print("MYERROR" + errMessage);
                          if (errMessage == 'ellomate') {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EnterCode()));
                          } else {
                            return null;
                          }
                        }));
          }
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Color(0xFF61bcbc),
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Colors.white,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 20.0),
        Text(
          'Sign in with',
          style: kLabelStyle,
        ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55.0,
        width: 55.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildSocialBtn(
            () => signInService
                .facebookSignIn(context)
                .then((FirebaseUser user) => populateData())
                .catchError((e) => print(''))
                .whenComplete(() => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EnterCode()))),
            AssetImage(
              'assets/images/facebook.jpg',
            ),
          ),
          _buildSocialBtn(
            () => signInService
                .googSignIn(context)
                //.timeout(const Duration(seconds: 30),onTimeout: _onTimeout() => (FirebaseUser user))
                .then((FirebaseUser user) => populateData())
                .catchError((e) => print(''))
                .whenComplete(() => addUser())
                .whenComplete(() => authenticateService
                    .autheticate()
                    .whenComplete(() => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => EnterCode())))),
            AssetImage(
              'assets/images/google.png',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text('Don\'t have an Account? ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold)),
        ),
        FlatButton(
            child: FittedBox(
              fit: BoxFit.contain,
              child: Text(
                'Click here',
                style: TextStyle(
                    color: Color(0xFF61bcbc),
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => SignUp()));
            }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 40.0,
          backgroundColor: Color(0xFF61bcbc),
          automaticallyImplyLeading: false,
          shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(100),
                  topRight: Radius.circular(100)))),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Color(0xFFFAFAFA),
              ),
            ),
            Container(
              height: double.infinity,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 80.0),
                      ),

                      Text(
                        'Welcome to ISKCON',
                        style: TextStyle(
                          color: Color(0xFF61bcbc),
                          fontFamily: 'OpenSans',
                          fontSize: 25.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 30.0),
                      ),

                      _buildEmailTF(),

                      //_buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
                      _buildSignupBtn(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final kHintTextStyle = TextStyle(
  color: Colors.grey,
  fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.black,
  fontWeight: FontWeight.bold,
  fontFamily: 'OpenSans',
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  border: Border.all(color: Color(0xFF61bcbc)),
  borderRadius: BorderRadius.circular(10.0),
  /* boxShadow: [
    BoxShadow(
      color: Color(0xFF61bcbc),
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],*/
);

void showFlushBar(BuildContext context, String errMessage) {
  Flushbar(
    padding: EdgeInsets.all(10),
    borderRadius: 8,
    backgroundColor: Colors.grey.shade800,
    // boxShadows: [
    //   BoxShadow(color: Colors.black45,offset: Offset(3,3),blurRadius: 3),
    // ],
    margin: EdgeInsets.all(20),
    leftBarIndicatorColor: Colors.cyanAccent,
    // dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    // forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
    titleText: Text(
      errMessage,
      style: TextStyle(fontSize: 18),
    ),
    messageText: errMessage == 'No user Found'
        ? Text('Sign up Instead')
        : Text('Enter correct password'),
    duration: errMessage == 'No user Found'
        ? Duration(seconds: 3)
        : Duration(seconds: 3),
    icon: Icon(
      Icons.info_outline,
      size: 28,
      color: Colors.cyanAccent,
    ),
  )..show(context).whenComplete(() => Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginApp())));
}
