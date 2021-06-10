import 'package:flutter_kirthan/models/notification.dart';

abstract class INotificationRestApi {
  Future<List<NotificationModel>> getData();

  Future<List<NotificationModel>> getNotificationsBySpec(String ntfType);

  void respondToNotification(var callback, String id, bool response);

  Future<bool> deleteNotification(Map<String, dynamic> processrequestmap);

  Future<bool> deleteNotificationApproval(
      Map<String, dynamic> processrequestmap);
}
