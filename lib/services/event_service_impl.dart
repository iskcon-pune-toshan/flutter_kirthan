import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_interface.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as _http;
class EventAPIService extends BaseAPIService implements IEventRestApi  {

  static final EventAPIService _internal = EventAPIService.internal();

  factory EventAPIService() => _internal;

  EventAPIService.internal();

  @override
  Future<List<int>> getEventCount() async {
    _http.Response response =  await _http.get("$baseUrl/event/count");
    if(response.statusCode == 200 ) {
      List<dynamic> data = json.decode(response.body);
      List<int> resultData = [];
      for (int i = 0; i < 3; i++)
        resultData.add((data[i]));
      return (resultData);
    }
    else{
      print("Error fetching data");
      return [0,0,0];
    }
  }

  @override
  Future<List<EventRequest>> getData(String status) async {
    _http.Response response =  await _http.get("$baseUrl/event?status=$status");
    List<dynamic> data = json.decode(response.body);
    List<EventRequest> newData =  data.map((e) => EventRequest.fromMap(e)).toList();
    return Future.value(newData);
  }

  //processEvents
  Future<bool> processEventRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/processevent',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //getEvent
  Future<List<EventRequest>> getEventRequests(String eventType) async {
    print("I am in Service: getEventRequests");

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
    requestBody = '{"city":["Pune","Mumbai"]}';



    if (eventType == ["bmg"]) {
      requestBody = '{"id":"4"}';
    } else {
      requestBody = '{"state":["MH"]}';
    }

    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    print("entered getEvents");
    var response = await client1.put('$baseUrl/api/event/getevents',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<EventRequest> eventrequests = eventrequestsData
          .map((eventrequestsData) => EventRequest.fromMap(eventrequestsData))
          .toList();

      //print(userdetails);

      return eventrequests;
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
  Future<EventRequest> submitNewEventRequest(
      Map<String, dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl//api/eventaddevent',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      //EventRequest respeventrequest = json.decode(response.body);
      //print(respeventrequest);
      //return respeventrequest;

      Map<String, dynamic> eventrequestsData = json.decode(response.body);
      EventRequest eventrequests = EventRequest.fromMap(eventrequestsData);
      print(eventrequests);
      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }
  //deleteEvents
  Future<bool> deleteEventRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token  = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/deleteevent',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventRequest>> getDummyEventRequests() async {
    List<EventRequest> eventrequests;
    return eventrequests;
  }

  Future<bool> submitUpdateEventRequest(String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/updateevent',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: eventrequestmap);

    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}

