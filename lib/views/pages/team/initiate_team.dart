import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/team/initiate_team_userdetails.dart';
import 'package:flutter_kirthan/views/pages/team/non_user_team_invite.dart';
import 'package:flutter_kirthan/views/pages/team/team_profile_page.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());
final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class InitiateTeam extends StatefulWidget {
  final String title = "Teams";
  final String screenName = SCR_TEAM;
  @override
  _InitiateTeamState createState() => _InitiateTeamState();
}

class _InitiateTeamState extends State<InitiateTeam> {
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  List<UserRequest> localAdminList = new List<UserRequest>();
  Future<List<TeamRequest>> Team;
  List<TeamRequest> teamList = new List<TeamRequest>();
  String currentEmail;
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();

  // void loadPref() async {
  //   prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     access = prefs.getStringList(widget.screenName);
  //     access.forEach((f) {
  //       List<String> access = f.split(":");
  //       accessTypes[access.elementAt(0)] =
  //           access.elementAt(1).toLowerCase() == "true" ? true : false;
  //     });
  //     teamPageVM.accessTypes = accessTypes;
  //   });
  // }

  Future loadData() async {
    await teamPageVM.getTeamRequests("Initiated");
  }

  String currentUserName;
  @override
  void initState() {
    super.initState();
    loadData();
    // loadPref();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      loadData();
    });
    return null;
  }

  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var email = user.email;
    return email;
  }

  // Widget initializedTeams(String userName) {
  //   return RefreshIndicator(
  //     key: refreshKey,
  //     child: Consumer<ThemeNotifier>(
  //       builder:(context, notifier, child)
  //       =>FutureBuilder<List<TeamRequest>>(
  //           future: Team,
  //           builder: (context, snapshot) {
  //             if (snapshot.data != null) {
  //               teamList = snapshot.data;
  //               List<String> teamTitles = this
  //                   .teamList
  //                   .map((title) => (title.teamTitle))
  //                   .toSet()
  //                   .toList();
  //               return ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: teamList.length,
  //                   itemBuilder: (context, index) {
  //                     return Card(
  //                       elevation: 10,
  //                       child: Container(
  //                         height: 70,
  //                         child: ListTile(
  //                           leading: Icon(Icons.group),
  //                           trailing: Icon(Icons.arrow_forward_ios),
  //                           onTap: () {
  //                             Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) => TeamProfilePage(
  //                                         teamTitle: teamList[index].teamTitle)));
  //                           },
  //                           title: Text(
  //                             teamTitles[index],
  //                             style: TextStyle(
  //                                 fontSize: 4+notifier.custFontSize,
  //                                 fontWeight: FontWeight.bold,
  //                                 color: Colors.grey),
  //                           ),
  //                         ),
  //                       ),
  //                     );
  //                   });
  //             }
  //             return Center(
  //               child: Container(child: Text('No Teams Available',style: TextStyle(fontSize: notifier.custFontSize),)),
  //             );
  //           }),
  //     ),
  //     onRefresh: refreshList,
  //   );
  // }

  final userSelected = TextEditingController();
  String selectUser = "";

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Consumer<ThemeNotifier>(builder: (context, notifier, child) =>(
        Scaffold(
          appBar: AppBar(
            title: Text(
                'Initiate a Team',style: TextStyle(
                fontSize: notifier.custFontSize)
            ),
          ),
          drawer: MyDrawer(),
          body: RefreshIndicator(
            key: refreshKey,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: <Widget>[
                    Container(
                        height: 56,
                        width: MediaQuery.of(context).size.width * 0.9,
                        margin: EdgeInsets.fromLTRB(10, 20, 0, 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                              style: BorderStyle.solid, color: Colors.grey),
                        ),
                        child: FlatButton(
                          child: Row(
                            children: <Widget>[
                              Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(
                                    Icons.search,
                                    color: Colors.grey,
                                  )),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Search User',
                                style: TextStyle(fontSize: notifier.custFontSize, color: Colors.grey),
                              ),
                            ],
                          ),
                          onPressed: () {
                            showSearch(context: context, delegate: userSearch());
                          },
                        )),
                    SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.6,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: EdgeInsets.only(top: 20, left: 20),
                              child: Text(
                                "Initiated Teams:",
                                style: TextStyle(fontSize: 4+notifier.custFontSize),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              thickness: 2,
                              indent: 20,
                              endIndent: 20,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            FutureBuilder<List<TeamRequest>>(
                                future: teamPageVM.getTeamRequests("Initiated"),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<TeamRequest>> snapshot) {
                                  if (snapshot.hasData) {
                                    teamList = snapshot.data;
                                    List<String> teamtitles = teamList
                                        .map((e) => e.teamTitle)
                                        .toSet()
                                        .toList();
                                    return teamtitles.isNotEmpty
                                        ? Expanded(
                                      child: SingleChildScrollView(
                                        physics: ScrollPhysics(),
                                        child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                20, 20, 0, 20),
                                            child: Column(children: <Widget>[
                                              ListView.builder(
                                                physics:
                                                NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: teamtitles.length,
                                                itemBuilder: (context, index) {
                                                  return Column(
                                                    children: [
                                                      ListTile(
                                                        leading:
                                                        Icon(Icons.group),
                                                        trailing: Icon(Icons
                                                            .arrow_forward_ios),
                                                        onTap: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      TeamProfilePage(
                                                                          teamTitle:
                                                                          teamList[index].teamTitle)));
                                                        },
                                                        title: Text(
                                                          teamtitles[index],
                                                          style: TextStyle(
                                                              fontSize: notifier.custFontSize,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold,
                                                              color:
                                                              Colors.grey),
                                                        ),
                                                      ),
                                                      Divider(
                                                        thickness: 2,
                                                        endIndent: 20,
                                                      )
                                                    ],
                                                  );
                                                },
                                              )
                                            ])),
                                      ),
                                    )
                                        : Container(
                                        margin: EdgeInsets.only(
                                            top: MediaQuery.of(context)
                                                .size
                                                .height *
                                                0.25),
                                        child: Text(
                                          "No teams initiated",
                                          style: TextStyle(
                                              fontSize: notifier.custFontSize, color: Colors.grey),
                                        ));
                                  }
                                  return Center(child: CircularProgressIndicator());
                                })
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),

            onRefresh: refreshList,
          ),
        )
    ),
    );
  }
}

class userSearch extends SearchDelegate<String> {
  Future<List<UserRequest>> Users = userPageVM.getUserRequests("Approved");
  List<UserRequest> userList = new List<UserRequest>();
  List<String> recentSearch = [];

  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryIconTheme: theme.primaryIconTheme.copyWith(color: Colors.grey),
      primaryColorBrightness: Brightness.light,
      primaryTextTheme: theme.textTheme,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    String menuItem = " Invite User via Email";
    void choiceAction(String choice) {
      if (choice == Constant.invite) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NonUserTeamInvite()));
      }
    }

    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      ),
      PopupMenuButton<String>(
        onSelected: choiceAction,
        itemBuilder: (BuildContext context) {
          return Constant.choice.map((String choice) {
            return PopupMenuItem<String>(value: choice, child: Text(choice));
          }).toList();
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, notifier, child) =>(
        Center(child: Text('No User Found', style: TextStyle(
            fontSize: notifier.custFontSize)),
        )
    )
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return  Consumer<ThemeNotifier>(builder: (context, notifier, child) =>(
        FutureBuilder(
          future: Users,
          builder:
              (BuildContext context, AsyncSnapshot<List<UserRequest>> snapshot) {
            if (snapshot.data != null) {
              userList = snapshot.data;
              List<String> UserList =
              userList.map((user) => user.fullName).toSet().toList();
              List<String> suggestionList = [];
              query.isEmpty
                  ? suggestionList = recentSearch
                  : suggestionList.addAll(UserList.where((element) =>
              element.toUpperCase().contains(query) == true ||
                  element.toLowerCase().contains(query) == true || element.contains(query) == true));
              return ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                      title: Text(
                          suggestionList[index],style: TextStyle(
                          fontSize: notifier.custFontSize)
                      ),
                      leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
                      onTap: () {
                        (suggestionList.isEmpty)
                            ? showResults(context)
                            : Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeamInitiateUserDetails(
                                    UserName: suggestionList[index])));
                      });
                },
              );
            }
            return Container();
          },
        )
    ),
    );
  }
}

class Constant {
  static const String invite = "Invite User Via Email";
  static const List<String> choice = [invite];
}
