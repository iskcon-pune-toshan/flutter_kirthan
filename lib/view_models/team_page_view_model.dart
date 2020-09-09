import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/team_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/team.dart';

class TeamPageViewModel extends Model {
  Future<List<TeamRequest>> _teamrequests;
  Future<List<TeamRequest>> get teamrequests => _teamrequests;
  final ITeamRestApi apiSvc;

  Map<String,bool> accessTypes;

  TeamPageViewModel({@required this.apiSvc});

  set teamrequests(Future<List<TeamRequest>> value) {
    _teamrequests = value;
    notifyListeners();
  }
  Future<List<int>> getTeamsCount() async {
    List<int> result = await  apiSvc?.getTeamsCount();
    return result;
  }
  Future<List<TeamRequest>> getTeamForApproval(String status){
    Future<List<TeamRequest>> teamsreqs = apiSvc?.getTeamRequestByStatus(status);
    return teamsreqs;
  }
  Future<bool> setTeamRequests(String teamTitle) async {
    teamrequests = apiSvc?.getTeamRequests(teamTitle);
    return teamrequests != null;
  }

  Future<List<TeamRequest>> getTeamRequests(String teamTitle) {
    Future<List<TeamRequest>> teamreqs = apiSvc?.getTeamRequests(teamTitle);
    return teamreqs;
  }

  Future<TeamRequest> submitNewTeamRequest(Map<String, dynamic> teamrequestmap) {
    Future<TeamRequest> teamrequest = apiSvc?.submitNewTeamRequest(teamrequestmap);
    return teamrequest;
  }

  Future<bool> submitUpdateTeamRequest(String teamrequestmap) {
    Future<bool>  updateflag = apiSvc?.submitUpdateTeamRequest(teamrequestmap);
    return updateflag;
  }

  Future<bool> processTeamRequest(Map<String, dynamic> processrequestmap) {
    Future<bool>  processflag = apiSvc?.processTeamRequest(processrequestmap);
    return processflag;

  }

  Future<bool> deleteTeamRequest(Map<String, dynamic> processrequestmap) {
    Future<bool>  deleteflag = apiSvc?.deleteTeamRequest(processrequestmap);
    return deleteflag;
  }
}
