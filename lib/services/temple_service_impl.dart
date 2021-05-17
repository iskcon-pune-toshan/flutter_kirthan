import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/services/temple_service_interface.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as _http;

//getTemples based on Id
class TempleAPIService extends BaseAPIService implements ITempleRestApi {
  static final TempleAPIService _internal = TempleAPIService.internal();

  factory TempleAPIService() => _internal;

  TempleAPIService.internal();

  @override
  Future<List<Temple>> getData(String status) async {
    _http.Response response = await _http.get("$baseUrl/temple?status=$status");
    List<dynamic> data = json.decode(response.body);
    List<Temple> newData = data.map((e) => Temple.fromMap(e)).toList();
    return Future.value(newData);
  }

  //processEvents
  Future<bool> processTemple(Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/temple/processtemple',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //getEvent
  Future<List<Temple>> getTemples(String eventType) async {
    String requestBody = '';
    requestBody = '{"city":["Pune","Mumbai"]}';

    if (eventType == ["bmg"]) {
      requestBody = '{"id":"4"}';
    } else if (eventType == "All") {
      requestBody = '{"state":["MH"]}';
    } else {
      int id = int.parse(eventType);
      requestBody = '{"id":$id}';
    }

    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put('$baseUrl/api/temple/gettemple',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      //print(response.body);
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<Temple> eventrequests = eventrequestsData
          .map((eventrequestsData) => Temple.fromMap(eventrequestsData))
          .toList();

      //print(userdetails);

      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

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
*/

  //addevent
  Future<Temple> submitNewTemple(Map<String, dynamic> eventrequestmap) async {
    print(eventrequestmap);
    String requestBody = json.encode(eventrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/temple/addtemple',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      //EventRequest respeventrequest = json.decode(response.body);
      //print(respeventrequest);
      //return respeventrequest;

      Map<String, dynamic> eventrequestsData = json.decode(response.body);
      Temple eventrequests = Temple.fromMap(eventrequestsData);
      print(eventrequests);
      return eventrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //deleteEvents
  Future<bool> deleteTemple(Map<String, dynamic> processrequestmap) async {
    print(processrequestmap);
    String requestBody = json.encode(processrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/temple/deletetemple',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    if (response.statusCode == 200) {
      print(response.body);

      return true;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> submitUpdateTemple(String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/temple/updatetemple',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: eventrequestmap);

    if (response.statusCode == 200) {
      print(response.body);
    } else {
      throw Exception('Failed to get data');
    }
  }
}
