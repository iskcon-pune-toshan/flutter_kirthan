import 'dart:async';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/services/team_user_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class TeamUserPageViewModel extends Model {
  Future<List<TeamUser>> _teamUsers;
  final ITeamUserRestApi apiSvc;
  Map<String,bool> accessTypes;

  TeamUserPageViewModel({@required this.apiSvc});

  Future<List<TeamUser>> get teamUsers => _teamUsers;

  set teamUsers(Future<List<TeamUser>> value) {
    _teamUsers = value;
    notifyListeners();
  }

  Future<List<TeamUser>> getTeamUserMappings(String teamMapping) {
    Future<List<TeamUser>> teamusers = apiSvc?.getTeamUserMappings(teamMapping);
    return teamusers;
  }

  Future<List<TeamUser>> submitNewTeamUserMapping(
      List<TeamUser> listofteamusermap) {
    Future<List<TeamUser>> teamusers =
    apiSvc?.submitNewTeamUserMapping(listofteamusermap);
    return teamusers;
  }

  Future<List<TeamUser>> submitDeleteTeamUserMapping(
      List<TeamUser> listofteamusermap) {
    Future<List<TeamUser>> teamusers =
    apiSvc?.submitDeleteTeamUserMapping(listofteamusermap);
    return teamusers;
  }
}