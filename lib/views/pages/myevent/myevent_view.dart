import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/views/widgets/myevent/myevent_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/firebasemessage_service.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/widgets/event/Interested_events.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

import 'package:flutter_kirthan/views/pages/event/event_create_invite.dart';

import 'package:flutter_kirthan/views/widgets/event/event_panel.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

class MyEventView extends StatefulWidget {
  final String title = "My Events";
  final String screenName = SCR_MYEVENT;
  EventRequest eventrequest;
  MyEventView({Key key, @required this.eventrequest}) : super(key: key);
  @override
  _MyEventViewState createState() => _MyEventViewState();
}

class _MyEventViewState extends State<MyEventView> with BaseAPIService {
  bool _v = false;
  List<String> eventTime = [
    "Today",
    "Tomorrow",
    "This Week",
    "This Month",
    "Clear Filter"
  ];
  String date;
  String datetomm;
  String _selectedValue;
  int _index;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();
  String photoUrl;
  String name;
  List<String> event;
  List<String> tempList = List<String>();
  bool isLoading = false;
  int length;
  http.Client client1 = http.Client();


  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      /*access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
            access.elementAt(1).toLowerCase() == "true" ? true : false;
      });*/
      eventPageVM.accessTypes = accessTypes;
      //userdetails = prefs.getStringList("LoginDetails");
      SignInService().firebaseAuth.currentUser().then((onValue) {
        photoUrl = onValue.photoUrl;
        name = onValue.displayName;
       // print(name);
        //print(photoUrl);
      });
      //print(userdetails.length);
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    //print(email);
    return email;
  }

  final now = DateTime.now();
  Future loadData() async {
    await eventPageVM.setEventRequests("MyEvent");
  }

  @override
  void initState() {
    super.initState();
    _index = 0;
    loadData();
    loadPref();
    NotificationManager ntfManger = NotificationManager();
   // getevent();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      loadData();
    });
    return null;
  }

  @override
  Widget build(BuildContext context) {
    //accessTypes.containsKey(ACCESS_TYPE_CREATE)
    //print("Accesstype: C: $accessTypes.containsKey(ACCESS_TYPE_CREATE)");
    //print(accessTypes[ACCESS_TYPE_PROCESS]);
    return Consumer<ThemeNotifier>(
      builder: (content, notifier, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            "My Events",
            style: TextStyle(fontSize: notifier.custFontSize),
          ),
          actions: <Widget>[
          ],
          iconTheme: IconThemeData(color: KirthanStyles.colorPallete30),
        ),
        drawer: MyDrawer(),
        //resizeToAvoidBottomPadding: false,
        //resizeToAvoidBottomInset: false,
        body:SingleChildScrollView(child: Column(
          children: <Widget>[
            SwitchListTile(
                title: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Text(
                    "Calender View",
                    style: TextStyle(
                        fontSize: notifier.custFontSize,
                        color: KirthanStyles.colorPallete30),
                  ),
                ),
                activeColor: KirthanStyles.colorPallete30,
                value: _v,
                onChanged: (value) {
                  setState(() {
                    _v = value;
                  });
                }),
            /*Divider(
              thickness: 2,
            ),*/
            RefreshIndicator(
              key: refreshKey,
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  child: _v == false
                      ? ScopedModel<EventPageViewModel>(
                          model: eventPageVM,
                          child: MyEventsPanel(
                            eventType: "Pune",
                          ),
                        )
                      : CalendarPage(eventrequest: null)),
              onRefresh: refreshList,
            ),
          ],
        ),
        )
      ),
    );
  }
}

