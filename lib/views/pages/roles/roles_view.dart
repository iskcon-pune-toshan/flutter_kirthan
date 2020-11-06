import 'package:flutter/material.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
//import 'package:flutter_kirthan/views/temple/temple_view.dart';
import 'package:flutter_kirthan/views/widgets/temple/temple_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
//import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';

final TemplePageViewModel templePageVM =
TemplePageViewModel(apiSvc: TempleAPIService());

class RolesView extends StatefulWidget {
  RolesView({Key key}) : super(key: key);

  final String title = "Roles";
  final String screenName = SCR_ROLES;

  @override
  _TempleViewState createState() => _TempleViewState();
}

class _TempleViewState extends State<RolesView> {
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
      templePageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await templePageVM.setTemples("All");
  }

  @override
  void initState() {
    super.initState();
    loadData();
    _index = 1;
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Roles"),
      ),
      body: ScopedModel<TemplePageViewModel>(
        model: templePageVM,
        child: TemplesPanel(
          templeType: "All",
        ),
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NotificationView()));
              break;
            case 4:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Calendar()));
              break;
            case 5:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => TempleView() ));
              break;
            case 6:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RolesView() ));
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
          BottomNavigationBarItem(
            icon: Icon(Icons.title),
            title: Text('Temple'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Roles'),
          ),
        ],
      ),
    );
  }
}
