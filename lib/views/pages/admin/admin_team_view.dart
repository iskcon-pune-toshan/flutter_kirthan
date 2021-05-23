import 'package:flutter/material.dart';

import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/team/team_edit.dart';
import 'package:flutter_kirthan/views/widgets/team/team_list_item.dart';
import 'package:flutter_kirthan/models/team.dart';
import './admin_view.dart';
import 'package:scoped_model/scoped_model.dart';

class TeamAdminView extends StatefulWidget {
  String status;
  TeamAdminView({this.status});

  @override
  State<StatefulWidget> createState() {
    return _TeamAdminView();
  }
}

class _TeamAdminView extends State<TeamAdminView> {
  TeamPageViewModel _teamVM;

  void setStats() async {
    ScopedModel.of<Stats>(context).stats = await _teamVM.getTeamsCount();
  }

  void initState() {
    super.initState();
    _teamVM = TeamPageViewModel(apiSvc: TeamAPIService());
    setStats();
  }

  @override
  Widget build(BuildContext context) {
    return View(status: widget.status);
  }

  Widget EditView({Widget page, Widget actions, String status}) {
    return Scaffold(
      body: page,
      persistentFooterButtons: <Widget>[
        if (status.toLowerCase() == "NEW") actions
      ],
    );
  }

  Widget Actions(TeamRequest data) {
    Map<String, dynamic> resultData = {
      "id": data.id,
      "usertype": "admin",
      "updatedby": "PlaceHolder"
    };
    return Row(
      children: [
        FlatButton(
            child: Text('Approve'),
            onPressed: () {
              resultData["approvalstatus"] = "approved";
              //callback(resultData);
            }),
        FlatButton(
          child: Text('Reject'),
          onPressed: () {
            resultData["approvalstatus"] = "rejected";
            //callback(resultData);
          },
        ),
      ],
    );
  }

  Widget View({String status}) {
    return FutureBuilder(
        future: _teamVM.getTeamForApproval(status),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, itemCount) => Card(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.0,
                          ),
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            clipBehavior: Clip.none,
                            child: TeamRequestsListItem(
                              teamrequest: snapshot.data[itemCount],
                              teamPageVM: _teamVM,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditView(
                                    status:
                                        snapshot.data[itemCount].approvalStatus,
                                    page: EditTeam(
                                        teamrequest: snapshot.data[itemCount]),
                                    actions: Actions(snapshot.data[itemCount]),
                                  ),
                                ),
                              );
                            },
                          ),
                          if (status == "NEW")
                            Actions(snapshot.data[itemCount]),
                        ],
                      ),
                    ));
          }
          return Center(child: Text("No data found"));
        });
  }
}
