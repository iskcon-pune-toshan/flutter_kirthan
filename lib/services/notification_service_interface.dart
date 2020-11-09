import 'package:flutter_kirthan/models/notification.dart';

abstract class INotificationRestApi {

  Future<List<NotificationModel>> getData();

  void respondToNotification(var callback, String id, bool response);
}

