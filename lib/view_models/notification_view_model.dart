
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
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

  Future<void> getNotifications() async{
   Future<Map<String,dynamic>> data = apiSvc?.getData();
   List<NotificationModel> notifications = <NotificationModel>[];
    await data.then((value){
     List<NotificationModel> ntf = value["ntf"].map<NotificationModel>((e) => NotificationModel.fromJson(e)).toList();
     List<NotificationModel> ntf_appr = value["ntf_appr"].map<NotificationModel>((e) => NotificationModel.fromJson(e)).toList();
     /*int size =0 ;
     notifications.length = ntf.length + ntf_appr.length;
     int i=0,j=0;
     while(size< notifications.length){
       notifications[size] = ntf[]
     }*/
     notifications.addAll(ntf);
     notifications.addAll(ntf_appr);
    });
  return notifications;
  }

  Future<bool> updateNotifications(var callback, String id, bool response){
    apiSvc?.respondToNotification(callback, id, response);
    return Future.value(true);
  }
}