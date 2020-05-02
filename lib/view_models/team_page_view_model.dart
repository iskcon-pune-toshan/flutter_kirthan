import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/team_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/team.dart';

class TeamPageViewModel extends Model {
  Future<List<TeamRequest>> _teamrequests;
  Future<List<TeamRequest>> get teamrequests => _teamrequests;
  final ITeamRestApi apiSvc;

  TeamPageViewModel({@required this.apiSvc});

  set teamrequests(Future<List<TeamRequest>> value) {
    _teamrequests = value;
    notifyListeners();
  }

  Future<bool> setTeamRequests(String teamTitle) async {
    teamrequests = apiSvc?.getTeamRequests(teamTitle);
    return teamrequests != null;
  }
}
