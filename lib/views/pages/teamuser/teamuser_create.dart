import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/interfaces/i_restapi_svcs.dart';
import 'package:flutter_kirthan/services/data_services.dart';

class TeamUserMapping extends StatefulWidget {
  TeamUserMapping({this.selectedUsers}) : super();
  List<UserRequest> selectedUsers;

  final String title = "Team User Mapping";
  final String screenName = "Team-user";

  @override
  _TeamUserMappingState createState() =>
      _TeamUserMappingState(selectedUsers: selectedUsers);
}

class _TeamUserMappingState extends State<TeamUserMapping> {
  final _formKey = GlobalKey<FormState>();
  List<UserRequest> selectedUsers;
  final IKirthanRestApi apiSvc = new RestAPIServices();
  _TeamUserMappingState({this.selectedUsers});
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
    teams = apiSvc?.getTeamRequests("SA");
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
                    apiSvc?.submitNewTeamUserMapping(listofTeamUsers);
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
