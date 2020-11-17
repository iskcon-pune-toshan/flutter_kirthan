import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/role_screen_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/eventuser/eventuser_create.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_create.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_create.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
import 'package:shared_preferences/shared_preferences.dart';


final RoleScreenViewPageModel roleScreenPageVM =
RoleScreenViewPageModel(apiSvc: RoleScreenAPIService());


class RoleScreenView extends StatefulWidget {
  final String title = "Role Screen";
  final String screenName = SCR_ROLE_SCREEN;

  @override
  _RoleScreenViewState createState() => _RoleScreenViewState();
}

class _RoleScreenViewState extends State<RoleScreenView> {
  Future<List<RoleScreen>> rolescreen;
  List<RoleScreen> listofrolescreen = new List<RoleScreen>();
  List<RoleScreen> selectedRoleScreen = new List<RoleScreen>();
  Map<String, bool> usercheckmap = new Map<String, bool>();
  @override
  void initState() {
    rolescreen = roleScreenPageVM.getRoleScreenMaping("All");
    rolescreen.then((newrolescreen) {
      newrolescreen.forEach((rolescreen) => usercheckmap[
      rolescreen.roleId.toString() +
          "RS" +
          rolescreen.screenId.toString()] = false
        //usercehckmap.putIfAbsent(, () => )
      );
    });

    super.initState();
    _index = 1;

  }


  List<Widget> populateChildren(String roleName) {
    List<Widget> children = new List<Widget>();
    List<RoleScreen> listofscreens =
    listofrolescreen.where((user) => user.roleName == roleName).toList();
    for (var user in listofscreens) {
      //print(user.templeName+"UT"+user.userId.toString());
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Text(user.userId.toString()),
          Checkbox(
            value: usercheckmap[
            (user.roleId.toString() + "RS" + user.screenId.toString())
                .toString()],
            onChanged: (input) {
              setState(() {
                usercheckmap[user.roleId.toString() +
                    "TU" +
                    user.screenId.toString()] = input;
                if (input == true)
                  selectedRoleScreen.add(user);
                else
                  selectedRoleScreen.remove(user);
                //print(input);
              });
            },
          ),
          Text(user.screenName),
        ],
      ));
    }
    return children;
  }


  int _index;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: Expanded(
              child: Scrollbar(
                //scrollDirection: Axis.vertical,
                //padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FutureBuilder<List<RoleScreen>>(
                    future: rolescreen,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<RoleScreen>> snapshot) {
                      switch (snapshot.connectionState) {
                      // ignore: missing_return
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(
                              child: const CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            listofrolescreen = snapshot.data;
                            listofrolescreen
                                .sort((a, b) => b.roleId.compareTo(a.roleId));
                            List<String> setofTeams = listofrolescreen
                                .map((user) => user.roleName)
                                .toSet()
                                .toList();
                            //setofTeams.reversed;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: setofTeams.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title:
                                    Text(setofTeams[index]),
                                    //subtitle: Text("Hello Manjunath"),
                                    children:
                                    populateChildren(setofTeams[index]),
                                  );
                                });
                          } else {
                            return Container(
                              width: 20.0,
                              height: 10.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                      }
                    }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('SELECTED ${selectedRoleScreen.length}'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                RoleScreenWrite(roleScreenrequest: null)));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('DELETE SELECTED ${selectedRoleScreen.length}'),
                  onPressed: () {
                    print(selectedRoleScreen);
                    roleScreenPageVM.submitDeleteRoleScreenMapping(selectedRoleScreen);
                  },
                ),
              ),
            ],
          ),
        ],
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
                  context, MaterialPageRoute(builder: (context) => UserTempleView()));
              break;
            case 5:
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RoleScreenView()));
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
            icon: Icon(Icons.map),
            title: Text('User Temple'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_drop_down_circle),
            title: Text('Role Screen'),
          ),
        ],
      ),
    );
  }
}
