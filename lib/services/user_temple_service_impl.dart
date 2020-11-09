/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/user_temple_service_interface.dart';

class UserTempleAPIService extends BaseAPIService implements IUserTempleRestApi {

  static final UserTempleAPIService _internal = UserTempleAPIService.internal();

  factory UserTempleAPIService() => _internal;
  String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMzU5MzYyOSwiaWF0IjoxNjAzNTU3NjI5fQ.LX6aUpXG28wdWC3vfVuAW9TOv0VxqAiySYuCDYVhklU";
 UserTempleAPIService.internal();

  Future<List<UserTemple>> getUserTemples(String eventType) async {


    String requestBody = '';


    //String token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/usertemple/getusertemple',headers:{'Content-Type': 'application/json','Authorization':'Bearer $token'},
        body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> usertemplerequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<UserTemple> usertemplerequests = usertemplerequestsData
          .map((usertemplerequestData) => UserTemple.fromMap(usertemplerequestData))
          .toList();


      return usertemplerequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

*/
/*  Future<EventRequest> submitNewEventRequest(EventRequest pEventrequest) async {
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
  }
*//*


  Future<UserTemple> submitNewUserTemple(
      Map<String, dynamic> usertemplerequestmap) async {
    print(usertemplerequestmap);
    String requestBody = json.encode(usertemplerequestmap);
    print(requestBody);

    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/usertemple/addusertemple',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);
    if (response.statusCode == 200) {


      Map<String, dynamic> usertemplerequestsData = json.decode(response.body);
     UserTemple usertemplerequests = UserTemple.fromMap(usertemplerequestsData);
      print(usertemplerequests);
      return usertemplerequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> deleteUserTemple(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    // String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/usertemple/deleteusertemple',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

@override
  Future<bool> submitUpdateUserTemple(String eventrequestmap) async {


    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/usertemple/updateusertemple',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: eventrequestmap);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }





}
*/
