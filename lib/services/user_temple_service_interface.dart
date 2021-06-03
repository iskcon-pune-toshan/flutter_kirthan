import 'dart:async';
import 'package:flutter_kirthan/models/usertemple.dart';

abstract class IUserTempleRestApi {
  Future<List<UserTemple>> getUserTempleMapping(String userTempleMapping);

  Future<List<UserTemple>> submitNewUserTempleMapping(
      List<UserTemple> listofusertemplemap);

  Future<List<UserTemple>> submitDeleteUserTempleMapping(
      List<UserTemple> listofusertemplemap);
}
