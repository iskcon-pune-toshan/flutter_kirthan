import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:http/http.dart' as _http;
import 'package:flutter_kirthan/services/team_service_interface.dart';

class TeamAPIService extends BaseAPIService  implements ITeamRestApi {

  static final TeamAPIService _internal = TeamAPIService.internal();

  factory TeamAPIService() => _internal;

  TeamAPIService.internal();
  @override
  Future<List<int>> getTeamsCount() async {
    _http.Response response =  await _http.get("$baseUrl/team/count");
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
  Future<bool> submitUpdateTeamRequest(String teamrequestmap) async {
    print(teamrequestmap);
    //String requestBody = json.encode(userrequestmap);
    //print(requestBody);

    var response = await client1.put('$baseUrl/submitupdateteamrequest',
        headers: {"Content-Type": "application/json"}, body: teamrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<TeamRequest> submitNewTeamRequest(
      Map<String, dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    var response = await client1.put('$baseUrl/submitnewteamrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

  Future<bool> deleteTeamRequest(Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await client1.put('$baseUrl/deleteteamrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<TeamRequest>> getTeamRequests(String teamTitle) async {
    String requestBody = '{"approvalStatus":"approved"}';

    //if (teamType == "AE" ) {
    //requestBody = '{"teamType":"All Teams"}';
    //}

    print(requestBody);

    var response = await client1.put('$baseUrl/getteamrequests',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

  Future<bool> processTeamRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await client1.put('$baseUrl/processteamrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  @override
  Future<List<TeamRequest>> getTeamRequestByStatus(String status) async {
      print(status);
      String finalUrl = '$baseUrl/team?status=$status';//needs to adjust this to temple
      print(finalUrl);
      var response = await client1.get(finalUrl);
      if (response.statusCode == 200) {
        List<dynamic> teamrequestsData = json.decode(response.body);
        List<TeamRequest> teamrequests = teamrequestsData
            .map((teamrequestsData) => TeamRequest.fromMap(teamrequestsData))
            .toList();
        print(teamrequests);
        return teamrequests;
      } else {
        throw Exception('Failed to get data');
      }
    }
  }

