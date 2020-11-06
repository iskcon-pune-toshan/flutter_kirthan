import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/services/role_screen_service_interface.dart';

class RoleScreenAPIService extends BaseAPIService implements IRoleScreenRestApi {

  static final RoleScreenAPIService _internal = RoleScreenAPIService.internal();

  factory RoleScreenAPIService() => _internal;
  RoleScreenAPIService.internal();
  String token = AutheticationAPIService().sessionJWTToken;

  Future<List<RoleScreen>> getRoleScreens(String eventType) async {


    String requestBody = '{"roleId":1}';


    //String token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/rolescreen/getrolescreen',headers:{'Content-Type': 'application/json','Authorization':'Bearer $token'},
        body: requestBody);
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> rolescreenrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<RoleScreen> rolescreenrequests = rolescreenrequestsData
          .map((rolescreensrequestsData) => RoleScreen.fromMap(rolescreensrequestsData))
          .toList();


      return rolescreenrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  /*Future<EventRequest> submitNewEventRequest(EventRequest pEventrequest) async {
    String requestBody = ''; Future<List<EventRequest>> getEventRequestsFromJson() async {
    var userDetailsJson = await rootBundle.loadString(eventdetailsJsonPath);
    List<dynamic> eventdetailsData = json.decode(eventDetailsJson) as List;
    List<UserRequest> eventdetails = eventdetailsData.map((eventdetailsData) => EventRequest.fromMap(eventdetailsData)).toList();

    return eventdetails;
  }

    var response = await _client.put('$_baseUrl/submitneweventrequest', headers: {"Content-Type": "application/json"}, body: requestBody);
    if (response.statusCode == 200) {
      EventRequest eventrequestsData = json.decode(response.body);
      print(eventrequestsData);
    }
  }*/



  Future<RoleScreen> submitNewRoleScreen(
      Map<String, dynamic> rolescreensrequestmap) async {
    print(rolescreensrequestmap);
    String requestBody = json.encode(rolescreensrequestmap);
    print(requestBody);

    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/rolescreen/addrolescreen',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);
    if (response.statusCode == 200) {


      Map<String, dynamic> rolescreenrequestsData = json.decode(response.body);
      RoleScreen rolescreenrequests = RoleScreen.fromMap(rolescreenrequestsData);
      print(rolescreenrequests);
      return rolescreenrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> deleteRoleScreen(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    // String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/rolescreen/deleterolescreen',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

@override
  Future<bool> submitUpdateRoleScreen(String eventrequestmap) async {


    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/rolescreen/updaterolescreen',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: eventrequestmap);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }





}
