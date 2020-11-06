import 'dart:async';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/role_screen_service_interface.dart';
import 'package:flutter_kirthan/services/user_temple_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/temple_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/temple.dart';


class RoleScreenViewPageModel extends Model {
  final IRoleScreenRestApi apiSvc;

  RoleScreenViewPageModel({@required this.apiSvc});
  Map<String,bool> accessTypes;

  Future<List<RoleScreen>> _rolescreenrequests;
  Future<List<RoleScreen>> get rolescreenrequests => _rolescreenrequests;

  set rolescreenrequests(Future<List<RoleScreen>> value) {
    _rolescreenrequests = value;
    notifyListeners();
  }


  Future<bool> setRoleScreen(String roleId) async {
    rolescreenrequests = apiSvc?.getRoleScreens(roleId);
    return rolescreenrequests != null;
  }

  Future<List<RoleScreen>> getRoleScreen(String roleId) {
    Future<List<RoleScreen>> rolescreenreqs = apiSvc?.getRoleScreens(roleId);
    return rolescreenreqs;
  }


  Future<RoleScreen> submitNewRoleScreen(Map<String, dynamic> rolescreenrequestmap) {
    Future<RoleScreen> rolescreenrequest = apiSvc?.submitNewRoleScreen(rolescreenrequestmap);
    return rolescreenrequest;
  }


  Future<bool> deleteRoleScreen(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deleteRoleScreen(processrequestmap);
    return deleteFlag;
  }


  Future<bool> submitUpdateRoleScreen(String userrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdateRoleScreen(userrequestmap);
    return updateFlag;
  }


}