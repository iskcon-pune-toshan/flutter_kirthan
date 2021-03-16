import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/preferences.dart';
import 'package:flutter_kirthan/services/preferences_service_interface.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as _http;

class PreferencesAPIService extends BaseAPIService
    implements IPreferencesRestApi {
  static final PreferencesAPIService _internal =
      PreferencesAPIService.internal();

  factory PreferencesAPIService() => _internal;

  PreferencesAPIService.internal();

  @override
  Future<List<Preferences>> getData(String status) async {
    _http.Response response =
        await _http.get("$baseUrl/preferences?status=$status");
    List<dynamic> data = json.decode(response.body);
    List<Preferences> newData =
        data.map((e) => Preferences.fromMap(e)).toList();
    return Future.value(newData);
  }

  //getPreferences
  Future<List<Preferences>> getPreferences(String eventType) async {
    String requestBody = '';

    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put(
        '$baseUrl/api/preferences/getpreferenceswithdescription',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    print(response.statusCode);
    print(requestBody);
    if (response.statusCode == 200) {
      print(response.statusCode);
      List<dynamic> preferencerequestsData = json.decode(response.body);
      //print(userdetailsData);
      List<Preferences> preferencesrequests = preferencerequestsData
          .map((preferencerequestsData) =>
              Preferences.fromMap(preferencerequestsData))
          .toList();

      print(preferencerequestsData);

      return preferencesrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  //addpref
  Future<Preferences> submitNewPreferences(
      Map<String, dynamic> preferencesrequestmap) async {
    print(preferencesrequestmap);
    String requestBody = json.encode(preferencesrequestmap);
    print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/preferences/addeventpref',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      Map<String, dynamic> preferencesData = json.decode(response.body);
      Preferences preferencesrequests = Preferences.fromMap(preferencesData);
      print(preferencesrequests);
      return preferencesrequests;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<bool> submitUpdatePreferences(String eventrequestmap) async {
    print(eventrequestmap);

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/preferences/updateeventpref',
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
