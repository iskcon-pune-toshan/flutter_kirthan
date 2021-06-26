import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/user/initiate_userdetails.dart';
import 'package:flutter_kirthan/views/pages/user/inviteUser.dart';
import 'package:provider/provider.dart';

import 'initiate_userdetails.dart';

// final TeamPageViewModel teamPageVM =
//     TeamPageViewModel(apiSvc: TeamAPIService());
final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class InviteLocalAdmin extends StatefulWidget {
  @override
  _InviteLocalAdminState createState() => _InviteLocalAdminState();
}

class _InviteLocalAdminState extends State<InviteLocalAdmin> {
  void choiceAction(String choice) {
    if (choice == Constant.invite) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => InviteUser()));
    }
  }

  FirebaseUser user;
  int superId;
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future loadData() async {
    //await teamPageVM.setTeamRequests("Approved");

    await userPageVM.getUserRequests("Approved");
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      loadData();
    });

    return null;
  }

  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    getSuperAdminId();
    super.initState();
  }

  final userSelected = TextEditingController();
  String selectUser = "";
  // List<String> listOfUsers =[
  // ];
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => (Scaffold(
        appBar: AppBar(
          title: Text('Create a Local Admin',
              style: TextStyle(fontSize: notifier.custFontSize)),

          // actions: [
          // PopupMenuButton<String>(
          //   onSelected: choiceAction,
          //   itemBuilder: (BuildContext context) {
          //     return Constant.choice.map((String choice) {
          //       return PopupMenuItem<String>(
          //           value: choice, child: Text(choice));
          //     }).toList();
          //   },
          // )
          //],
        ),
        drawer: MyDrawer(),
        body: RefreshIndicator(
          key: refreshKey,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  FutureBuilder<List<UserRequest>>(
                      future: userPageVM.getUserRequests("Approved"),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<UserRequest>> snapshot) {
                        if (snapshot.hasData) {
                          userList = snapshot.data;
                          String _email = user.email;

                          for (var _users in userList) {
                            if (_users.email == _email) {
                              superId = _users.id;
                            } else {}
                          }

                          List<String> listOfUsers = userList
                              .where((element) =>
                          element.invitedBy == superId &&
                              element.id != superId)
                              .map((e) => e.fullName)
                              .toSet()
                              .toList();
                          List<int> listOfUsersRole = userList
                              .where((element) =>
                          element.invitedBy == superId &&
                              element.id != superId)
                              .map((e) => e.roleId)
                              .toList();
                          return listOfUsers.length != 0
                              ? Column(
                            children: [
                              Container(
                                  height: 56,
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.9,
                                  margin:
                                  EdgeInsets.fromLTRB(10, 20, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.grey),
                                  ),
                                  child: FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Align(
                                            alignment:
                                            Alignment.centerRight,
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
                                              fontSize:
                                              notifier.custFontSize,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      showSearch(
                                          context: context,
                                          delegate:
                                          Search(superId: superId));
                                    },
                                  )),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin:
                                EdgeInsets.only(top: 20, left: 20),
                                child: Text(
                                  "Initiated by you:",
                                  style: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color:
                                      KirthanStyles.colorPallete30),
                                ),
                              ),
                              Container(
                                child: SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        20, 20, 0, 20),
                                    child: Column(
                                      children: [
                                        ListView.builder(
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            itemCount: listOfUsers.length,
                                            itemBuilder: (_, int index) {
                                              return Column(
                                                children: [
                                                  ListTile(
                                                    title: Text(
                                                      listOfUsers[index]
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          fontSize: notifier
                                                              .custFontSize,
                                                          fontWeight:
                                                          FontWeight
                                                              .bold),
                                                    ),
                                                    trailing: Icon(Icons
                                                        .navigate_next),
                                                    subtitle: Text(
                                                      listOfUsersRole
                                                          .length ==
                                                          listOfUsers
                                                              .length
                                                          ? listOfUsersRole[
                                                      index] ==
                                                          2
                                                          ? "Local Admin"
                                                          : listOfUsersRole[index] ==
                                                          3
                                                          ? "User"
                                                          : "Team Lead"
                                                          : "",
                                                      style: TextStyle(
                                                          fontSize: notifier
                                                              .custFontSize),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  InitiateUserDetails(
                                                                      UserName:
                                                                      listOfUsers[index])));
                                                    },
                                                  ),
                                                  Divider(
                                                    thickness: 2,
                                                    endIndent: 20,
                                                  )
                                                ],
                                              );
                                            })
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                              : Column(
                            children: [
                              Container(
                                  height: 56,
                                  width:
                                  MediaQuery.of(context).size.width *
                                      0.9,
                                  margin:
                                  EdgeInsets.fromLTRB(10, 20, 0, 10),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        style: BorderStyle.solid,
                                        color: Colors.grey),
                                  ),
                                  child: FlatButton(
                                    child: Row(
                                      children: <Widget>[
                                        Align(
                                            alignment:
                                            Alignment.centerRight,
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
                                              fontSize:
                                              notifier.custFontSize,
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      showSearch(
                                          context: context,
                                          delegate: Search());
                                    },
                                  )),
                              Container(
                                alignment: Alignment.centerLeft,
                                margin:
                                EdgeInsets.only(top: 20, left: 20),
                                child: Text(
                                  "Initiated by you:",
                                  style: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color:
                                      KirthanStyles.colorPallete30),
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height:
                                MediaQuery.of(context).size.height -
                                    350,
                                child: Text(
                                  "Nothing to show",
                                  style: TextStyle(
                                      fontSize: notifier.custFontSize,
                                      color:
                                      KirthanStyles.colorPallete60),
                                ),
                              )
                            ],
                          );
                        }
                        return Center(child: CircularProgressIndicator());
                      }),
                ]),
              ),
            ),
          ),
          onRefresh: refreshList,
        ),
      )),
    );
  }

  void getSuperAdminId() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = await auth.currentUser();
  }
}

class Search extends SearchDelegate {
  int superId;
  Search({this.superId});
  Future<List<UserRequest>> Users = userPageVM.getUserRequests("Approved");
  List<UserRequest> userlist = new List<UserRequest>();
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
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => InviteUser()));
      }
    }

    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
      Consumer<ThemeNotifier>(
          builder: (context, notifier, child) => (PopupMenuButton<String>(
            onSelected: choiceAction,
            itemBuilder: (BuildContext context) {
              return Constant.choice.map((String choice) {
                return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice,
                        style: TextStyle(fontSize: notifier.custFontSize)));
              }).toList();
            },
          )))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => (Container(
          child: Center(
            child: Text(selectedResult,
                style: TextStyle(
                    color: KirthanStyles.colorPallete10,
                    fontSize: notifier.custFontSize)),
          ),
        )));
  }

  // final List<String> listExample;
  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => (FutureBuilder(
          future: Users,
          builder: (BuildContext context,
              AsyncSnapshot<List<UserRequest>> snapshot) {
            if (snapshot.data != null) {
              userlist = snapshot.data;
              userlist.removeWhere((element) => element.id == superId);
              userlist.removeWhere((element) => element.roleId == 1);
              List<String> UserList =
              userlist.map((user) => user.fullName).toSet().toList();

              List<String> suggestionList = [];
              query.isEmpty
                  ? suggestionList = UserList
                  : suggestionList.addAll(UserList.where((element) =>
              element.toUpperCase().contains(query) == true ||
                  element.toLowerCase().contains(query) == true ||
                  element.contains(query) == true));
              return ListView.builder(
                itemCount: suggestionList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => InitiateUserDetails(
                                UserName: suggestionList[index],
                              )));
                    },
                    title: Text(suggestionList[index],
                        style: TextStyle(fontSize: notifier.custFontSize)),
                    //leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
                  );
                },
              );
            }
            return Container();
          },
        )));
  }
}

class Constant {
  static const String invite = "Invite User Via Email";
  static const List<String> choice = [invite];
}
