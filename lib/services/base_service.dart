import 'package:http/http.dart' as http;

class BaseAPIService {
  final _baseUrl = 'http://192.168.1.8:8080'; //Manju
  http.Client _client = http.Client();

  set client(http.Client value) => _client = value;

  static final BaseAPIService _internal = BaseAPIService.internal();

  factory BaseAPIService() => _internal;

  BaseAPIService.internal();


}