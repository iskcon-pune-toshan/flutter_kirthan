import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/services/role_screen_service_impl.dart';
import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_create.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';

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
      children.add(
          Row(
          //direction: Axis.horizontal,
        children: <Widget>[
          //Text(user.userId.toString()),

          Checkbox(
            value: usercheckmap[
                (user.roleId.toString() + "RS" + user.screenId.toString())
                    .toString()],
            onChanged: (input) {
              setState(() {
                usercheckmap[user.roleId.toString() +
                    "RS" +
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
          Checkbox(
            value: user.createFlag,
            onChanged: (input) {
              setState(() {
               user.createFlag = input;
                if (input == true)
                  selectedRoleScreen.add(user);
                else
                  selectedRoleScreen.remove(user);
                print(input);
              });
            },
          ),
          Text('Create'),
          Checkbox(
            value: user.updateFlag,
            onChanged: (input) {
              setState(() {
                user.updateFlag = input;
                if (input == true)
                  selectedRoleScreen.add(user);
                else
                  selectedRoleScreen.remove(user);
                //print(input);
              });
            },
          ),
          Text('Update'),
          Checkbox(
            value: user.deleteFlag,
            onChanged: (input) {
              setState(() {
                user.deleteFlag = input;
                if (input == true)
                  selectedRoleScreen.add(user);
                else
                  selectedRoleScreen.remove(user);
                //print(input);
              });
            },
          ),
          Text('Delete'),
          Checkbox(
            value: user.viewFlag,
            onChanged: (input) {
              setState(() {
                user.viewFlag = input;
                if (input == true)
                  selectedRoleScreen.add(user);
                else
                  selectedRoleScreen.remove(user);
                //print(input);
              });
            },
          ),
          Text('View'),
          Checkbox(
            value: user.processFlag,
            onChanged: (input) {
              setState(() {
                user.processFlag = input;
                if (input == true)
                  selectedRoleScreen.add(user);
                else
                  selectedRoleScreen.remove(user);
                //print(input);
              });
            },
          ),
          Text('Process'),
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
                            List<String> setofRoles = listofrolescreen
                                .map((user) => user.roleName)
                                .toSet()
                                .toList();
                            //setofTeams.reversed;
                            return ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: setofRoles.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title: Text(setofRoles[index]),

                                    //subtitle: Text("Hello Manjunath"),
                                    children:
                                        populateChildren(setofRoles[index]),
                                  );
                                });
                          } else {
                            print('RoleScreenView unavailable');
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
                                RoleScreenCreate(selectedScreens : selectedRoleScreen)));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('DELETE SELECTED ${selectedRoleScreen.length}'),
                  onPressed: () {
                    print(selectedRoleScreen);
                    roleScreenPageVM
                        .submitDeleteRoleScreenMapping(selectedRoleScreen);
                  },
                ),
              ),
            ],
          ),
        ],
      ),

    );
  }
}
