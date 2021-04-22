import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:intl/intl.dart';
import 'dart:core';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_user_page_view_model.dart';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/event_user_service_impl.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

final EventUserPageViewModel eventUserPageVM =
    EventUserPageViewModel(apiSvc: EventUserAPIService());

class EventTeamUserRegister extends StatefulWidget {
  EventRequest eventrequest;
  bool flag;
  EventTeamUserRegister(
      {Key key, @required this.eventrequest, @required this.flag})
      : super(key: key);
  @override
  _EventTeamUserRegisterState createState() => _EventTeamUserRegisterState();
}

class _EventTeamUserRegisterState extends State<EventTeamUserRegister> {
  Future<List<UserRequest>> Users;
  Future<List<EventUser>> EventUsers;
  List<UserRequest> userList = new List<UserRequest>();
  List<UserRequest> userTempList = new List<UserRequest>();
  List<EventUser> eventUserList = new List<EventUser>();
  List<TeamUser> listofTeamUsers = new List<TeamUser>();
  String email;
  bool _flag;
  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    EventUsers = eventUserPageVM.getEventTeamUserMappings();
    email = getCurrentUser().toString();
    super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    widget.eventrequest.updatedBy = email;
    print(email);
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventUser>>(
        future: EventUsers,
        builder:
            (BuildContext context, AsyncSnapshot<List<EventUser>> snapshot) {
          if (snapshot.data != null) {
            eventUserList = snapshot.data
                .where((element) => element.eventId == widget.eventrequest.id)
                .toList();
            print(eventUserList);
            // eventUserList = eventUserList
            //     .where((element) => element.userName == email)
            //     .toList();
            return eventUserList.isNotEmpty ||
                widget.flag
                    ? FlatButton(
                        //color: const Color(0xFF1BC0C5),
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.grey[700],
                              width: 1,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Row(
                          children: [
                            Text(
                              "RSVP",
                              //style: TextStyle(color: Colors.white),
                            ),
                            Icon(Icons.check),
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            widget.flag = false;
                            List<EventUser> eventUserTempList =
                                new List<EventUser>();
                            eventUserTempList = eventUserList
                                .where((element) =>
                                    element.eventId == widget.eventrequest.id)
                                .toList();
                            eventUserPageVM.submitDeleteEventTeamUserMapping(
                                eventUserTempList);
                          });
                        }
                        //String s = jsonEncode(userrequest.mapToJson());
                        //service.registerUser(s);
                        //print(s);
                        )
                    : FutureBuilder<List<UserRequest>>(
                        future: Users,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<UserRequest>> snapshot) {
                          if (snapshot.data != null) {
                            userList = snapshot.data;
                            print(userList);

                            return FlatButton(
                                //color: KirthanStyles.colorPallete30,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      color: Colors.grey[700],
                                      width: 1,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: Text(
                                  "RSVP",
                                  //style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  if (!widget.flag) {
                                    final FirebaseAuth auth =
                                        FirebaseAuth.instance;
                                    final FirebaseUser user =
                                        await auth.currentUser();
                                    final String email = user.email;
                                    userTempList = userList
                                        .where(
                                            (element) => element.email == email)
                                        .toList();
                                    for (var user in userTempList) {
                                      EventUser eventUser = new EventUser();
                                      eventUser.createdBy = user.email;
                                      eventUser.userId = user.id;
                                      eventUser.teamId = 11;
                                      eventUser.userName = user.email;
                                      eventUser.eventId =
                                          widget.eventrequest?.id;
                                      String dt = DateFormat(
                                              "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                          .format(DateTime.now());
                                      eventUser.createdTime = dt;
                                      eventUser.updatedBy = null;
                                      eventUser.updatedTime = null;
                                      widget.eventrequest?.updatedTime;
                                      eventUser.teamName = "New";

                                      eventUserList.add(eventUser);
                                    }
                                    //TODO
                                    setState(() {
                                      eventUserPageVM
                                          .submitNewEventTeamUserMapping(
                                              eventUserList);

                                      //notificationPageVM.addNotification(eventUsermap);

                                      // await widget.notificationPageVM.updateNotifications(
                                      //     await widget.notificationPageVM.getNotifications(),
                                      //     widget.eventrequest.id.toString(),
                                      //     true);
                                      String title =
                                          widget.eventrequest.eventTitle;
                                      SnackBar mysnackbar = SnackBar(
                                        content: Text("Registred for $title"),
                                        duration: new Duration(seconds: 4),
                                        backgroundColor: Colors.white,
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(mysnackbar);

                                      widget.flag = true;
                                    });
                                  }
                                  if (widget.flag) {
                                    String eventrequestStr = jsonEncode(
                                        widget.eventrequest.toStrJson());
                                    eventPageVM.submitRegisterEventRequest(
                                        eventrequestStr);
                                  }
                                }
                                //String s = jsonEncode(userrequest.mapToJson());
                                //service.registerUser(s);
                                //print(s);
                                );
                          }
                          return Container();
                        });
          }
          return Container();
        });
  }
}
