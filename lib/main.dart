import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/members_name_profile.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/widgets/event/int_item.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/models/user.dart';

void main() => runApp(KirthanApp());

class KirthanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeNotifier(),
          ),
          ChangeNotifierProvider(
            create: (_) => int_item(),
          )
        ],
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
          return new StreamProvider<User>.value(
            //value: SignInService().user,
            child: new MaterialApp(
              title: 'Kirthan Application',
              theme: notifier.darkTheme ? dark : light,
              home: LoginApp(),
              //home: Wrapper(),
              //home:SignInApp() ,
              debugShowCheckedModeBanner: false,
              routes: <String, WidgetBuilder>{
                '/screen1': (BuildContext context) => MyProfileSettings(),
                '/screen4': (BuildContext context) => members_profile(),
              },
            ),
          );
          // MaterialApp(
          //   title: 'Kirthan Application',
          //   theme: notifier.darkTheme ? dark : light,
          //   home: LoginApp(),
          //   //home:SignInApp() ,
          //   debugShowCheckedModeBanner: false,
          //
          // );
        }));
  }
}
