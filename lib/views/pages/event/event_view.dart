import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_create.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/widgets/event/event_panel.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/settings_list_item.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/aboutus.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/faq.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/rateus.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

class EventView extends StatefulWidget {
  final String title = "Events";
  final String screenName = SCR_EVENT;

  EventView({Key key}) : super(key: key);

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
  List<String> userdetails;
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
      userdetails = prefs.getStringList("LoginDetails");
      photoUrl = userdetails.elementAt(1);
      name = userdetails.elementAt(0);
      print(userdetails.length);
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
          PopupMenuButton(
              icon: Icon(Icons.tune),
              onSelected: (input) {
                _selectedValue = input;
                print(input);
                eventPageVM.setEventRequests("All");
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
              trailing: Icon(FontAwesomeIcons.signOutAlt),
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
                trailing: Icon(Icons.remove_circle_outline),
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
      floatingActionButton: accessTypes[ACCESS_TYPE_CREATE] == true
          ? FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.green,
              //tooltip: accessTypes["Create"].toString(),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => EventWrite()));
              },
            )
          : FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.grey,
              onPressed: null,
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
              break;
          }
        },
        currentIndex: _index,
        selectedItemColor: Colors.orange,
        items: const <BottomNavigationBarItem>[
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
            icon: Icon(Icons.notifications),
            title: Text('Notifications'),
          ),
        ],
      ),
    );
  }
}
