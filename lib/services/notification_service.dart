import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as _http;
import 'dart:convert' as convert;
import 'package:flutter_kirthan/services/base_service.dart';

class NotificationManager extends BaseAPIService {
  static final NotificationManager _nm = NotificationManager.internal();

  factory NotificationManager() {
    return _nm;
  }

  NotificationManager.internal() {
    init();
  }

  Future<void> _createNotificationChannel(
      String id, String name, String description) async {
    final flutterLocalNotificationPlugin = FlutterLocalNotificationsPlugin();
    var androdiNotificationChannel = AndroidNotificationChannel(
      id,
      name,
      description,
    );
    await flutterLocalNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androdiNotificationChannel);
  }

  void init() {
    if (Platform.operatingSystem == "Android")
      _createNotificationChannel('Kirtan@ISKON', 'Kirtan Notifications',
              'Default Channel for Kirtan notification')
          .then((value) => print("Channel Created"));
    FirebaseMessaging _fcm = FirebaseMessaging();
    Map<String, Object> body;
    try {
      _fcm.getToken().then((deviceToken) {
        print(deviceToken);
        body = {
          "deviceToken": deviceToken,
        };
        var bodyData = convert.jsonEncode(body);
        _http.put("$baseUrl/tokens",
                    headers: {"Content-Type": "application/json"},
                    body: bodyData);
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

  void respondToNotification(var callback,
      String id, bool response, BuildContext context) async {
    String tempUrl = "$baseUrl/$userId/notifications/$id";
    print(tempUrl);
    Map<String, Object> data = {"response": response ? 1 : 0, "userId": 3};
    var body = convert.jsonEncode(data);
    _http.Response resp = await _http.put(tempUrl,
        body: body, headers: {"Content-Type": "application/json"});
    var respData = convert.jsonDecode(resp.body);
    if(callback != null)
      callback();
    Navigator.pop(context);
  }

  void showNotification(BuildContext context, Map<String, dynamic> message,var callback) {
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
                        onPressed: () =>
                            respondToNotification(callback,message["id"], true, context))
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
                        onPressed: () => respondToNotification(
                            callback,message["id"], false, context),
                      )
                    : FlatButton(
                        child: Text("Discard"),
                        onPressed: () => Navigator.pop(context),
                      ),
              ],
            ));
  }

  void initMessageHandler(BuildContext context) {
    FirebaseMessaging _fcm = new FirebaseMessaging();
    _fcm.requestNotificationPermissions();
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("Configuration Called : Here");
          showNotification(context, message,null);
          return Future.value(null);
        },
        onBackgroundMessage: null,
        onLaunch: (Map<String, Object> message) async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationView()));
          return Future.value(null);
        },
        onResume: (Map<String, Object> message) {

          Navigator.push(context,MaterialPageRoute(builder: (context)=> NotificationView()));
      //    showNotification(context, message,null);
          return Future.value(null);
        });
  }
}
