import 'dart:io';
import 'package:flutter_kirthan/models/notification.dart';
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

  Future<List<NotificationModel>> getData() async {
    String token = AutheticationAPIService().sessionJWTToken;
    print("Jwt token"+ token);
    _http.Response response = await _http.get("$baseUrl/notifications",headers: {'Content-Type':'application/json','Authorization': 'Bearer $token'});
    List<dynamic> data = convert.jsonDecode(response.body);
   // List<NotificationModel> expectedData =
    return data.map((element) =>NotificationModel.fromJson(element)).toList();
    //return expectedData;
  }

  void getToken(String deviceToken) async {
    String token = AutheticationAPIService().sessionJWTToken;
    Map<String, Object> body;
    body = {
      "deviceToken": deviceToken,
    };
    var bodyData = convert.jsonEncode(body);
   _http.Response response = await _http.put("$baseUrl/tokens",
        headers: {"Content-Type": "application/json",'Authorization':'Bearer $token'},
        body: bodyData);
  }

  void respondToNotification(var callback,String id, bool response) async {
      String token = AutheticationAPIService().sessionJWTToken;
      String tempUrl = "$baseUrl/notifications/update";
    Map<String, Object> data = {"response": response ? 1 : 0,"ntfId":id};
    var body = convert.jsonEncode(data);
    _http.Response resp = await _http.put(tempUrl,
        body: body, headers: {"Content-Type": "application/json",'Authorization':'Bearer $token'});
    var respData = convert.jsonDecode(resp.body);
    print(resp.statusCode);
    if(callback != null)
      callback();
  }

}
