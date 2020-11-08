import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_create.dart';
//import 'package:flutter_kirthan/views/roles/roles_view.dart';
import 'package:flutter_kirthan/views/widgets/temple/temple_panel.dart';
import 'package:flutter_kirthan/views/widgets/user_temple/user_temple_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
//import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';

final UserTemplePageViewModel userTemplePageVM =
UserTemplePageViewModel(apiSvc: UserTempleAPIService());

class UserTempleView extends StatefulWidget {
  UserTempleView({Key key}) : super(key: key);

  final String title = "UserTemples";
  final String screenName = SCR_TEMPLE;

  @override
  _UserTempleViewState createState() => _UserTempleViewState();
}

class _UserTempleViewState extends State<UserTempleView> {
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
      userTemplePageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await userTemplePageVM.setUserTemples("All");
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
        title: Text("User Temple"),
      ),
      body: ScopedModel<UserTemplePageViewModel>(
        model: userTemplePageVM,
        child: UserTemplesPanel(
          usertempleType: "All",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => UserTempleCreate()));
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => NotificationView()));
              break;
            case 4:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserTempleView() ));
              break;
            case 5:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RoleScreenView() ));
              break;
            /*case 4:
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
              break;*/
            /*case 7:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UserTempleView() ));
              break;
            case 8:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RoleScreenView() ));
              break;*/
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
         /* BottomNavigationBarItem(
            icon: Icon(Icons.title),
            title: Text('Temple'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Roles'),
          ),*/
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('User Temple'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Role Screens'),
          ),
        ],
      ),
    );
  }
}
