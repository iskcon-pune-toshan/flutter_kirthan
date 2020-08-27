
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/services/notification_service.dart';
import 'package:scoped_model/scoped_model.dart';

class NotificationViewModel extends Model {
  Future<List<NotificationModel>> _notifications;
  final apiSvc = new NotificationManager();
  Future<List> get notifications => _notifications;

  set notification(Future<List<NotificationModel>> notifications){
    this._notifications = notifications;
    notifyListeners();
  }

  Future<void> getNotifications(){
   Future<Map<String,dynamic>> data = apiSvc.getData();
   List<NotificationModel> notifications;
   data.then((value){
     value.forEach((key, value) {
       notifications.addAll(value.map((value){
         return NotificationModel.fromJson(value);
       }).toList());
     });
   });
   print(notifications);
   return Future.value(notifications);
  }

  Future<bool> updateNotifications(BuildContext context, String id, bool response){
    apiSvc.respondToNotification(null, id, response, context);
    return Future.value(true);
  }
}