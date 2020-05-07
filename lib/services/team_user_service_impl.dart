import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/services/team_user_service_interface.dart';
import 'package:flutter_kirthan/models/user.dart';

class TeamUserAPIService extends BaseAPIService implements ITeamUserRestApi {

  static final TeamUserAPIService _internal = TeamUserAPIService.internal();

  factory TeamUserAPIService() => _internal;

  TeamUserAPIService.internal();

  Future<List<TeamUser>> submitNewTeamUserMapping(
      List<TeamUser> listofteamusermap) async {
    print(listofteamusermap);
    String requestBody = json.encode(listofteamusermap);
    print(requestBody);

    var response = await client1.put('$baseUrl/submitnewteamusermapping',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<TeamUser> teamrequests = teamusermappingData
          .map((teamusermappingData) => TeamUser.fromMap(teamusermappingData))
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

  Future<List<TeamUser>> getTeamUserMappings(String teamMapping) async {
    String requestBody = '{"createdBy":"SYSTEM"}';
    /*String requestBody = '{"eventdate":"sysdate()"}'; //today
    requestBody = '{"eventdate":"sysdate()+1"}'; //tomorrow
    requestBody = '{"eventdate":"sysdate()+7"}'; //week
    requestBody = '{"eventdate":"sysdate()+30"}'; //month
*/
    print(requestBody);

    var response = await client1.put('$baseUrl/getteamusermappings',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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
    print(listofteamusermap);
    String requestBody = json.encode(listofteamusermap);
    print(requestBody);

    var response = await client1.put('$baseUrl/submitdeleteteamusermapping',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<TeamUser> teamusers = teamusermappingData
          .map((teamusermappingData) => TeamUser.fromMap(teamusermappingData))
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
