import 'dart:async';
import 'package:flutter_kirthan/models/roles.dart';

abstract class IRolesRestApi {
  //Sample

  //permissions
  Future<List<Roles>> getRoles(String userType);

  Future<Roles> submitNewRoles(Map<String, dynamic> rolesmap);

  Future<bool> deleteRoles(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateRoles(String rolesrequestmap);
}
