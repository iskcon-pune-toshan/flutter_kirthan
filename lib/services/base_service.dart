import 'package:http/http.dart' as http;

abstract class BaseAPIService {
  //final baseUrl = 'http://10.0.2.2:8080';
  //final baseUrl = 'http://192.168.1.7:8080'; // Janice

  final baseUrl = 'http://192.168.1.9:8080'; //Manju
  final int userId = 4;
  http.Client client1 = http.Client();

  set client(http.Client value) => client1 = value;
}