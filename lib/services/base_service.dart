import 'package:http/http.dart' as http;

abstract class BaseAPIService {
  final baseUrl = "http://164.52.202.23:8080";
  http.Client client1 = http.Client();
  set client(http.Client value) => client1 = value;
}
