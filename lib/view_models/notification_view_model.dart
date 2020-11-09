import 'dart:math';

import 'package:flutter_kirthan/models/notification.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationViewModel extends Model {
  Future<List<NotificationModel>> _notifications;
  final apiSvc;
  NotificationViewModel({this.apiSvc});
  Future<List> get notifications => _notifications;
  int _unreadNotificationCount = 0;

  int get newNotificationCount => _unreadNotificationCount;

  set notificationCount(int count){
    _unreadNotificationCount = count;
    notifyListeners();
  }

  set notification(Future<List<NotificationModel>> notifications){
    this._notifications = notifications;
    notifyListeners();
  }

  Future<List<NotificationModel>> getNotifications() async {
    return await apiSvc?.getData();
  }


  Future<bool> updateNotifications(var callback, String id, bool response){
    apiSvc?.respondToNotification(callback, id, response);
    return Future.value(true);
  }

}