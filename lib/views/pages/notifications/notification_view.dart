
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:scoped_model/scoped_model.dart';


/* The view for the notifications */
final NotificationViewModel notificationPageVM =
NotificationViewModel(apiSvc: NotificationManager());

class NotificationView extends StatefulWidget {
  final String title = "Notifications";
  @override
  State<StatefulWidget> createState() {
    return new NotificationViewState();
  }

}

class NotificationViewState extends State<NotificationView> {

  Widget _buildNotification(NotificationModel data) {
    IconData icon;
    if (data.action == null) {
      icon = null;
    } else {
      String val = data.action;
      val = val.toLowerCase();
      if (val == "rejected")
        icon = Icons.close;
      else if (val == "approved")
        icon = Icons.check;
      else
        icon = Icons.pause;
    }
    return Column(children: [
      ListTile(
          contentPadding: EdgeInsets.all(10),
          title: Text(data.message),
          subtitle: Text("CreatedBy " + data.creatorId.toString()),
          trailing: icon == null ? null : Icon(icon),
          onTap: () {
            //_nm.showNotification(context, data,(){setState(() {
              showNotification(context, data,(){setState(() {
              notificationPageVM.getNotifications();
            });});
          }),
      Divider(),
    ]);
  }

  @override
  void initState(){
    super.initState();
  //  print(context);
   //NotificationViewModel _nvm =  ScopedModel.of<NotificationViewModel>(context);
   //_nvm.notificationCount = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      drawer: Drawer(
        child: Center(child: Text("Drawer placeholder")),
      ),
      body: FutureBuilder(
          future: notificationPageVM.getNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemBuilder: (context, itemCount) =>
                      _buildNotification(snapshot.data[itemCount]),
                  itemCount: snapshot.data.length);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Error loading notifications'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }



  void showNotification(BuildContext context,NotificationModel notification,var callback) {
    bool setAction = false;
    if (notification.action == "WAIT") setAction = true;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(notification.message),
          title: Text("New Notifications"),
          actions: <Widget>[
            setAction
                ? FlatButton(
                child: Text("Approve"),
                onPressed: () {
                  notificationPageVM.updateNotifications(callback,notification.id, true);
                  Navigator.pop(context);
                })
                : FlatButton(
              child: Text("View"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationView()));
              },
            ),
            setAction
                ? FlatButton(
                child: Text("Reject"),
                onPressed: () {
                  notificationPageVM.updateNotifications(callback, notification.id, false);
                  Navigator.pop(context);
                }
            )
                : FlatButton(
              child: Text("Discard"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ));
  }
}
