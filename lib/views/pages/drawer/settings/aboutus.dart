import 'dart:ui';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';

class AboutUsApp extends StatefulWidget {
  @override
  static double custFontSize = 17;
  _AboutUsState createState() => new _AboutUsState();
}

class _AboutUsState extends State<AboutUsApp> {
  double _brightness = 1.0;

  void changeFontSize() async {
    setState(() {
      AboutUsApp.custFontSize += 2;
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
            child: Stack(children: <Widget>[
              Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Image.asset("assets/images/kri2.jpg",
                        color: Color.fromRGBO(255, 255, 255, 0.3),
                        fit: BoxFit.fitHeight,
                        height: MediaQuery.of(context).size.height-136,
                        colorBlendMode: BlendMode.modulate),
                    // Image.asset("assets/images/kf.jpg",
                    //     // height: 1210,
                    //     color: Color.fromRGBO(255, 255, 255, 0.3),
                    //     colorBlendMode: BlendMode.modulate),
                  ]),

              // SizedBox(
              //   height: 40,
              // ),
              // Divider(
              //   height: 1.5,
              //   color: Colors.white,
              // ),
              // SizedBox(
              //   height: 40,
              // ),
              SingleChildScrollView(
                child: Column(children: <Widget>[
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text("Iskcon",
                        style: TextStyle(
                            fontFamily: 'Sacramento',
                            fontSize: 70,
                            //color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  ),
                Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) => Text(
                      "\nInternational Society For Krishna Consciousness:\n"
                          "\n"
                          "The society gives emphasis on four regulative principles as the basis of spiritual life. These principles are inspired from four legs of Dharma. These four principles are as follows:"
                          "\n"
                          "\n1.No meat-eating including fish and eggs"
                          "\n2.No illicit sex (even between husband and wife if it "
                          "is not for the procreation of children)"
                          "\n3.No Gambling"
                          "\n4.No intoxicants"
                          "\n"
                          "\nISKCON has seven main purposes which are as follows:"
                          "\n"
                          "\n1.To systematically spread spiritual knowledge and techniques of spiritual life to achieve balance in the values in life and to achieve real unity and peace across the world."
                          "\n2.To spread the consciousness of Krishna as described in the Bhagavad-gita and Srimad Bhagavatam."
                          "\n3.To bring the members of the society close to Krishna (the prime entity) and develop the thought within members and humanity that each soul is part of the quality of Godhead (Krishna)."
                          "\n4.To teach and encourage the Sankirtan movement (the congregational chanting of the holy name of the God) as described by the Lord Sri Chaitanya Mahaprabhu."
                          "\n5.To raise a holy place of transcendental pastimes dedicated to lord Krishna for the members and society at large."
                          "\n6.To bring members close to one another for the purpose of teaching simple and natural way of life."
                          "\n7.To publish and distribute books, magazines, periodicals etc, to achieve the above-mentioned purposes.",
                      style: TextStyle(
                          fontSize: AboutUsApp.custFontSize,
                          //color: Colors.white,
                          fontWeight: FontWeight.w600)),
                )]),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
