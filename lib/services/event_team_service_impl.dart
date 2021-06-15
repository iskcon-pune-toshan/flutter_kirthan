import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/services/team_user_service_interface.dart';
import 'package:flutter_kirthan/models/user.dart';

import 'event_team_service_interface.dart';

class EventTeamAPIService extends BaseAPIService implements IEventTeamRestApi {
  static final EventTeamAPIService _internal = EventTeamAPIService.internal();

  factory EventTeamAPIService() => _internal;

  EventTeamAPIService.internal();

  Future<List<EventTeam>> submitNewEventTeamMapping(
      List<EventTeam> listofteamusermap) async {
    String requestBody = json.encode(listofteamusermap);
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/eventteam/addeventteam',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<EventTeam> teamrequests = teamusermappingData
          .map((teamusermappingData) => EventTeam.fromMap(teamusermappingData))
          .toList();

      return teamrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventTeam>> getEventTeamMappings(int teamMapping) async {
    String requestBody = "";

    requestBody = '{"eventId" : $teamMapping}';

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/eventteam/geteventteams',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      List<dynamic> teamtsermappingData = json.decode(response.body);

      List<EventTeam> teamusermappings = teamtsermappingData
          .map((teamtsermappingData) => EventTeam.fromMap(teamtsermappingData))
          .toList();

      return teamusermappings;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventTeam>> submitDeleteEventTeamMapping(
      Map<String, dynamic> listofteamusermap) async {
    String requestBody = json.encode(listofteamusermap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/eventteam/deleteeventteam',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<EventTeam> teamusers = teamusermappingData
          .map((teamusermappingData) => EventTeam.fromMap(teamusermappingData))
          .toList();

      return teamusers;
    } else {
      throw Exception('Failed to get data');
    }
  }
}
