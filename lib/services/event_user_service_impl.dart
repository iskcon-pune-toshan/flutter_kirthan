import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/event_user_service_interface.dart';

class EventUserAPIService implements IEventUserRestApi {
  //final _baseUrl = 'http://10.0.2.2:8080';
  final _baseUrl = 'http://192.168.1.8:8080'; //Manju
  //final _baseUrl = 'http://192.168.1.7:8080'; // Janice
  http.Client _client = http.Client();

  set client(http.Client value) => _client = value;

  static final EventUserAPIService _internal = EventUserAPIService.internal();

  factory EventUserAPIService() => _internal;

  EventUserAPIService.internal();

  Future<List<EventUser>> submitNewEventTeamUserMapping(
      List<EventUser> listofeventusermap) async {
    print(listofeventusermap);
    String requestBody = json.encode(listofeventusermap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitneweventteamusermapping',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> eventusermappingData = json.decode(response.body);
      List<EventUser> eventusers = eventusermappingData
          .map(
              (eventusermappingData) => EventUser.fromMap(eventusermappingData))
          .toList();
//      TeamUser.fromMap(teamusermappingData);
      print(eventusers);
      return eventusers;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData
          .map((userrequestsData) => UserRequest.fromMap(userrequestsData))
          .toList();
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventUser>> getEventTeamUserMappings(String eventMapping) async {
    String requestBody = '{"createdBy":"SYSTEM"}';

    print(requestBody);

    var response = await _client.put('$_baseUrl/geteventteamusermappings',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventtsermappingData = json.decode(response.body);
      // print(teamtsermappingData);
      List<EventUser> eventusermappings = eventtsermappingData
          .map(
              (eventtsermappingData) => EventUser.fromMap(eventtsermappingData))
          .toList();
      //print(teamusermappings);
      //print(userdetails);

      return eventusermappings;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventUser>> submitDeleteEventTeamUserMapping(
      List<EventUser> listofeventusermap) async {
    print(listofeventusermap);
    String requestBody = json.encode(listofeventusermap);
    print(requestBody);

    var response = await _client.put(
        '$_baseUrl/submitdeleteeventteamusermapping',
        headers: {"Content-Type": "application/json"},
        body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> eventusermappingData = json.decode(response.body);
      List<EventUser> eventusers = eventusermappingData
          .map(
              (eventusermappingData) => EventUser.fromMap(eventusermappingData))
          .toList();
//      TeamUser.fromMap(teamusermappingData);
      print(eventusers);
      return eventusers;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData
          .map((userrequestsData) => UserRequest.fromMap(userrequestsData))
          .toList();
    } else {
      throw Exception('Failed to get data');
    }
  }
}
