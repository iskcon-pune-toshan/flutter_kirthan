import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/view_models/main_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/team/team_list_item.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/pages/teamuser/user_selection.dart';
import 'package:flutter_kirthan/views/pages/teamuser/teamuser_view.dart';


class TeamsPanel extends StatelessWidget {
  String teamType;
  final String screenName = "Team";
  TeamsPanel({this.teamType});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TeamPageViewModel>(
      //rebuildOnChange: true,
      builder: (context, child, model) {
        return FutureBuilder<List<TeamRequest>>(
          future: model.teamrequests,
          builder: (_, AsyncSnapshot<List<TeamRequest>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var teamRequests = snapshot.data;
                  return new Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            child: const Text("All Teams"),
                            onPressed: () {
                              print("All Teams");
                              model.setTeamRequests("AE");
                            },
                          ),

                          RaisedButton(
                            child: const Text("Team-User Add"),
                            onPressed: () {
                              print("Team-User Add");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => UserSelection()));
                            },
                          ),
                          RaisedButton(
                            child: const Text("Team-User View"),
                            onPressed: () {
                              print("Team-User View");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeamUserView()));
                            },
                          ),
                          Expanded(
                            child: RaisedButton(
                              child: const Text("Create a Team"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TeamWrite()));
                              },
                            ),
                          ),
                        ],
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount:
                        teamRequests == null ? 0 : teamRequests.length,
                        itemBuilder: (_, int index) {
                          var teamrequest = teamRequests[index];
                          return TeamRequestsListItem(teamrequest: teamrequest);
                        },
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      await model.setTeamRequests("All");
                    },
                  );
                }
            }
          },
        );
      },
    );
  }
}
