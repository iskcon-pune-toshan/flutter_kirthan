import 'dart:async';
import 'package:flutter_kirthan/models/eventuser.dart';

abstract class IEventUserRestApi {
//EventUserMapping
  Future<List<EventUser>> getEventTeamUserMappings();

  Future<List<EventUser>> submitNewEventTeamUserMapping(
      List<EventUser> listofeventsermap, var callback);

  Future<List<EventUser>> submitDeleteEventTeamUserMapping(
      List<EventUser> listofeventsermap);
}
