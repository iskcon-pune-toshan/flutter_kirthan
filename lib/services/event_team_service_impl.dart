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
    print(listofteamusermap);
    String requestBody = json.encode(listofteamusermap);
    print(requestBody);

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
//      TeamUser.fromMap(teamusermappingData);
      print(teamrequests);
      return teamrequests;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData
          .map((userrequestsData) => UserRequest.fromMap(userrequestsData))
          .toList();
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventTeam>> getEventTeamMappings(int teamMapping) async {
    //String requestBody = '{"createdBy":"SYSTEM"}';
    /*String requestBody = '{"eventdate":"sysdate()"}'; //today
    requestBody = '{"eventdate":"sysdate()+1"}'; //tomorrow
    requestBody = '{"eventdate":"sysdate()+7"}'; //week
    requestBody = '{"eventdate":"sysdate()+30"}'; //month
*/
    //print(requestBody);
//print(teamMapping);
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
      //print(response.body);
      List<dynamic> teamtsermappingData = json.decode(response.body);
      //print(teamtsermappingData);
      List<EventTeam> teamusermappings = teamtsermappingData
          .map((teamtsermappingData) => EventTeam.fromMap(teamtsermappingData))
          .toList();
      //print(teamusermappings);
      //print(userdetails);

      return teamusermappings;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventTeam>> submitDeleteEventTeamMapping(
      Map<String, dynamic> listofteamusermap) async {
    print(listofteamusermap);
    String requestBody = json.encode(listofteamusermap);
    print(requestBody);

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
//      TeamUser.fromMap(teamusermappingData);
      print(teamusers);
      return teamusers;

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
