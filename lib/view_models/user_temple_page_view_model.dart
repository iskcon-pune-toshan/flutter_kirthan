import 'dart:async';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/user_temple_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/temple_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';


class UserTemplePageViewModel extends Model {
  Future<List<UserTemple>> _userTemples;
  final IUserTempleRestApi apiSvc;
  Map<String,bool> accessTypes;

  UserTemplePageViewModel({@required this.apiSvc});

  Future<List<UserTemple>> get userTemples => _userTemples;

  set userTemple(Future<List<UserTemple>> value) {
    _userTemples = value;
    notifyListeners();
  }

  Future<List<UserTemple>> getUserTempleMapping(String userTempleMapping) {
    Future<List<UserTemple>> usertemples = apiSvc?.getUserTempleMapping(userTempleMapping);
    return usertemples;
  }

  Future<List<UserTemple>> submitNewUserTempleMapping(
      List<UserTemple> listofusertemplemap) {
    Future<List<UserTemple>> usertemples =
    apiSvc?.submitNewUserTempleMapping(listofusertemplemap);
    return usertemples;
  }

  Future<List<UserTemple>> submitDeleteUserTempleMapping(
      List<UserTemple> listofusertemplemap) {
    Future<List<UserTemple>> usertemples =
    apiSvc?.submitDeleteUserTempleMapping(listofusertemplemap);
    return usertemples;
  }
}