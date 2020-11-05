import 'dart:io';
import 'package:flutter_kirthan/services/firebasemessage_service.dart';
import 'package:http/http.dart' as _http;
import 'dart:convert' as convert;
import 'package:flutter_kirthan/services/base_service.dart';

import 'notification_service_interface.dart';
import './authenticate_service.dart';

class NotificationManager extends BaseAPIService implements INotificationRestApi{
  static final NotificationManager _internal = NotificationManager.internal();
  factory NotificationManager() => _internal;
  NotificationManager.internal() {
    init();
  }


  void init()  {
    FirebaseMessageService fms = new FirebaseMessageService();
    if (Platform.operatingSystem == "Android")
      fms.createNotificationChannel('Kirtan@ISKON', 'Kirtan Notifications',
          'Default Channel for Kirtan notification')
          .then((value) => print("Channel Created"));
    try {
      fms.getFBToken().then((deviceToken) {
        print(deviceToken);
        getToken(deviceToken);
      });
    } catch (Exception) {
      print("Error uploading token");
    }
  }

  Future<Map<String, dynamic>> getData() async {
    String token = AutheticationAPIService().sessionJWTToken;
    print(token);
    _http.Response response = await _http.get("$baseUrl/$userId/notifications",headers: {"Content-Type": "application/json","Authorization": "Bearer $token"});

    var data = convert.jsonDecode(response.body);
    return data;
  }

  void getToken(String deviceToken) async {
    String token = AutheticationAPIService().sessionJWTToken;
    print(token);
    Map<String, Object> body;
    body = {
      "deviceToken": deviceToken,
    };
    var bodyData = convert.jsonEncode(body);
    _http.put("$baseUrl/tokens",
        headers: {"Content-Type": "application/json","Authorization": "Bearer $token"},
        body: bodyData);
  }

  void respondToNotification(var callback,String id, bool response) async {
      String token = AutheticationAPIService().sessionJWTToken;
      print(token);
      String tempUrl = "$baseUrl/$userId/notifications/$id";
    print(tempUrl);
    Map<String, Object> data = {"response": response ? 1 : 0, "userId": 3};
    print(data);
    var body = convert.jsonEncode(data);
    _http.Response resp = await _http.put(tempUrl,
        body: body, headers: {"Content-Type": "application/json","Authorization": "Bearer $token"});
    var respData = convert.jsonDecode(resp.body);
    if(callback != null)
      callback();
    //Navigator.pop(context);
  }



}
