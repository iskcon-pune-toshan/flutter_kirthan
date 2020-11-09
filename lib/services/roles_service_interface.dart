import 'dart:async';
import 'package:flutter_kirthan/models/roles.dart';

abstract class IRolesRestApi {
  //Sample


  //permissions
  Future<List<Roles>> getRoles(String userType);

  //Future<List<Permissions>> getDummyUserRequests();

  Future<Roles> submitNewRoles(Map<String, dynamic> rolesmap);

  //Future<bool> processPermissions(Map<String, dynamic> processrequestmap);

  Future<bool> deleteRoles(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateRoles(String rolesrequestmap);
}
