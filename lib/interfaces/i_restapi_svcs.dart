import 'dart:async';
import 'package:flutter_kirthan/models/permissions.dart';
import 'package:flutter_kirthan/models/roles.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/models/screens.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/models/usertemple.dart';

abstract class IKirthanRestApi {
  //Sample
  Future<List<UserRequest>> getUserRequestsFromJson();

  //user
  Future<List<UserRequest>> getUserRequests(String userType);
  Future<List<UserRequest>> getDummyUserRequests();
  Future<UserRequest> submitNewUserRequest(Map<String,dynamic> userrequestmap);
  Future<bool> processUserRequest(Map<String,dynamic> processrequestmap);
  Future<bool> deleteUserRequest(Map<String,dynamic> processrequestmap);
  Future<void> submitUpdateUserRequest(String userrequestmap);


  //event
  Future<List<EventRequest>> getEventRequests(String userType);
  Future<EventRequest> submitNewEventRequest(Map<String,dynamic> eventrequestmap);
  Future<List<EventRequest>> getDummyEventRequests();
  Future<bool> processEventRequest(Map<String,dynamic> processrequestmap);
  Future<bool> deleteEventRequest(Map<String,dynamic> processrequestmap);
  Future<void> submitUpdateEventRequest(String eventrequestmap);

  //team
  Future<List<TeamRequest>> getTeamRequests(String teamTitle);
  Future<TeamRequest> submitNewTeamRequest(Map<String,dynamic> teamrequestmap);
  Future<void> submitUpdateTeamRequest(String teamrequestmap);
  Future<bool> processTeamRequest(Map<String,dynamic> processrequestmap);
  Future<bool> deleteTeamRequest(Map<String,dynamic> processrequestmap);


  //TeamUserMapping
  Future<List<TeamUser>> getTeamUserMappings(String teamMapping);
  Future<List<TeamUser>> submitNewTeamUserMapping(List<TeamUser> listofteamusermap);
  Future<List<TeamUser>> submitDeleteTeamUserMapping(List<TeamUser> listofteamusermap);
  //Future<void> submitUpdateTeamRequest(String teamrequestmap);
  //Future<bool> processTeamRequest(Map<String,dynamic> processrequestmap);

  //EventUserMapping
  Future<List<EventUser>> getEventTeamUserMappings(String eventMapping);
  Future<List<EventUser>> submitNewEventTeamUserMapping(List<EventUser> listofeventsermap);
  Future<List<EventUser>> submitDeleteEventTeamUserMapping(List<EventUser> listofeventsermap);
//Future<void> submitUpdateTeamRequest(String teamrequestmap);
//Future<bool> processTeamRequest(Map<String,dynamic> processrequestmap);

  //TempleMapping
  Future<List<Temple>> getTempleMappings(String templeMapping);
  Future<List<Temple>> submitNewTempleMapping(List<Temple> listoftemplemap);
  Future<List<Temple>> submitDeleteTempleMapping(List<Temple> listoftemplemap);
//Future<void> submitUpdateTeamRequest(String teamrequestmap);
//Future<bool> processTeamRequest(Map<String,dynamic> processrequestmap);

//RolesMapping
  Future<List<Roles>> getRolesMappings(String rolesMapping);
  Future<List<Roles>> submitNewRolesMapping(List<Roles> listofrolesmap);
  Future<List<Roles>> submitDeleteRolesMapping(List<Roles> listofrolesmap);

  //UserTempleMapping
  Future<List<UserTemple>> getUserTempleMappings(String usertempleMapping);
  Future<List<UserTemple>> submitNewUserTempleMapping(List<UserTemple> listofusertemplemap);
  Future<List<UserTemple>> submitDeleteUserTempleMapping(List<UserTemple> listofusertemplemap);

  //RolesScreenmapping
  Future<List<RoleScreen>> getRoleScreenMappings(String rolescreenMapping);
  Future<List<RoleScreen>> submitNewRoleScreenMapping(List<RoleScreen> listofrolescreenmap);
  Future<List<RoleScreen>> submitDeleteRoleScreenMapping(List<RoleScreen> listofrolescreenmap);

  //Permissions
  Future<List<Permissions>> getPermissionsMappings(String permissionsMapping);
  Future<List<Permissions>> submitNewPermissionsMapping(List<Permissions> listofpermissionsmap);
  Future<List<Permissions>> submitDeletePermissionsMapping(List<Permissions> listofpermissionsmap);
//Future<void> submitUpdateRolesRequest(String rolesrequestmap);


  //Screens
  Future<List<Screens>> getScreensMappings(String screensMapping);
  Future<List<Screens>> submitNewScreensMapping(List<Screens> listofscreensmap);
  Future<List<Screens>> submitDeleteScreensMapping(List<Screens> listofscreensmap);
//Future<void> submitUpdateRolesRequest(String rolesrequestmap);

}