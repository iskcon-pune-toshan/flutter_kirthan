import 'dart:async';
import 'dart:convert';
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
    _http.Response response =  await _http.get("$baseUrl/users/count");
    if(response.statusCode == 200 ) {
      List<dynamic> data = json.decode(response.body);
      List<int> resultData = [];
      for (int i = 0; i < 3; i++)
        resultData.add((data[i]));
      return (resultData);
    }
    else{
      print("Error fetching data");
      return [0,0,0];
    }
  }

  @override
  Future<List<UserRequest>> getNewUserRequests(String status,String city) async {
    String finalUrl = '$baseUrl/users?status=$status&city=$city';//needs to adjust this to temple
    print(finalUrl);
    var response = await client1.get(finalUrl);
    if (response.statusCode == 200) {
      List<dynamic> userrequestsData = json.decode(response.body);
      List<UserRequest> userrequests = userrequestsData
          .map((userrequestsData) => UserRequest.fromMap(userrequestsData))
          .toList();
      return userrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }
  Future<List<UserRequest>> getUserRequests(String userType) async {
    String requestBody = '{"locality":"Warje"}';
    //adding a test comment
    if (userType == "SA") {
      requestBody = '{"userType":"SuperAdmin"}';
    } else if (userType == "A") {
      requestBody = '{"userType":"Admin"}';
    } else if (userType == "U") {
      requestBody = '{"userType":"Users"}';
    }

    print(requestBody);

    var response = await client1.put('$baseUrl/getuserrequests',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

  Future<UserRequest> submitNewUserRequest(
      Map<String, dynamic> userrequestmap) async {
    print(userrequestmap);
    String requestBody = json.encode(userrequestmap);
    print(requestBody);

    var response = await client1.put('$baseUrl/submitnewuserrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

  Future<bool> processUserRequest(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    var response = await client1.put('$baseUrl/processuserrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

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

    var response = await client1.put('$baseUrl/deleteuserrequest',
        headers: {"Content-Type": "application/json"}, body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<UserRequest>> getDummyUserRequests() async {
    var response = await client1.get('$baseUrl/getdummyuserrequest',
        headers: {"Content-Type": "application/json"});

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

    var response = await client1.put('$baseUrl/submitupdateuserrequest',
        headers: {"Content-Type": "application/json"}, body: userrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
