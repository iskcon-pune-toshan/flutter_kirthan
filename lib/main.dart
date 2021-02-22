import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/widgets/event/event_list_item.dart';
import 'package:flutter_kirthan/views/widgets/event/int_item.dart';
import 'package:provider/provider.dart';

void main() => runApp(KirthanApp());

class KirthanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers:[
          ChangeNotifierProvider(
            create: (_) => ThemeNotifier(),),
          ChangeNotifierProvider(
            create: (_) => int_item(),)
        ],
        child: Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child)
            {
              return new MaterialApp(
                title: 'Kirthan Application',
                theme: notifier.darkTheme ? dark : light,
                home: LoginApp(),
                //home:SignInApp() ,
                debugShowCheckedModeBanner: false,

              );
            }
        ));
  }
}
