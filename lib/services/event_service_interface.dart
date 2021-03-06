import 'dart:async';
import 'package:flutter_kirthan/models/event.dart';

abstract class IEventRestApi {
//event
  Future<List<EventRequest>> getEventRequests(String userType);

  Future<EventRequest> submitNewEventRequest(
      Map<String, dynamic> eventrequestmap);

  Future<bool> processEventRequest(Map<String, dynamic> processrequestmap);

  Future<bool> deleteEventRequest(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateEventRequest(String eventrequestmap);

  Future<List<EventRequest>> getDummyEventRequests();

}
