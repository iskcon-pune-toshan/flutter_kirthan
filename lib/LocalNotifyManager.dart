import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'dart:io' show Platform;

class LocalNotifyManager{
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  var initSetting;
  // int id = random
  BehaviorSubject<ReceivedNotification> get didReceivedLocalNotificationSubject =>
      BehaviorSubject<ReceivedNotification>();

  LocalNotifyManager.init(){
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if(Platform.isIOS){
      requestIOSPermission();
    }
    initializePlatform();
  }

  requestIOSPermission(){
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  initializePlatform(){
    var initSettingAndroid = AndroidInitializationSettings('app_notification');
    var initSettingIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (id, title, body, payload)async {
          ReceivedNotification notification = ReceivedNotification(id, title, body, payload);
          didReceivedLocalNotificationSubject.add(notification);
        }
    );
    initSetting = InitializationSettings(initSettingAndroid,initSettingIOS);
  }

  setOnNotificationReceived(Function onNotificationReceived){
    didReceivedLocalNotificationSubject.listen((notification) {
      onNotificationReceived(notification);
    });
  }
  seOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initSetting,
        onSelectNotification: (String payload)async{
          onNotificationClick(payload);
        });
  }

  Future<void> showNotification(String title, String body) async{
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      playSound: true,
      priority: Priority.High,
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    await flutterLocalNotificationsPlugin.show(
        0,
        title,
        body,
        platformChannel,
        payload: 'New Payload');
  }


  Future<void> scheduleNotification(String title, String body, DateTime date1) async{
    var androidChannel = AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL_DESCRIPTION',
      importance: Importance.Max,
      playSound: true,
      priority: Priority.High,
      styleInformation: BigTextStyleInformation('')
    );
    var iosChannel = IOSNotificationDetails();
    var platformChannel = NotificationDetails(androidChannel, iosChannel);
    DateTime date = DateTime.now().add(Duration(seconds: 5));
    await flutterLocalNotificationsPlugin.schedule(
        0,
        title,
        body,
        date1,
        platformChannel,
        payload: 'New Payload');
  }
}
LocalNotifyManager localNotifyManager = LocalNotifyManager.init();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;
  ReceivedNotification(@required this.id, @required this.title, @required this.body, @required this.payload);
}