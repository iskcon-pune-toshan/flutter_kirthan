import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/roles.dart';
import 'package:flutter_kirthan/services/roles_service_interface.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as _http;
class RolesAPIService extends BaseAPIService implements IRolesRestApi  {

  static final RolesAPIService _internal = RolesAPIService.internal();

  factory RolesAPIService() => _internal;

  RolesAPIService.internal();



  @override
  Future<List<Roles>> getData(String status) async {
    _http.Response response =  await _http.get("$baseUrl/roles?status=$status");
    List<dynamic> data = json.decode(response.body);
    List<Roles> newData =  data.map((e) => Roles.fromMap(e)).toList();
    return Future.value(newData);
  }

  //processEvents


  //getEvent
  Future<List<Roles>> getRoles(String eventType) async {


    String requestBody = '';

    // All Events [Select * from event_request]
    // One Single events [Select * from event_request where id=?]
    // Events on datewise [Today/Tomorrow/This week/This month]
    // Events at City wise [City='Pune']
    // Events at Statewise [State='MH']
    // Events isprocessed = 0 or 1
    // Events on event Type = Free or Premium
    // Events public or private

    // Events on duration


    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put('$baseUrl/api/roles/getroles',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> rolesrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<Roles> rolesrequests = rolesrequestsData
          .map((rolesrequestsData) =>Roles.fromMap(rolesrequestsData))
          .toList();

      print(rolesrequestsData);

      return rolesrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

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
*/

  //addevent
  Future<Roles> submitNewRoles(
      Map<String, dynamic> rolesrequestmap) async {
    print(rolesrequestmap);
    String requestBody = json.encode(rolesrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/roles/addroles',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      //EventRequest respeventrequest = json.decode(response.body);
      //print(respeventrequest);
      //return respeventrequest;

      Map<String, dynamic> rolesData = json.decode(response.body);
     Roles rolesrequests = Roles.fromMap(rolesData);
      print(rolesrequests);
      return rolesrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }
  //deleteEvents
  Future<bool> deleteRoles(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token  = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/roles/deleteroles',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }


  Future<bool> submitUpdateRoles(String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/roles/updateroles',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: eventrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
