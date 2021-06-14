import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/color_picker.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/impl_perferences.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/settings_list_item.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'color_picker.dart';

class MyPrefSettingsApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyPrefSettingsApp> {
  double _brightness = 1.0;

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  initPlatformState() async {
    double brightness = await Screen.brightness;
    setState(() {
      _brightness = brightness;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Display Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => SwitchListTile(
                title: Text("Dark Mode",
                    style: TextStyle(
                      fontSize: notifier.custFontSize,
                    )),
                onChanged: (val) {
                  notifier.toggleTheme();
                },
                value: notifier.darkTheme,
              ),
            ),
            Divider(),
            /* new Text(
              "Brightness:",
                  style: TextStyle(fontSize:MySettingsApp.custFontSize),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(MySettingsApp.custFontSize.toString(),
                        style: TextStyle(fontSize: 20)
                        ),
                    Slider(
                        value: _brightness,
                      activeColor: Color(0xFFEB1555),
                      inactiveColor: Color(0xFF8D8E98),
                        onChanged: (double b) {
                          setState(() {
                            _brightness = b;
                          });
                          Screen.setBrightness(b);
                        }),
                  ],
                ),
              ),
            ),*/
            /*RaisedButton(
              onPressed: () {
                changeFontSize();
              },
              child: Text('Change size'),
            ),*/
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => Text(
                "TextSize :",
                style: TextStyle(fontSize: notifier.custFontSize),
              ),
            ),
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) =>
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) => Column(
                          children: <Widget>[
                            Text(notifier.custFontSize.toString(),
                                style: TextStyle(fontSize: 20)),
                            Slider(
                              value: notifier.custFontSize,
                              min: 16,
                              max: 30,

                              activeColor: KirthanStyles.colorPallete10,
                              inactiveColor: Color(0xFF8D8E98),
                              onChanged: (changeFontSize){
                                setState(() {
                                  notifier.custFontSize = changeFontSize;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
            ),
            Divider(),
            MyColorPicker(),
          ],
        ),
      ),
    );
  }
}
