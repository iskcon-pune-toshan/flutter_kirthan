import 'package:flutter/material.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/widgets/user/user_panel.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class UserView extends StatefulWidget {
  UserView({Key key}) : super(key: key);

  final String title = "Users";
  final String screenName = SCR_REGISTER_USER;

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
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
      userPageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await userPageVM.setUserRequests("All");
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
        title: Text("User"),
      ),
      body: ScopedModel<UserPageViewModel>(
        model: userPageVM,
        child: UsersPanel(
          userType: "All",
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
