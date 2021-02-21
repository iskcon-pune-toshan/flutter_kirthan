import 'dart:ui';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

class FaqApp extends StatefulWidget {
  @override
  _FaqState createState() => new _FaqState();
}

class _FaqState extends State<FaqApp> {
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
        title: Text('FAQs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    Text("Frequently Asked Questions",
                        style: TextStyle(fontSize: 30, color: Colors.red)),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Text(
                          "\nQ1)How do we send invite to team?\n"
                          "\n"
                          ".........................",
                          style: TextStyle(
                              fontSize: notifier.custFontSize,
                              color: Colors.red)),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
