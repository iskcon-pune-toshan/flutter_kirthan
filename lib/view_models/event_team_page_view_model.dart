import 'dart:async';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:flutter_kirthan/services/event_team_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class EventTeamPageViewModel extends Model {
  Future<List<EventTeam>> _teamUsers;
  final IEventTeamRestApi apiSvc;
  Map<String,bool> accessTypes;

  EventTeamPageViewModel({@required this.apiSvc});

  Future<List<EventTeam>> get teamUsers => _teamUsers;

  set teamUsers(Future<List<EventTeam>> value) {
    _teamUsers = value;
    notifyListeners();
  }
  Future<bool> setEvenTeamMappings(int eventteamType) async {
    teamUsers = apiSvc?.getEventTeamMappings(eventteamType);
    return teamUsers != null;
  }

  Future<List<EventTeam>> getEventTeamMappings(int teamMapping) {
    Future<List<EventTeam>> teamusers = apiSvc?.getEventTeamMappings(teamMapping);
    return teamusers;
  }

  Future<List<EventTeam>> submitNewEventTeamMapping(
      List<EventTeam> listofteamusermap) {
    Future<List<EventTeam>> teamusers =
    apiSvc?.submitNewEventTeamMapping(listofteamusermap);
    return teamusers;
  }

  Future<List<EventTeam>> submitDeleteEventTeamMapping(
      Map<String, dynamic> listofteamusermap) {
    Future<List<EventTeam>> teamusers =
    apiSvc?.submitDeleteEventTeamMapping(listofteamusermap);
    return teamusers;
  }
}
