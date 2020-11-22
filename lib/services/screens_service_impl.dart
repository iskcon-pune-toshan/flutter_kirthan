import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/screens.dart';
import 'package:flutter_kirthan/services/screens_service_interface.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as _http;
class ScreensAPIService extends BaseAPIService implements IScreensRestApi  {

  static final ScreensAPIService _internal = ScreensAPIService.internal();

  factory ScreensAPIService() => _internal;

  ScreensAPIService.internal();



  @override
  Future<List<Screens>> getData(String status) async {
    _http.Response response =  await _http.get("$baseUrl/screens?status=$status");
    List<dynamic> data = json.decode(response.body);
    List<Screens> newData =  data.map((e) => Screens.fromMap(e)).toList();
    return Future.value(newData);
  }

  //processEvents


  //getEvent
  Future<List<Screens>> getScreens(String eventType) async {


    String requestBody = '';

    requestBody = '{"screenName":["Register User","Register User01","Forget password","Login screen","Team","Team-user","Event-User","Notification Hub","Register User"]}';
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

    var response = await client1.put('$baseUrl/api/screen/getscreen',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);
    print(response.statusCode);
    print(requestBody);
    if (response.statusCode == 200) {
      print(response.statusCode);
      List<dynamic> rolesrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<Screens> rolesrequests = rolesrequestsData
          .map((rolesrequestsData) =>Screens.fromMap(rolesrequestsData))
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
  Future<Screens> submitNewScreens(
      Map<String, dynamic> rolesrequestmap) async {
    print(rolesrequestmap);
    String requestBody = json.encode(rolesrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/screen/addscreen',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      //EventRequest respeventrequest = json.decode(response.body);
      //print(respeventrequest);
      //return respeventrequest;

      Map<String, dynamic> rolesData = json.decode(response.body);
      Screens rolesrequests = Screens.fromMap(rolesData);
      print(rolesrequests);
      return rolesrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }
  //deleteEvents
  Future<bool> deleteScreens(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token  = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/screen/deletescreen',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }


  Future<bool> submitUpdateScreens(String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/screen/updatescreen',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: eventrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}

