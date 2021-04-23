import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_interface.dart';
import 'package:http/http.dart' as _http;

class EventAPIService extends BaseAPIService implements IEventRestApi {
  static final EventAPIService _internal = EventAPIService.internal();
  EventRequest eventRequest;
  factory EventAPIService() => _internal;

  EventAPIService.internal();

  @override
  Future<List<int>> getEventCount() async {
    List<EventRequest> approved = await getEventRequests("All");
    List<EventRequest> rejected = await getEventRequests("Rejected");
    List<EventRequest> waiting = await getEventRequests("Waiting");
    List<int> resultData = [];
    resultData.add(approved.length);
    resultData.add(rejected.length);
    resultData.add(waiting.length);
    return (resultData);
  }

  @override
  Future<List<EventRequest>> getData(String status) async {
    // _http.Response response = await _http.get("$baseUrl/event?status=$status");
    // List<dynamic> data = json.decode(response.body);
    // List<EventRequest> newData =
    //     data.map((e) => EventRequest.fromMap(e)).toList();
    return await getEventRequests("$status");
  }

  //processEvents
  Future<bool> processEventRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/processevent',
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
  Future<List<EventRequest>> getEventRequests(String eventType) async {
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
    if (eventType == "TODAY") {
      requestBody = '{"dateInterval" : "TODAY"}';
    } else if (eventType == "TOMORROW")
      requestBody = '{"dateInterval" : "TOMORROW"}';
    else if (eventType == "This Week") {
      requestBody = '{"dateInterval" : "This Week"}';
    } else if (eventType == "This Month") {
      requestBody = '{"dateInterval": "This Month"}';
    } else if (eventType == "All" ||
        eventType == "AA" ||
        eventType == "Approved") {
      print("Public request body");
      //requestBody = '{"isPublicEvent" : true , "approvalStatus" : "Approved"}';
      requestBody = '{"isPublicEvent" : true,"status":2}';
    } else if (eventType == "Rejected") {
      requestBody = '{"approvalStatus" : "Rejected"}';
    } else if (eventType == "Waiting") {
      requestBody = '{"approvalStatus" : "Processing"}';
    } else if (eventType == "MyEvent") {
      requestBody = '{"createdBy" : ["$email"]}';
    } else {
      requestBody = '{"eventDuration" : "$eventType"}';
    }
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    print("entered getEvents");
    var response = await client1.put('$baseUrl/api/event/getevents',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventrequestsData = json.decode(response.body);
      print(eventrequestsData);
      List<EventRequest> eventrequests = eventrequestsData
          .map((eventrequestsData) => EventRequest.fromMap(eventrequestsData))
          .toList();

      print(eventrequests.length);
      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventRequest>> getEventTitle(String eventType) async {
    //print("I am in Service: getEventRequests");

    String requestBody = '';

    requestBody = '{"approvalStatus" : "Approved"}';

    //print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    print("search service");
    var response = await client1.put('$baseUrl/api/event/geteventtitle',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(eventrequestsData);
      List<EventRequest> eventrequests = eventrequestsData
          .map((eventrequestsData) => EventRequest.fromJson(eventrequestsData))
          .toList();
      List<String> events =
          eventrequests.map((event) => event.toString()).toList();
      print(events);
//print(eventrequests);
      print("before return");
      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventRequest>> getEventByDate(String request) async {
    //print("I am in Service: getEventRequests");

    String requestBody = '';
    request = DateTime.now().toString();
    requestBody = '{"eventDate" : "2020-04-20T05:50:02.000+0000"}';

    //print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put('$baseUrl/api/event/geteventbydate',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);
      print(eventrequestsData);
      List<EventRequest> eventrequests = eventrequestsData
          .map((eventrequestsData) => EventRequest.fromJson(eventrequestsData))
          .toList();
      List<String> events =
          eventrequests.map((event) => event.toString()).toList();
      print(events);
//print(eventrequests);
      print("before return");
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

  //addevent
  Future<EventRequest> submitNewEventRequest(
      Map<String, dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/addevent',
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
      EventRequest eventrequests = EventRequest.fromMap(eventrequestsData);
      print(eventrequests);

      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //deleteEvents
  Future<bool> deleteEventRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/deleteevent',
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

  Future<List<EventRequest>> getDummyEventRequests() async {
    List<EventRequest> eventrequests;
    return eventrequests;
  }

  Future<bool> submitUpdateEventRequest(String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/updateevent',
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

  Future<bool> submitRegisterEventRequest(String eventrequestmap) async {
    //print(eventrequestmap);
    print("Inside register event service");
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/registerevent',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: eventrequestmap);

    print(response.statusCode);
    if (response.statusCode == 200) {
      //print(response.body);
      print("register event called successfully");
    } else {
      throw Exception('Failed to get data');
    }
  }

  @override
  Future<List<EventRequest>> getEventDates(String userType) {
    // TODO: implement getEventDates
    throw UnimplementedError();
  }
}
