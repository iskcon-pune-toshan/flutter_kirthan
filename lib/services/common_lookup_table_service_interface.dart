import 'dart:async';
import 'package:flutter_kirthan/models/commonlookuptable.dart';

abstract class ICommonLookupTableRestApi {
  //Sample

  //permissions
  Future<List<CommonLookupTable>> getCommonLookupTable(String userType);

  //Future<List<Permissions>> getDummyUserRequests();

  Future<CommonLookupTable> submitNewCommonLookupTable(
      Map<String, dynamic> rolesmap);

  //Future<bool> processPermissions(Map<String, dynamic> processrequestmap);

  Future<bool> deleteCommonLookupTable(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateCommonLookupTable(String rolesrequestmap);
}
