//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/interfaces/i_restapi_svcs.dart';
import 'package:flutter_kirthan/services/data_services.dart';
import 'package:flutter_kirthan/views/pages/team/team_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';


class TeamRequestsListItem extends StatelessWidget {
  final TeamRequest teamrequest;
  final IKirthanRestApi apiSvc = new RestAPIServices();
  TeamRequestsListItem({@required this.teamrequest});

  @override
  Widget build(BuildContext context) {
    var title = Text(
      teamrequest?.teamTitle,
      style: TextStyle(
        color: KirthanStyles.titleColor,
        fontWeight: FontWeight.bold,
        fontSize: KirthanStyles.titleFontSize,
      ),
    );

    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.movie,
          color: KirthanStyles.subTitleColor,
          size: KirthanStyles.subTitleFontSize,
        ),
        /*Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: Text(
            teamrequest?.teamTitle,
            style: TextStyle(
              color: KirthanStyles.subTitleColor,
            ),
          ),
        ),*/
        Row(
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 65,

              child: RaisedButton(
                child: teamrequest.isProcessed? const Text("Processed"):const Text("Not Processed"),
                onPressed: () {
                  Map<String,dynamic> processrequestmap = new Map<String,dynamic>();
                  processrequestmap["id"] = teamrequest?.id;
                  processrequestmap["approvalstatus"] = "Approved";
                  processrequestmap["approvalcomments"] = "ApprovalComments";

                  apiSvc?.processTeamRequest(processrequestmap);
                  SnackBar mysnackbar = SnackBar (
                    content: Text("team $process "),
                    duration: new Duration(seconds: 4),
                    backgroundColor: Colors.green,
                  );
                  Scaffold.of(context).showSnackBar(mysnackbar);
                },
              ),
            ),
          ],
        ),


        Row(
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 55,
              child: RaisedButton(
                child: const Text("Delete"),
                onPressed: () {
                  Map<String,dynamic> teamrequestmap = new Map<String,dynamic>();
                  teamrequestmap["id"] = teamrequest?.id;
                  apiSvc?.deleteTeamRequest(teamrequestmap);
                  SnackBar mysnackbar = SnackBar (
                    content: Text("team $delete "),
                    duration: new Duration(seconds: 4),
                    backgroundColor: Colors.red,
                  );
                  Scaffold.of(context).showSnackBar(mysnackbar);
                },
              ),
            ),
          ],
        ),

        Row(
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 55,
              child: RaisedButton(
                child: const Text("Edit"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfileView(teamrequest: teamrequest)),);
                  //updateEvent
                },
              ),
            ),
          ],
        ),


      ],
    );

    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          title: title,
          subtitle: subTitle,
        ),
        Divider(),
      ],
    );
  }
}