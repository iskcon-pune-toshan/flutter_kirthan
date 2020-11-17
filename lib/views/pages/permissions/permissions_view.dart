import 'package:flutter/material.dart';
import 'package:flutter_kirthan/view_models/permissions_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/widgets/permissions/permissions_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/permissions_service_impl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/permissions/permissions_create.dart';

final PermissionsPageViewModel permissionsPageVM =
PermissionsPageViewModel(apiSvc: PermissionsAPIService());

class PermissionsView extends StatefulWidget {
  PermissionsView({Key key}) : super(key: key);

  final String title = "Permissionss";
  final String screenName = SCR_PERMISSIONS;

  @override
  _PermissionsViewState createState() => _PermissionsViewState();
}

class _PermissionsViewState extends State<PermissionsView> {
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
      permissionsPageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await permissionsPageVM.setPermissions("All");
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
        title: Text("Permissions"),
      ),
      body: ScopedModel<PermissionsPageViewModel>(
        model: permissionsPageVM,
        child: PermissionsPanel(
          permissionsType: "All",
        ),
      ),
     /* floatingActionButton: accessTypes[ACCESS_TYPE_CREATE] == true
          ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        //tooltip: accessTypes["Create"].toString(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => PermissionsWrite()));
        },
      )
          : FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: null,
      ),*/
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      PermissionsWrite()));
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
                  context, MaterialPageRoute(builder: (context) => TempleView() ));
              break;
            case 2:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RolesView() ));
              break;
            case 3:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => PermissionsView()));
              break;
            case 4:
              Navigator.push(
                context, MaterialPageRoute(builder: (context) => ScreensView()));
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
            icon: Icon(Icons.title),
            title: Text('Temple'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('Roles'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_parking),
            title: Text('Permissions'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fullscreen),
            title: Text('Screens'),
    ),
        ],
      ),
    );
  }
}
