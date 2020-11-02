
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

  Future<List<NotificationModel>> getNotifications() async{
    //print("get Notifications method called");
    Map<String,dynamic> data = await apiSvc?.getData();
    List<NotificationModel> notifications = <NotificationModel>[];
    //print(data["ntf"]);
    List<NotificationModel> ntf = data["ntf"]
         .map<NotificationModel>((e) => NotificationModel.fromJson(e))
         .toList();

     List<NotificationModel> ntfAppr = data["ntf_appr"]
         .map<NotificationModel>((e) => NotificationModel.fromJson(e))
         .toList();
     int size = 0;
     notifications.length = ntf.length + ntfAppr.length;
     int i = 0, j = 0;
     while (size < notifications.length) {
       if(i<ntf.length && j<ntfAppr.length){
         if(ntf[i].createdAt.isAfter(ntf[j].createdAt)){
           notifications[size] = (ntf[i]);
           i+=1;
         }
         else{
           notifications[size] = (ntfAppr[j]);
           j+=1;
         }
       }
       else{
         if(i<ntf.length){
           notifications[size] = (ntf[i]);
           i+=1;
         }
         if(j<ntfAppr.length){
           notifications[size] = (ntfAppr[j]);
           j+=1;
         }
       }
       size+=1;
     }
  return Future.value(notifications);
  }

  Future<bool> updateNotifications(var callback, String id, bool response){
    apiSvc?.respondToNotification(callback, id, response);
    return Future.value(true);
  }
}