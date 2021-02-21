import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
import 'package:flutter_kirthan/views/widgets/team/team_panel.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

class TeamView extends StatefulWidget {
  final String title = "Teams";
  final String screenName = SCR_TEAM;

  TeamView({Key key}) : super(key: key);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView>
    with SingleTickerProviderStateMixin {
  List<String> eventTime = ["Today", "Tomorrow", "This Week", "This Month"];
  String _selectedValue;
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
      teamPageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await teamPageVM.setTeamRequests("All");
  }

  @override
  void initState() {
    super.initState();
    _index = 2;
    loadData();
    loadPref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teams"),
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
      body: ScopedModel<TeamPageViewModel>(
        model: teamPageVM,
        child: TeamsPanel(
          teamType: "All",
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "team",
        child: Icon(Icons.add),
        //backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => TeamWrite()));
        },
      ),
    );
  }
}
