import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/signin/kirthan_signin.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';

void main() => runApp(KirthanApp());

class KirthanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Kirthan Application',
      theme: new ThemeData(
        primaryColor: Color(0xff070707),
        primaryColorLight: Color(0xff0a0a0a),
        primaryColorDark: Color(0xff000000),
      ),
      home:LoginApp() ,
      //home:SignInApp() ,
      debugShowCheckedModeBanner: false,
    );
  }
}
