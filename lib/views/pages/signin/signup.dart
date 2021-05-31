import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/teamuser/user_selection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class SignUp extends StatefulWidget {
  SignUp({Key key}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  File _image;
  String _uploadedFileURL;
  final TextEditingController _passwordcontroller = new TextEditingController();
  String password;
  final TextEditingController _emailcontroller = new TextEditingController();
  String email;
  final TextEditingController _displaynamecontroller =
  new TextEditingController();
  final TextEditingController _addresscontroller = new TextEditingController();
  String displayName;
  final TextEditingController _confirmpassword = new TextEditingController();
  String _username;
  UserLogin _selecteduser;
  UserRequest user = new UserRequest();
  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadFile() async {
    StorageReference storageReference = await FirebaseStorage.instance
        .ref()
        .child('${_emailcontroller.text}' + '.jpg');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    // print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
      });
    });
  }

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
    String num = s.phoneNumber;
    //print("signup uid");
    //print(pass);
    if (_formKey.currentState.validate()) {
      String dt =
      DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
      // user.firstName = _displaynamecontroller.text;
      // user.lastName = _displaynamecontroller.text;
      user.email = _emailcontroller.text;
      user.password = pass;
      user.phoneNumber = 123456789;
      user.fullName = _displaynamecontroller.text;
      user.addLineOne = "xyz";
      user.addLineTwo = "abc";
      user.addLineThree = "pqr";
      user.locality = "Pune";
      user.city = _addresscontroller.text;
      user.pinCode = 400001;
      user.state = "Maharashtra";
      user.country = "India";
      user.govtIdType = "Aadhaar";
      user.govtId = "Aadhaar";
      //user.isProcessed = true;
      // user.approvalComments = "Waiting";
      user.approvalStatus = "Approved";
      user.roleId = 3;
      user.prevRoleId = 3;
      user.createdBy = _emailcontroller.text;
      user.updatedBy = "";
      user.createdTime = dt;
      user.updatedTime = null;
      user.profileUrl = _uploadedFileURL;
      Map<String, dynamic> usermap = user.toJson();
      UserRequest userRequest = await userPageVM.submitNewUserRequest(usermap).whenComplete(()=>showFlushBar(context,"User registered successfully"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sign-Up Page",
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
          title: Text(
            'Sign Up',
            style: TextStyle(color: KirthanStyles.colorPallete60),
          ),
          backgroundColor: KirthanStyles.colorPallete30,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20),
              //color: Color.alphaBlend(BlendMode.color, BlendMode.colorDodge),
              child: Form(
                key: _formKey,
                autovalidate: true,
                child: Center(
                  child: Column(
                    verticalDirection: VerticalDirection.down,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () {
                          chooseFile();
                        },
                        child: CircleAvatar(
                          backgroundColor: KirthanStyles.colorPallete30,
                          radius: MediaQuery.of(context).size.width / 5 + 3,
                          child: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: MediaQuery.of(context).size.width / 5.5,
                              backgroundImage: _image != null
                                  ? FileImage(
                                _image,
                              )
                                  : AssetImage(
                                  "assets/images/default_profile_picture.png")),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15, top: 15),
                        child: TextFormField(
                          decoration: buildInputDecoration(
                              Icons.person, "Full Name", "Full Name"),
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
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: buildInputDecoration(
                              Icons.email, "Email", "Email"),
                          controller: _emailcontroller,
                          validator: (value) {
                            if(value.isEmpty) {
                              return 'Please enter email';
                            }
                            else{
                              return EmailValidator.validate(value)
                                  ? null
                                  : "Please enter valid email";
                            }
                          },
                          //onSaved: (input) => email = input,
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: buildInputDecoration(
                                Icons.location_on, "Address", "Address"),
                            controller: _addresscontroller,
                            validator: (value) {
                              // ignore: missing_return
                              if (value.isEmpty) return 'Please enter a value';
                              return null;
                            },
                          )),
                      Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: buildInputDecoration(Icons.lock,
                                "Must contain 8-30 characters", "Password"),
                            controller: _passwordcontroller,
                            validator: (value) {
                              // ignore: missing_return
                              if (value.isEmpty) return 'Please enter a value';
                              if (value.length < 8)
                                return 'Must contain 8-30 characters';
                              return null;
                            },
                            obscureText: true,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: buildInputDecoration(Icons.lock,
                              "Re-Type Password", "Re-Type Password"),
                          controller: _confirmpassword,
                          validator: (val) {
                            if (val.isEmpty) return 'Please enter a value';
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // SizedBox(
                          //   width: 140,
                          //   height: 50,
                          //   child: RaisedButton(
                          //     color: Colors.white,
                          //     child: Text('Cancel'),
                          //     onPressed: () {
                          //       Navigator.pop(context);
                          //     },
                          //     shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(50.0),
                          //         side: BorderSide(color: Colors.blue, width: 2)),
                          //   ),
                          // ),
                          /*SizedBox(
                            width: 140,
                            height: 50,
                            child: (
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    KirthanStyles.colorPallete30),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                      side: BorderSide(
                                          color: Colors.blue, width: 2)),
                                ),
                              ),
                              child: Text('Submit'),
                              onPressed: () async {
                                signIn
                                    .signUpWithEmail(_emailcontroller.text,
                                        _passwordcontroller.text)
                                    .then((FirebaseUser user) => populateData())
                                    .catchError((e) => print(e))
                                    .whenComplete(() => addUser());
                              },
                            ),
                          )*/
                          SizedBox(
                            width: 140,
                            height: 50,
                            child: RaisedButton(
                              color: KirthanStyles.colorPallete30,
                              child: Text(
                                'Register',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  var errorMessage='null';

                                  signIn
                                      .signUpWithEmail(_emailcontroller.text,
                                      _passwordcontroller.text)
                                      .then(
                                          (FirebaseUser user) => populateData())
                                      .catchError((e){
                                    // print(e);
                                    if(e.code == 'ERROR_EMAIL_ALREADY_IN_USE'){
                                      errorMessage="Email already in use";
                                      showFlushBar(context,errorMessage);
                                    }
                                  }).whenComplete(() {
                                    errorMessage=='null'
                                        ?addUser() :null;
                                  }).whenComplete(() => errorMessage=='null'&&_image!=null ?uploadFile():null);
                                }
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50.0),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration buildInputDecoration(
      IconData icons, String hinttext, String labeltext) {
    return InputDecoration(
      labelText: labeltext,
      hintText: hinttext,
      prefixIcon: Icon(
        icons,
        color: KirthanStyles.colorPallete30,
      ),
      labelStyle: TextStyle(color: Colors.grey),
      hintStyle: TextStyle(color: Colors.grey),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: Colors.grey,
          width: 1.5,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(
          color: KirthanStyles.colorPallete30,
          width: 1.5,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(
          color: KirthanStyles.colorPallete30,
          width: 1.5,
        ),
      ),
    );
  }
}

void showFlushBar(BuildContext context, var error) {
  Flushbar(
    messageText: Text(
        error,
        style: TextStyle(color: Colors.white)),
    backgroundColor: error=='Email already in use'?Colors.red:Colors.green,
    duration: Duration(seconds: 4),
  )..show(context).whenComplete(() => error=='Email already in use'?null:Navigator.push(
      context, MaterialPageRoute(builder: (context) => LoginApp())));
}
