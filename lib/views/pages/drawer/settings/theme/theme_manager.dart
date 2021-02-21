import 'package:flutter/material.dart';
import 'package:flutter_kirthan/main.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';

ThemeData light = ThemeData(
  brightness: Brightness.light,
  primaryColor: KirthanStyles.colorPallete60,
  accentColor: KirthanStyles.colorPallete10,
  scaffoldBackgroundColor: Color(0xfff9f9f9),
  cardColor: KirthanStyles.colorPallete60,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: KirthanStyles.colorPallete30),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: KirthanStyles.colorPallete30,
    highlightColor: Colors.grey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    textTheme: ButtonTextTheme.primary,
  ),
);

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: KirthanStyles.colorPallete10,
  appBarTheme: AppBarTheme(
    iconTheme: IconThemeData(color: KirthanStyles.colorPallete30),
  ),
  buttonTheme: ButtonThemeData(
    buttonColor: KirthanStyles.colorPallete30,
    highlightColor: Colors.grey,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    textTheme: ButtonTextTheme.primary,
  ),
);

class ThemeNotifier extends ChangeNotifier {
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;
  //Card color picker
  Color currentColor = Colors.blue;

  //Preference settings
  String area, localAdmin, duration, requestAcceptance;
  bool get darkTheme => _darkTheme;

  ThemeNotifier() {
    _darkTheme = false;
    _loadFromPrefs();
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }

  void changeColor(Color color) {
    currentColor = color;
    notifyListeners();
  }

  void durationNotifier() {
    notifyListeners();
  }
}
