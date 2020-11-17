import 'dart:async';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/services/role_screen_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

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


  Future<List<RoleScreen>> getRoleScreenMaping(String roleId) {
    Future<List<RoleScreen>> rolescreenreqs = apiSvc?.getRoleScreenMapping(roleId);
    return rolescreenreqs;
  }


  Future<List<RoleScreen>> submitNewRoleScreenMapping(List<RoleScreen> listroleScreen) {
    Future<List<RoleScreen>> rolescreenrequest = apiSvc?.submitNewRoleScreenMapping(listroleScreen);
    return rolescreenrequest;
  }


  Future<List<RoleScreen>> submitDeleteRoleScreenMapping(
      List<RoleScreen> listofrolescreenmap) {
    Future<List<RoleScreen>> rolescreens =
    apiSvc?.submitDeleteRoleScreenMapping(listofrolescreenmap);
    return rolescreens;
  }



}