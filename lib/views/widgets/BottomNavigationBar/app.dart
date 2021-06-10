import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
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
import 'package:flutter_kirthan/views/pages/user/inviteUser.dart';
import 'package:flutter_kirthan/views/pages/user/user_view.dart';
import 'package:flutter_kirthan/views/pages/user_temple/user_temple_view.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/CommonBottomNavigationBar.dart';
import 'package:flutter_kirthan/views/pages/user/inviteLocalAdmin.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/tabItem.dart';
import 'package:flutter_kirthan/views/pages/user/enterCode.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final ProspectiveUserPageViewModel prospectiveUserPageVM =
    ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());

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
  int role_id;
  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var email = user.email;
    return email;
  }

  @override
  void initState() {
    getRoleId();
    super.initState();
    // print("+++++++++++++ Role Id");
    //print("//////////");
  }

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
    // TabItem(
    //   tabName: "Teams",
    //   icon: Icons.people,
    //   page: TeamView(),
    // ),
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
    // TabItem(
    //   tabName: "Initiate team",
    //   icon: Icons.group_add,
    //   page: InitiateTeam(),
    // ),
    // //  if (role_id == 1)
    // TabItem(
    //   tabName: "Users",
    //   icon: Icons.group,
    //   page: InviteLocalAdmin(),
    // ),

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

  final List<TabItem> tabs_alternative = [
    TabItem(
      tabName: "Home",
      icon: Icons.home,
      page: EventView(),
    ),
    TabItem(
      tabName: "Notifications",
      icon: Icons.notifications,
      page: NotificationView(),
    ),
    TabItem(
      tabName: "Initiate team",
      icon: Icons.group_add,
      page: InitiateTeam(),
    ),
  ];

  AppState() {
    // indexing is necessary for proper functionality
    // of determining which tab is active
    tabs.asMap().forEach((index, details) {
      details.setIndex(index);
    });
    tabs_alternative.asMap().forEach((index, details) {
      details.setIndex(index);
    });
  }
  // sets current tab index
  // and update state
  void _selectTab(int index) {
    if (role_id == 2) {
      if (index == currentTab) {
        // pop to first route
        // if the user taps on the active tab
        tabs_alternative[index]
            .key
            .currentState
            .popUntil((route) => route.isFirst);
      } else {
        // update the state
        // in order to repaint
        setState(() => currentTab = index);
      }
    } else {
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
  }

  @override
  Widget build(BuildContext context) {
    // WillPopScope handle android back btn
    return WillPopScope(
      onWillPop: () async {
        if (role_id == 2) {
          final isFirstRouteInCurrentTab =
              !await tabs_alternative[currentTab].key.currentState.maybePop();
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
        } else {
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
        }
      },
      // this is the base scaffold
      // don't put appbar in here otherwise you might end up
      // with multiple appbars on one screen
      // eventually breaking the app
      child: Scaffold(
        // indexed stack shows only one child
        body: IndexedStack(
          index: currentTab,
          children: role_id == 2
              ? tabs_alternative.map((e) => e.page).toList()
              : tabs.map((e) => e.page).toList(),
        ),
        // Bottom navigation
        bottomNavigationBar: BottomNavigation(
          onSelectTab: _selectTab,
          tabs: role_id == 2 ? tabs_alternative : tabs,
        ),
      ),
    );
  }

  getRoleId() async {
    final FirebaseUser user = await auth.currentUser();
    userRequestList = await userPageVM.getUserRequests("Approved");
    for (var users in userRequestList) {
      // print("HELLOHELLOHELLOHELLOHELLO");
      //print(users.email);
      // print(user.email);
      if (users.email == user.email) {
        setState(() {
          role_id = users.roleId;
        });
      }
    }
    // print("HELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLOHELLO");
    //print(email);
    // print(role_id.toString());
  }
}
