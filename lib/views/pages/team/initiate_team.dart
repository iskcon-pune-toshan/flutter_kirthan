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
import 'package:flutter_kirthan/views/pages/team/initiate_team_userdetails.dart';
import 'package:flutter_kirthan/views/pages/team/non_user_team_invite.dart';
import 'package:flutter_kirthan/views/pages/team/team_profile_page.dart';
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
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
    /*  access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
            access.elementAt(1).toLowerCase() == "true" ? true : false;
      });*/
      teamPageVM.accessTypes = accessTypes;
    });
  }

  Future loadData() async {
    await teamPageVM.setTeamRequests("Approved");
  }

  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    Team = teamPageVM.getTeamRequests("Approved");
   // print('CHECK');
   // print(Users);
    //print('CHECK');
    //print(Team);
    super.initState();
    loadData();
    loadPref();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
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

  Widget initializedTeams(String userName) {
    return FutureBuilder<List<TeamRequest>>(
        future: Team,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            teamList = snapshot.data
                .where((user) => user.localAdminName == userName)
                .toList();
            List<String> teamTitles =
                teamList.map((title) => (title.teamTitle)).toSet().toList();
            return ListView.builder(
                shrinkWrap: true,
                itemCount: teamTitles.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 10,
                    child: Container(
                      height: 70,
                      child: ListTile(
                        leading: Icon(Icons.group),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TeamProfilePage(
                                      teamTitle: teamTitles[index])));
                        },
                        title: Text(
                          teamTitles[index],
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ),
                    ),
                  );
                });
          }
          return Center(
            child: Container(child: Text('No Teams Available')),
          );
        });
  }

  final userSelected = TextEditingController();
  String selectUser = "";

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Initiate a Team',
        ),
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        key: refreshKey,
        child: FutureBuilder(
            future: getEmail(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                String currentEmail = snapshot.data;

                return FutureBuilder<List<UserRequest>>(
                    future: Users,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<UserRequest>> snapshot) {
                      if (snapshot.hasData) {
                        userList = snapshot.data;
                        String currentUserName;
                       // print(userList);
                        List<UserRequest> localadmin1 = userList
                            .where((element) => element.roleId == 2)
                            .toList();
                        List<String> listOfUsers =
                            userList.map((e) => e.fullName).toSet().toList();
                        for (var user in localadmin1) {
                          if (user.email == currentEmail) {
                            currentUserName = user.fullName;
                          }
                        }
                       // print(listOfUsers);
                        return Column(
                          children: <Widget>[
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                    height: 56,
                                    width:
                                        MediaQuery.of(context).size.width * 0.9,
                                    margin: EdgeInsets.fromLTRB(10, 20, 0, 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          style: BorderStyle.solid,
                                          color: Colors.grey),
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
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      onPressed: () {
                                        showSearch(
                                            context: context,
                                            delegate: userSearch());
                                      },
                                    )),
                              ],
                            ),
                            Divider(),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: Text(
                                  'Initiated Teams:',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                                child: SingleChildScrollView(
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.55,
                                        child:
                                            initializedTeams(currentUserName))))
                          ],
                        );
                      }
                      return CircularProgressIndicator();
                    });
              }
              return Container();
            }),
        onRefresh: refreshList,
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
    return Center(child: Text('No User Found'));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
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
                  element.toLowerCase().contains(query) == true));
          return ListView.builder(
            itemCount: suggestionList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  title: Text(
                    suggestionList[index],
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
    );
  }
}

class Constant {
  static const String invite = "Invite User Via Email";
  static const List<String> choice = [invite];
}
