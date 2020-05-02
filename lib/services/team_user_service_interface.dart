import 'dart:async';
import 'package:flutter_kirthan/models/teamuser.dart';

abstract class ITeamUserRestApi {
//TeamUserMapping
  Future<List<TeamUser>> getTeamUserMappings(String teamMapping);

  Future<List<TeamUser>> submitNewTeamUserMapping(
      List<TeamUser> listofteamusermap);

  Future<List<TeamUser>> submitDeleteTeamUserMapping(
      List<TeamUser> listofteamusermap);
//Future<void> submitUpdateTeamRequest(String teamrequestmap);
//Future<bool> processTeamRequest(Map<String,dynamic> processrequestmap);
}
