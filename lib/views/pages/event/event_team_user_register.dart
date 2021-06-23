import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/LocalNotifyManager.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
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
import 'package:provider/provider.dart';


final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

final EventUserPageViewModel eventUserPageVM =
    EventUserPageViewModel(apiSvc: EventUserAPIService());

class EventTeamUserRegister extends StatefulWidget {
  EventRequest eventrequest;
  EventTeamUserRegister({Key key, @required this.eventrequest})
      : super(key: key);
  @override
  _EventTeamUserRegisterState createState() => _EventTeamUserRegisterState();
}

class _EventTeamUserRegisterState extends State<EventTeamUserRegister> {
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  List<UserRequest> userTempList = new List<UserRequest>();
  List<EventUser> eventUserList = new List<EventUser>();
  List<TeamUser> listofTeamUsers = new List<TeamUser>();
  String email;

  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    email = getCurrentUser().toString();
    super.initState();
    localNotifyManager.setOnNotificationReceived(onNotificationReceived);
    localNotifyManager.seOnNotificationClick(onNotificationClick);
  }
  onNotificationReceived(ReceivedNotification notification) {
    print('Notification Recieved: ${notification.id}');
  }
  onNotificationClick(String payload){
    print('Payload:$payload');
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
        future: eventUserPageVM.getEventTeamUserMappings(),
        builder:
            (BuildContext context, AsyncSnapshot<List<EventUser>> snapshot) {
          if (snapshot.data != null) {
            eventUserList = snapshot.data
                .where((element) => element.eventId == widget.eventrequest.id)
                .toList();
            print(eventUserList);
            final eventDate = widget.eventrequest?.eventDate;
            DateTime EventDate = DateTime.parse(eventDate);
            DateTime now = DateTime.now();
            var dateTime = DateFormat('yyyy-MM-dd').format(now);
            DateTime dateTimeNow = DateTime.parse(dateTime);
            int daysRemaining = EventDate.difference(dateTimeNow).inDays;
            return eventUserList.isNotEmpty
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
                    Consumer<ThemeNotifier>(
                    builder: (context, notifier, child) =>
                    daysRemaining<0
                        ?Text(
                      "RSVP",
                      style: TextStyle(color: Colors.grey,fontSize: notifier.custFontSize),
                    )
                        :Text(
                      "RSVP",
                      style: TextStyle(fontSize: notifier.custFontSize),
                    ),
                    ),
                        Icon(Icons.check),
                      ],
                    ),
                    onPressed: () async {
                      if(daysRemaining<0){

                      }
                      else
                      setState(() {
                        List<EventUser> eventUserTempList =
                            new List<EventUser>();
                        eventUserTempList = eventUserList
                            .where((element) =>
                                element.eventId == widget.eventrequest.id)
                            .toList();
                        eventUserPageVM.submitDeleteEventTeamUserMapping(
                            eventUserTempList)
                        .whenComplete(() => Scaffold.of(context).showSnackBar(SnackBar(content: Text('Successfully unregistered'),)));
                      });
                    })
                : FutureBuilder<List<UserRequest>>(
                    future: Users,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<UserRequest>> snapshot) {
                      if (snapshot.data != null) {
                        userList = snapshot.data;
                        print(userList);

                        return Consumer<ThemeNotifier>(
                            builder: (context, notifier, child) =>FlatButton(
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: Colors.grey[700],
                                  width: 1,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child:
                                daysRemaining<0
                            ?Text(
                              "RSVP",
                              style: TextStyle(color: Colors.grey,fontSize: notifier.custFontSize),
                            )
                                :Text(
                                  "RSVP",
                                  style: TextStyle(fontSize: notifier.custFontSize),
                                ),
                            onPressed: () async {
                              if(daysRemaining<0){

                              }
                              else {
                                final FirebaseAuth auth = FirebaseAuth.instance;
                                final FirebaseUser user =
                                await auth.currentUser();
                                final String email = user.email;
                                userTempList = userList
                                    .where((element) => element.email == email)
                                    .toList();
                                for (var user in userTempList) {
                                  EventUser eventUser = new EventUser();
                                  eventUser.createdBy = user.email;
                                  eventUser.userId = user.id;
                                  eventUser.userName = user.email;
                                  eventUser.eventId = widget.eventrequest?.id;
                                  String dt =
                                  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                      .format(DateTime.now());
                                  eventUser.createdTime = dt;
                                  eventUser.updatedBy = null;
                                  eventUser.updatedTime = null;
                                  widget.eventrequest?.updatedTime;

                                  eventUserList.add(eventUser);
                                }

                                eventUserPageVM.submitNewEventTeamUserMapping(
                                    eventUserList, () {
                                  setState(() {
                                    // String eventrequestStr = jsonEncode(
                                    //     widget.eventrequest.toStrJson());
                                    // eventPageVM.submitRegisterEventRequest(
                                    //     eventrequestStr);
                                    null;
                                  });
                                });
                                DateTime EventDate = DateTime.parse(widget.eventrequest.eventDate).subtract(Duration(hours: 24));
                                await localNotifyManager.scheduleNotification(
                                    'Event reminder',
                                    widget.eventrequest.eventTitle +' is scheduled for tomorrow @ '+widget.eventrequest.eventStartTime +"\nHope to see you at the event :)" ,
                                    EventDate);

                                String title = widget.eventrequest.eventTitle;
                                SnackBar mysnackbar = SnackBar(
                                  content: Text("Registered for $title"),
                                  duration: new Duration(seconds: 4),
                                  backgroundColor: notifier.darkTheme ? Colors
                                      .white : Colors.green,
                                );
                                Scaffold.of(context).showSnackBar(mysnackbar);
                              }
                            }));
                      }
                      return Container();
                    });
          }
          return Container();
        });
  }
}
