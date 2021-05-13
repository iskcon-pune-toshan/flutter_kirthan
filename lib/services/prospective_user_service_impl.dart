import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_interface.dart';
import 'package:flutter_kirthan/services/prospective_user_service_interface.dart';
import 'package:http/http.dart' as _http;

//get events based on eventId
class ProspectiveUserAPIService extends BaseAPIService
    implements IProspectiveUserRestApi {
  static final ProspectiveUserAPIService _internal =
      ProspectiveUserAPIService.internal();
  ProspectiveUserRequest eventRequest;
  factory ProspectiveUserAPIService() => _internal;

  ProspectiveUserAPIService.internal();

  //processEvents
  Future<bool> processProspectiveUserRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put(
        '$baseUrl/api/event/processprospectiveuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  //getEvent
  Future<List<ProspectiveUserRequest>> getProspectiveUserRequests(
      String eventType) async {
    print("I am in Service: getEventRequests");
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    print(email);

    String requestBody = '';

    // All Events [Select * from event_request]
    // One Single events [Select * from event_request where id=?]
    // Events on datewise [Today/Tomorrow/This week/This month]
    // Events at City wise [City='Pune']
    // Events at Statewise [State='MH']
    // Events isprocessed = 0 or 1
    // Events on event Type = Free or Premium
    // Events public or private

    // Events on duration
    //requestBody = '{"city":["Pune","Mumbai"]}';
    if (eventType.contains("uEmail")) {
      var array = eventType.split(":");
      String umail = array[1];
      requestBody = '{"userEmail" : "$umail"}';
    } else if (eventType.contains("invitedBy")) {
      var array = eventType.split(":");
      String lamail = array[1];
      requestBody = '{"invitedBy" : "$lamail"}';
    } else if (eventType.contains("local admin") ||
        eventType.contains("team")) {
      requestBody = '{"inviteType" : "$eventType"}';
    } else {
      requestBody = '{"inviteCode" : "$eventType"}';
    }
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    print("entered getEvents");
    var response = await client1.put('$baseUrl/api/event/getprospectiveuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventrequestsData = json.decode(response.body);
      print(eventrequestsData);
      List<ProspectiveUserRequest> eventrequests = eventrequestsData
          .map((eventrequestsData) =>
              ProspectiveUserRequest.fromMap(eventrequestsData))
          .toList();

      print(eventrequests.length);
      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<ProspectiveUserRequest> submitNewProspectiveUserRequest(
      Map<String, dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/addprospectiveuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      //EventRequest respeventrequest = json.decode(response.body);
      //print(respeventrequest);
      //return respeventrequest;

      Map<String, dynamic> eventrequestsData = json.decode(response.body);
      ProspectiveUserRequest eventrequests =
          ProspectiveUserRequest.fromMap(eventrequestsData);
      print(eventrequests);

      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //deleteEvents
  Future<bool> deleteProspectiveUserRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/deleteprospectiveuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<ProspectiveUserRequest>> getDummyProspectiveUserRequests() async {
    List<ProspectiveUserRequest> eventrequests;
    return eventrequests;
  }

  Future<bool> submitUpdateProspectiveUserRequest(
      String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/updateprospectiveuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: eventrequestmap);

    print(response.statusCode);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
