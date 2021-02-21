import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

class RateUsApp extends StatefulWidget {
  @override
  _RateUsState createState() => new _RateUsState();
}

class _RateUsState extends State<RateUsApp> {
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
        title: Text('About Us'),
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
                    Text("", style: TextStyle(fontSize: 30, color: Colors.red)),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Text(
                          "\nInternational Society For Krishna Consciousness:\n"
                          "\n"
                          "The society gives emphasis on four regulative principles as the basis of spiritual life. These principles are inspired from four legs of Dharma. These four principles are as follows:"
                          "\n1.No meat-eating including fish and eggs"
                          "\n2.No illicit sex (even between husband and wife if it is not for the procreation of children)"
                          "\n3.No Gambling"
                          "\n4.No intoxicants"
                          "\n"
                          "\nISKCON has seven main purposes which are as follows:"
                          "\n1.To systematically spread spiritual knowledge and techniques of spiritual life to achieve balance in the values in life and to achieve real unity and peace across the world."
                          "\n2.To spread the consciousness of Krishna as described in the Bhagavad-gita and Srimad Bhagavatam."
                          "\n3.To bring the members of the society close to Krishna (the prime entity) and develop the thought within members and humanity that each soul is part of the quality of Godhead (Krishna)."
                          "\n4.To teach and encourage the Sankirtan movement (the congregational chanting of the holy name of the God) as described by the Lord Sri Chaitanya Mahaprabhu."
                          "\n5.To raise a holy place of transcendental pastimes dedicated to lord Krishna for the members and society at large."
                          "\n6.To bring members close to one another for the purpose of teaching simple and natural way of life."
                          "\n7.To publish and distribute books, magazines, periodicals etc, to achieve the above-mentioned purposes.",
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
