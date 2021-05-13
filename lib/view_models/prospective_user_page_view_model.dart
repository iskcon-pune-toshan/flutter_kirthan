import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/services/prospective_user_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/event_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/event.dart';

class ProspectiveUserPageViewModel extends Model {
  Future<List<ProspectiveUserRequest>> _eventrequests;
  final IProspectiveUserRestApi apiSvc;

  Map<String, bool> accessTypes;

  ProspectiveUserPageViewModel({@required this.apiSvc});

  Future<List<ProspectiveUserRequest>> get eventrequests => _eventrequests;

  set eventrequests(Future<List<ProspectiveUserRequest>> value) {
    _eventrequests = value;
    notifyListeners();
  }

  Future<bool> setProspectiveUserRequests(String eventType) async {
    eventrequests = apiSvc?.getProspectiveUserRequests(eventType);
    return eventrequests != null;
  }

  Future<List<ProspectiveUserRequest>> getProspectiveUserRequests(
      String userType) {
    Future<List<ProspectiveUserRequest>> eventRequests =
        apiSvc?.getProspectiveUserRequests(userType);
    return eventRequests;
  }

  Future<ProspectiveUserRequest> submitNewProspectiveUserRequest(
      Map<String, dynamic> eventrequestmap) {
    Future<ProspectiveUserRequest> eventRequest =
        apiSvc?.submitNewProspectiveUserRequest(eventrequestmap);
    return eventRequest;
  }

  Future<bool> processProspectiveUserRequest(
      Map<String, dynamic> processrequestmap) {
    Future<bool> processFlag =
        apiSvc?.processProspectiveUserRequest(processrequestmap);
    return processFlag;
  }

  Future<bool> deleteProspectiveUserRequest(
      Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag =
        apiSvc?.deleteProspectiveUserRequest(processrequestmap);
    return deleteFlag;
  }

  Future<bool> submitUpdateProspectiveUserRequest(String eventrequestmap) {
    Future<bool> updateFlag =
        apiSvc?.submitUpdateProspectiveUserRequest(eventrequestmap);
    return updateFlag;
  }
}
