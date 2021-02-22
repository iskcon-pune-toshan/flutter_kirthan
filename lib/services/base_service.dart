import 'package:http/http.dart' as http;

abstract class BaseAPIService {
  //final baseUrl = 'http://192.168.43.222:8080'; //Nisha

  final baseUrl = 'http://172.20.10.2:8085'; //Manjunath Sir
 // final baseUrl = 'http://164.52.202.127:8080'; //server

  http.Client client1 = http.Client();

  final int userId = 4;

  set client(http.Client value) => client1 = value;
}