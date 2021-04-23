import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/event_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/event.dart';

class EventPageViewModel extends Model {
  Future<List<EventRequest>> _eventrequests;
  final IEventRestApi apiSvc;

  Map<String, bool> accessTypes;

  EventPageViewModel({@required this.apiSvc});

  Future<List<EventRequest>> get eventrequests => _eventrequests;

  set eventrequests(Future<List<EventRequest>> value) {
    _eventrequests = value;
    notifyListeners();
  }

  Future<List<int>> getEventCount() async {
    List<int> result = await apiSvc?.getEventCount();
    return result;
  }

  Future<List<EventRequest>> getData(status) async {
    eventrequests = apiSvc?.getData(status);
    return eventrequests;
  }

  Future<bool> setEventRequests(String eventType) async {
    eventrequests = apiSvc?.getEventRequests(eventType);
    return eventrequests != null;
  }

  Future<List<EventRequest>> getEventRequests(String userType) {
    Future<List<EventRequest>> eventRequests =
    apiSvc?.getEventRequests(userType);
    return eventRequests;
  }

  Future<bool> setEventTitles(String eventtype) async {
    eventrequests = apiSvc?.getEventTitle(eventtype);
    return eventrequests != null;
  }

  Future<List<EventRequest>> getEventTitle(String userType) async {
    Future<List<EventRequest>> eventRequests = apiSvc?.getEventTitle(userType);
    return eventRequests;
  }

  Future<EventRequest> submitNewEventRequest(
      Map<String, dynamic> eventrequestmap) {
    Future<EventRequest> eventRequest =
    apiSvc?.submitNewEventRequest(eventrequestmap);
    return eventRequest;
  }

  Future<bool> processEventRequest(Map<String, dynamic> processrequestmap) {
    Future<bool> processFlag = apiSvc?.processEventRequest(processrequestmap);
    return processFlag;
  }

  Future<bool> deleteEventRequest(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deleteEventRequest(processrequestmap);
    return deleteFlag;
  }

  Future<bool> submitUpdateEventRequest(String eventrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdateEventRequest(eventrequestmap);
    return updateFlag;
  }

  Future<bool> submitRegisterEventRequest(String eventrequestmap) {
    Future<bool> updateFlag =
    apiSvc?.submitRegisterEventRequest(eventrequestmap);
    return updateFlag;
  }
}
