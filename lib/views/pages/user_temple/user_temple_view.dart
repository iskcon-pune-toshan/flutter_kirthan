import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/eventuser/eventuser_create.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_create.dart';
import 'package:shared_preferences/shared_preferences.dart';


final UserTemplePageViewModel userTemplePageVM =
UserTemplePageViewModel(apiSvc: UserTempleAPIService());


class UserTempleView extends StatefulWidget {
  final String title = "User Temple";
  final String screenName = SCR_USER_TEMPLE;

  @override
  _UserTempleViewState createState() => _UserTempleViewState();
}

class _UserTempleViewState extends State<UserTempleView> {
  Future<List<UserTemple>> usertemple;
  List<UserTemple> listofusertemple = new List<UserTemple>();
  List<UserTemple> selectedUserTemple = new List<UserTemple>();
  Map<String, bool> usercheckmap = new Map<String, bool>();
  @override
  void initState() {
    usertemple = userTemplePageVM.getUserTempleMapping("All");
    usertemple.then((newusertemple) {
      newusertemple.forEach((usertemple) => usercheckmap[
      usertemple.templeId.toString() +
          "UT" +
          usertemple.userId.toString()] = false
        //usercehckmap.putIfAbsent(, () => )
      );
    });

    super.initState();
    _index = 1;

  }


  List<Widget> populateChildren(String templeName) {
    List<Widget> children = new List<Widget>();
    List<UserTemple> listofusers =
    listofusertemple.where((user) => user.templeName == templeName).toList();
    for (var user in listofusers) {
      //print(user.templeName+"UT"+user.userId.toString());
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Text(user.userId.toString()),
          Checkbox(
            value: usercheckmap[
            (user.templeId.toString() + "UT" + user.userId.toString())
                .toString()],
            onChanged: (input) {
              setState(() {
                usercheckmap[user.templeId.toString() +
                    "UT" +
                    user.userId.toString()] = input;
                if (input == true)
                  selectedUserTemple.add(user);
                else
                  selectedUserTemple.remove(user);
                //print(input);
              });
            },
          ),
          Text(user.userName),
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
                child: FutureBuilder<List<UserTemple>>(
                    future: usertemple,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<UserTemple>> snapshot) {
                      switch (snapshot.connectionState) {
                      // ignore: missing_return
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(
                              child: const CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            listofusertemple = snapshot.data;
                            listofusertemple
                                .sort((a, b) => b.templeId.compareTo(a.templeId));
                            List<String> setofTeams = listofusertemple
                                .map((user) => user.templeName)
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
                            print("Rolescreen View unavailable");
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
                  child: Text('SELECTED ${selectedUserTemple.length}'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserTempleCreate(selectedUsers : selectedUserTemple)));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('DELETE SELECTED ${selectedUserTemple.length}'),
                  onPressed: () {
                    print(selectedUserTemple);
                    userTemplePageVM.submitDeleteUserTempleMapping(selectedUserTemple);
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
                  context, MaterialPageRoute(builder: (context) => UserTempleView()));
              break;
            case 2:
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
