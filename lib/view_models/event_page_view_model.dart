import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/event_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/event.dart';

class EventPageViewModel extends Model {
  Future<List<EventRequest>> _eventrequests;
  final IEventRestApi apiSvc;

  EventPageViewModel({@required this.apiSvc});

  Future<List<EventRequest>> get eventrequests => _eventrequests;

  set eventrequests(Future<List<EventRequest>> value) {
    _eventrequests = value;
    notifyListeners();
  }

  Future<bool> setEventRequests(String eventType) async {
    eventrequests = apiSvc?.getEventRequests(eventType);
    return eventrequests != null;
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
}
