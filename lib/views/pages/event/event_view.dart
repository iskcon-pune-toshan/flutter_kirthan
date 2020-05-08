import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_create.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/widgets/event/event_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';


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
  Map<String,bool> accessTypes = new Map<String,bool>();

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =  access.elementAt(1).toLowerCase() == "true" ? true:false;
      });
      eventPageVM.accessTypes = accessTypes;
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
            ListTile(
              title: Text("One"),
            ),
            ListTile(
              title: Text("Two"),
            ),
          ],
        ),
      ),
      body: ScopedModel<EventPageViewModel>(
        model: eventPageVM,
        child: EventsPanel(
          eventType: "All",
        ),
      ),
      floatingActionButton:
      accessTypes[ACCESS_TYPE_CREATE] == true?
        FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        //tooltip: accessTypes["Create"].toString(),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => EventWrite()));
        },
      ):
      FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: null,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        onTap: (newIndex) {
          setState(() => _index = newIndex);
          print(newIndex);
          switch(newIndex) {
            case 0:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => EventView()));
              break;
            case 1:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserView()));
              break;
            case 2:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TeamView()));
              break;
            case 3: break;
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
