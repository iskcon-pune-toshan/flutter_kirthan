import 'dart:convert';
import 'dart:ffi';
import 'package:firebase_auth/firebase_auth.dart';
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
  List<String> eventTime = ["Today", "Tomorrow", "This Week", "This Month","Clear Filter"];
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
  Future getevent() async {
    String requestBody = '';
    requestBody = '{"approvalStatus" : "Approved"}';
    print(requestBody);
    String token = AutheticationAPIService().sessionJWTToken;
    print("search service");
    var response = await client1.put('$baseUrl/api/event/geteventtitle',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: requestBody);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(eventrequestsData);
      List<String> events =
          eventrequestsData.map((event) => event.toString()).toList();
      event = events;
      print(event);
      int len = event.length;
      print(len);
      length = len;
      //print(event);
//print(eventrequests);
    } else {
      throw Exception('Failed to get data');
    }
  }

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
            access.elementAt(1).toLowerCase() == "true" ? true : false;
      });
      eventPageVM.accessTypes = accessTypes;
      //userdetails = prefs.getStringList("LoginDetails");
      SignInService().firebaseAuth.currentUser().then((onValue) {
        photoUrl = onValue.photoUrl;
        name = onValue.displayName;
        print(name);
        print(photoUrl);
      });
      //print(userdetails.length);
    });
  }
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    print(email);
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
    getevent();
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
            //style: TextStyle(fontSize: notifier.custFontSize),
          ),
          actions: <Widget>[
            /*IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () => {
                      showSearch(
                        context: context,
                        delegate: Search(event),
                      )

                    }),*/
/*            PopupMenuButton(
                icon: Icon(
                  Icons.tune,
                ),
                onSelected: (input) {
                  _selectedValue = input;
                  print(input);
                  if (input == 'Today')
                    eventPageVM.setEventRequests("TODAY");
                  else if (input == 'Tomorrow')
                    eventPageVM.setEventRequests("TOMORROW");
                  else if (input == 'This Week')
                    eventPageVM.setEventRequests("This Week");
                  else if (input == 'This Month')
                    eventPageVM.setEventRequests("This Month");
                  else if(input == 'Clear Filter')
                    eventPageVM.setEventRequests("All");
                  else if (notifier.duration != null) {
                    eventPageVM.setEventRequests(notifier.duration);
                  }
                },
                itemBuilder: (BuildContext context) {
                  return eventTime.map((f) {
                    return CheckedPopupMenuItem<String>(
                      child: Text(
                        f,
                        style: TextStyle(
                          fontSize: notifier.custFontSize,
                        ),
                      ),
                      value: f,
                      checked: _selectedValue == f ? true : false,
                      enabled: true,
                      //checked: true,
                    );
                  }).toList();
                }),*/
          ],
          iconTheme: IconThemeData(color: KirthanStyles.colorPallete30),
        ),
        drawer: MyDrawer(),
        body: RefreshIndicator(
          key: refreshKey,
          child: ScopedModel<EventPageViewModel>(
            model: eventPageVM,
            child: MyEventsPanel(
              eventType: "Pune",
            ),
          ),
          onRefresh: refreshList,
        ),
        /*floatingActionButton: FloatingActionButton(
          heroTag: "myevent",
          child: Icon(Icons.add),
          backgroundColor: KirthanStyles.colorPallete10,
          //tooltip: accessTypes["Create"].toString(),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EventWrite()));
          },
        ),*/
      ),
    );
  }
}

class Search extends SearchDelegate {
  Search(
    this.listExample, {
    String hintText = "Search by Event Title",

  }) : super(
          searchFieldLabel: hintText,

          searchFieldStyle: TextStyle(color: Colors.grey),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult,
            style: TextStyle(color: KirthanStyles.colorPallete10)),
      ),
    );
  }

  final List<String> listExample;
  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where(
            // In the false case
            (element) => element.toUpperCase().contains(query) || element.toLowerCase().contains(query),
        
          ));

    return
        //_widget();
        ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
        );
      },
    );
  }
}