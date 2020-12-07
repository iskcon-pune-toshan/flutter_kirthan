import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/firebasemessage_service.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/aboutus.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/faq.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/rateus.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/settings_list_item.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/event/event_create.dart';
import 'package:flutter_kirthan/views/pages/event/event_search.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
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
    with SingleTickerProviderStateMixin {
  List<String> eventTime = ["Today", "Tomorrow", "This Week", "This Month"];

  String _selectedValue;
  int _index;
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();
  //List<String> userdetails;
  String photoUrl;
  String name;

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

  Future loadData() async {
    await eventPageVM.setEventRequests("All");
  }

  @override
  void initState() {
    super.initState();
    _index = 0;
    loadData();
    loadPref();
    NotificationManager ntfManger = NotificationManager();
    //print("in Event");
    //print(SignInService().firebaseAuth.currentUser().then((onValue) => print(onValue.displayName)));
  }

  @override
  Widget build(BuildContext context) {
    //accessTypes.containsKey(ACCESS_TYPE_CREATE)
    //print("Accesstype: C: $accessTypes.containsKey(ACCESS_TYPE_CREATE)");
    //print(accessTypes[ACCESS_TYPE_PROCESS]);
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EventSearchView()),
                    ),
                  }),
          PopupMenuButton(
              icon: Icon(Icons.tune),
              onSelected: (input) {
                _selectedValue = input;
                print(input);
                eventPageVM.setEventRequests(widget.eventrequest?.eventTitle);
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RateUsApp()));
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
                                  TextField(
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Do you want to Logout?'),
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
      body: ScopedModel<EventPageViewModel>(
        model: eventPageVM,
        child: EventsPanel(
          eventType: "All",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        //tooltip: accessTypes["Create"].toString(),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventWrite()));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) {
          setState(() => _index = newIndex);
          print(newIndex);
          switch (newIndex) {
            case 0:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EventView()));
              break;
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserView()));
              break;
            case 2:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TeamView()));
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NotificationView()));
              break;
            case 4:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Calendar()));
              break;
            case 5:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TempleView()));
              break;
            case 6:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RoleScreenView()));
              break;
          }
        },
        currentIndex: _index,
        selectedItemColor: Colors.orange,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Users'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text('Team'),
          ),
          BottomNavigationBarItem(
            title: Text("Notification"),
            icon: ScopedModel<NotificationViewModel>(
              model: NotificationViewModel(),
              child: ScopedModelDescendant<NotificationViewModel>(
                  builder: (context, child, model) {
                FirebaseMessageService fms = new FirebaseMessageService();
                fms.initMessageHandler(context);
                print(model.newNotificationCount);
                bool visibilty = true;
                if (model.newNotificationCount == 0) visibilty = false;
                return Stack(
                  alignment: Alignment.topRight,
                  children: <Widget>[
                    Icon(Icons.notifications),
                    if (visibilty)
                      Positioned(
                        child: Container(
                          padding: EdgeInsets.all(1),
                          decoration: new BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          constraints: BoxConstraints(
                            minHeight: 8,
                            minWidth: 8,
                          ),
                          child: Text(
                            model.newNotificationCount.toString(),
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Calendar'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.title),
            title: Text('Temple'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('User Temple'),
          ),
        ],
      ),
    );
  }
}
