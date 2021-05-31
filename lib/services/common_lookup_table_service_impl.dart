import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as _http;

import 'common_lookup_table_service_interface.dart';

class CommonLookupTableAPIService extends BaseAPIService
    implements ICommonLookupTableRestApi {
  static final CommonLookupTableAPIService _internal =
      CommonLookupTableAPIService.internal();

  factory CommonLookupTableAPIService() => _internal;

  CommonLookupTableAPIService.internal();

  //processEvents

  //getEvent
  Future<List<CommonLookupTable>> getCommonLookupTable(String eventType) async {
    String requestBody = '';
    if (eventType.compareTo("lookupType") >= 0) {
      var array = eventType.split(":");
      String lookupType = array[1];
      requestBody = '{"lookupType" : "$lookupType"}';
    } else if (eventType.compareTo("description") >= 0) {
      var array = eventType.split(":");
      String category = array[1];
      requestBody = '{"description" : "$category"}';
    }

    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put('$baseUrl/api/commonlookuptable/getclt',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      print(response.statusCode);
      List<dynamic> rolesrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<CommonLookupTable> rolesrequests = rolesrequestsData
          .map((rolesrequestsData) =>
              CommonLookupTable.fromMap(rolesrequestsData))
          .toList();
      return rolesrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //addevent
  Future<CommonLookupTable> submitNewCommonLookupTable(
      Map<String, dynamic> rolesrequestmap) async {
    String requestBody = json.encode(rolesrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/commonlookuptable/addclt',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map<String, dynamic> rolesData = json.decode(response.body);
      CommonLookupTable rolesrequests = CommonLookupTable.fromMap(rolesData);
      return rolesrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //deleteEvents
  Future<bool> deleteCommonLookupTable(
      Map<String, dynamic> processrequestmap) async {
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/commonlookuptable/deleteclt',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> submitUpdateCommonLookupTable(String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/commonlookuptable/updateclt',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: eventrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
