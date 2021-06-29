import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/admin/admin_view.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/pages/team/team_profile_page.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'notificationDetails.dart';

/* The view for the notifications */
final NotificationViewModel notificationPageVM =
NotificationViewModel(apiSvc: NotificationManager());
final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());
final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());
final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());

class NotificationView extends StatefulWidget {
  final String title = "Notifications";
  final String screenName = SCR_NTF;
  @override
  State<StatefulWidget> createState() {
    return new NotificationViewState();
  }
}

class NotificationViewState extends State<NotificationView> {
  // int teamId;
  String teamLead;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  //final Firestore _db = Firestore.instance;
  // final FirebaseMessaging _fcm = FirebaseMessaging();
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();
  bool isVisible = false;
  List<UserRequest> userRequest = new List<UserRequest>();
  UserRequest userRequestTeam = new UserRequest();
  UserRequest localAdminTeam = new UserRequest();

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      /*access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
            access.elementAt(1).toLowerCase() == "true" ? true : false;
      });*/
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  getRoleId() async {
    final FirebaseUser user = await auth.currentUser();
    userRequest = await userPageVM.getUserRequests("Approved");
    List<UserRequest> temp =
    userRequest.where((element) => element.email == user.email).toList();
    for (var users in temp) {
      if (users.roleId == 1 || users.roleId == 2) {
        setState(() {
          isVisible = true;
        });
      } else {
        setState(() {
          isVisible = false;
        });
      }
    }
  }

  //Yet to be approved events
  Widget CustomTile(NotificationModel data, var callback) {
    String createdAt = DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(data.createdAt.toString())
        .add(Duration(hours: 5, minutes: 30)))
        .toString();
    String updatedAt = DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(data.updatedAt.toString())
        .add(Duration(hours: 5, minutes: 30)))
        .toString();
    return Container(
      margin: EdgeInsets.all(5),
      child: FlatButton(
          shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.grey[400], width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(10)),
          padding: EdgeInsets.only(top: 10, left: 20, bottom: 0, right: 20),
          onPressed: () async {
            if (data.targetType.contains("event") ||
                data.message.contains("event")) {
              List<UserRequest> user =
              await userPageVM.getUserRequests(data.createdBy);
              String userName = " ";
              for (var u in user) {
                userName = u.fullName;
              }

              String eventId = data.targetId.toString();
              List<EventRequest> eventList =
              await eventPageVM.getEventRequests("event_id:$eventId");
              EventRequest eventRequest = new EventRequest();
              for (var event in eventList) {
                eventRequest = event;
              }
              WidgetsBinding.instance.addPostFrameCallback((_) {

              });
            } else {
              getTeamId(data.message.split("\"")[1], "Waiting");
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationDetails(
                          eventId: null,
                          teamLeadId: teamLead,
                          status: "Waiting")));
            }
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: Consumer<ThemeNotifier>(
                                        builder: (context, notifier, child) =>
                                            Text(
                                              data.message,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: notifier.darkTheme
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt.toString().substring(11, 19),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                      ),
                                    )
                                        :Text(
                                      updatedAt.toString().substring(11, 19),
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
                                            data.message.contains("Your")
                                                ? "By " + data.updatedBy.toString()
                                                : "By " + data.createdBy.toString(),
                                            overflow: TextOverflow.clip,
                                            style: TextStyle(
                                              color: notifier.darkTheme
                                                  ? Colors.white
                                                  : Colors.grey[500],
                                            ),
                                          ),
                                    ),
                                  ),
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt.toString().substring(0, 10),
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(color: Colors.grey[500]),
                                    )
                                        :Text(
                                      updatedAt.toString().substring(0, 10),
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
                          color: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          textColor: KirthanStyles.colorPallete60,
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
    String createdAt = DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(data.createdAt.toString())
        .add(Duration(hours: 5, minutes: 30)))
        .toString();
    String updatedAt = DateFormat('yyyy-MM-dd HH:mm a').format(DateTime.parse(data.updatedAt.toString())
        .add(Duration(hours: 5, minutes: 30)))
        .toString();
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
          flag
              ? notificationPageVM.getNotificationsBySpec("Today")
              : notificationPageVM.getNotifications();
        });
      });
    else if (icon == null)
      //user accept, reject ntf layout
      return Container(
        margin: EdgeInsets.all(5),
        child: Column(
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
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rejected",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: updatedAt==null?Text(
                                    createdAt
                                        .toString()
                                        .substring(11, 19),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  )
                                      :Text(
                                    updatedAt
                                        .toString()
                                        .substring(11, 19),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: updatedAt==null?Text(
                                    createdAt.toString().substring(0, 10),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  )
                                      :Text(
                                    updatedAt.toString().substring(0, 10),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  )
                                ),
                              ],
                            )
                          ],
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
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Registered",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: updatedAt==null?Text(
                                    createdAt
                                        .toString()
                                        .substring(11, 19),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  )
                                      :Text(
                                    updatedAt
                                        .toString()
                                        .substring(11, 19),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: updatedAt==null?Text(
                                    createdAt
                                        .toString()
                                        .substring(0, 11),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  )
                                      :Text(
                                    updatedAt
                                        .toString()
                                        .substring(0, 11),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
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
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Updated",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.end,
                              children: [
                                Container(
                                  child: updatedAt==null?Text(
                                    createdAt
                                        .toString()
                                        .substring(11, 19),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ):Text(
                                    updatedAt
                                        .toString()
                                        .substring(11, 19),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),

                                ),
                                Container(
                                  child: updatedAt==null?Text(
                                    createdAt
                                        .toString()
                                        .substring(0, 10),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ):Text(
                                    updatedAt
                                        .toString()
                                        .substring(0, 10),
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                        : data.message.contains("cancelled")
                        ? Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Cancelled",
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                            Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt
                                          .toString()
                                          .substring(11, 19),
                                      overflow:
                                      TextOverflow.clip,
                                      style: TextStyle(
                                        color:
                                        Colors.grey[500],
                                      ),
                                    ):Text(
                                      updatedAt
                                          .toString()
                                          .substring(11, 19),
                                      overflow:
                                      TextOverflow.clip,
                                      style: TextStyle(
                                        color:
                                        Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt
                                          .toString()
                                          .substring(0, 10),
                                      overflow:
                                      TextOverflow.clip,
                                      style: TextStyle(
                                        color:
                                        Colors.grey[500],
                                      ),
                                    ):Text(
                                      updatedAt
                                          .toString()
                                          .substring(0, 10),
                                      overflow:
                                      TextOverflow.clip,
                                      style: TextStyle(
                                        color:
                                        Colors.grey[500],
                                      ),
                                    ),
                                  ),
                                ])
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                        : data.message.contains("Approved")
                        ? Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                          children: [
                            Text(
                              "Accepted",
                              style: TextStyle(
                                color: Colors.green,
                              ),
                            ),
                            Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .end,
                                children: [
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt
                                          .toString()
                                          .substring(
                                          11, 19),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    ):Text(
                                      updatedAt
                                          .toString()
                                          .substring(
                                          11, 19),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt
                                          .toString()
                                          .substring(
                                          0, 10),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    )
                                        :Text(
                                      updatedAt
                                          .toString()
                                          .substring(
                                          0, 10),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    ),
                                  ),
                                ])
                          ],
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
                        Row(
                          children: [
                            Container(
                              width:
                              MediaQuery.of(context)
                                  .size
                                  .width *
                                  0.6,
                              child: Text(
                                data.message,
                              ),
                            ),
                            Column(
                                crossAxisAlignment:
                                CrossAxisAlignment
                                    .end,
                                children: [
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt
                                          .toString()
                                          .substring(
                                          11, 19),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    )
                                        :Text(
                                      updatedAt
                                          .toString()
                                          .substring(
                                          11, 19),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    child: updatedAt==null?Text(
                                      createdAt
                                          .toString()
                                          .substring(
                                          0, 10),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    ):Text(
                                      updatedAt
                                          .toString()
                                          .substring(
                                          0, 10),
                                      overflow:
                                      TextOverflow
                                          .clip,
                                      style: TextStyle(
                                        color: Colors
                                            .grey[500],
                                      ),
                                    ),
                                  ),
                                ])
                          ],
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
                        Text(data.message),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                        : data.message.contains("cancelled")
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
                        : data.message.contains("Approved") ||
                        data.message.contains("Rejected")
                        ? Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        data.message.contains(
                            "Approved(Request to create a team") //&& data.action.toString()=="Approved"
                            ? Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              "You are now a Team Lead",
                              style: TextStyle(
                                  fontWeight:
                                  FontWeight.bold),
                            ),
                            Text(data.message +
                                " by " +
                                data.updatedBy.toString()),
                          ],
                        )
                            : Text(
                          data.message +
                              " by " +
                              data.updatedBy.toString(),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )
                        : data.message.contains(
                        "You have been invited to create a team by")
                        ? Column(
                      mainAxisAlignment:
                      MainAxisAlignment.start,
                      crossAxisAlignment:
                      CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        FlatButton(
                          textColor:
                          KirthanStyles.colorPallete60,
                          color: KirthanStyles.colorPallete30,
                          child: Text("Create team"),
                          onPressed: () async {
                            List<UserRequest>
                            userRequestList =
                            await userPageVM
                                .getUserRequests(
                                data.createdBy);
                            for (var user
                            in userRequestList) {
                              userRequestTeam = user;
                            }
                            List<UserRequest> localAdminList =
                            await userPageVM
                                .getUserRequests(
                                data.updatedBy);
                            for (var user in localAdminList) {
                              localAdminTeam = user;
                            }
                            // Navigator.pop(context);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TeamWrite(
                                          userRequest:
                                          userRequestTeam,
                                          localAdmin:
                                          localAdminTeam,
                                        )));
                          },
                        ),
                      ],
                    )
                        : Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(" "),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                    onTap: () {
                      if (data.targetType == "team") {
                        if (data.message.contains("Approved")) {
                          getTeamId(data.message.split("\"")[1], "Approved");
                        } else if (data.message.contains("Waiting"))
                          getTeamId(data.message.split("\"")[1], "Waiting");
                        else
                          getTeamId(data.message.split("\"")[1], "Rejected");
                      }
                      if (data.targetType == "user") {
                        if (data.message.contains("team")) {
                          if (data.message.contains("Approved")) {
                            print("Inside approve");
                            getTeamId(data.message.split("\"")[1], "Approved");
                          } else if (data.message.contains("Waiting"))
                            getTeamId(data.message.split("\"")[1], "Waiting");
                          else
                            getTeamId(data.message.split("\"")[1], "Rejected");
                        }
                      }
                      data.message.contains("event")
                          ? data.message.contains("Approved")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  eventId: data.targetId,
                                  status: "Approved")))
                          : data.message.contains("Waiting")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  eventId: data.targetId,
                                  status: "Waiting")))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  eventId: data.targetId,
                                  status: "Rejected")))
                          : data.targetType.contains("team")
                          ? data.message.contains("Approved")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  teamId: data.targetId,
                                  status: "Approved")))
                          : data.message.contains("Waiting")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  teamId: data.targetId,
                                  status: "Waiting")))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NotificationDetails(
                                      teamId: data.targetId,
                                      status: "Rejected")))
                          : data.targetType.contains("user")
                          ? data.message.contains("team")
                          ? data.message.contains("Approved")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                eventId: null,
                                teamId: null,
                                teamLeadId: teamLead,
                                status: "Approved",
                              )))
                          : data.message.contains("Waiting")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                eventId: null,
                                teamId: null,
                                teamLeadId:
                                teamLead,
                                status: "Waiting",
                              )))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                eventId: null,
                                teamId: null,
                                teamLeadId:
                                teamLead,
                                status: "Rejected",
                              )))
                          : null
                          : null;
                    }),
              ),
            ]),
      );
    //Team Admin accept, reject ntf layout
    else
      return Container(
        margin: EdgeInsets.all(5),
        child: Column(
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
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text(
                            data.message,
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        // Text(
                        //   createdAt
                        //       .toString()
                        //       .substring(11, 19),
                        //   overflow: TextOverflow.clip,
                        //   style: TextStyle(color: Colors.grey[500]),
                        // ),
                      ],
                    ),
                    subtitle: Text(
                      "By " + data.createdBy.toString(),
                    ),
                    trailing: icon == Icons.pause
                        ? actions
                        : Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          createdAt.toString().substring(11, 19),
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          createdAt.toString().substring(0, 10),
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
                          "Rejected ",
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
                    onTap: () async {
                      if (data.targetType == "user") {
                        if (data.message.contains("team")) {
                          if (data.message.contains("Approved"))
                            getTeamId(data.message.split("\"")[1], "Approved");
                          else if (data.message.contains("Waiting"))
                            getTeamId(data.message.split("\"")[1], "Waiting");
                          else
                            getTeamId(data.message.split("\"")[1], "Rejected");
                        }
                      } else if (data.targetType == "team") {
                        if (data.message.contains("Approved"))
                          getTeamId(data.message.split("\"")[1], "Approved");
                        else if (data.message.contains("Waiting"))
                          getTeamId(data.message.split("\"")[1], "Waiting");
                        else
                          getTeamId(data.message.split("\"")[1], "Rejected");
                      }
                      data.message.contains("event")
                          ? data.message.contains("Approved")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  eventId: data.targetId,
                                  status: "Approved")))
                          : data.message.contains("Waiting")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  eventId: data.targetId,
                                  status: "Waiting")))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  eventId: data.targetId,
                                  status: "Rejected")))
                          : data.targetType == "team"
                          ? data.message.contains("Approved")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  teamId: data.targetId,
                                  status: "Approved")))
                          : data.message.contains("Rejected")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                  teamId: data.targetId,
                                  status: "Rejected")))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  NotificationDetails(
                                      teamId: data.targetId,
                                      status: "Waiting")))
                          : data.targetType == "user"
                          ? data.message.contains("team")
                          ? data.message.contains("Rejected")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                eventId: null,
                                teamId: null,
                                teamLeadId: teamLead,
                                status: "Rejected",
                              )))
                          : data.message.contains("Approved")
                          ? Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                eventId: null,
                                teamId: null,
                                teamLeadId:
                                teamLead,
                                status: "Approved",
                              )))
                          : Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NotificationDetails(
                                eventId: null,
                                teamId: null,
                                teamLeadId:
                                teamLead,
                                status: "Waiting",
                              )))
                          : null
                          : null;
                    }),
              ),
            ]),
      );
  }

  SlidableController _slidableController;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.redAccent;
  List<NotificationModel> ntfList = new List<NotificationModel>();
  @override
  void initState() {
    super.initState();
    loadPref();
    getRoleId();
    _slidableController = SlidableController(
      onSlideAnimationChanged: slideAnimationChanged,
      onSlideIsOpenChanged: slideIsOpenChanged,
    );
    // NotificationViewModel _nvm =  ScopedModel.of<NotificationViewModel>(context);
    // _nvm.notificationCount = 0;
  }

  void slideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void slideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.orange : Colors.redAccent;
    });
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
        child: Center(
          child: OrientationBuilder(
            builder: (context, orientation) => buildlist(
                context,
                orientation == Orientation.portrait
                    ? Axis.vertical
                    : Axis.horizontal),
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }

  Widget buildlist(BuildContext context, Axis direction) {
    return FutureBuilder(
        future: notificationPageVM.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                scrollDirection: direction,
                itemBuilder: (context, itemCount) {
                  direction == Axis.horizontal
                      ? Axis.vertical
                      : Axis.horizontal;
                  _buildNotification(snapshot.data[itemCount], false);
                  var item = snapshot.data[itemCount];
                  return Slidable(
                    child: _buildNotification(snapshot.data[itemCount], false),
                    controller: _slidableController,
                    actionPane: SlidableDrawerActionPane(),
                    actions: <Widget>[],
                    secondaryActions: <Widget>[
                      Visibility(
                        visible: isVisible,
                        child: IconSlideAction(
                          caption: 'View',
                          color: Colors.grey.shade200,
                          icon: Icons.more_horiz,
                          onTap: () async {
                            UserRequest userReq = new UserRequest();
                            UserRequest localAdmin = new UserRequest();
                            TeamRequest team = new TeamRequest();
                            EventRequest eventRequest = new EventRequest();
                            if (snapshot.data[itemCount].targetType == "team") {
                              List<TeamRequest> teamList =
                              await teamPageVM.getTeamRequests(snapshot
                                  .data[itemCount].targetId
                                  .toString());
                              for (var t in teamList) {
                                team = t;
                              }
                            }
                            if (snapshot.data[itemCount].targetType == "user" &&
                                snapshot.data[itemCount].message
                                    .contains("Invited user")) {
                              List<TeamRequest> teamList = await teamPageVM
                                  .getTeamRequests("teamLeadId:" +
                                  snapshot.data[itemCount].createdBy);
                              for (var t in teamList) {
                                team = t;
                              }
                            }
                            List<UserRequest> userRequestList =
                            await userPageVM.getUserRequests(
                                snapshot.data[itemCount].createdBy);
                            for (var user in userRequestList) {
                              userReq = user;
                            }
                            List<UserRequest> user =
                            await userPageVM.getUserRequests(
                                snapshot.data[itemCount].createdBy);
                            String userName = " ";
                            for (var u in user) {
                              userName = u.fullName;
                            }
                            String eventId =
                            snapshot.data[itemCount].targetId.toString();
                            List<EventRequest> eventList = await eventPageVM
                                .getEventRequests("event_id:$eventId");
                            for (var event in eventList) {
                              eventRequest = event;
                            }
                            List<UserRequest> localAdminList =
                            await userPageVM.getUserRequests(
                                snapshot.data[itemCount].updatedBy);
                            for (var user in localAdminList) {
                              localAdmin = user;
                            }
                            // if (snapshot.data[itemCount].message
                            //     .contains("Request to create an event") &&
                            //     snapshot.data[itemCount].targetType
                            //         .contains("event")) {
                            //   //   print("Printing dara");
                            //   // print(snapshot.data[itemCount]);
                            //   WidgetsBinding.instance.addPostFrameCallback((_) {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (context) => AdminEventDetails(
                            //               UserName: userName,
                            //               eventRequest: eventRequest,
                            //               data: snapshot.data[itemCount],
                            //             )));
                            //   });
                            // } else
                            if (snapshot.data[itemCount].message
                                .contains("team") ||
                                snapshot.data[itemCount].message
                                    .contains("Invited user")) {
                              // print(snapshot.data[itemCount].targetId);
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                //Navigator.pop(context);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamProfilePage(
                                          teamTitle: team.teamTitle,
                                        )));
                              });
                            }
                          },
                          closeOnTap: false,
                        ),
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () => {
                          setState(() {
                            Map<String, dynamic> processrequestmap =
                            new Map<String, dynamic>();

                            processrequestmap["id"] =
                                snapshot.data[itemCount].id;
                            snapshot.data[itemCount].message.contains("Your") ||
                                snapshot.data[itemCount].message
                                    .contains("Request") ||
                                snapshot.data[itemCount].message
                                    .contains("Registered") ||
                                snapshot.data[itemCount].message
                                    .contains("cancelled") ||
                                snapshot.data[itemCount].message
                                    .contains("has been created") ||
                                snapshot.data[itemCount].message
                                    .contains("have been promoted") ||
                                snapshot.data[itemCount].message
                                    .contains("have been made") ||
                                snapshot.data[itemCount].message
                                    .contains("have been invited")
                                ? notificationPageVM.deleteNotification(
                                processrequestmap, false)
                                : notificationPageVM.deleteNotification(
                                processrequestmap, true);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.of(context);
                            });
                          }),
                        },
                      ),
                    ],
                  );
                },
                itemCount: snapshot.data.length);
          } else if (snapshot.hasError) {
            return Center(
                child: Text(
                    'Error loading notifications' + snapshot.error.toString()));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  getTeamId(String teamTitle, String status) async {
    print("team title");
    print(teamTitle);
    List<TeamRequest> teamList = await teamPageVM.getTeamRequests(status);
    for (var team in teamList) {
      if (team.teamTitle == teamTitle) {
        teamLead = team.teamLeadId;
      }
    }
  }
}

bool isVisible;
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
          Visibility(
            visible: isVisible,
            child: FlatButton(
              child: Text("View"),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminView()));
              },
            ),
          ),
          FlatButton(
              child: Text("Discard"),
              onPressed: () {
              }),
        ],
      ));
}


