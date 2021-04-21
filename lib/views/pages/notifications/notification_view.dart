import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/views/pages/admin/admin_view.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Discard notification bug fixed
//Tile text color bug fixed

/* The view for the notifications */
final NotificationViewModel notificationPageVM =
    NotificationViewModel(apiSvc: NotificationManager());

class NotificationView extends StatefulWidget {
  final String title = "Notifications";
  final String screenName = SCR_NTF;
  @override
  State<StatefulWidget> createState() {
    return new NotificationViewState();
  }
}

class NotificationViewState extends State<NotificationView> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  //final Firestore _db = Firestore.instance;
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
            access.elementAt(1).toLowerCase() == "true" ? true : false;
      });
      notificationPageVM.accessTypes = accessTypes;
    });
  }
  // //Get current date & compare for Today's notification (NOT USED)
  // bool compareNotificationDate(NotificationModel data) {
  //   String now = DateFormat("yyyy-MM-dd").format(DateTime.now());
  //   if (data.createdAt.toString().substring(0, 10) == now)
  //     return true;
  //   else
  //     return false;
  // }

  //Yet to be approved events
  Widget CustomTile(NotificationModel data, var callback) {
    return Container(
      margin: EdgeInsets.all(5),
      child: FlatButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.grey[400], width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(top: 10, left: 20, bottom: 0, right: 20),
          onPressed: () {
            //Screen doesn't pop. User, team lead should be able to view admin panel until ntf is not accepted or declined
            // Navigator.pop(context);
            // Navigator.push(
            //     context, MaterialPageRoute(builder: (context) => AdminView()));
          },
          child: Column(children: [
            Container(
              height: 120,
              child: Column(
                children: <Widget>[
                  Row(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Consumer<ThemeNotifier>(
                                      builder: (context, notifier, child) =>
                                          Text(
                                        data.message,
                                        //maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: notifier.darkTheme
                                                ? Colors.white
                                                : Colors.black),
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      data.createdAt
                                          .toString()
                                          .substring(11, 16),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 10, top: 3),
                                    child: Consumer<ThemeNotifier>(
                                      builder: (context, notifier, child) =>
                                          Text(
                                        'By ' + data.createdBy.toString(),
                                        overflow: TextOverflow.clip,
                                        style: TextStyle(
                                          //fontWeight: FontWeight.w300,
                                          color: notifier.darkTheme
                                              ? Colors.white
                                              : Colors.grey[500],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      data.createdAt
                                          .toString()
                                          .substring(0, 10),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(color: Colors.grey[500]),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FlatButton(
                          textColor: KirthanStyles.colorPallete60,
                          color: KirthanStyles.colorPallete30,
                          child: Text('Accept'),
                          onPressed: () {
                            notificationPageVM.updateNotifications(
                                callback, data.uuid, true);
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.grey[700],
                                width: 1,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textColor: Colors.grey[700],
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
          ])),
    );
  }

  Widget _buildNotification(NotificationModel data, bool flag) {
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
    //TODO for update action == null (Check Server code)
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
          flag
              ? notificationPageVM.getNotificationsBySpec("Today")
              : notificationPageVM.getNotifications();
        });
      });
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     SizedBox(
    //       height: 10,
    //     ),
    //     Row(
    //       children: [
    //         SizedBox(
    //           width: 10,
    //         ),
    //         Text(
    //           "Today",
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ],
    //     ),
    //     CustomTile(data, () {
    //       setState(() {
    //         notificationPageVM.getNotificationsBySpec("TODAY");
    //       });
    //     }),
    //     Divider(),
    //     Row(
    //       children: [
    //         SizedBox(
    //           width: 10,
    //         ),
    //         Text(
    //           "Pending Notifications",
    //           style: TextStyle(
    //             fontWeight: FontWeight.bold,
    //           ),
    //         ),
    //       ],
    //     ),
    //     CustomTile(data, () {
    //       setState(() {
    //         notificationPageVM.getNotificationsBySpec("NOT TODAY");
    //       });
    //     }),
    //   ],
    // );
    else if (icon == null)
      //user accept, reject ntf layout
      return Container(
        margin: EdgeInsets.all(5),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.grey[400],
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    dense: false,
                    contentPadding: EdgeInsets.all(5),
                    title: data.message.contains("Rejected")
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Rejected",
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : data.message.contains("Registered")
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Registered",
                                    style: TextStyle(
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )
                            : data.message
                                    .contains("Request to update an event")
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Updated",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Accepted",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                    subtitle: data.message.contains("Registered")
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.message,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data.message +
                                    " by " +
                                    data.createdBy.toString(),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                    //isThreeLine: true,
                    //trailing:
                    onTap: () {
                      showNotification(context, data, () {
                        setState(() {
                          notificationPageVM.getNotifications();
                        });
                      });
                    }),
              ),
            ]),
      );
    //Team Admin accept, reject ntf layout
    else
      return Container(
        margin: EdgeInsets.all(5),
        child: Column(
            //mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FlatButton(
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: Colors.grey[400],
                        width: 1,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                    dense: false,
                    contentPadding: EdgeInsets.all(5),
                    title: Text(
                      data.message,
                      overflow: TextOverflow.clip,
                    ),
                    subtitle: Text(
                      "By " + data.createdBy.toString(),
                    ),
                    //isThreeLine: true,
                    trailing: icon == Icons.pause
                        ? actions
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data.createdAt.toString().substring(11, 16),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                data.createdAt.toString().substring(0, 10),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              icon == Icons.close
                                  ? Text(
                                      "Rejected",
                                      style: TextStyle(
                                        color: Colors.red,
                                      ),
                                    )
                                  : Text(
                                      "Accepted",
                                      style: TextStyle(
                                        color: Colors.green,
                                      ),
                                    ),
                            ],
                          ),
                    onTap: () {
                      showNotification(context, data, () {
                        setState(() {
                          flag
                              ? notificationPageVM
                                  .getNotificationsBySpec("Today")
                              : notificationPageVM.getNotifications();
                        });
                      });
                    }),
              ),
            ]),
      );
  }

  List<NotificationModel> ntfList = new List<NotificationModel>();
  @override
  void initState() {
    super.initState();
    loadPref();
    print(notificationPageVM.newNotificationCount);
    //notificationPageVM.newNotificationCount;
    //  print(context);
    //NotificationViewModel _nvm =  ScopedModel.of<NotificationViewModel>(context);
    //_nvm.notificationCount = 0;
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // notificationPageVM.getNotificationsBySpec("Today");
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
      drawer: MyDrawer(),
      body: RefreshIndicator(
        key: refreshKey,
        child:
            // FutureBuilder(
            //     future: notificationPageVM.getNotificationsBySpec("Today"),
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         ntfList = snapshot.data;
            //         print(ntfList);
            //         return ntfList.isNotEmpty
            //             ? Column(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Text(
            //                     "Today",
            //                     style: TextStyle(
            //                       fontWeight: FontWeight.bold,
            //                     ),
            //                   ),
            //                   Divider(),
            //                   Expanded(
            //                     child: ListView.builder(
            //                         itemBuilder: (context, itemCount) =>
            //                             _buildNotification(
            //                                 snapshot.data[itemCount], true),
            //                         itemCount: snapshot.data.length),
            //                   ),
            //                 ],
            //               )
            //             : Container();
            //       } else if (snapshot.hasError) {
            //         print(snapshot);
            //         print(snapshot.error.toString() + " Error ");
            //         return Center(child: Text('Error loading notifications'));
            //       } else {
            //         return Center(child: CircularProgressIndicator());
            //       }
            //     }),
            FutureBuilder(
                future: notificationPageVM.getNotifications(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemBuilder: (context, itemCount) =>
                            _buildNotification(snapshot.data[itemCount], false),
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
    if (notification.action == "waiting") setAction = true;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text(notification.message),
              title: Center(
                child: Text(
                  "Notification Alert!",
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("View"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AdminView()));
                  },
                ),
                FlatButton(
                    child: Text("Discard"),
                    onPressed: () {
                      setState(() {
                        Map<String, dynamic> processrequestmap =
                            new Map<String, dynamic>();
                        processrequestmap["id"] = notification.id;
                        print(notification.id);
                        notification.message.contains("Your") ||
                                notification.message.contains("Registered")
                            ? notificationPageVM.deleteNotification(
                                processrequestmap, false)
                            : notificationPageVM.deleteNotification(
                                processrequestmap, true);
                        Navigator.pop(context);
                      });
                    }),
              ],
            ));
  }
}
