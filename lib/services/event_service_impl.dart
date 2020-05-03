import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_kirthan/models/event.dart';

import 'package:flutter_kirthan/services/event_service_interface.dart';

class EventAPIService implements IEventRestApi {
  //final _baseUrl = 'http://10.0.2.2:8080';
  final _baseUrl = 'http://192.168.1.8:8080'; //Manju
  //final _baseUrl = 'http://192.168.1.7:8080'; // Janice
  http.Client _client = http.Client();

  set client(http.Client value) => _client = value;

  static final EventAPIService _internal = EventAPIService.internal();

  factory EventAPIService() => _internal;

  EventAPIService.internal();

  Future<bool> processEventRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/processeventrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventRequest>> getEventRequests(String eventType) async {
    print("I am in Service: getEventRequests");

    String requestBody = '';

    if (eventType == "bmg") {
      requestBody = '{"id":"4"}';
    } else {
      requestBody = '{"city":"Pune"}';
    }

    print(requestBody);

    var response = await _client.put('$_baseUrl/geteventrequests',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

  Future<EventRequest> submitNewEventRequest(
      Map<String, dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitneweventrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

  Future<bool> deleteEventRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/deleteeventrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

    var response = await _client.put('$_baseUrl/submitupdateeventrequest',
        headers: {"Content-Type": "application/json"}, body: eventrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
