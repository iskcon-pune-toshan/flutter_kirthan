import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/services/notification_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';

//Modified for getNotificationsBySpec to seperate Today's & rest notifications.
class NotificationViewModel extends Model {
  Future<List<NotificationModel>> _notifications;
  final INotificationRestApi apiSvc;
  Map<String, bool> accessTypes;
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
    //print(expectedData);
    return expectedData;
  }

  //geting today's ntfs
  Future<List<NotificationModel>> getNotificationsBySpec(String ntfType) async {
    List<NotificationModel> expectedData =
        await apiSvc?.getNotificationsBySpec(ntfType);
    return expectedData;
  }

  Future<bool> updateNotifications(var callback, String id, bool response) {
    apiSvc?.respondToNotification(callback, id, response);
    return Future.value(true);
  }

  Future<bool> deleteNotification(
      Map<String, dynamic> processrequestmap, bool response) {
    Future<bool> deleteFlag;
    //response = 0 => delete notification from notification table
    //response = 1 => delete notification from notification approval table
    if (response)
      deleteFlag = apiSvc?.deleteNotificationApproval(processrequestmap);
    else
      deleteFlag = apiSvc?.deleteNotification(processrequestmap);
    return deleteFlag;
  }
}
