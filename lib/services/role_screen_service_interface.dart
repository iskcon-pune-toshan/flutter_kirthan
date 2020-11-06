import 'dart:async';
import 'package:flutter_kirthan/models/rolescreen.dart';

abstract class IRoleScreenRestApi {
  //Sample


  //permissions
  Future<List<RoleScreen>> getRoleScreens(String roelId);

  //Future<List<Permissions>> getDummyUserRequests();

  Future<RoleScreen> submitNewRoleScreen(Map<String, dynamic> rolescreenmap);

  //Future<bool> processPermissions(Map<String, dynamic> processrequestmap);

  Future<bool> deleteRoleScreen(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateRoleScreen(String rolescreenrequestmap);
}
