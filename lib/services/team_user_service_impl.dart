import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/services/team_user_service_interface.dart';
import 'package:flutter_kirthan/models/user.dart';

//getTeamUsers based on Id
class TeamUserAPIService extends BaseAPIService implements ITeamUserRestApi {
  static final TeamUserAPIService _internal = TeamUserAPIService.internal();

  factory TeamUserAPIService() => _internal;

  TeamUserAPIService.internal();

  Future<List<TeamUser>> submitNewTeamUserMapping(
      List<TeamUser> listofteamusermap) async {

    String requestBody = json.encode(listofteamusermap);


    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/teamuser/addteamuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<TeamUser> teamrequests = teamusermappingData
          .map((teamusermappingData) => TeamUser.fromMap(teamusermappingData))
          .toList();
//      TeamUser.fromMap(teamusermappingData);

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

  Future<List<TeamUser>> getTeamUserMappings(String teamMapping) async {
    String requestBody = "";
    int teamid = int.parse(teamMapping);
    requestBody = '{"team_id": $teamid}';
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/teamuser/getteamusers',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> teamtsermappingData = json.decode(response.body);
      // print(teamtsermappingData);
      List<TeamUser> teamusermappings = teamtsermappingData
          .map((teamtsermappingData) => TeamUser.fromMap(teamtsermappingData))
          .toList();
      //print(teamusermappings);
      //print(userdetails);

      return teamusermappings;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<TeamUser>> submitDeleteTeamUserMapping(
      List<TeamUser> listofteamusermap) async {

    String requestBody = json.encode(listofteamusermap);


    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/teamuser/deleteteamuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<TeamUser> teamusers = teamusermappingData
          .map((teamusermappingData) => TeamUser.fromMap(teamusermappingData))
          .toList();
//      TeamUser.fromMap(teamusermappingData);

      return teamusers;

    } else {
      throw Exception('Failed to get data');
    }
  }
}
