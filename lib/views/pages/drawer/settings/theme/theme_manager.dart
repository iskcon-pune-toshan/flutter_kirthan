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
    color: KirthanStyles.colorPallete60,
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
  cardColor: Color(0xff303030),
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
  bool currentColorStatus = false;

  //Preference settings
  String area = " ";
  String localAdmin = " ";
  String requestAcceptance = " ";
  String duration = " ";

  //Custom Text Size
  double custFontSize = 16;

  bool get darkTheme => !_darkTheme;

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
    currentColorStatus = true;
    notifyListeners();
  }

  void removeColor() {
    currentColorStatus = !currentColorStatus;
    notifyListeners();
  }

  //on font size change
  void changeFontSize(double fontsize) {
    custFontSize = fontsize.floor().toDouble();
    notifyListeners();
  }

  void durationNotifier(String value) {
    duration = value;
    notifyListeners();
  }

  void areaNotifier(String value) {
    area = value;
    notifyListeners();
  }

  void localAdminNotifier(String value) {
    localAdmin = value;
    notifyListeners();
  }

  void requestAcceptanceNotifier(String value) {
    requestAcceptance = value;
    notifyListeners();
  }
}
