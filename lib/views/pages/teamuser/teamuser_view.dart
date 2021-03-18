import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/eventuser/eventuser_create.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


final TeamUserPageViewModel teamUserPageVM =
TeamUserPageViewModel(apiSvc: TeamUserAPIService());


class TeamUserView extends StatefulWidget {
  final String title = "Team User Mapping View";
  final String screenName = SCR_TEAM_USER;

  @override
  _TeamUserViewState createState() => _TeamUserViewState();
}

class _TeamUserViewState extends State<TeamUserView> {
//  final IKirthanRestApi apiSvc = new RestAPIServices();
  Future<List<TeamUser>> teamusers;

  List<TeamUser> listofteamusers = new List<TeamUser>();
  List<TeamUser> selectedTeamUsers = new List<TeamUser>();
  Map<String, bool> usercehckmap = new Map<String, bool>();

  /*Map<String, bool> usercehckmap = {
    '1TU1': false,
    '1TU2': false,
    '1TU5': false,
    '2TU2': false,
    '3TU2': false,
    '4TU1': false,
    '4TU2': false,
    '4TU4': false,
    '4TU5': false,
    '5TU1': false,
    '5TU2': false,
    '5TU3': false,
    '6TU1': false,
    '6TU2': false,
    '6TU4': false,
    '6TU5': false,
  };
*/
  /*= [
    TeamUser(
        id: 1,
        teamId: 1,
        userId: 1,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 2,
        teamId: 1,
        userId: 2,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 3,
        teamId: 1,
        userId: 3,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 4,
        teamId: 2,
        userId: 1,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 5,
        teamId: 2,
        userId: 2,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 6,
        teamId: 2,
        userId: 3,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 7,
        teamId: 2,
        userId: 4,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
  ];
*/
  @override
  void initState() {
    teamusers = teamUserPageVM.getTeamUserMappings("SA");
    teamusers.then((newteamusers) {
      newteamusers.forEach((teamuser) => usercehckmap[
              teamuser.teamId.toString() +
                  "TU" +
                  teamuser.userId.toString()] = false
          //usercehckmap.putIfAbsent(, () => )
          );
      /*listofteamusers.addAll(teamusers);
      print(teamusers.length);
      print("Vardhan: ");
      print(listofteamusers.length);
      print("Geetha: ");
      //listofteamusers.

       */
    });

    //listofteamusers.forEach((myteamuser) => print(myteamuser.teamId.toString()+"Manju:"+myteamuser.userId.toString()));
    //print("Manjunath: 1:  ${listofteamusers.length.toString()}");
    //listofteamusers.forEach((myteamuser) => print("Manju:"));
    //print("Manju: 2");
    super.initState();
    //usercehckmap = new Map<String,bool>();
  }

  //List<Widget> populateChildren(int teamid) {
  List<Widget> populateChildren(String teamName) {
    List<Widget> children = new List<Widget>();
    List<TeamUser> listofusers =
        listofteamusers.where((user) => user.teamName == teamName).toList();
    for (var user in listofusers) {
      //print(user.teamId.toString()+"TU"+user.userId.toString());
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //Text(user.userId.toString()),
          Checkbox(
            value: usercehckmap[
                (user.teamId.toString() + "TU" + user.userId.toString())
                    .toString()],
            onChanged: (input) {
              setState(() {
                usercehckmap[user.teamId.toString() +
                    "TU" +
                    user.userId.toString()] = input;
                if (input == true)
                  selectedTeamUsers.add(user);
                else
                  selectedTeamUsers.remove(user);
                //print(input);
              });
            },
          ),
          Text(user.userName),
        ],
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
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
                child: FutureBuilder<List<TeamUser>>(
                    future: teamusers,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<TeamUser>> snapshot) {
                      switch (snapshot.connectionState) {
                        // ignore: missing_return
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(
                              child: const CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            listofteamusers = snapshot.data;
                            listofteamusers
                                .sort((a, b) => b.teamId.compareTo(a.teamId));
                            List<String> setofTeams = listofteamusers
                                .map((user) => user.teamName)
                                .toSet()
                                .toList();
                            //setofTeams.reversed;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: setofTeams.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title:
                                        Text(setofTeams[index]),
                                    //subtitle: Text("Hello Manjunath"),
                                    children:
                                        populateChildren(setofTeams[index]),
                                  );
                                });
                          } else {
                            return Container(
                              width: 20.0,
                              height: 10.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                      }
                    }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  color: KirthanStyles.colorPallete30,
                  child: Text('SELECTED ${selectedTeamUsers.length}'),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EventUserCreate(selectedTeamUsers : selectedTeamUsers)));
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  color: Colors.redAccent,
                  //padding: EdgeInsets.all(20.0),
                  //child: Text('DELETE SELECTED ${selectedTeamUsers.length}'),
                  child: Text("Delete"),
                  onPressed: () {
                    print(selectedTeamUsers);
                    teamUserPageVM.submitDeleteTeamUserMapping(selectedTeamUsers);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
