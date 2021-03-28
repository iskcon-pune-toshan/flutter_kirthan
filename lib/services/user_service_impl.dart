import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/services/user_service_interface.dart';
import 'package:http/http.dart' as _http;

class UserAPIService extends BaseAPIService implements IUserRestApi {
  static final UserAPIService _internal = UserAPIService.internal();

  factory UserAPIService() => _internal;

  UserAPIService.internal();

  @override
  Future<List<int>> getUserCount() async {
    List<UserRequest> approved = await getUserRequests("Approved");
    List<UserRequest> rejected = await getUserRequests("Rejected");
    List<UserRequest> allevents = await getUserRequests("Waiting");
    List<int> resultData = [];
    resultData.add(approved.length);
    resultData.add(rejected.length);
    resultData.add(allevents.length);
    return (resultData);
  }

  @override
  Future<List<UserRequest>> getNewUserRequests(
      String status, String city) async {
    return await getUserRequests("$status");
  }

  //getuser
  Future<List<UserRequest>> getUserRequests(String userType) async {
    String requestBody = '{"locality":["Warje"]}';
    requestBody = '{"city":"Pune"}';
    //adding a test comment
    if (userType == "SA") {
      requestBody = '{"roleId": 1}';
    } else if (userType == "A") {
      requestBody = '{"roleId": 2}';
    } else if (userType == "U") {
      requestBody = '{"roleId": 3}';
    } else if (userType == "Approved") {
      requestBody = '{"approvalStatus":"approved"}';
    } else if (userType == "Rejected") {
      requestBody = '{"approvalStatus":"rejected"}';
    } else if (userType == "Waiting") {
      requestBody = '{"approvalStatus":"Waiting"}';
    } else {
      requestBody = '{"email":"$userType"}';
    }

    print("Instance of request");
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/user/getuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    print(response.body);
    print("User sorting");
    print(requestBody);
    print(response.statusCode);

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> userrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userrequests = userrequestsData
          .map((userrequestsData) => UserRequest.fromMap(userrequestsData))
          .toList();

      //print(userdetails);

      return userrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //updateuser
  Future<UserRequest> submitNewUserRequest(
      Map<String, dynamic> userrequestmap) async {
    print(userrequestmap);
    String requestBody = json.encode(userrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
/*    var response = await client1.put('$baseUrl/api/user/updateuser',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);
  */
    var response = await client1.put('$baseUrl/api/user/adduser',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      //UserRequest respuserrequest = json.decode(response.body);
      //print(respuserrequest);
      //return respuserrequest;
      Map<String, dynamic> userrequestsData = json.decode(response.body);
      UserRequest userrequests = UserRequest.fromMap(userrequestsData);
      print(userrequests);
      return userrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //processuser
  Future<bool> processUserRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/user/processuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> deleteUserRequest(Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/user/deleteuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<UserRequest>> getDummyUserRequests() async {
    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.get('$baseUrl/api/user/getdummyuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        });

    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> userdetailsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserRequest> userdetails = userdetailsData
          .map((userdetailsData) => UserRequest.fromMap(userdetailsData))
          .toList();

      return userdetails;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<UserRequest>> getUserRequestsFromJson() async {
    var userDetailsJson = await rootBundle.loadString(userdetailsJsonPath);
    List<dynamic> userdetailsData = json.decode(userDetailsJson) as List;
    List<UserRequest> userdetails = userdetailsData
        .map((userdetailsData) => UserRequest.fromMap(userdetailsData))
        .toList();

    return userdetails;
  }

  Future<bool> submitUpdateUserRequest(String userrequestmap) async {
    print(userrequestmap);
    //String requestBody = json.encode(userrequestmap);
    //print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/user/updateuser',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: userrequestmap);

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
