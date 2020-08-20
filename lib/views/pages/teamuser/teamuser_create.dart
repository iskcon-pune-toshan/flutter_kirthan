import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TeamUserPageViewModel teamUserPageVM =
TeamUserPageViewModel(apiSvc: TeamUserAPIService());

final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());


class TeamUserCreate extends StatefulWidget {
  TeamUserCreate({this.selectedUsers}) : super();
  List<UserRequest> selectedUsers;

  final String screenName = SCR_TEAM_USER;
  final String title = "Team User Mapping";


  @override
  _TeamUserCreateState createState() =>
      _TeamUserCreateState(selectedUsers: selectedUsers);
}

class _TeamUserCreateState extends State<TeamUserCreate> {
  final _formKey = GlobalKey<FormState>();
  List<UserRequest> selectedUsers;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  _TeamUserCreateState({this.selectedUsers});
  TeamUser teamUser = new TeamUser();
  Future<List<TeamRequest>> teams;

  List<TeamRequest> _teams = [
    TeamRequest(id: 1, teamTitle: 'Team-1', teamDescription: 'Team-1'),
    TeamRequest(id: 2, teamTitle: 'Team-2', teamDescription: 'Team-2'),
    TeamRequest(id: 3, teamTitle: 'Team-3', teamDescription: 'Team-3'),
    TeamRequest(id: 4, teamTitle: 'Team-4', teamDescription: 'Team-4'),
  ];
  TeamRequest _selectedTeam;

  @override
  void initState() {
    teams = teamPageVM.getTeamRequests("SA");
    super.initState();
    //_selectedTeam =  null;
  }

  FutureBuilder getTeamWidget() {
    return FutureBuilder<List<TeamRequest>>(
        future: teams,
        builder:
            (BuildContext context, AsyncSnapshot<List<TeamRequest>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Center(child: const CircularProgressIndicator());
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return Container(
                      //width: 20.0,
                      //height: 10.0,
                      child: Center(
                        child: DropdownButtonFormField<TeamRequest>(
                          value: _selectedTeam,
                          icon: const Icon(Icons.supervisor_account),
                          hint: Text('Select Team'),
                          items: snapshot.data
                              .map((team) =>
                              DropdownMenuItem<TeamRequest>(
                                value: team,
                                child: Text(team.teamDescription),
                              ))
                              .toList(),
                          onChanged: (input) {
                            setState(() {
                              _selectedTeam = input;
                            });
                          },
                        ),
                      ),
                    );
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
            });
  }

  @override
  Widget build(BuildContext context) {
    //print(selectedUsers.length);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          getTeamWidget(),
          ListView.builder(
              shrinkWrap: true,
              itemCount: selectedUsers == null ? 0 : selectedUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(selectedUsers[index].firstName),
                  subtitle: Text(selectedUsers[index].lastName),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('SELECTED ${selectedUsers.length}'),
                  onPressed: () {
                    List<TeamUser> listofTeamUsers = new List<TeamUser>();
                    for (var user in selectedUsers) {
                      TeamUser teamUser = new TeamUser();
                      teamUser.userId = user.id;
                      //print(user.id);
                      teamUser.teamId = _selectedTeam.id;
                      teamUser.createdBy = "SYSTEM";
                      String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                          .format(DateTime.now());
                      teamUser.createTime = dt;
                      teamUser.updatedBy = "SYSTEM";
                      teamUser.updateTime = dt;
                      listofTeamUsers.add(teamUser);
                    }
                    //Map<String,dynamic> teamusermap = teamUser.toJson();
                    print(listofTeamUsers);
                    teamUserPageVM.submitNewTeamUserMapping(listofTeamUsers);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('DELETE SELECTED'),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
