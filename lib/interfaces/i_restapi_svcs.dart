import 'dart:async';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/eventuser.dart';

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

}