import 'dart:async';
import 'package:flutter_kirthan/models/event.dart';

abstract class IEventRestApi {
//event
  Future<List<EventRequest>> getEventRequests(String userType);

  Future<EventRequest> submitNewEventRequest(
      Map<String, dynamic> eventrequestmap);

  Future<List<int>> getEventCount();

  Future<List<EventRequest>> getData(String status);

  Future<bool> processEventRequest(Map<String, dynamic> processrequestmap);

  Future<EventRequest> deleteEventRequest(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateEventRequest(String eventrequestmap);

  Future<bool> submitRegisterEventRequest(String eventrequestmap);

  Future<List<EventRequest>> getDummyEventRequests();
}
