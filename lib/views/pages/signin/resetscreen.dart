import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/signin/signup.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';


final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class ResetScreen extends StatefulWidget {
  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  //FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController username = new TextEditingController();
  AutheticationAPIService authenticateService = AutheticationAPIService();
  FocusNode myFocusNode = new FocusNode();
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController _email = new TextEditingController();
  SharedPreferences prefs;
  void loadPref() async {
    prefs = await SharedPreferences.getInstance();

  }

  final kBoxDecorationStyle = BoxDecoration(
    color: Colors.white,
    border: Border.all(color: Color(0xFF61bcbc)),
    borderRadius: BorderRadius.circular(10.0),
  );

  final kHintTextStyle = TextStyle(
    color: Colors.grey,
    fontFamily: 'OpenSans',
  );

  final kLabelStyle = TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontFamily: 'OpenSans',
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder:(context, notifier, child)=> Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
          //icon: Icon(Icons.arrow_back, color: Colors.white),
          backgroundColor: KirthanStyles.colorPallete30,
          title: Text('Reset Password',  style: TextStyle(color: KirthanStyles.colorPallete60),
          ),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Column(
          children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
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
              // Container(
              //   alignment: Alignment.centerLeft,
              //   decoration: kBoxDecorationStyle,
              //   height: 60.0,
              //   child: TextFormField(
              //     autovalidateMode: AutovalidateMode.onUserInteraction,
              //     controller:_email,
              //     focusNode: myFocusNode,
              //     keyboardType: TextInputType.emailAddress,
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontFamily: 'OpenSans',
              //     ),
              //     decoration: InputDecoration(
              //       border: InputBorder.none,
              //       contentPadding: EdgeInsets.only(top: 14.0),
              //       prefixIcon: Icon(
              //         Icons.email,
              //         color: KirthanStyles.colorPallete30,
              //       ),
              //       hintText: 'Email address',
              //       hintStyle: kHintTextStyle,
              //     ),
              //     // controller: username,
              //     validator: (input) =>
              //     EmailValidator.validate(input) ? null : "Not a Valid User",
              //   ),
              // ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: KirthanStyles.colorPallete30,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(
                          color: KirthanStyles.colorPallete30,
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
                      prefixIcon: Icon(Icons.email, color: Color(0xFF61bcbc)),
                      hintText: 'Enter Email',
                      hintStyle: kHintTextStyle,
                    ),
                    controller: username,
                    validator: (value) {
                      if (value.trimLeft().isEmpty) {
                        return 'Please enter email';
                      } else {
                        return EmailValidator.validate(value)
                            ? null
                            : "Please enter valid email";
                      }
                    },
                    //onSaved: (input) => email = input,
                  ),
                ),
                SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RaisedButton(

                        child: Text('Send Request'),
                        onPressed: () {
                          var e=null;
                          auth.sendPasswordResetEmail( email: _email.text)
                          .catchError((error){
                            error.code=='ERROR_USER_NOT_FOUND';
                            showDialog(
                              context: context,
                              builder: (context){
                                return AlertDialog(
                              // actions: [
                              //   FlatButton(onPressed: (){
                              //     Navigator.of(context).push(
                              //         MaterialPageRoute(builder: (context) => SignUp()));
                              //   },
                              //   child: Row(
                              //     children: [Text('Sign-up instead?',style: TextStyle(fontSize:18,color: KirthanStyles.colorPallete30),),
                              //     Icon(Icons.arrow_forward_ios,color: Colors.blue,)],
                              //   ),)
                              // ],
                              // content: Text('User not found',style: TextStyle(color: Colors.black),),
                              backgroundColor: Colors.white,
                            title:Row(
                              children: [
                                Icon(Icons.error_outline,color: KirthanStyles.colorPallete30,),
                                SizedBox(width: 10,),
                                Text('User not found',style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            );});
                            e= "error";
                          })
                              .whenComplete(() => e==null?showDialog(
                            context:context,
                              builder: (context){
                              return AlertDialog(
                                backgroundColor: Colors.white,
                                title: Row(
                                children: [
                                  Icon(Icons.info_outline, color:KirthanStyles.colorPallete30),
                                  SizedBox(width:10),
                                  Text('Email Sent',style: TextStyle(color:Colors.black),),
                                ],
                              ),
                              content: Text('Please check your mail for the password reset link',style: TextStyle(color:Colors.black),),);}
                          )
                              :null);
                        },
                        color: KirthanStyles.colorPallete30,
                      ),
                    ],
                  ),
                ],),
            ),
          ),
          ],
      ),
        ),
      ),
    );
  }
}


