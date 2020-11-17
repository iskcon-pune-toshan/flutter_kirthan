import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/permissions_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/permissions.dart';


class PermissionsPageViewModel extends Model {
  final IPermissionsRestApi apiSvc;

  PermissionsPageViewModel({@required this.apiSvc});
  Map<String,bool> accessTypes;

  Future<List<Permissions>> _permissionsrequests;
  Future<List<Permissions>> get permissionsrequests => _permissionsrequests;

  set permissionsrequests(Future<List<Permissions>> value) {
    _permissionsrequests = value;
    notifyListeners();
  }


  Future<bool> setPermissions(String userType) async {
    permissionsrequests = apiSvc?.getPermissions(userType);
    return permissionsrequests != null;
  }

  Future<List<Permissions>> getPermissions(String userType) {
    Future<List<Permissions>> usersreqs = apiSvc?.getPermissions(userType);
    return usersreqs;
  }


  Future<Permissions> submitNewPermissions(Map<String, dynamic> userrequestmap) {
    Future<Permissions> userrequest = apiSvc?.submitNewPermissions(userrequestmap);
    return userrequest;
  }


  Future<bool> deletePermissions(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deletePermissions(processrequestmap);
    return deleteFlag;
  }


  Future<bool> submitUpdatePermissions(String userrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdatePermissions(userrequestmap);
    return updateFlag;
  }


}