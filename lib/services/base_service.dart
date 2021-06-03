import 'package:http/http.dart' as http;

abstract class BaseAPIService {
 // final baseUrl = 'http://164.52.202.127:9090';  //server
 final baseUrl = 'http://kirtanappprod.kairavalabs.com:8080'; // Production
 // final baseUrl = 'http://kirtanappdev.kairavalabs.com:9090'; // Development


  http.Client client1 = http.Client();

  final int userId = 4;

  set client(http.Client value) => client1 = value;
}
