import 'dart:async';
import 'package:flutter_kirthan/models/preferences.dart';

abstract class IPreferencesRestApi {
  //Sample

  //preferences
  Future<List<Preferences>> getPreferences(String userType);

  Future<Preferences> submitNewPreferences(Map<String, dynamic> preferencesmap);

  Future<bool> submitUpdatePreferences(String preferencesmap);
}
