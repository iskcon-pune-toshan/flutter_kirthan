import 'dart:convert';
import 'dart:ffi';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/aboutus.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/faq.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/settings_list_item.dart';
import 'package:flutter_kirthan/views/pages/event/event_create.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/widgets/event/event_panel.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

class EventView extends StatefulWidget {
  final String title = "Events";
  final String screenName = SCR_EVENT;
  EventRequest eventrequest;
  EventView({Key key, @required this.eventrequest}) : super(key: key);

  @override
  _EventViewState createState() => _EventViewState();
}

class _EventViewState extends State<EventView>
    with BaseAPIService{
  List<String> eventTime = ["Today", "Tomorrow", "This Week", "This Month"];
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
  Future getevent() async{
    String requestBody = '';
    requestBody = '{"approvalStatus" : "Approved"}';
    print(requestBody);
    String token = AutheticationAPIService().sessionJWTToken;
    print("search service");
    var response = await client1.put('$baseUrl/api/event/geteventtitle',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }, body: requestBody);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(eventrequestsData);
      List<String> events = eventrequestsData.map((event) => event.toString()).toList();
      event=events;
      print(event);
      int len=event.length;
      print(len);
      length=len;
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
  final now = DateTime.now();

  Future loadData() async {
    await eventPageVM.setEventRequests("Pune");
  }

  geteventbyday(){
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    print(today);
    final yesterday = DateTime(now.year, now.month, now.day - 1);
    final tomorrow = DateTime(now.year, now.month, now.day + 1).toString().substring(0,10);

datetomm=tomorrow;

    final todaydate=today.toString().substring(0,10);
    date=todaydate;
/*
    final dateToCheck = widget.eventrequest.eventDate;
    final aDate = DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    if(aDate == today) {

    } else if(aDate == week) {

    } else if(aDate == tomorrow) {

    } else if(aDate == month){

    }*/
  }

  @override
  void initState() {
;

    super.initState();
    _index = 0;
    final now = DateTime.now().toString();
    loadData();
    loadPref();
    NotificationManager ntfManger = NotificationManager();
    getevent();
geteventbyday();
    print(now.substring(0,10));
    print(date);

  }
  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      eventPageVM.setEventRequests("");
    });

    return null;
  }
  @override
  Widget build(BuildContext context) {
    //accessTypes.containsKey(ACCESS_TYPE_CREATE)
    //print("Accesstype: C: $accessTypes.containsKey(ACCESS_TYPE_CREATE)");
    //print(accessTypes[ACCESS_TYPE_PROCESS]);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          //style: TextStyle(color: KirthanStyles.titleColor),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.search,
              ),
              onPressed: () => {
              showSearch(context: context, delegate: Search(event),)
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventSearchView()),
                    ),*/
                  }),
          PopupMenuButton(
              icon: Icon(
                Icons.tune,
              ),
              onSelected: (input) {
                _selectedValue = input;
                print(input);
                if(input=='Today')
                eventPageVM.setEventRequests("$date");
                else if(input=='Tomorrow')
                  eventPageVM.setEventRequests("$datetomm");
                else if(input=='This Week')
                  eventPageVM.setEventRequests("eventType");
              },
              itemBuilder: (BuildContext context) {
                return eventTime.map((f) {
                  return CheckedPopupMenuItem<String>(
                    child: Text(f),
                    value: f,
                    checked: _selectedValue == f ? true : false,
                    enabled: true,
                    //checked: true,
                  );
                }).toList();
              }),
        ],
        iconTheme: IconThemeData(color: KirthanStyles.colorPallete30),
      ),


      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          Card(
            child: ListTile(
              // title: Text("Profile"),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    child: photoUrl != null
                        ? Image.network(
                            photoUrl,
                            fit: BoxFit.contain,
                          )
                        : Image.network(
                            'assets/images/login_user.jpg',
                            fit: BoxFit.scaleDown,
                          ),
                  ),
                  Expanded(
                    child: Text(
                      name != null ? name : "AA",
                      style: TextStyle(
                        fontSize: 15.0,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              trailing: null,
              onTap: () {},
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Participated Teams"),
              trailing: Icon(Icons.phone_in_talk),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Interested Events"),
              trailing: Icon(Icons.event),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Settings"),
              trailing: Icon(Icons.settings),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MySettingsApp()));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Share app"),
              trailing: Icon(Icons.share),
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (BuildContext bc) {
                      return Container(
                        child: new Wrap(
                          children: <Widget>[
                            new ListTile(
                                leading: new Icon(Icons.apps),
                                title: new Text('WhatsApp'),
                                onTap: () => {}),
                            new ListTile(
                              leading: new Icon(Icons.mail),
                              title: new Text('Mail'),
                              onTap: () => {},
                            ),
                            new ListTile(
                              leading: new Icon(Icons.message),
                              title: new Text('Sms'),
                              onTap: () => {},
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Rate Us"),
              trailing: const Icon(Icons.rate_review),
              onTap: () {
                showDialog(
                    context: context,
                    barrierDismissible:
                        true, // set to false if you want to force a rating
                    builder: (context) {
                      return RatingDialog(
                        icon: Icon(Icons.rate_review),
                        title: "Rate Us",
                        description:
                            "Tap a star to set your rating. Add more description here if you want.",
                        submitButton: "SUBMIT",
                        alternativeButton: "Contact us instead?", // optional
                        positiveComment:
                            "We are so happy to hear :)", // optional
                        negativeComment: "We're sad to hear :(", // optional
                        accentColor: Colors.red, // optional
                        onSubmitPressed: (int rating) {
                          print("onSubmitPressed: rating = $rating");
                        },
                        onAlternativePressed: () {
                          print("onAlternativePressed: do something");
                        },
                      );
                    });
                /*Navigator.push(context,
                        MaterialPageRoute(builder: (context) => RateUsApp()));*/
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("About Us"),
              trailing: Icon(Icons.info),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AboutUsApp()));
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("FAQs"),
              trailing: Icon(Icons.question_answer),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FaqApp()));
              },
            ),
          ),
          Card(
            child: ListTile(
                title: Text("Logout"),
                trailing: Icon(
                  Icons.settings_power,
                  color: Colors.lightBlue,
                ),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0)), //this right here
                          child: Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      'Do you want to Logout?',
                                      style: TextStyle(
                                        fontSize:
                                            MyPrefSettingsApp.custFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 320.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        SignInService()
                                            .signOut()
                                            .then((onValue) => print(onValue))
                                            .whenComplete(() => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginApp())));
                                        //Navigator.pop(context);
                                      },
                                      child: Text(
                                        "yes",
                                        style: TextStyle(
                                            //fontSize: MyPrefSettingsApp.custFontSize,
                                            color: Colors.white),
                                      ),
                                      color: const Color(0xFF1BC0C5),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 320.0,
                                    child: RaisedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "No",
                                        style: TextStyle(
                                            //fontSize: MyPrefSettingsApp.custFontSize,
                                            color: Colors.white),
                                      ),
                                      color: const Color(0xFF1BC0C5),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                }),
          ),
        ],
      )),

      body:
    RefreshIndicator(
    key: refreshKey,
    child:ScopedModel<EventPageViewModel>(
        model: eventPageVM,
        child: EventsPanel(
          eventType: "Pune",
        ),
      ),
      onRefresh: refreshList,
    ),
      floatingActionButton: FloatingActionButton(
        heroTag: "event",
        child: Icon(Icons.add),
        backgroundColor: KirthanStyles.colorPallete10,
        //tooltip: accessTypes["Create"].toString(),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventWrite()));
        },
      ),
    );
  }
}
class Search extends SearchDelegate {

  Search(this.listExample, {
    String hintText = "Search by Event Title",
  }) : super(
    searchFieldLabel: hintText,
    keyboardType: TextInputType.text,
    textInputAction: TextInputAction.search,
  );
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
        child: Text(selectedResult),
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
          (element) => element.contains(query),
    ));

    return
      //_widget();
      ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return
            ListTile(
              title: Text(
                suggestionList[index],
              ),
              leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),

            );

        },
      );
  }
}



