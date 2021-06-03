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
    String requestBody = json.encode(listofeventusermap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/eventuser/addeventuser',
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

      return eventusers;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventUser>> getEventTeamUserMappings() async {
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.get(
      '$baseUrl/api/eventuser/geteventusers',
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> eventtsermappingData = json.decode(response.body);
      // print(teamtsermappingData);
      List<EventUser> eventusermappings = eventtsermappingData
          .map(
              (eventtsermappingData) => EventUser.fromMap(eventtsermappingData))
          .toList();

      return eventusermappings;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventUser>> submitDeleteEventTeamUserMapping(
      List<EventUser> listofeventusermap) async {
    String requestBody = json.encode(listofeventusermap);
    print("I am in submitDeleteEventTeamUserMapping");

    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put('$baseUrl/api/eventuser/deleteeventuser',
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
      return eventusers;
    } else {
      throw Exception('Failed to get data');
    }
  }
}