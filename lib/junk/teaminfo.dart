import 'package:flutter/material.dart';
import 'package:flutter_kirthan/junk/userinfo.dart';


class TeamInfo extends StatelessWidget {
  int teamId;
  List<UserInfo> users = new List<UserInfo>();

  TeamInfo({this.teamId});

  void addUser(UserInfo user) {
    users.add(user);
    //userNames.add(Text(userid.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return render(context);
  }

  @override
  Widget render(BuildContext context) {
    return ExpansionTile(
        title: Text("Team Name: $teamId"),
    subtitle: Text("Number of users in this team are: ${users.length}"),
    initiallyExpanded: true,
    //children: userNames ,
    children: users.map((user) => user.render(context)).toList(),

    );
  }
}
