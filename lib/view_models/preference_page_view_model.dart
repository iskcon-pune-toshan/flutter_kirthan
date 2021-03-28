import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/preferences_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/preferences.dart';

class PreferencesPageViewModel extends Model {
  final IPreferencesRestApi apiSvc;

  PreferencesPageViewModel({@required this.apiSvc});
  Map<String, bool> accessTypes;

  Future<List<Preferences>> _preferencesrequests;
  Future<List<Preferences>> get preferencesrequests => _preferencesrequests;

  set preferencesrequests(Future<List<Preferences>> value) {
    _preferencesrequests = value;
    notifyListeners();
  }

  Future<bool> setPreferences() async {
    preferencesrequests = apiSvc?.getPreferences();
    return preferencesrequests != null;
  }

  Future<List<Preferences>> getPreferences() {
    Future<List<Preferences>> usersreqs = apiSvc?.getPreferences();
    return usersreqs;
  }

  Future<Preferences> submitNewPreferences(
      Map<String, dynamic> userrequestmap) {
    Future<Preferences> userrequest =
        apiSvc?.submitNewPreferences(userrequestmap);
    return userrequest;
  }

  Future<bool> submitUpdatePreferences(String userrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdatePreferences(userrequestmap);
    return updateFlag;
  }
}
