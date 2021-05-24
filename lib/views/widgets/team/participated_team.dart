import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';

final TeamUserPageViewModel teamUserPageVM =
    TeamUserPageViewModel(apiSvc: TeamUserAPIService());
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class Participated_Team extends StatefulWidget {
  @override
  _Participated_TeamState createState() => _Participated_TeamState();
}

class _Participated_TeamState extends State<Participated_Team> {
  Future<List<TeamUser>> teamusers;
  Future<List<UserRequest>> Users;

  List<TeamUser> listofteamusers = new List<TeamUser>();
  List<UserRequest> userList = new List<UserRequest>();
  @override
  void initState() {
    teamusers = teamUserPageVM.getTeamUserMappings("All");
    Users = userPageVM.getUserRequests("All");
    super.initState();
  }

  String currentUserName;
  List<Widget> populateChildren(String teamName) {
    List<Widget> children = new List<Widget>();
    List<TeamUser> listofusers =
        listofteamusers.where((user) => user.teamName == teamName).toList();
    int flag = 0;
    for (var user in listofusers) {
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10),
            child: Text('- ' + user.userName),
          ),
        ],
      ));
    }
    return children;
  }

  int populateChildren2(String teamName, String currentUserName) {
    List<Widget> children = new List<Widget>();
    // print(currentUserName);
    List<TeamUser> listofusers =
        listofteamusers.where((user) => user.teamName == teamName).toList();
    int flag = 0;
    for (var user in listofusers) {
      String abc = user.userName;
      if (currentUserName == abc) {
        children.add(Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text('- ' + user.userName),
            ),
          ],
        ));
        return 1;
      }
    }
    return 0;
  }

  List<String> getUserTeams(List<String> setofTeams, String currentUserName) {
    List<String> abc = [];
    for (int i = 0; i < setofTeams.length; i++) {
      int flag = populateChildren2(setofTeams[i], currentUserName);
      if (flag == 1) abc.add(setofTeams[i]);
    }
    return abc;
  }

  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var email = user.email;
    // Future<List<UserRequest>> listofusers = Users;
    // for(var i in listofusers)
    //   if(i.)

    // ((UserRequest) => user.email == email);

    return email;
  }

  String uname() {
    // StreamBuilder<String>(
    //   future: Users
    // )

    // StreamBuilder(
    //     stream: getEmail(),
    //     builder: (context, snapshot) {
    //       if (snapshot.data != null) {
    //         String uemail = snapshot.data;
    //         return StreamBuilder<List<UserRequest>>(
    //             future: Users,
    //             builder: (context,snapshot) {
    //                   if (snapshot.data != null) {
    //                     // String CurrentUserName;
    //                     userList = snapshot.data;
    //                     for (var uname in userList) {
    //                       if (uname.email == uemail) {
    //                         String CurrentUserName = uname.userName;
    //                         print(CurrentUserName);
    //                       }
    //                     }
    //                     // currentUserName =CurrentUserName;
    //                     // print(currentUserName);
    //               }return Container();
    //             });
    //       }
    //       return Container();
    //     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Participated Teams'),
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
                child: FutureBuilder(
                    future: getEmail(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        String CurrentUserName = "karan512";
                        String uemail = snapshot.data;
                        return FutureBuilder<List<UserRequest>>(
                            future: Users,
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                // String CurrentUserName;
                                userList = snapshot.data;
                                for (var uname in userList) {
                                  if (uname.email == uemail) {
                                    CurrentUserName = uname.fullName;
                                    print(CurrentUserName);
                                  }
                                }
                                // currentUserName =CurrentUserName;
                                // print(currentUserName);
                                return FutureBuilder<List<TeamUser>>(
                                    future: teamusers,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<TeamUser>>
                                            snapshot) {
                                      switch (snapshot.connectionState) {
                                        // ignore: missing_return
                                        case ConnectionState.none:
                                        case ConnectionState.active:
                                        case ConnectionState.waiting:
                                          return Center(
                                              child:
                                                  const CircularProgressIndicator());
                                        case ConnectionState.done:
                                          if (snapshot.hasData) {
                                            //   uname();
                                            listofteamusers = snapshot.data;
                                            listofteamusers.sort((a, b) =>
                                                b.teamId.compareTo(a.teamId));
                                            List<String> setofTeams =
                                                listofteamusers
                                                    .map(
                                                        (user) => user.teamName)
                                                    .toSet()
                                                    .toList();
                                            List<String> participatedTeams =
                                                getUserTeams(setofTeams,
                                                    CurrentUserName);
                                            return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    participatedTeams.length,
                                                itemBuilder: (context, index) {
                                                  return ExpansionTile(
                                                    title: Text(
                                                      participatedTeams[index],
                                                    ),
                                                    children: populateChildren(
                                                      participatedTeams[index],
                                                    ),
                                                  );
                                                });
                                          } else {
                                            return Container(
                                              width: 20.0,
                                              height: 10.0,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              ),
                                            );
                                          }
                                      }
                                    });
                              } else {
                                return CircularProgressIndicator();
                              }
                            });
                      } else {
                        return CircularProgressIndicator();
                      }
                    }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
