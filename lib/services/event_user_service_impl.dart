import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/services/event_user_service_interface.dart';

class EventUserAPIService extends BaseAPIService implements IEventUserRestApi {
  static final EventUserAPIService _internal = EventUserAPIService.internal();

  factory EventUserAPIService() => _internal;

  EventUserAPIService.internal();

  Future<List<EventUser>> submitNewEventTeamUserMapping(
      List<EventUser> listofeventusermap, var callback) async {
    print(listofeventusermap);
    String requestBody = json.encode(listofeventusermap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put(
        '$baseUrl/api/eventteamuser/addeventteamuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> eventusermappingData = json.decode(response.body);
      List<EventUser> eventusers = eventusermappingData
          .map(
              (eventusermappingData) => EventUser.fromMap(eventusermappingData))
          .toList();
      if (callback != null) callback();
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

  Future<List<EventUser>> getEventTeamUserMappings() async {
    //String requestBody = '{"createdBy":"SYSTEM"}';
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.get(
      '$baseUrl/api/eventteamuser/geteventteamusers',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
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
    print("I am in submitDeleteEventTeamUserMapping");
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put(
        '$baseUrl/api/eventteamuser/deleteeventteamuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
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
