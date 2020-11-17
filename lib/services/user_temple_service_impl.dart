import 'dart:async';
import 'dart:convert';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/user_temple_service_interface.dart';

class UserTempleAPIService extends BaseAPIService implements IUserTempleRestApi {

  static final UserTempleAPIService _internal = UserTempleAPIService.internal();

  factory UserTempleAPIService() => _internal;
   UserTempleAPIService.internal();
  String token = AutheticationAPIService().sessionJWTToken;

  Future<List<UserTemple>> submitNewUserTempleMapping(
      List<UserTemple> listofusertemplemap) async {
    print(listofusertemplemap);
    String requestBody = json.encode(listofusertemplemap);
    print(requestBody);


    var response = await client1.put('$baseUrl/api/usertemple/addusertemple',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> usertemplemappingData = json.decode(response.body);
      List<UserTemple> usertemplerequests = usertemplemappingData
          .map((usertemplemappingData) => UserTemple.fromMap(usertemplemappingData))
          .toList();
      print(usertemplemappingData);
      return usertemplemappingData;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<UserTemple>> getUserTempleMapping(String userMapping) async {

    String requestBody = "";

    String token = AutheticationAPIService().sessionJWTToken;
    var response = await client1.put('$baseUrl/api/usertemple/getusertemplewithdescription',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);


    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {

      List<dynamic> usertemplemappingData = json.decode(response.body);
      List<UserTemple> usertemplemappings = usertemplemappingData
          .map((usertemplemappingData) => UserTemple.fromMap(usertemplemappingData))
          .toList();


      return usertemplemappings;
    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<UserTemple>> submitDeleteUserTempleMapping(
      List<UserTemple> listofusertemplemap) async {
    print(listofusertemplemap);
    String requestBody = json.encode(listofusertemplemap);
    print(requestBody);


    var response = await client1.put('$baseUrl/api/usertemple/deleteusertemple',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    if (response.statusCode == 200) {
      List<dynamic> usertemplemappingData = json.decode(response.body);
      List<UserTemple> usertemple = usertemplemappingData
          .map((usertemplemappingData) => UserTemple.fromMap(usertemplemappingData))
          .toList();
      print(usertemple);
      return usertemple;

    } else {
      throw Exception('Failed to get data');
    }
  }



}
