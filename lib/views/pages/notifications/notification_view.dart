import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/views/pages/admin/admin_view.dart';

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
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  Widget CustomTile(NotificationModel data, var callback) {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AdminView()));
        },
        child: Column(children: [
          Container(
            height: 120,
            child: Column(
              children: <Widget>[
                Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            data.message,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w400),
                            softWrap: true,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(
                            'CreatedBy' + data.createdBy.toString(),
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                        ),
                      ],
                    )),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        textColor: Colors.black,
                        color: Colors.green,
                        child: Text('Approve'),
                        onPressed: () {
                          notificationPageVM.updateNotifications(
                              callback, data.uuid, true);
                        },
                      ),
                      FlatButton(
                        textColor: Colors.black,
                        color: Colors.red,
                        child: Text('Reject'),
                        onPressed: () {
                          notificationPageVM.updateNotifications(
                              callback, data.uuid, false);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Divider(),
        ]));
  }

  Widget _buildNotification(NotificationModel data) {
    IconData icon;
    Widget actions = Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlatButton(child: Icon(Icons.check)),
              FlatButton(child: Icon(Icons.close)),
            ]));
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
    if (icon == Icons.pause)
      return CustomTile(data, () {
        setState(() {
          notificationPageVM.getNotifications();
        });
      });
    else
      return Column(children: [
        ListTile(
            dense: false,
            contentPadding: EdgeInsets.all(10),
            title: Text(data.message),
            subtitle: Text("CreatedBy " + data.createdBy),
            isThreeLine: true,
            trailing: icon == Icons.pause ? actions : Icon(icon),
            onTap: () {
              showNotification(context, data, () {
                setState(() {
                  notificationPageVM.getNotifications();
                });
              });
            }),
        Divider(),
      ]);
  }

  @override
  void initState() {
    super.initState();
    //  print(context);
    //NotificationViewModel _nvm =  ScopedModel.of<NotificationViewModel>(context);
    //_nvm.notificationCount = 0;
  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      notificationPageVM.getNotifications();
    });

    return null;
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
      body:RefreshIndicator(
        key: refreshKey,
        child:FutureBuilder(
            future: notificationPageVM.getNotifications(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemBuilder: (context, itemCount) =>
                        _buildNotification(snapshot.data[itemCount]),
                    itemCount: snapshot.data.length);
              } else if (snapshot.hasError) {
                print(snapshot);
                print(snapshot.error.toString() + " Error ");
                return Center(child: Text('Error loading notifications'));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
        onRefresh: refreshList,
      ),

    );
  }

  void showNotification(
      BuildContext context, NotificationModel notification, var callback) {
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
                          notificationPageVM.updateNotifications(
                              callback, notification.uuid, true);
                          Navigator.pop(context);
                        })
                    : FlatButton(
                        child: Text("View"),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AdminView()));
                        },
                      ),
                setAction
                    ? FlatButton(
                        child: Text("Reject"),
                        onPressed: () {
                          notificationPageVM.updateNotifications(
                              callback, notification.uuid, false);
                          Navigator.pop(context);
                        })
                    : FlatButton(
                        child: Text("Discard"),
                        onPressed: () => Navigator.pop(context),
                      ),
              ],
            ));
  }
}
