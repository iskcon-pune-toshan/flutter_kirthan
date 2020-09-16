import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/impl_perferences.dart';
//import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/signin/kirthan_signin.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:provider/provider.dart';

void main() => runApp(KirthanApp());

class KirthanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotificationManager _notification = new NotificationManager();
    return ChangeNotifierProvider(
        create: (_) => SettingsNotifier(),
        child: Consumer<SettingsNotifier>(
            builder: (context, SettingsNotifier notifier, child) {
              return new MaterialApp(
                title: 'Kirthan Application',
                theme: notifier.darkTheme ? dark : light,
                home: LoginApp(),
                //home:SignInApp() ,
                debugShowCheckedModeBanner: false,
              );
            }
        )
    );
  }
}