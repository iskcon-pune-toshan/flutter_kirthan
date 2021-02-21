import 'package:flutter/material.dart';
import 'package:flutter_kirthan/view_models/screens_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/widgets/screens/screens_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_create.dart';
import 'package:flutter_kirthan/services/screens_service_impl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';

final ScreensPageViewModel screensPageVM =
    ScreensPageViewModel(apiSvc: ScreensAPIService());

class ScreensView extends StatefulWidget {
  ScreensView({Key key}) : super(key: key);

  final String title = "Screens";
  final String screenName = SCR_SCREENS;

  @override
  _ScreensViewState createState() => _ScreensViewState();
}

class _ScreensViewState extends State<ScreensView> {
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
      screensPageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await screensPageVM.setScreens("All");
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
        title: Text("Screens"),
      ),
      body: ScopedModel<ScreensPageViewModel>(
        model: screensPageVM,
        child: ScreensPanel(
          screenType: "All",
        ),
      ),
      /*floatingActionButton: accessTypes[ACCESS_TYPE_CREATE] == true
          ? FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        //tooltip: accessTypes["Create"].toString(),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => ScreensWrite()));
        },
      )
          : FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.grey,
        onPressed: null,
      ),*/
      floatingActionButton: FloatingActionButton(
        heroTag: "screens",
        child: Icon(Icons.add),
        //backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ScreensWrite()));
        },
      ),
    );
  }
}
