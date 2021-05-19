import 'package:dropdownfield/dropdownfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:flutter_kirthan/views/pages/user/initiate_userdetails.dart';
import 'package:flutter_kirthan/views/pages/user/inviteUser.dart';
import 'initiate_userdetails.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class InviteLocalAdmin extends StatefulWidget {
  @override
  _InviteLocalAdminState createState() => _InviteLocalAdminState();
}

class _InviteLocalAdminState extends State<InviteLocalAdmin> {
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future loadData() async {
    await teamPageVM.setTeamRequests("Approved");
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
    print(Users);
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
      ),
      drawer: MyDrawer(),
      body: RefreshIndicator(
        key: refreshKey,
        child: Column(children: <Widget>[
          SizedBox(
            height: 10,
          ),
          FutureBuilder<List<UserRequest>>(
              future: Users,
              builder: (BuildContext context,
                  AsyncSnapshot<List<UserRequest>> snapshot) {
                if (snapshot.hasData) {
                  userList = snapshot.data;
                  print(userList);
                  List<String> listOfUsers =
                      userList.map((e) => e.userName).toSet().toList();
                  print(listOfUsers);
                  return Expanded(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(20, 20, 0, 20),
                        child: Column(
                          children: [
                            DropDownField(
                              textStyle: TextStyle(color: Colors.white70),
                              controller: userSelected,
                              hintText: 'Search User',
                              items: listOfUsers,
                              onValueChanged: (value) {
                                setState(() {
                                  selectUser = value;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              InitiateUserDetails(
                                                  UserName: selectUser)));
                                });
                              },
                              icon: PopupMenuButton(
                                  onSelected: (input) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InviteUser(),
                                        ));
                                  },
                                  child: const Icon(
                                    Icons.more_vert_sharp,
                                    color: Colors.grey,
                                  ),
                                  itemBuilder: (BuildContext context) {
                                    List<String> newList = ["Invite User"];
                                    return newList.map((f) {
                                      return CheckedPopupMenuItem<String>(
                                        child: Text(
                                          f,
                                        ),
                                        value: f,

                                      );
                                    }).toList();
                                  }),
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: listOfUsers.length,
                                itemBuilder: (_, int index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        title: Text(
                                            listOfUsers[index].toUpperCase()),
                                        trailing: Icon(Icons.navigate_next),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      InitiateUserDetails(
                                                          UserName: listOfUsers[
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
                  );
                }
                return CircularProgressIndicator();
              }),
        ]),
        onRefresh: refreshList,
      ),
    );
  }
}
