import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/teamuser/user_selection.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _passwordcontroller = new TextEditingController();
  String password;
  final TextEditingController _emailcontroller = new TextEditingController();
  String email;
  final TextEditingController _displaynamecontroller =
      new TextEditingController();
  String displayName;
  final TextEditingController _confirmpassword = new TextEditingController();

  String _username;
  UserLogin _selecteduser;

  UserRequest user = new UserRequest();

  @override
  void initState() {
    super.initState();
    entitlements = UserAccess.getUserEntitlements();
    loadPref();
  }

  SignInService signIn = new SignInService();
  UserAccess _userAccess;
  List<UserAccess> entitlements;
  SharedPreferences prefs;

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    //prefs.setString("My Name", "Manjunath Bijinepalli");
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

  addUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    FirebaseUser s = await auth.currentUser();
    String pass = s.uid;
    print("signup uid");
    print(pass);

    if (_formKey.currentState.validate()) {
      String dt =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());

      user.firstName = _displaynamecontroller.text;
      user.lastName = _displaynamecontroller.text;
      user.email = _emailcontroller.text;
      user.password = pass;
      user.phoneNumber = 12345678;
      user.userName = _displaynamecontroller.text;
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
      user.isProcessed = true;
      user.approvalComments = "Waiting";
      user.approvalStatus = "Waiting";
      user.roleId = 3;
      user.createdBy = _emailcontroller.text;
      user.updatedBy = "";
      user.createdTime = dt;
      user.updatedTime = null;

      Map<String, dynamic> usermap = user.toJson();
      UserRequest userRequest = await userPageVM.submitNewUserRequest(usermap);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sign-Up Page",
      debugShowCheckedModeBanner: false,

      home: Scaffold(
        appBar: AppBar(
          title: Text("Sign-Up"),
          backgroundColor: Colors.indigo,
        ),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom:15),
                      child: TextFormField(
                        decoration: buildInputDecoration(Icons.person,"Full Name","Full Name"),


                        controller: _displaynamecontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            // ignore: missing_return
                            return "Please enter some text";
                          }
                          return null;
                        },
                        //onSaved: (input) => displayName = input,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom:15),
                      child: TextFormField(
                        decoration:buildInputDecoration(Icons.email,"Email","Email"),

                        controller: _emailcontroller,
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                        //onSaved: (input) => email = input,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:15),
                      child: TextFormField(
                        decoration:buildInputDecoration(Icons.lock,"Must contain 8-30 characters","Password"),
                        controller: _passwordcontroller,
                        validator: (value) {
                          // ignore: missing_return
                          if(value.isEmpty)
                            return 'Please enter a value';

                          if(value.length < 8)
                            return 'Must contain 8-30 characters';
                          return null;

                        },
                        obscureText: true,
                      )
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom:15),
                      child: TextFormField(

                        decoration:buildInputDecoration(Icons.lock,"Confirm Password","Confirm Password"),
                        controller: _confirmpassword,
                        validator: (val) {
                          if (val.isEmpty) return 'Empty';
                          if (val != _passwordcontroller.text)
                            return "Not Match";
                          return null;
                        },
                        onSaved: (input) => password = input,
                        obscureText: true,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Divider(
                          thickness: 100.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: RaisedButton(
                        color: Colors.lightGreen,
                        child: Text('Submit'),
                        onPressed: () async {

                          signIn
                              .signUpWithEmail(
                                  _emailcontroller.text, _passwordcontroller.text)
                              .then((FirebaseUser user) => populateData())
                              .catchError((e) => print(e))
                              .whenComplete(() => addUser())
                              .whenComplete(() => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginApp())));
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            side: BorderSide(color: Colors.blue,width: 2)

                      ),
                    ),
                    )],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(IconData icons,String hinttext,String labeltext) {
    return InputDecoration(
      labelText: labeltext,
      hintText: hinttext,
      
      prefixIcon: Icon(icons),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
            color: Colors.green,
            width: 1.5
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.5,
        ),
      ),
      enabledBorder:OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: BorderSide(
          color: Colors.blue,
          width: 1.5,
        ),
      ),
    );
  }
}
