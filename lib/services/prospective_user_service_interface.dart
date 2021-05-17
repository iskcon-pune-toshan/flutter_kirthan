import 'dart:async';
import 'package:flutter_kirthan/models/prospectiveuser.dart';

abstract class IProspectiveUserRestApi {
  Future<List<ProspectiveUserRequest>> getProspectiveUserRequests(
      String userType);

  Future<ProspectiveUserRequest> submitNewProspectiveUserRequest(
      Map<String, dynamic> eventrequestmap);

  Future<bool> processProspectiveUserRequest(
      Map<String, dynamic> processrequestmap);

  Future<bool> deleteProspectiveUserRequest(
      Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateProspectiveUserRequest(String eventrequestmap);

  Future<List<ProspectiveUserRequest>> getDummyProspectiveUserRequests();
}
