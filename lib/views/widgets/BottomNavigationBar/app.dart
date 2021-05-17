import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/team/initiate_team.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/CommonBottomNavigationBar.dart';
import 'file:///D:/AndroidStudioProjects/flutter_kirthan/lib/views/pages/user/inviteLocalAdmin.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/tabItem.dart';
import 'package:flutter_kirthan/views/widgets/event/int_item.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

//import 'bottomNavigation.dart';
//import 'screens.dart';
FirebaseAuth auth = FirebaseAuth.instance;
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  int role_id;
  Future<List<UserRequest>> userRequest;
  List<UserRequest> userRequestList = List<UserRequest>();

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;

    print(email);
    print("Current User Call");
    return email;
  }

  String email;

  //
  getUserId() async {
    final FirebaseUser user = await auth.currentUser();
    List<UserRequest> userList = await userPageVM.getUserRequests("Approved");
    for (var users in userList) {
      print("Role Id is");
      if (users.email == user.email) {
        setState(() {
          role_id = users.roleId;
        });
      }
    }
  }
  /*getRoleId() async {
    FutureBuilder<List<UserRequest>>(
        future:  userPageVM.getUserRequests(email),
        builder:
            (BuildContext context, AsyncSnapshot<List<UserRequest>> snapshot) {
          if (snapshot.data != null) {
            setState(() {
              userRequestList = snapshot.data;
              for (var user in userRequestList) {
                setState(() {
                  role_id = user.roleId;
                  print("From User");
                  print(user.roleId);
                });
              }
            });
          }else{
            return Text("Error in getRoleId");
          }
        });
  }*/

  @override
  void initState() {
    //checkIfLoggedIn();

    email = getCurrentUser().toString();
    print(">>>>>>>>>>>>>>>>");
    print(email);
    getUserId();
    // getRoleId();
    super.initState();
    print("+++++++++++++ Role Id");
    print(role_id);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Bottom(role_id: role_id)),
    );
  }
}

class Bottom extends StatefulWidget {
  int role_id;
  Bottom({Key key, this.role_id}) : super(key: key);
  @override
  _BottomState createState() => _BottomState();
}

int _currentindex = 0;

final List<Widget> tabs = [
  EventView(),
  NotificationView(),
  MyEventView(),
];
final List<Widget> tabs_alternative = [
  EventView(),
  NotificationView(),
  InitiateTeam(),
];

class _BottomState extends State<Bottom> {
  Widget _bar() {
    print("<<<<<<<<<<<<<<<<<<");
    print(widget.role_id);
    if (widget.role_id == 2) {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ThemeNotifier(),
            ),
            ChangeNotifierProvider(
              create: (_) => int_item(),
            )
          ],
          child: Consumer<ThemeNotifier>(
              builder: (context, ThemeNotifier notifier, child) {
            return new MaterialApp(
              title: 'Kirthan Application',
              theme: notifier.darkTheme ? dark : light,
              home: Scaffold(
                body: tabs_alternative[_currentindex],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentindex,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: "Notifications",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.people),
                      label: "Initiate a Team",
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentindex = index;
                    });
                  },
                ),
              ),
              debugShowCheckedModeBanner: false,
            );
          }));
    } else {
      return MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => ThemeNotifier(),
            ),
            ChangeNotifierProvider(
              create: (_) => int_item(),
            )
          ],
          child: Consumer<ThemeNotifier>(
              builder: (context, ThemeNotifier notifier, child) {
            return new MaterialApp(
              title: 'Kirthan Application',
              theme: notifier.darkTheme ? dark : light,
              home: Scaffold(
                body: tabs[_currentindex],
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _currentindex,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "Home",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.notifications),
                      label: "Notifications",
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_today),
                      label: "My Events",
                    ),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentindex = index;
                    });
                  },
                ),
              ),
              debugShowCheckedModeBanner: false,
            );
          }));
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Center(
        child: _bar(),
      ),
    );
  }
}
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_kirthan/models/prospectiveuser.dart';
// import 'package:flutter_kirthan/models/user.dart';
// import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
// import 'package:flutter_kirthan/services/user_service_impl.dart';
// import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
// import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
// import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
// import 'package:flutter_kirthan/views/pages/event/event_view.dart';
// import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
// import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
// import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
// import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
// import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';
// import 'package:flutter_kirthan/views/pages/team/initiate_team.dart';
// import 'package:flutter_kirthan/views/pages/team/team_view.dart';
// import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
// import 'package:flutter_kirthan/views/pages/user/inviteUser.dart';
// import 'package:flutter_kirthan/views/pages/user/user_view.dart';
// import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
// import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/CommonBottomNavigationBar.dart';
// import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/inviteLocalAdmin.dart';
// import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/tabItem.dart';
// import 'package:flutter_kirthan/views/pages/user/enterCode.dart';
//
// FirebaseAuth auth = FirebaseAuth.instance;
// final UserPageViewModel userPageVM =
//     UserPageViewModel(apiSvc: UserAPIService());
// final ProspectiveUserPageViewModel prospectiveUserPageVM =
//     ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());
//
// class App extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() => AppState();
// }
//
// class AppState extends State<App> {
//   // this is static property so other widget throughout the app
//   // can access it simply by AppState.currentTab
//   static int currentTab = 0;
//   Future<List<UserRequest>> userRequest;
//   List<UserRequest> userRequestList = List<UserRequest>();
//
//   Future<String> getEmail() async {
//     final FirebaseAuth auth = FirebaseAuth.instance;
//     var user = await auth.currentUser();
//     var email = user.email;
//     return email;
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     print("+++++++++++++ Role Id");
//     print("//////////");
//   }
//
//   final List<TabItem> tabs = [
//     TabItem(
//       tabName: "Home",
//       icon: Icons.home,
//       page: EventView(),
//     ),
//     /*TabItem(
//       tabName: "Users",
//       icon: Icons.account_circle,
//       page: UserView(),
//     ),*/
//     // TabItem(
//     //   tabName: "Teams",
//     //   icon: Icons.people,
//     //   page: TeamView(),
//     // ),
//     TabItem(
//       tabName: "Notifications",
//       icon: Icons.notifications,
//       page: NotificationView(),
//     ),
//     TabItem(
//       tabName: "Events",
//       icon: Icons.calendar_today,
//       page: MyEventView(),
//     ),
//     TabItem(
//       tabName: "Initiate team",
//       icon: Icons.group_add,
//       page: InitiateTeam(),
//     ),
//     //  if (role_id == 1)
//     TabItem(
//       tabName: "Users",
//       icon: Icons.group,
//       page: InviteLocalAdmin(),
//     ),
//
//     /*TabItem(
//       tabName: "Screens",
//       icon: Icons.fullscreen,
//       page: ScreensView(),
//     ),
//     TabItem(
//       tabName: "Roles",
//       icon: Icons.person_outline,
//       page: RolesView(),
//     ),
//     TabItem(
//       tabName: "RoleScreen",
//       icon: Icons.fullscreen_exit,
//       page: RoleScreenView(),
//     ),*/
//   ];
//
//   AppState() {
//     // indexing is necessary for proper functionality
//     // of determining which tab is active
//     tabs.asMap().forEach((index, details) {
//       details.setIndex(index);
//     });
//   }
//   // sets current tab index
//   // and update state
//   void _selectTab(int index) {
//     if (index == currentTab) {
//       // pop to first route
//       // if the user taps on the active tab
//       tabs[index].key.currentState.popUntil((route) => route.isFirst);
//     } else {
//       // update the state
//       // in order to repaint
//       setState(() => currentTab = index);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // WillPopScope handle android back btn
//     return WillPopScope(
//       onWillPop: () async {
//         final isFirstRouteInCurrentTab =
//             !await tabs[currentTab].key.currentState.maybePop();
//         if (isFirstRouteInCurrentTab) {
//           // if not on the 'main' tab
//           if (currentTab != 0) {
//             // select 'main' tab
//             _selectTab(0);
//             // back button handled by app
//             return false;
//           }
//         }
//         // let system handle back button if we're on the first route
//         return isFirstRouteInCurrentTab;
//       },
//       // this is the base scaffold
//       // don't put appbar in here otherwise you might end up
//       // with multiple appbars on one screen
//       // eventually breaking the app
//       child: Scaffold(
//         // indexed stack shows only one child
//         body: IndexedStack(
//           index: currentTab,
//           children: tabs.map((e) => e.page).toList(),
//         ),
//         // Bottom navigation
//         bottomNavigationBar: BottomNavigation(
//           onSelectTab: _selectTab,
//           tabs: tabs,
//         ),
//       ),
//     );
//   }
// }
