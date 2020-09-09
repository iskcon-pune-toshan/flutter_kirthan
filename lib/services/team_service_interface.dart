import 'dart:async';
import 'package:flutter_kirthan/models/team.dart';

abstract class ITeamRestApi {
//team
  Future<List<int>> getTeamsCount();

  Future<List<TeamRequest>> getTeamRequestByStatus(String status);
  Future<List<TeamRequest>> getTeamRequests(String teamTitle);

  Future<TeamRequest> submitNewTeamRequest(Map<String, dynamic> teamrequestmap);

  Future<bool> submitUpdateTeamRequest(String teamrequestmap);

  Future<bool> processTeamRequest(Map<String, dynamic> processrequestmap);

  Future<bool> deleteTeamRequest(Map<String, dynamic> processrequestmap);
}
