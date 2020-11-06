import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/roles_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/roles.dart';


class RolesPageViewModel extends Model {
  final IRolesRestApi apiSvc;

  RolesPageViewModel({@required this.apiSvc});
  Map<String,bool> accessTypes;

  Future<List<Roles>> _rolesrequests;
  Future<List<Roles>> get rolesrequests => _rolesrequests;

  set rolesrequests(Future<List<Roles>> value) {
    _rolesrequests = value;
    notifyListeners();
  }


  Future<bool> setRoles(String userType) async {
    rolesrequests = apiSvc?.getRoles(userType);
    return rolesrequests != null;
  }

  Future<List<Roles>> getRoles(String userType) {
    Future<List<Roles>> usersreqs = apiSvc?.getRoles(userType);
    return usersreqs;
  }


  Future<Roles> submitNewRoles(Map<String, dynamic> userrequestmap) {
    Future<Roles> userrequest = apiSvc?.submitNewRoles(userrequestmap);
    return userrequest;
  }


  Future<bool> deleteRoles(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deleteRoles(processrequestmap);
    return deleteFlag;
  }


  Future<bool> submitUpdateRoles(String userrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdateRoles(userrequestmap);
    return updateFlag;
  }


}