import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

class TeamSelection extends StatefulWidget {
  TeamSelection({Key key}) : super(key: key);

  final String title = "Team Selection";
  final String screenName = SCR_TEAM_USER;

  @override
  _TeamSelectionState createState() => _TeamSelectionState();
}

class _TeamSelectionState extends State<TeamSelection> {
  Future<List<TeamRequest>> teams;
  TeamRequest selectedteam;
  bool sort;

  @override
  void initState() {
    sort = false;

    teams = teamPageVM.getTeamRequests("All");
    super.initState();
  }


  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<TeamRequest>>(
          future: teams,
          builder: (BuildContext context,
              AsyncSnapshot<List<TeamRequest>> snapshot) {
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
                        value: selectedteam,
                        icon: const Icon(Icons.supervisor_account),
                        hint: Text('Select Team'),
                        items: snapshot.data
                            .map((team) => DropdownMenuItem<TeamRequest>(
                                  value: team,
                                  child: Text(team.teamTitle),
                                ))
                            .toList(),
                        onChanged: (input) {
                          setState(() {
                            selectedteam = input;
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
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child: dataBody(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  color: KirthanStyles.colorPallete30,
                  //child: Text('SELECTED ${selectedUsers.length}'),
                  child: Text("Next"),
                  onPressed: () {
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

