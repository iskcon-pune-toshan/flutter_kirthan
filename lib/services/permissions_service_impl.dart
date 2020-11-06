/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/permissions.dart';
import 'package:flutter_kirthan/services/permissions_service_interface.dart';

class PermissionsAPIService extends BaseAPIService implements IPermissionsRestApi  {

  static final PermissionsAPIService _internal = PermissionsAPIService.internal();

  factory PermissionsAPIService() => _internal;
  String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMzU5MzYyOSwiaWF0IjoxNjAzNTU3NjI5fQ.LX6aUpXG28wdWC3vfVuAW9TOv0VxqAiySYuCDYVhklU";
  PermissionsAPIService.internal();

  Future<List<Permissions>> getPermissions(String eventType) async {


    String requestBody = '';


    //String token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/permissions/getpermissions',headers:{'Content-Type': 'application/json','Authorization':'Bearer $token'},
        body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> permissionsrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<Permissions> permissionsrequests = permissionsrequestsData
          .map((permissionsrequestsData) => Permissions.fromMap(permissionsrequestsData))
          .toList();


      return permissionsrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

*/
/*  Future<EventRequest> submitNewEventRequest(EventRequest pEventrequest) async {
    String requestBody = ''; Future<List<EventRequest>> getEventRequestsFromJson() async {
    var userDetailsJson = await rootBundle.loadString(eventdetailsJsonPath);
    List<dynamic> eventdetailsData = json.decode(eventDetailsJson) as List;
    List<UserRequest> eventdetails = eventdetailsData.map((eventdetailsData) => EventRequest.fromMap(eventdetailsData)).toList();

    return eventdetails;
  }

    var response = await _client.put('$_baseUrl/submitneweventrequest', headers: {"Content-Type": "application/json"}, body: requestBody);
    if (response.statusCode == 200) {
      EventRequest eventrequestsData = json.decode(response.body);
      print(eventrequestsData);
    }
  }
*//*


  Future<Permissions> submitNewPermissions(
      Map<String, dynamic> permissionsrequestmap) async {
    print(permissionsrequestmap);
    String requestBody = json.encode(permissionsrequestmap);
    print(requestBody);

    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/permissions/addpermissions',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);
    if (response.statusCode == 200) {


      Map<String, dynamic> permissionsrequestsData = json.decode(response.body);
      Permissions permissionsrequests = Permissions.fromMap(permissionsrequestsData);
      print(permissionsrequests);
      return permissionsrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> deletePermissions(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    // String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/permissions/deletpermissions',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

@override
  Future<bool> submitUpdatePermissions(String eventrequestmap) async {


    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/permissions/updatepermissions',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: eventrequestmap);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }





}
*/
