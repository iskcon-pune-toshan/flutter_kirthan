import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/connection.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/pages/team/initiate_team.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/CommonBottomNavigationBar.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/tabItem.dart';
import 'package:provider/provider.dart';

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

  StreamSubscription _connectionChangeStream;

  bool isOffline = false;
  @override
  void initState() {
    getRoleId();
    super.initState();
    // print("+++++++++++++ Role Id");
    //print("//////////");
    ConnectionStatus connectionStatus = ConnectionStatus.getInstance();
    _connectionChangeStream =
        connectionStatus.connectionChange.listen(connectionChanged);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
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
    return !(isOffline)
        ? WillPopScope(
            onWillPop: () async {
              if (role_id == 2) {
                final isFirstRouteInCurrentTab =
                    !await tabs_alternative[currentTab]
                        .key
                        .currentState
                        .maybePop();
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
          )
        : Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Scaffold(
              backgroundColor: notifier.darkTheme ? Colors.black : Colors.white,
              body: Column(
                children: [
                  Container(
                      padding: EdgeInsets.only(top: 100),
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                          "assets/images/no_internet_connection.gif")),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "No connection",
                        style: TextStyle(
                            color: notifier.darkTheme
                                ? Colors.white
                                : Colors.black,
                            fontSize: 20),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                      child: Text(
                        "No internet connection found",
                        style: TextStyle(
                          color: notifier.darkTheme
                              ? Colors.white
                              : Colors.black54,
                          fontSize: 16,
                        ),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      child: Text(
                        "Check your connection or try again.",
                        style: TextStyle(
                          color: notifier.darkTheme
                              ? Colors.white
                              : Colors.black54,
                          fontSize: 16,
                        ),
                      )),
                  RaisedButton.icon(
                      label: Text("TRY AGAIN"),
                      icon: Icon(Icons.refresh),
                      onPressed: () {
                        BottomNavigation(
                          onSelectTab: _selectTab,
                          tabs: role_id == 2 ? tabs_alternative : tabs,
                        );
                      })
                ],
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
