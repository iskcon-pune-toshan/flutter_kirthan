import 'dart:async';
import 'package:flutter_kirthan/models/eventteam.dart';

abstract class IEventTeamRestApi {
//TeamUserMapping
  Future<List<EventTeam>> getEventTeamMappings(int EventTeamMapping);

  Future<List<EventTeam>> submitNewEventTeamMapping(
      List<EventTeam> listofEventTeamrmap);

  Future<List<EventTeam>> submitDeleteEventTeamMapping(
      Map<String, dynamic> processrequestmap);
}
