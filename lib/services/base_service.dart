import 'package:http/http.dart' as http;

abstract class BaseAPIService {
  //final baseUrl = 'http://10.0.2.2:8080';
  //final baseUrl = 'http://192.168.1.7:8080'; // Janice

  final baseUrl = 'http://192.168.1.6:8080'; //Manju
  //final baseUrl = 'http://164.52.202.23:8080'; //server
  http.Client client1 = http.Client();

  final int userId = 4;

  set client(http.Client value) => client1 = value;
}