import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as _http;
import 'dart:convert' as convert;

class NotificationManager {
  String url = "http://192.168.43.4:8080/";
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
        /*_http.post(
           "http://192.168.43.4:8080/tokens",
           body: bodyData, headers: {"Content-Type": "application/json"});*/
        print(_http
                .put("http://192.168.43.4:8080/tokens",
                    headers: {"Content-Type": "application/json"},
                    body: bodyData)
                .toString() +
            "Updated");
      });
    } catch (Exception) {
      print("Error uploading token");
    }
  }

  void _respondToNotification(
      String id, bool response, BuildContext context) async {
    String tempUrl = url + "/4/notifications/" + id;
    print(tempUrl);
    Map<String, Object> data = {"response": response ? 1 : 0, "userId": 3};
    var body = convert.jsonEncode(data);
    _http.Response resp = await _http.put(tempUrl,
        body: body, headers: {"Content-Type": "application/json"});
    var respData = convert.jsonDecode(resp.body);
    print("Notification update request sent.  Response is :  " +
        resp.statusCode.toString() +
        respData);
    Navigator.pop(context);
  }

  void _showNotification(BuildContext context, Map<String, dynamic> message) {
    bool setAction = false;
    print("message:"+message.toString());
    if (message["action"] != null) setAction = true;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("New Notifications"),
              content: message["message"],
              actions: <Widget>[
                setAction
                    ? FlatButton(
                        child: Text("Approve"),
                        onPressed: () => _respondToNotification(
                            message["data"]["id"], true, context))
                    : FlatButton(
                        child: Text("View"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotificationView()));
                        },
                      ),
                setAction
                    ? FlatButton(
                        child: Text("Reject"),
                        onPressed: () => _respondToNotification(
                            message["data"]["id"], false, context),
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
          _showNotification(context, message);
          return Future.value(null);
        },
        onBackgroundMessage: null,
        onLaunch: (Map<String, Object> message) async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationView()));
          return Future.value(null);
        },
        onResume: (Map<String, Object> message) {
          print(message);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationView()));
          _showNotification(context, message);
          return Future.value(null);
        });
  }
}
