import 'dart:async';

abstract class INotificationRestApi {

  Future<Map<String, dynamic>> getData();

  void respondToNotification(var callback, String id, bool response);
}

