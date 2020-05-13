import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/pref_settings.dart';

class MySettingsApp extends StatefulWidget {
  @override
  //static double custFontSize = 16;
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MySettingsApp> {
  //double _brightness = 1.0;

  /*void changeFontSize() async {
    setState(() {
      MySettingsApp.custFontSize += 2;
    });
  }

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
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           /* Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => SwitchListTile(
                title: Text("Dark Mode",
                style: TextStyle(
                  fontSize: MyPrefSettingsApp.custFontSize,
                )
                ),
                onChanged: (val) {
                  notifier.toggleTheme();
                },
                value: notifier.darkTheme,
              ),
            ),*/
            //Divider(),
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
           /* Text("TextSize :",
              style: TextStyle(fontSize:MyPrefSettingsApp.custFontSize),
            ),
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text(MyPrefSettingsApp.custFontSize.toString(),
                        style: TextStyle(fontSize: 20)),
                    Slider(
                      value: MyPrefSettingsApp.custFontSize,
                      min: 16,
                      max: 30,
                      activeColor: Color(0xFFEB1555),
                      inactiveColor: Color(0xFF8D8E98),
                      onChanged: (double newValue) {
                        setState(() {
                          MyPrefSettingsApp.custFontSize =
                              newValue.floor().toDouble();
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),*/
            Divider(),
            Card(
              child:ListTile(
                trailing: Icon(Icons.keyboard_arrow_right),
                title: Text("Preference Settings",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyPrefSettingsApp()));
                },
                selected: true,
              ),
            ),
             Divider(),
            Card(
              child:ListTile(
                title: Text("Notifications",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),),
                onTap: (){
                  _showMaterialDialog();
                },
                selected: true,
              ),
            ),

            /*Divider(),
            Card(
              child:ListTile(
                title: Text("About us",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),),
                onTap: (){
                  _showMaterialDialog();
                },
                selected: true,
              ),
            ),

            Divider(),
            Card(
              child:ListTile(
                title: Text("Help and FAQs",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),),
                onTap: (){
                  _showMaterialDialog();
                },
                selected: true,
              ),
            ),

            Divider(),
            Card(
              child:ListTile(
                title: Text("Rate us",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),),
                onTap: (){
                  _showMaterialDialog();
                },
                selected: true,
              ),
            ),

            Divider(),
            Card(
              child:ListTile(
                title: Text("Share the app",
                  style: TextStyle(
                    fontSize: MyPrefSettingsApp.custFontSize,
                  ),),
                onTap: (){
                  _showMaterialDialog();
                },
                selected: true,
              ),
            ),*/

          ],
        ),
      ),
    );
  }

  _showMaterialDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Notifications"),
          content: new Text("Do you want to get notifications on phone?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
  }
}
