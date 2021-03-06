import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/notification_service.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:provider/provider.dart';

void main() => runApp(KirthanApp());

class KirthanApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    NotificationManager _notification = new NotificationManager();
    return ChangeNotifierProvider(
        create: (_) => ThemeNotifier(),
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
              return new MaterialApp(
                title: 'Kirthan Application',
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
