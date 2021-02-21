import 'package:flutter/material.dart';
import 'package:flutter_kirthan/view_models/roles_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/permissions/permissions_view.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/widgets/roles/roles_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/roles_service_impl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_create.dart';

final RolesPageViewModel rolesPageVM =
    RolesPageViewModel(apiSvc: RolesAPIService());

class RolesView extends StatefulWidget {
  RolesView({Key key}) : super(key: key);

  final String title = "Roles";
  final String screenName = SCR_ROLES;

  @override
  _RolesViewState createState() => _RolesViewState();
}

class _RolesViewState extends State<RolesView> {
  int _index;
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
            access.elementAt(1).toLowerCase() == "true" ? true : false;
      });
      rolesPageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await rolesPageVM.setRoles("All");
  }

  @override
  void initState() {
    super.initState();
    loadData();

    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Roles"),
      ),
      body: ScopedModel<RolesPageViewModel>(
        model: rolesPageVM,
        child: RolesPanel(
          rolesType: "All",
        ),
      ),
      /*floatingActionButton: accessTypes[ACCESS_TYPE_CREATE] == true
          ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        //tooltip: accessTypes["Create"].toString(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => RolesWrite()));
        },
      )
          : FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: null,
      ),*/
      floatingActionButton: FloatingActionButton(
        heroTag: "roles",
        child: Icon(Icons.add),
        //backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => RolesWrite()));
        },
      ),
    );
  }
}
