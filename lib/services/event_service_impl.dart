import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_interface.dart';
import 'package:http/http.dart' as _http;

//get events based on eventId
class EventAPIService extends BaseAPIService implements IEventRestApi {
  static final EventAPIService _internal = EventAPIService.internal();
  EventRequest eventRequest;

  factory EventAPIService() => _internal;

  EventAPIService.internal();

  @override
  Future<List<int>> getEventCount() async {
    List<EventRequest> approved = await getEventRequests("2");
    List<EventRequest> rejected = await getEventRequests("4");
    List<EventRequest> waiting = await getEventRequests("1");
    List<int> resultData = [];
    resultData.add(approved.length);
    resultData.add(rejected.length);
    resultData.add(waiting.length);
    return (resultData);
  }

  @override
  Future<List<EventRequest>> getData(String status) async {
    return await getEventRequests("$status");
  }

  //processEvents
  Future<bool> processEventRequest(
      Map<String, dynamic> processrequestmap) async {
    String requestBody = json.encode(processrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/processevent',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  //getEvent
  Future<List<EventRequest>> getEventRequests(String eventType) async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;

    String requestBody = '';

    // All Events [Select * from event_request]
    // One Single events [Select * from event_request where id=?]
    // Events on datewise [Today/Tomorrow/This week/This month]
    // Events at City wise [City='Pune']
    // Events at Statewise [State='MH']
    // Events isprocessed = 0 or 1
    // Events on event Type = Free or Premium
    // Events public or private
    // Events as per status(
    //  0=not initiated
    //  1=Processing(team has not accepted the invite)
    //  2=Approved(team accepted the invite)
    //  3=Cancelled(Event is cancelled)
    //  )
    // Events on duration
    //requestBody = '{"city":["Pune","Mumbai"]}';
    if (eventType == "TODAY") {
      requestBody =
          '{"dateInterval" : "TODAY" , "isPublicEvent" : true , "status" : 2}';
    } else if (eventType == "TOMORROW")
      requestBody =
          '{"dateInterval" : "TOMORROW" , "isPublicEvent" : true, "status" : 2}';
    else if (eventType == "This Week") {
      requestBody =
          '{"dateInterval" : "This Week", "isPublicEvent" : true, "status" : 2}';
    } else if (eventType == "This Month") {
      requestBody =
          '{"dateInterval": "This Month", "isPublicEvent" : true, "status" : 2}';
    } else if (eventType == "All" ||
        eventType == "AA" ||
        eventType == "Approved") {
      requestBody = '{"isPublicEvent" : true, "status" : 2}';
    } else if (eventType == "Rejected") {
      requestBody = '{"approvalStatus" : "Rejected"}';
    } else if (eventType == "Waiting") {
      requestBody = '{"approvalStatus" : "Processing"}';
    } else if (eventType == "MyEvent") {
      requestBody = '{"createdBy" : ["$email"],"isProcessed" : true}';
    } else if (eventType == "1" || eventType == "2" || eventType == "4") {
      int status = int.parse(eventType);
      requestBody = '{"teamInviteStatus" : $status}';
    } else if (eventType.contains("event_id:")) {
      var array = eventType.split(":");
      int eventId = int.parse(array[1]);
      requestBody = '{"id" : $eventId}';
    }
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/getevents',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventrequestsData = json.decode(response.body);

      List<EventRequest> eventrequests = eventrequestsData
          .map((eventrequestsData) => EventRequest.fromMap(eventrequestsData))
          .toList();

      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //addevent
  Future<EventRequest> submitNewEventRequest(
      Map<String, dynamic> eventrequestmap) async {
    String requestBody = json.encode(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/addevent',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      Map<String, dynamic> eventrequestsData = json.decode(response.body);
      EventRequest eventrequests = EventRequest.fromMap(eventrequestsData);

      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //deleteEvents
  Future<EventRequest> deleteEventRequest(
      Map<String, dynamic> processrequestmap) async {
    String requestBody = json.encode(processrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/deleteevent',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      Map<String, dynamic> eventrequestsData = json.decode(response.body);
      EventRequest eventrequests = EventRequest.fromMap(eventrequestsData);
      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<EventRequest>> getDummyEventRequests() async {
    List<EventRequest> eventrequests;
    return eventrequests;
  }

  Future<bool> submitUpdateEventRequest(String eventrequestmap) async {
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/event/updateevent',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: eventrequestmap);

    if (response.statusCode == 200) {
    } else {
      throw Exception('Failed to get data');
    }
  }
}
