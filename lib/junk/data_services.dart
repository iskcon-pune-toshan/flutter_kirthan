import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/models/roles.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/team.dart';

import 'package:flutter_kirthan/interfaces/i_restapi_svcs.dart';

class MyRestAPIServices implements IKirthanRestApi {
  //final _baseUrl = 'http://10.0.2.2:8080';
  final _baseUrl = 'http://192.168.1.8:8080'; //Manju
  //final _baseUrl = 'http://192.168.1.7:8080'; // Janice
  http.Client _client = http.Client();

  set client(http.Client value) => _client = value;

  static final MyRestAPIServices _internal = MyRestAPIServices.internal();
  factory MyRestAPIServices() => _internal;
  MyRestAPIServices.internal();


  //user
  Future<List<UserRequest>> getUserRequests(String userType) async {
    String requestBody = '{"locality":"Warje"}';
    //adding a test comment
    if (userType == "SA" ) {
      requestBody = '{"userType":"SuperAdmin"}';
    }

    else if (userType == "A" ) {
      requestBody = '{"userType":"Admin"}';
    }

    else if (userType == "U" ) {
      requestBody = '{"userType":"Users"}';
    }

    print(requestBody);

    var response = await _client.put('$_baseUrl/getuserrequests', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();

      //print(userdetails);

      return userrequests;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<UserRequest> submitNewUserRequest(Map<String,dynamic> userrequestmap) async {
    print(userrequestmap);
    String requestBody = json.encode(userrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitnewuserrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //UserRequest respuserrequest = json.decode(response.body);
      //print(respuserrequest);
      //return respuserrequest;
      Map<String, dynamic> userrequestsData = json.decode(response.body);
      UserRequest userrequests = UserRequest.fromMap(userrequestsData);
      print(userrequests);
      return userrequests;

    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<bool> processUserRequest(Map<String,dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/processuserrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);
      return true;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> deleteUserRequest(Map<String,dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/deleteuserrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> processEventRequest(Map<String,dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/processeventrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<UserRequest>> getDummyUserRequests() async {
    var response = await _client.get('$_baseUrl/getdummyuserrequest', headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> userdetailsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userdetails = userdetailsData.map((userdetailsData) => UserRequest.fromMap(userdetailsData)).toList();

      return userdetails;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<UserRequest>> getUserRequestsFromJson() async {
    var userDetailsJson = await rootBundle.loadString(userdetailsJsonPath);
    List<dynamic> userdetailsData = json.decode(userDetailsJson) as List;
    List<UserRequest> userdetails = userdetailsData.map((userdetailsData) => UserRequest.fromMap(userdetailsData)).toList();

    return userdetails;
  }


  Future<List<EventRequest>> getEventRequests(String eventType) async {
    print("I am in Service: getEventRequests");

    String requestBody = '';

    if(eventType == "bmg") {
      requestBody = '{"id":"4"}';
    }
    else {
      requestBody = '{"city":"Pune"}';
    }

    print(requestBody);

    var response = await _client.put('$_baseUrl/geteventrequests', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<EventRequest> eventrequests = eventrequestsData.map((eventrequestsData) => EventRequest.fromMap(eventrequestsData)).toList();

      //print(userdetails);

      return eventrequests;

    } else {
      throw Exception('Failed to get data');
    }
  }

/*  Future<EventRequest> submitNewEventRequest(EventRequest pEventrequest) async {
    String requestBody = ''; Future<List<EventRequest>> getEventRequestsFromJson() async {
    var userDetailsJson = await rootBundle.loadString(eventdetailsJsonPath);
    List<dynamic> eventdetailsData = json.decode(eventDetailsJson) as List;
    List<UserRequest> eventdetails = eventdetailsData.map((eventdetailsData) => EventRequest.fromMap(eventdetailsData)).toList();

    return eventdetails;
  }

    var response = await _client.put('$_baseUrl/submitneweventrequest', headers: {"Content-Type": "application/json"}, body: requestBody);
    if (response.statusCode == 200) {
      EventRequest eventrequestsData = json.decode(response.body);
      print(eventrequestsData);
    }
  }
*/

  Future<EventRequest> submitNewEventRequest(Map<String,dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitneweventrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //EventRequest respeventrequest = json.decode(response.body);
      //print(respeventrequest);
      //return respeventrequest;

      Map<String, dynamic> eventrequestsData = json.decode(response.body);
      EventRequest eventrequests = EventRequest.fromMap(eventrequestsData);
      print(eventrequests);
      return eventrequests;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> deleteEventRequest(Map<String,dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/deleteeventrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;

    } else {
      throw Exception('Failed to get data');
    }
  }



  Future<List<EventRequest>> getDummyEventRequests() async {

    List<EventRequest> eventrequests;
    return eventrequests;
  }

  Future<void> submitUpdateUserRequest(String userrequestmap) async {
    print(userrequestmap);
    //String requestBody = json.encode(userrequestmap);
    //print(requestBody);

    var response = await _client.put('$_baseUrl/submitupdateuserrequest', headers: {"Content-Type": "application/json"}, body: userrequestmap);

    if (response.statusCode == 200) {

      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<void> submitUpdateEventRequest(String eventrequestmap) async {
    print(eventrequestmap);

    var response = await _client.put('$_baseUrl/submitupdateeventrequest', headers: {"Content-Type": "application/json"}, body: eventrequestmap);

    if (response.statusCode == 200) {

      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<void> submitUpdateTeamRequest(String teamrequestmap) async {
    print(teamrequestmap);
    //String requestBody = json.encode(userrequestmap);
    //print(requestBody);

    var response = await _client.put('$_baseUrl/submitupdateteamrequest', headers: {"Content-Type": "application/json"}, body: teamrequestmap);

    if (response.statusCode == 200) {

      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }


  Future<TeamRequest> submitNewTeamRequest(Map<String,dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitnewteamrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //team respteamrequest = json.decode(response.body);
      //print(respteamrequest);
      //return respteamrequest;

      Map<String, dynamic> teamrequestsData = json.decode(response.body);
      TeamRequest teamrequests = TeamRequest.fromMap(teamrequestsData);
      print(teamrequests);
      return teamrequests;

    } else {
      throw Exception('Failed to get data');
    }
  }


  Future<bool> deleteTeamRequest(Map<String,dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/deleteteamrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<TeamRequest>> getTeamRequests(String teamTitle) async {
    String requestBody = '{"approvalStatus":"approved"}';

    //if (teamType == "AE" ) {
    //requestBody = '{"teamType":"All Teams"}';
    //}



    print(requestBody);

    var response = await _client.put('$_baseUrl/getteamrequests', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> teamrequestsData = json.decode(response.body);
      print(teamrequestsData);
      List<TeamRequest> teamrequests = teamrequestsData.map((teamrequestsData) => TeamRequest.fromMap(teamrequestsData)).toList();
      print(teamrequests);
      //print(userdetails);

      return teamrequests;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> processTeamRequest(Map<String,dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/processteamrequest', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;

    } else {
      throw Exception('Failed to get data');
    }


  }

  Future<List<TeamUser>> submitNewTeamUserMapping(List<TeamUser> listofteamusermap) async {
    print(listofteamusermap);
    String requestBody = json.encode(listofteamusermap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitnewteamusermapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<TeamUser> teamrequests = teamusermappingData.map((teamusermappingData) =>  TeamUser.fromMap(teamusermappingData)).toList();
//      TeamUser.fromMap(teamusermappingData);
      print(teamrequests);
      return teamrequests;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<TeamUser>> getTeamUserMappings(String teamMapping) async {
    String requestBody = '{"createdBy":"SYSTEM"}';
    /*String requestBody = '{"eventdate":"sysdate()"}'; //today
    requestBody = '{"eventdate":"sysdate()+1"}'; //tomorrow
    requestBody = '{"eventdate":"sysdate()+7"}'; //week
    requestBody = '{"eventdate":"sysdate()+30"}'; //month
*/
    print(requestBody);

    var response = await _client.put('$_baseUrl/getteamusermappings', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> teamtsermappingData = json.decode(response.body);
     // print(teamtsermappingData);
      List<TeamUser> teamusermappings = teamtsermappingData.map((teamtsermappingData) => TeamUser.fromMap(teamtsermappingData)).toList();
      //print(teamusermappings);
      //print(userdetails);

      return teamusermappings;

    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<TeamUser>> submitDeleteTeamUserMapping(List<TeamUser> listofteamusermap) async {
    print(listofteamusermap);
    String requestBody = json.encode(listofteamusermap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitdeleteteamusermapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> teamusermappingData = json.decode(response.body);
      List<TeamUser> teamusers = teamusermappingData.map((teamusermappingData) =>  TeamUser.fromMap(teamusermappingData)).toList();
//      TeamUser.fromMap(teamusermappingData);
      print(teamusers);
      return teamusers;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventUser>> submitNewEventTeamUserMapping(List<EventUser> listofeventusermap) async {
    print(listofeventusermap);
    String requestBody = json.encode(listofeventusermap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitneweventteamusermapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> eventusermappingData = json.decode(response.body);
      List<EventUser> eventusers = eventusermappingData.map((eventusermappingData) =>  EventUser.fromMap(eventusermappingData)).toList();
//      TeamUser.fromMap(teamusermappingData);
      print(eventusers);
      return eventusers;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventUser>> getEventTeamUserMappings(String eventMapping) async {
    String requestBody = '{"createdBy":"SYSTEM"}';

    print(requestBody);

    var response = await _client.put('$_baseUrl/geteventteamusermappings', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventtsermappingData = json.decode(response.body);
      // print(teamtsermappingData);
      List<EventUser> eventusermappings = eventtsermappingData.map((eventtsermappingData) => EventUser.fromMap(eventtsermappingData)).toList();
      //print(teamusermappings);
      //print(userdetails);

      return eventusermappings;

    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<EventUser>> submitDeleteEventTeamUserMapping(List<EventUser> listofeventusermap) async {
    print(listofeventusermap);
    String requestBody = json.encode(listofeventusermap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitdeleteeventteamusermapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> eventusermappingData = json.decode(response.body);
      List<EventUser> eventusers = eventusermappingData.map((eventusermappingData) =>  EventUser.fromMap(eventusermappingData)).toList();
//      TeamUser.fromMap(teamusermappingData);
      print(eventusers);
      return eventusers;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<Temple>> submitDeleteTempleMapping(List<Temple> listoftemplemap) async {
    print(listoftemplemap);
    String requestBody = json.encode(listoftemplemap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitdeletetemplemapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> eventusermappingData = json.decode(response.body);
      List<Temple> eventusers = eventusermappingData.map((eventusermappingData) =>  Temple.fromMap(eventusermappingData)).toList();
//      TeamUser.fromMap(teamusermappingData);
      print(eventusers);
      return eventusers;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<Temple>> submitNewTempleMapping(List<Temple> listoftemplemap) async {
    print(listoftemplemap);
    String requestBody = json.encode(listoftemplemap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitnewtemplemapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> templemappingData = json.decode(response.body);
      List<Temple> templerequests = templemappingData.map((teamusermappingData) =>  Temple.fromMap(teamusermappingData)).toList();
//      TeamUser.fromMap(templemappingData);
      print(templerequests);
      return templerequests;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<Temple>> getTempleMappings(String eventMapping) async {
    String requestBody = '';

    //print(requestBody);

    var response = await _client.put('$_baseUrl/gettemplemappings', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventtsermappingData = json.decode(response.body);
      // print(teamtsermappingData);
      List<Temple> eventusermappings = eventtsermappingData.map((eventtsermappingData) => Temple.fromMap(eventtsermappingData)).toList();
      //print(teamusermappings);
      //print(userdetails);

      return eventusermappings;

    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<Roles>> submitDeleteRolesMapping(List<Roles> listofrolesmap) async {
    print(listofrolesmap);
    String requestBody = json.encode(listofrolesmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitdeleterolesmapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> rolesmappingData = json.decode(response.body);
      List<Roles> roles = rolesmappingData.map((rolesmappingData) =>  Roles.fromMap(rolesmappingData)).toList();
//      TeamUser.fromMap(teamusermappingData);
      print(roles);
      return roles;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<Roles>> submitNewRolesMapping(List<Roles> listofrolesmap) async {
    print(listofrolesmap);
    String requestBody = json.encode(listofrolesmap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitnewrolesmapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> rolesmappingData = json.decode(response.body);
      List<Roles> rolesrequests = rolesmappingData.map((rolesmappingData) =>  Roles.fromMap(rolesmappingData)).toList();
//      TeamUser.fromMap(templemappingData);
      print(rolesrequests);
      return rolesrequests;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<Roles>> getRolesMappings(String roleMapping) async {
    String requestBody = '';

    //print(requestBody);

    var response = await _client.put('$_baseUrl/getrolesmappings', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> rolesmappingData = json.decode(response.body);
      // print(teamtsermappingData);
      List<Roles> rolesmappings = rolesmappingData.map((rolesmappingData) => Roles.fromMap(rolesmappingData)).toList();
      //print(teamusermappings);
      //print(userdetails);

      return rolesmappings;

    } else {
      throw Exception('Failed to get data');
    }
  }

  //userTemple
  Future<List<UserTemple>> submitDeleteUserTempleMapping(List<UserTemple> listofusertemplemap) async {
    print(listofusertemplemap);
    String requestBody = json.encode(listofusertemplemap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitdeleteusertemplemapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> eventusermappingData = json.decode(response.body);
      List<UserTemple> usertemple = eventusermappingData.map((eventusermappingData) =>  UserTemple.fromMap(eventusermappingData)).toList();
//      TeamUser.fromMap(teamusermappingData);
      print(usertemple);
      return usertemple;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<UserTemple>> submitNewUserTempleMapping(List<UserTemple> listofusertemplemap) async {
    print(listofusertemplemap);
    String requestBody = json.encode(listofusertemplemap);
    print(requestBody);

    var response = await _client.put('$_baseUrl/submitnewusertemplemapping', headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> templemappingData = json.decode(response.body);
      List<UserTemple> usertemplerequests = templemappingData.map((teamusermappingData) =>  UserTemple.fromMap(teamusermappingData)).toList();
//      TeamUser.fromMap(templemappingData);
      print(usertemplerequests);
      return usertemplerequests;

      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<UserTemple>> getUserTempleMappings(String usertempleMapping) async {
    String requestBody = '';

    //print(requestBody);

    var response = await _client.put('$_baseUrl/getusertemplemappings',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventtsermappingData = json.decode(response.body);
      // print(teamtsermappingData);
      List<UserTemple> usertemplemapping = eventtsermappingData.map((
          eventtsermappingData) => UserTemple.fromMap(eventtsermappingData))
          .toList();
      //print(teamusermappings);
      //print(userdetails);

      return usertemplemapping;
    } else {
      throw Exception('Failed to get data');
    }
  }

    //rolescreen
    Future<List<RoleScreen>> submitDeleteRoleScreenMapping(List<RoleScreen> listofrolescreenmap) async {
      print(listofrolescreenmap);
      String requestBody = json.encode(listofrolescreenmap);
      print(requestBody);

      var response = await _client.put('$_baseUrl/submitdeleterolescreenmappings', headers: {"Content-Type": "application/json"}, body: requestBody);

      if (response.statusCode == 200) {
        List<dynamic> rolescreenmappingdata = json.decode(response.body);
        List<RoleScreen> roleScreen = rolescreenmappingdata.map((rolescreenmappingdata) =>  RoleScreen.fromMap(rolescreenmappingdata)).toList();
//      TeamUser.fromMap(teamusermappingData);
        print(roleScreen);
        return roleScreen;

        List<dynamic> userrequestsData = json.decode(response.body);
        //print(userdetailsData);
        List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


      } else {
        throw Exception('Failed to get data');
      }
    }
    Future<List<RoleScreen>> submitNewRoleScreenMapping(List<RoleScreen> listofrolescreenmap) async {
      print(listofrolescreenmap);
      String requestBody = json.encode(listofrolescreenmap);
      print(requestBody);

      var response = await _client.put('$_baseUrl/submitnewrolescreenmapping', headers: {"Content-Type": "application/json"}, body: requestBody);

      if (response.statusCode == 200) {
        List<dynamic> rolescreenmappingdata = json.decode(response.body);
        List<RoleScreen> rolescreenrequest = rolescreenmappingdata.map((rolescreenmappingdata) =>  RoleScreen.fromMap(rolescreenmappingdata)).toList();
//      TeamUser.fromMap(templemappingData);
        print(rolescreenrequest);
        return rolescreenrequest;

        List<dynamic> userrequestsData = json.decode(response.body);
        //print(userdetailsData);
        List<UserRequest> userrequests = userrequestsData.map((userrequestsData) => UserRequest.fromMap(userrequestsData)).toList();


      } else {
        throw Exception('Failed to get data');
      }
    }
    Future<List<RoleScreen>> getRoleScreenMappings(String rolescreenMapping) async {
      String requestBody = '';

      //print(requestBody);

      var response = await _client.put('$_baseUrl/getrolescreenmappings', headers: {"Content-Type": "application/json"}, body: requestBody);

      if (response.statusCode == 200) {
        //print(response.body);
        List<dynamic> rolescreenmappingData = json.decode(response.body);
        // print(teamtsermappingData);
        List<RoleScreen> rolescreenMapping = rolescreenmappingData.map((rolescreenmappingData) => RoleScreen.fromMap(rolescreenmappingData)).toList();
        //print(teamusermappings);
        //print(userdetails);

        return rolescreenMapping;

      } else {
        throw Exception('Failed to get data');
      }
  }
}

