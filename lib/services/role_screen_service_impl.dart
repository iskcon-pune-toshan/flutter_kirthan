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

  Future<List<RoleScreen>> getRoleScreenMapping(String roleScreen) async {


    String requestBody = "";
    var response = await client1.put('$baseUrl/api/rolescreen/getrolescreenwithdescription',headers:{'Content-Type': 'application/json','Authorization':'Bearer $token'},
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



  Future<List<RoleScreen>> submitNewRoleScreenMapping(
      List<RoleScreen> listofrolescreen) async {
    print(listofrolescreen);
    String requestBody = json.encode(listofrolescreen);
    print(requestBody);


    var response = await client1.put('$baseUrl/api/rolescreen/addrolescreen',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      List<dynamic> rolescreenmappingData = json.decode(response.body);
      List<RoleScreen> rolescreenrequests = rolescreenmappingData
          .map((rolescreenmappingData) => RoleScreen.fromMap(rolescreenmappingData))
          .toList();
      print(rolescreenmappingData);
      return rolescreenmappingData;

    } else {
      throw Exception('Failed to get data');
    }
  }

  Future<List<RoleScreen>> submitDeleteRoleScreenMapping(
      List<RoleScreen> listofrolescreenmap) async {
    print(listofrolescreenmap);
    String requestBody = json.encode(listofrolescreenmap);
    print(requestBody);


    var response = await client1.put('$baseUrl/api/rolescreen/deleterolescreen',
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"}, body: requestBody);

    print(response.body);
    print(response.statusCode);

    if (response.statusCode == 200) {
      List<dynamic> rolescreenmappingData = json.decode(response.body);
      List<RoleScreen> rolescreen = rolescreenmappingData
          .map((rolescreenmappingData) => RoleScreen.fromMap(rolescreenmappingData))
          .toList();
      print(rolescreen);
      return rolescreen;

    } else {
      throw Exception('Failed to get data');
    }
  }

}
