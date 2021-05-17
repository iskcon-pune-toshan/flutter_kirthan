import 'dart:async';
import 'package:flutter_kirthan/models/user.dart';

//added submit initiate team function
abstract class IUserRestApi {
  //Sample
  Future<List<UserRequest>> getUserRequestsFromJson();

  //user
  Future<List<int>> getUserCount();
  Future<List<UserRequest>> getNewUserRequests(String status, String city);

  Future<List<UserRequest>> getUserRequests(String userType);

  Future<List<UserRequest>> getDummyUserRequests();

  Future<UserRequest> submitNewUserRequest(Map<String, dynamic> userrequestmap);

  Future<bool> processUserRequest(Map<String, dynamic> processrequestmap);

  Future<bool> deleteUserRequest(Map<String, dynamic> processrequestmap);

  Future<bool> submitUpdateUserRequest(String userrequestmap);

  Future<bool> submitInitiateTeam(String userrequestmap);
}
