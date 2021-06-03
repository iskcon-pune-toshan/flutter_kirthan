import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:scoped_model/scoped_model.dart';

class FirebaseMessageService {
  static final FirebaseMessageService _internal =
      FirebaseMessageService.internal();

  final FirebaseMessaging _fcm = FirebaseMessaging();

  factory FirebaseMessageService() => _internal;

  FirebaseMessageService.internal();

  void initMessageHandler(BuildContext context) {
    _fcm.requestNotificationPermissions();
    _fcm.configure(
        onMessage: (Map<String, dynamic> message) async {
          print("Configuration Called : Here");
          try {
            NotificationViewModel _temp =
                ScopedModel.of<NotificationViewModel>(context);
            _temp.notificationCount = _temp.newNotificationCount + 1;
          } catch (Exception) {
            print(Exception);
          }
          return Future.value(null);
        },
        onBackgroundMessage: null,
        onLaunch: (Map<String, Object> message) async {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationView()));
          return Future.value(null);
        },
        onResume: (Map<String, Object> message) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NotificationView()));
          //    showNotification(context, message,null);
          return Future.value(null);
        });
  }

  Future<void> createNotificationChannel(
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

  Future<String> getFBToken() {
    try {
      _fcm.onTokenRefresh.listen((event) {
        return true;
      });
      return _fcm.getToken();
    } catch (Exception) {
      print("Error uploading token");
    }
  }
}
