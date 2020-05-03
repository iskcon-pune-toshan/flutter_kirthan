import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/widgets/team/team_panel.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:scoped_model/scoped_model.dart';


final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());


class TeamView extends StatefulWidget {
  final String title = "Teams";

  TeamView({Key key}) : super(key: key);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView>
    with SingleTickerProviderStateMixin {
  List<String> eventTime = ["Today", "Tomorrow", "This Week", "This Month"];
  String _selectedValue;
  int _index;

  Future loadData() async {
    await teamPageVM.setTeamRequests("All");
  }

  @override
  void initState() {
    super.initState();
    _index = 0;
    loadData();
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
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TeamWrite()));
        },
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
