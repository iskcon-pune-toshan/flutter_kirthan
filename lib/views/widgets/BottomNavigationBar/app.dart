import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_calendar.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/role_screen/role_screen_view.dart';
import 'package:flutter_kirthan/views/pages/roles/roles_view.dart';
import 'package:flutter_kirthan/views/pages/screens/screens_view.dart';
import 'package:flutter_kirthan/views/pages/team/initiate_team.dart';
import 'package:flutter_kirthan/views/pages/team/team_view.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_view.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/CommonBottomNavigationBar.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/inviteLocalAdmin.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/tabItem.dart';
//import 'bottomNavigation.dart';
//import 'screens.dart';
FirebaseAuth auth = FirebaseAuth.instance;
final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());
int role_id;
class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  // this is static property so other widget throughout the app
  // can access it simply by AppState.currentTab
  static int currentTab = 0;
  Future<List<UserRequest>> userRequest;
  List<UserRequest> userRequestList = List<UserRequest>();

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;

    print(email);
    print("Current User Call");
    return email;
  }


  getRoleId() async {
    FutureBuilder<List<UserRequest>>(
        future: userRequest,
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
  }

  @override
  void initState() {
    String email = getCurrentUser().toString();
    userRequest = userPageVM.getUserRequests(email.toString());
    getRoleId();
    super.initState();
    print("+++++++++++++ Role Id");
    print(role_id);
  }
  // list tabs here
  final List<TabItem> tabs = [
    TabItem(
      tabName: "Home",
      icon: Icons.home,
      page: EventView(),
    ),
    /*TabItem(
      tabName: "Users",
      icon: Icons.account_circle,
      page: UserView(),
    ),*/
    TabItem(
      tabName: "Teams",
      icon: Icons.people,
      page: TeamView(),
    ),
    TabItem(
      tabName: "Notifications",
      icon: Icons.notifications,
      page: NotificationView(),
    ),
    TabItem(
      tabName: "Events",
      icon: Icons.calendar_today,
      page: MyEventView(),
    ),
    // if(role_id == 1 || role_id ==2)
      TabItem(
        tabName: "Initiate team",
        icon: Icons.group_add,
        page: InitiateTeam(),
      ),
    // if(role_id == 1)
    TabItem(
      tabName: "Users",
      icon:  Icons.group ,
      page: InviteLocalAdmin() ,
    ),

    /*TabItem(
      tabName: "Screens",
      icon: Icons.fullscreen,
      page: ScreensView(),
    ),
    TabItem(
      tabName: "Roles",
      icon: Icons.person_outline,
      page: RolesView(),
    ),
    TabItem(
      tabName: "RoleScreen",
      icon: Icons.fullscreen_exit,
      page: RoleScreenView(),
    ),*/


  ];

  AppState() {
    // indexing is necessary for proper funcationality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }

  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (index == currentTab) {
      // pop to first route
      // if the user taps on the active tab
      tabs[index].key.currentState.popUntil((route) => route.isFirst);
    } else {
      // update the state
      // in order to repaint
      setState(() => currentTab = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await tabs[currentTab].key.currentState.maybePop();
        if (isFirstRouteInCurrentTab) {
          // if not on the 'main' tab
          if (currentTab != 0) {
            // select 'main' tab
            _selectTab(0);
            // back button handled by app
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
        // indexed stack shows only one child
        body: IndexedStack(
          index: currentTab,
          children: tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation
        bottomNavigationBar: BottomNavigation(
          onSelectTab: _selectTab,
          tabs: tabs,
        ),
      ),
    );
  }
}