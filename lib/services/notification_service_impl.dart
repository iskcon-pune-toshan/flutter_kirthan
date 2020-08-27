import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/firebasemessage_service.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as _http;
import 'dart:convert' as convert;
import 'package:flutter_kirthan/services/base_service.dart';

import 'notification_service_interface.dart';

class NotificationManager extends BaseAPIService implements INotificationRestApi{


  static final NotificationManager _internal = NotificationManager.internal();

  factory NotificationManager() => _internal;

  NotificationManager.internal() {
    init();
  }


  void init() {
    FirebaseMessageService fms = new FirebaseMessageService();
    if (Platform.operatingSystem == "Android")
      fms.createNotificationChannel('Kirtan@ISKON', 'Kirtan Notifications',
          'Default Channel for Kirtan notification')
          .then((value) => print("Channel Created"));
    //FirebaseMessaging _fcm = FirebaseMessaging();
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
    _http.Response response = await _http.get("$baseUrl/$userId/notifications");
    var data = convert.jsonDecode(response.body);
    print(data);
    return data;
  }

  void getToken(String deviceToken) async {
    Map<String, Object> body;
    body = {
      "deviceToken": deviceToken,
    };
    var bodyData = convert.jsonEncode(body);
    _http.put("$baseUrl/tokens",
        headers: {"Content-Type": "application/json"},
        body: bodyData);
  }


//  void respondToNotification(var callback,
//      String id, bool response, BuildContext context) async {

    void respondToNotification(var callback,
        String id, bool response) async {
    String tempUrl = "$baseUrl/$userId/notifications/$id";
    print(tempUrl);
    Map<String, Object> data = {"response": response ? 1 : 0, "userId": 3};
    var body = convert.jsonEncode(data);
    _http.Response resp = await _http.put(tempUrl,
        body: body, headers: {"Content-Type": "application/json"});
    var respData = convert.jsonDecode(resp.body);
    if(callback != null)
      callback();
    //Navigator.pop(context);
  }

/*  void showNotification(BuildContext context, Map<String, dynamic> message,var callback) {
    print("Method called");
    bool setAction = false;
    print("message:" + message.toString());
    if (message["action"] == "WAIT") setAction = true;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(message["notification"] == null ? message["message"]:message["notification"]["body"]),
          title: Text("New Notifications"),
              actions: <Widget>[
                setAction
                    ? FlatButton(
                        child: Text("Approve"),
                        onPressed: () {
                            respondToNotification(callback,message["id"], true);
                          Navigator.pop(context);
                        })
                    : FlatButton(
                        child: Text("View"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationView()));
                        },
                      ),
                setAction
                    ? FlatButton(
                        child: Text("Reject"),
                        onPressed: () {
                          respondToNotification(callback, message["id"], false);
                          Navigator.pop(context);
                        }
                      )
                    : FlatButton(
                        child: Text("Discard"),
                        onPressed: () => Navigator.pop(context),
                      ),
              ],
            ));
  }
  */



}
