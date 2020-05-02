import 'dart:async';
import 'package:flutter_kirthan/models/user.dart';

abstract class IUserRestApi {
  //Sample
  Future<List<UserRequest>> getUserRequestsFromJson();

  //user
  Future<List<UserRequest>> getUserRequests(String userType);

  Future<List<UserRequest>> getDummyUserRequests();

  Future<UserRequest> submitNewUserRequest(Map<String, dynamic> userrequestmap);

  Future<bool> processUserRequest(Map<String, dynamic> processrequestmap);

  Future<bool> deleteUserRequest(Map<String, dynamic> processrequestmap);

  Future<void> submitUpdateUserRequest(String userrequestmap);
}
