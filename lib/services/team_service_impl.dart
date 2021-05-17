import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:http/http.dart' as _http;
import 'package:flutter_kirthan/services/team_service_interface.dart';

//getTeams based on Id
class TeamAPIService extends BaseAPIService implements ITeamRestApi {
  static final TeamAPIService _internal = TeamAPIService.internal();

  factory TeamAPIService() => _internal;

  TeamAPIService.internal();
  @override
  Future<List<int>> getTeamsCount() async {
    List<TeamRequest> approved = await getTeamRequests("Approved");
    List<TeamRequest> rejected = await getTeamRequests("Rejected");
    List<TeamRequest> waiting = await getTeamRequests("Waiting");
    List<int> resultData = [];
    resultData.add(approved.length);
    resultData.add(rejected.length);
    resultData.add(waiting.length);
    return (resultData);
  }

  //updateTeam
  Future<bool> submitUpdateTeamRequest(String teamrequestmap) async {
    print(teamrequestmap);
    //String requestBody = json.encode(userrequestmap);
    //print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/team/updateteam',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: teamrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }

  //addTeam

  Future<TeamRequest> submitNewTeamRequest(
      Map<String, dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    //String teamRequest = json.encode(eventrequestmap);
    //String teamUserRequest = json.encode(listofteamusermap);
    // final Map<String, String> requestBody = new Map<String, String>();
    // requestBody["teamData"] = teamRequest;
    //requestBody["teamUserData"] = teamUserRequest;
    // var requestParams = {
    // "teamData" : teamRequest,
    // "teamUserData" = teamUserRequest,
    // };
    // String queryString = Uri(queryParameters: requestBody).query;
    //var endpointUrl = '$baseUrl/api/team/addteam';
    // var requestUrl = endpointUrl + '?' + queryString;
    print(requestBody);
    String token = AutheticationAPIService().sessionJWTToken;

    //  var uri = Uri.https('192.168.0.108:8080', '/api/team/addteam', requestBody);
    //var uri =
    //Uri.https('http://localhost:8080', '/api/team/addteam', requestBody);
    // var response = await client1.put(
    //   uri,
    //   headers: {
    //     "Content-Type": "application/json",
    //     "Authorization": "Bearer $token"
    //   },
    // );
    var response = await client1.put('$baseUrl/api/team/addteam',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    print("Team add status");
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      //team respteamrequest = json.decode(response.body);
      //print(respteamrequest);
      //return respteamrequest;

      Map<String, dynamic> teamrequestsData = json.decode(response.body);
      TeamRequest teamrequests = TeamRequest.fromMap(teamrequestsData);
      print(teamrequests);
      return teamrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //deleteTeam
  Future<bool> deleteTeamRequest(Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/team/deleteteam',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //getTeam
  Future<List<TeamRequest>> getTeamRequests(String teamTitle) async {
    String requestBody = '';

    if (teamTitle == "Approved") {
      requestBody = '{"approvalStatus":"approved"}';
    } else if (teamTitle == "Rejected") {
      requestBody = '{"approvalStatus":"rejected"}';
    } else if (teamTitle == "Waiting") {
      requestBody = '{"approvalStatus":"Waiting"}';
    } else if (teamTitle.contains("localAdmin")) {
      var array = teamTitle.split(":");
      String localAdminName = array[1];
      requestBody = '{"localAdminName":"$localAdminName"}';
    } else if (teamTitle.contains("teamLead")) {
      var array = teamTitle.split(":");
      String teamLeadId = array[1];
      requestBody = '{"teamLeadId":"$teamLeadId"}';
    } else {
      int teamId = int.parse(teamTitle);
      requestBody = '{"id": $teamId }';
    }
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/team/getteam',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> teamrequestsData = json.decode(response.body);
      print(teamrequestsData);
      List<TeamRequest> teamrequests = teamrequestsData
          .map((teamrequestsData) => TeamRequest.fromMap(teamrequestsData))
          .toList();
      print(teamrequests);
      //print(userdetails);

      return teamrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //processteam
  Future<bool> processTeamRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/team/processteam',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  @override
  Future<List<TeamRequest>> getTeamRequestByStatus(String status) async {
    return await getTeamRequests("$status");
  }
}
