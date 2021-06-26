import 'package:http/http.dart' as http;

abstract class BaseAPIService {
// final baseUrl = 'http://192.168.1.6:9090';  //server
 // final baseUrl = 'http://kirtanappprod.kairavalabs.com:8080'; // Production
 final baseUrl = 'http://kirtanappdev.kairavalabs.com:8080'; // Development
 http.Client client1 = http.Client();
 
  final int userId = 4;

  set client(http.Client value) => client1 = value;
}
