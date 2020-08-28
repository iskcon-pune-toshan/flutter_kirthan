import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/signin/kirthan_signin.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:provider/provider.dart';

void main() => runApp(KirthanApp());

class KirthanApp extends StatelessWidget {
  bool darkThemeenabled=false;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return new MaterialApp(
                title: 'Kirthan Application',
               // theme: notifier.darkTheme ? dark : light,
                theme: new ThemeData(

                  primaryColor: Color(0xff070707),
                  primaryColorLight: Color(0xff0a0a0a),
                  primaryColorDark: Color(0xff000000),
                ),
                home: LoginApp(),
                //home:SignInApp() ,
                debugShowCheckedModeBanner: false,
              );
            }
        )
    );
  }
}