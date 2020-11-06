import 'dart:async';
import 'package:flutter_kirthan/models/temple.dart';

abstract class ITempleRestApi {
  //Sample


  //permissions
  Future<List<Temple>> getTemples(String userType);

  //Future<List<Permissions>> getDummyUserRequests();

  Future<Temple> submitNewTemple(Map<String, dynamic> templemap);

  //Future<bool> processPermissions(Map<String, dynamic> processrequestmap);

  Future<bool> deleteTemple(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateTemple(String Templerequestmap);
}
