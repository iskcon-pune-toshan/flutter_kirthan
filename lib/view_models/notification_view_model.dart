import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/services/notification_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationViewModel extends Model {
  Future<List<NotificationModel>> _notifications;
  final INotificationRestApi apiSvc;
  NotificationViewModel({this.apiSvc});
  Future<List> get notifications => _notifications;
  int _unreadNotificationCount = 0;

  int get newNotificationCount => _unreadNotificationCount;

  set notificationCount(int count) {
    _unreadNotificationCount = count;
    notifyListeners();
  }

  set notification(Future<List<NotificationModel>> notifications) {
    this._notifications = notifications;
    notifyListeners();
  }

  Future<List<NotificationModel>> getNotifications() async {
    List<NotificationModel> expectedData = await apiSvc?.getData();
    print(expectedData);
    return expectedData;
  }

  Future<bool> updateNotifications(var callback, String id, bool response) {
    apiSvc?.respondToNotification(callback, id, response);
    return Future.value(true);
  }

  Future<bool> deleteNotification(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deleteNotification(processrequestmap);
    return deleteFlag;
  }
}
