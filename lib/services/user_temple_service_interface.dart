import 'dart:async';
import 'package:flutter_kirthan/models/usertemple.dart';

abstract class IUserTempleRestApi {
  //Sample


  //permissions
  Future<List<UserTemple>> getUserTemples(String userType);

  //Future<List<Permissions>> getDummyUserRequests();

  Future<UserTemple> submitNewUserTemple(Map<String, dynamic> usertemplemap);

  //Future<bool> processPermissions(Map<String, dynamic> processrequestmap);

  Future<bool> deleteUserTemple(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateUserTemple(String UserTemplerequestmap);
}
