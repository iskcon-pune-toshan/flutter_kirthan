import 'package:flutter/material.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/widgets/temple/temple_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_create.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';

final TemplePageViewModel templePageVM =
TemplePageViewModel(apiSvc: TempleAPIService());

class TempleView extends StatefulWidget {
  TempleView({Key key}) : super(key: key);

  final String title = "Temples";
  final String screenName = SCR_TEMPLE;

  @override
  _TempleViewState createState() => _TempleViewState();
}

class _TempleViewState extends State<TempleView> {
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
    print(accessTypes);
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
        title: Text("Temple"),
      ),
      body: ScopedModel<TemplePageViewModel>(
        model: templePageVM,
        child: TemplesPanel(
          templeType: "All",
        ),
      ),
      /*floatingActionButton: accessTypes[ACCESS_TYPE_CREATE] == true
          ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        //tooltip: accessTypes["Create"].toString(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => TempleWrite()));
        },
      )
          : FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: null,

      ),*/
      floatingActionButton: FloatingActionButton(
        heroTag: "temple",
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TempleWrite()));
        },
      ),


    );

  }
}
