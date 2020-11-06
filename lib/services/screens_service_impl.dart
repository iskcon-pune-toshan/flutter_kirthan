/*
import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/screens.dart';
import 'package:flutter_kirthan/services/screens_service_interface.dart';

class ScreenAPIService extends BaseAPIService implements IScreenRestApi {

  static final ScreenAPIService _internal = ScreenAPIService.internal();

  factory ScreenAPIService() => _internal;
  String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMzU5MzYyOSwiaWF0IjoxNjAzNTU3NjI5fQ.LX6aUpXG28wdWC3vfVuAW9TOv0VxqAiySYuCDYVhklU";
  ScreenAPIService.internal();

  Future<List<Screens>> getScreens(String eventType) async {


    String requestBody = '';


    //String token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/screen/getscreen',headers:{'Content-Type': 'application/json','Authorization':'Bearer $token'},
        body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> rolescreenrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<Screens> rolescreenrequests = rolescreenrequestsData
          .map((rolescreensrequestsData) => Screens.fromMap(rolescreensrequestsData))
          .toList();


      return rolescreenrequests;
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


  Future<Screens> submitNewScreen(
      Map<String, dynamic> rolescreensrequestmap) async {
    print(rolescreensrequestmap);
    String requestBody = json.encode(rolescreensrequestmap);
    print(requestBody);

    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/screen/addscreen',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);
    if (response.statusCode == 200) {


      Map<String, dynamic> rolescreenrequestsData = json.decode(response.body);
     Screens rolescreenrequests = Screens.fromMap(rolescreenrequestsData);
      print(rolescreenrequests);
      return rolescreenrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> deleteScreen(
      Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    // String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/screen/deletescreen',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

@override
  Future<bool> submitUpdateScreen(String eventrequestmap) async {


    //String  token ="eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJraXJ0aGFudXNlciIsImV4cCI6MTYwMjM2MjA4MywiaWF0IjoxNjAyMzI2MDgzfQ.tO8S8wQsFaEk0YnvL1mQXOE1oVEsVI0s3nKAU_3j94Y";
    var response = await client1.put('$baseUrl/api/screen/updatescreen',headers:{"Content-Type": "application/json","Authorization":"Bearer $token"},
        body: eventrequestmap);
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }





}
*/
