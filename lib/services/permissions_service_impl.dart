// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter_kirthan/services/authenticate_service.dart';
// import 'package:flutter_kirthan/services/base_service.dart';
// import 'package:flutter_kirthan/models/permissions.dart';
// import 'package:flutter_kirthan/services/permissions_service_interface.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:http/http.dart' as _http;
// class PermissionsAPIService extends BaseAPIService implements IPermissionsRestApi  {
//
//   static final PermissionsAPIService _internal = PermissionsAPIService.internal();
//
//   factory PermissionsAPIService() => _internal;
//
//   PermissionsAPIService.internal();
//
//
//
//   @override
//   Future<List<Permissions>> getData(String status) async {
//     _http.Response response =  await _http.get("$baseUrl/permissions?status=$status");
//     List<dynamic> data = json.decode(response.body);
//     List<Permissions> newData =  data.map((e) => Permissions.fromMap(e)).toList();
//     return Future.value(newData);
//   }
//
//   //processEvents
//
//
//   //getEvent
//   Future<List<Permissions>> getPermissions(String eventType) async {
//
//
//     String requestBody = '';
//     requestBody = '{"name":["Create","Update","Edit","Delete","Process","View","Create001"]}';
//     // All Events [Select * from event_request]
//     // One Single events [Select * from event_request where id=?]
//     // Events on datewise [Today/Tomorrow/This week/This month]
//     // Events at City wise [City='Pune']
//     // Events at Statewise [State='MH']
//     // Events isprocessed = 0 or 1
//     // Events on event Type = Free or Premium
//     // Events public or private
//
//     // Events on duration
//
//
//     String token = AutheticationAPIService().sessionJWTToken;
//
//     var response = await client1.put('$baseUrl/api/permissions/getpermissions',
//         headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);
//     print(response.statusCode);
//     print(requestBody);
//     if (response.statusCode == 200) {
//       print(response.statusCode);
//       List<dynamic> permissionsrequestsData = json.decode(response.body);
//       //print(userdetailsData);
//       List<Permissions> permissionsrequests = permissionsrequestsData
//           .map((rolesrequestsData) =>Permissions.fromMap(rolesrequestsData))
//           .toList();
//
//       print(permissionsrequestsData);
//
//       return permissionsrequests;
//     } else {
//       throw Exception('Failed to get data');
//     }
//   }
//
// /*  Future<EventRequest> submitNewEventRequest(EventRequest pEventrequest) async {
//     String requestBody = ''; Future<List<EventRequest>> getEventRequestsFromJson() async {
//     var userDetailsJson = await rootBundle.loadString(eventdetailsJsonPath);
//     List<dynamic> eventdetailsData = json.decode(eventDetailsJson) as List;
//     List<UserRequest> eventdetails = eventdetailsData.map((eventdetailsData) => EventRequest.fromMap(eventdetailsData)).toList();
//
//     return eventdetails;
//   }
//
//     var response = await _client.put('$_baseUrl/submitneweventrequest', headers: {"Content-Type": "application/json"}, body: requestBody);
//     if (response.statusCode == 200) {
//       EventRequest eventrequestsData = json.decode(response.body);
//       print(eventrequestsData);
//     }
//   }
// */
//
//   //addevent
//   Future<Permissions> submitNewPermissions(
//       Map<String, dynamic> permissionsrequestmap) async {
//     print(permissionsrequestmap);
//     String requestBody = json.encode(permissionsrequestmap);
//     print(requestBody);
//
//     String token = AutheticationAPIService().sessionJWTToken;
//     var response = await client1.put('$baseUrl/api/permissions/addpermissions',
//         headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);
//
//     if (response.statusCode == 200) {
//       //EventRequest respeventrequest = json.decode(response.body);
//       //print(respeventrequest);
//       //return respeventrequest;
//
//       Map<String, dynamic> permissionsData = json.decode(response.body);
//       Permissions permissionsrequests = Permissions.fromMap(permissionsData);
//       print(permissionsrequests);
//       return permissionsrequests;
//     } else {
//       throw Exception('Failed to get data');
//     }
//   }
//   //deleteEvents
//   Future<bool> deletePermissions(
//       Map<String, dynamic> processrequestmap) async {
//     print(processrequestmap);
//     String requestBody = json.encode(processrequestmap);
//     print(requestBody);
//
//     String token  = AutheticationAPIService().sessionJWTToken;
//     var response = await client1.put('$baseUrl/api/permissions/deletepermissions',
//         headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);
//
//     if (response.statusCode == 200) {
//       print(response.body);
//
//       return true;
//     } else {
//       throw Exception('Failed to get data');
//     }
//   }
//
//
//   Future<bool> submitUpdatePermissions(String eventrequestmap) async {
//     print(eventrequestmap);
//
//     String token = AutheticationAPIService().sessionJWTToken;
//     var response = await client1.put('$baseUrl/api/permissions/updatepermissions',
//         headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: eventrequestmap);
//
//     if (response.statusCode == 200) {
//       print(response.body);
//     } else {
//       throw Exception('Failed to get data');
//     }
//   }
// }
//
