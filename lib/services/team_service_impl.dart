import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/team_service_interface.dart';
import 'package:flutter_kirthan/views/pages/admin/admin_event_details.dart';

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
    print(requestBody);
    String token = AutheticationAPIService().sessionJWTToken;
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  //getTeam
  Future<List<TeamRequest>> getTeamRequests(String teamTitle) async {
    final FirebaseUser user = await auth.currentUser();
    String LocalAdminName;
    final String email = user.email;
    print(email);
    List<UserRequest> userList = await userPageVM.getUserRequests("Approved");
    for(var i in userList){
      if(i.email==email){
        LocalAdminName = i.fullName;
      }
    }
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
    } else if(teamTitle == "Initiated"){
      requestBody = '{"localAdminName":"$LocalAdminName", "approvalStatus": "approved"}';
    }else if (teamTitle.contains("teamLead")) {
      var array = teamTitle.split(":");
      String teamLeadId = array[1];
      requestBody = '{"teamLeadId":"$teamLeadId"}';
    } else {
      int teamId = int.parse(teamTitle);
      requestBody = '{"id": $teamId }';
    }
    print("In Get team");
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
