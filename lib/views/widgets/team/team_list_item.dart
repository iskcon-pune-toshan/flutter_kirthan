import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/pref_settings.dart';
import 'package:flutter_kirthan/views/pages/team/team_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';

class TeamRequestsListItem extends StatelessWidget {
  final TeamRequest teamrequest;
  final TeamPageViewModel teamPageVM;
  TeamRequestsListItem({@required this.teamrequest, @required this.teamPageVM});

  @override
  Widget build(BuildContext context) {
    var title = Text(
      teamrequest?.teamTitle,
      style: TextStyle(
        color: KirthanStyles.titleColor,
        fontWeight: FontWeight.bold,
        fontSize: MyPrefSettingsApp.custFontSize,
      ),
    );

    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Icon(
          Icons.movie,
          semanticLabel: teamrequest?.teamDescription,
          textDirection: TextDirection.ltr,
          color: KirthanStyles.subTitleColor,
          size: KirthanStyles.subTitleFontSize,
        ),
        IconButton(
          icon: Icon(Icons.sync),
          tooltip: "Process",
          iconSize: 25.0,
          onPressed: teamPageVM.accessTypes[ACCESS_TYPE_PROCESS] == true? () {
            Map<String, dynamic> processrequestmap = new Map<String, dynamic>();
            processrequestmap["id"] = teamrequest?.id;
            processrequestmap["approvalstatus"] = "Approved";
            processrequestmap["approvalcomments"] = "ApprovalComments";

            teamPageVM.processTeamRequest(processrequestmap);
            SnackBar mysnackbar = SnackBar(
              content: Text("team $process "),
              duration: new Duration(seconds: 4),
              backgroundColor: Colors.green,
            );
            Scaffold.of(context).showSnackBar(mysnackbar);
          }:null,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: "Delete",
          iconSize: 25.0,
          onPressed: teamPageVM.accessTypes[ACCESS_TYPE_DELETE] == true? () {
            Map<String, dynamic> teamrequestmap = new Map<String, dynamic>();
            teamrequestmap["id"] = teamrequest?.id;
            teamPageVM.deleteTeamRequest(teamrequestmap);
            SnackBar mysnackbar = SnackBar(
              content: Text("team $delete "),
              duration: new Duration(seconds: 4),
              backgroundColor: Colors.red,
            );
            Scaffold.of(context).showSnackBar(mysnackbar);
          }:null,
        ),
        IconButton(
          //child: const Text("Edit"),
          icon: Icon(Icons.edit),
          tooltip: "Edit",
          iconSize: 25.0,
          onPressed: teamPageVM.accessTypes[ACCESS_TYPE_EDIT] == true?  () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditTeam(teamrequest: teamrequest)),
            );
          }:null,
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
