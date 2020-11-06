import 'dart:async';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/user_temple_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/temple_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/temple.dart';


class UserTemplePageViewModel extends Model {
  final IUserTempleRestApi apiSvc;

  UserTemplePageViewModel({@required this.apiSvc});
  Map<String,bool> accessTypes;

  Future<List<UserTemple>> _usertemplerequests;
  Future<List<UserTemple>> get usertemplerequests => _usertemplerequests;

  set usertemplerequests(Future<List<UserTemple>> value) {
    _usertemplerequests = value;
    notifyListeners();
  }


  Future<bool> setUserTemples(String userType) async {
    usertemplerequests = apiSvc?.getUserTemples(userType);
    return usertemplerequests != null;
  }

  Future<List<UserTemple>> getUserTemples(String userType) {
    Future<List<UserTemple>> usersreqs = apiSvc?.getUserTemples(userType);
    return usersreqs;
  }


  Future<UserTemple> submitNewUserTemple(Map<String, dynamic> userrequestmap) {
    Future<UserTemple> userrequest = apiSvc?.submitNewUserTemple(userrequestmap);
    return userrequest;
  }


  Future<bool> deleteUserTemple(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deleteUserTemple(processrequestmap);
    return deleteFlag;
  }


  Future<bool> submitUpdateUserTemple(String userrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdateUserTemple(userrequestmap);
    return updateFlag;
  }


}