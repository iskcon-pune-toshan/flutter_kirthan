import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ThemeData light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.deepPurple,
    accentColor: Colors.pink,
    scaffoldBackgroundColor: Color(0xfff9f9f9));

ThemeData dark = ThemeData(
  brightness: Brightness.dark,
  primarySwatch: Colors.indigo,
  accentColor: Colors.pink,
);

List<String> area = ["NVCC", "katraj", "Camp", "Koregaon"];

class SettingsNotifier extends ChangeNotifier {
  final String key = "settings";
  SharedPreferences _sharedPref;
  String _area;
  bool _darkTheme;

  String get area => _area;
  bool get darkTheme => _darkTheme;

  _initSettings() async {
    if (_sharedPref == null) {
      _sharedPref = await SharedPreferences.getInstance();
    }
  }

  AreaNotifier() {
    _area = area;
    _getArea();
  }

  selectArea() {
    _area != area;
    _saveArea();
    notifyListeners();
  }


  _getArea() async {
    await _initSettings();
    _area = _sharedPref.getString(key) ?? true;
    notifyListeners();
  }

  _saveArea() async {
    await _initSettings();
    _sharedPref.setString(key, _area);
  }

  ThemeNotifier() {
    _loadFromPrefs();
  }

  _loadFromPrefs() async {
    await _initSettings();
    _darkTheme = _sharedPref.getBool(key) ?? true;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initSettings();
    _sharedPref.setBool(key, _darkTheme);
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }
}
