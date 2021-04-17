import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_kirthan/views/pages/event/event_location.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'dart:core';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/team/team_local_admin.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/view_models/event_user_page_view_model.dart';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/event_user_service_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

final EventUserPageViewModel eventUserPageVM =
    EventUserPageViewModel(apiSvc: EventUserAPIService());

class EventTeamUserJunk extends StatefulWidget {
  EventRequest eventrequest;
  bool flag;
  EventTeamUserJunk({Key key, @required this.eventrequest, @required this.flag})
      : super(key: key);
  @override
  _EventTeamUserJunkState createState() => _EventTeamUserJunkState();
}

class _EventTeamUserJunkState extends State<EventTeamUserJunk> {
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  List<UserRequest> userTempList = new List<UserRequest>();
  List<EventUser> eventUserList = new List<EventUser>();
  List<TeamUser> listofTeamUsers = new List<TeamUser>();
  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserRequest>>(
        future: Users,
        builder:
            (BuildContext context, AsyncSnapshot<List<UserRequest>> snapshot) {
          if (snapshot.data != null) {
            userList = snapshot.data;
            print(userList);

            return FlatButton(
                color: const Color(0xFF1BC0C5),
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Text(
                  "Register",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (!widget.flag) {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    final FirebaseUser user = await auth.currentUser();
                    final String email = user.email;
                    userTempList = userList
                        .where((element) => element.email == email)
                        .toList();
                    for (var user in userTempList) {
                      EventUser eventUser = new EventUser();
                      eventUser.createdBy = user.email;
                      eventUser.userId = user.id;
                      eventUser.teamId = 11;
                      eventUser.userName = user.email;
                      eventUser.eventId = widget.eventrequest?.id;
                      String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                          .format(DateTime.now());
                      eventUser.createdTime = dt;
                      eventUser.updatedBy = null;
                      eventUser.updatedTime = null;
                      widget.eventrequest?.updatedTime;
                      eventUser.teamName = "New";

                      eventUserList.add(eventUser);
                    }
                    //TODO

                    eventUserPageVM
                        .submitNewEventTeamUserMapping(eventUserList);

                    //notificationPageVM.addNotification(eventUsermap);

                    // await widget.notificationPageVM.updateNotifications(
                    //     await widget.notificationPageVM.getNotifications(),
                    //     widget.eventrequest.id.toString(),
                    //     true);
                    String title = widget.eventrequest.eventTitle;
                    SnackBar mysnackbar = SnackBar(
                      content: Text("Registred for $title"),
                      duration: new Duration(seconds: 4),
                      backgroundColor: Colors.white,
                    );
                    Scaffold.of(context).showSnackBar(mysnackbar);
                    widget.flag = true;
                  }
                  if (widget.flag) {
                    String eventrequestStr =
                        jsonEncode(widget.eventrequest.toStrJson());
                    eventPageVM.submitUpdateEventRequest(eventrequestStr);
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
}
