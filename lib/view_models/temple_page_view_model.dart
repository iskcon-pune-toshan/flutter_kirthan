import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/temple_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/temple.dart';


class TemplePageViewModel extends Model {
  final ITempleRestApi apiSvc;

  TemplePageViewModel({@required this.apiSvc});
  Map<String,bool> accessTypes;

  Future<List<Temple>> _templerequests;
  Future<List<Temple>> get templerequests => _templerequests;

  set templerequests(Future<List<Temple>> value) {
    _templerequests = value;
    notifyListeners();
  }


  Future<bool> setTemples(String userType) async {
    templerequests = apiSvc?.getTemples(userType);
    return templerequests != null;
  }

  Future<List<Temple>> getTemples(String userType) {
    Future<List<Temple>> usersreqs = apiSvc?.getTemples(userType);
    return usersreqs;
  }


  Future<Temple> submitNewTemple(Map<String, dynamic> userrequestmap) {
    Future<Temple> userrequest = apiSvc?.submitNewTemple(userrequestmap);
    return userrequest;
  }


  Future<bool> deleteTemple(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deleteTemple(processrequestmap);
    return deleteFlag;
  }


  Future<bool> submitUpdateTemple(String userrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdateTemple(userrequestmap);
    return updateFlag;
  }


}