import 'dart:async';
import 'package:flutter_kirthan/models/eventuser.dart';

abstract class IEventUserRestApi {
//EventUserMapping
  Future<List<EventUser>> getEventTeamUserMappings();

  Future<List<EventUser>> submitNewEventTeamUserMapping(
      List<EventUser> listofeventsermap);

  Future<List<EventUser>> submitDeleteEventTeamUserMapping(
      List<EventUser> listofeventsermap);
//Future<void> submitUpdateTeamRequest(String teamrequestmap);
//Future<bool> processTeamRequest(Map<String,dynamic> processrequestmap);
}
