import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:flutter_kirthan/views/pages/user/initiate_userdetails.dart';
import 'package:flutter_kirthan/views/pages/user/inviteUser.dart';

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
    // print(Users);
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
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Create a Local Admin',
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () => {
                      showSearch(
                        context: context,
                        delegate: Search(),
                      )
                    }),
          ]),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        key: refreshKey,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    "INITIATED BY YOU",
                    style: TextStyle(
                        fontSize: 20, color: KirthanStyles.colorPallete30),
                  ),
                ),
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
                            .where((element) => element.invitedBy == superId)
                            .map((e) => e.fullName)
                            .toSet()
                            .toList();
                        List<int> listOfUsersRole = userList
                            .where((element) => element.invitedBy == superId)
                            .map((e) => e.roleId)
                            .toList();
                        return listOfUsers != null
                            ? Expanded(
                                child: SingleChildScrollView(
                                  physics: ScrollPhysics(),
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
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
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    trailing: Icon(
                                                        Icons.navigate_next),
                                                    subtitle: Text(
                                                      listOfUsersRole.length ==
                                                              listOfUsers.length
                                                          ? listOfUsersRole[
                                                                      index] ==
                                                                  2
                                                              ? "Local Admin"
                                                              : listOfUsersRole[
                                                                          index] ==
                                                                      3
                                                                  ? "User"
                                                                  : "Team Lead"
                                                          : "",
                                                      style: TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  InitiateUserDetails(
                                                                      UserName:
                                                                          listOfUsers[
                                                                              index])));
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
                              )
                            : Container(child: Text("Nothing to show"));
                      }
                      return CircularProgressIndicator();
                    }),
              ]),
            ),
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }

  void getSuperAdminId() async {
    //print("helllloo");
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = await auth.currentUser();
    //print("helo");
    //print(user.email);
  }
}

class Search extends SearchDelegate {
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
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Container(
      child: Center(
        child: Text(selectedResult,
            style: TextStyle(color: KirthanStyles.colorPallete10)),
      ),
    );
  }

  // final List<String> listExample;
  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: Users,
      builder:
          (BuildContext context, AsyncSnapshot<List<UserRequest>> snapshot) {
        if (snapshot.data != null) {
          userlist = snapshot.data;
          List<String> UserList =
              userlist.map((user) => user.fullName).toSet().toList();
          List<String> suggestionList = [];
          query.isEmpty
              ? suggestionList = UserList
              : suggestionList.addAll(UserList.where((element) =>
                  element.toUpperCase().contains(query) == true ||
                  element.toLowerCase().contains(query) == true));
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
                title: Text(
                  suggestionList[index],
                ),
                //leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
              );
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
