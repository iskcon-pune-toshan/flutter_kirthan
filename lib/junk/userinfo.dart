import 'package:flutter/material.dart';

class UserInfo extends StatelessWidget {
  int userid;
  int username;
  UserInfo({this.userid,this.username});

  @override
  Widget render(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        title: Text("User Name: $userid",
          style: Theme.of(context).textTheme.body2,
        ),
        dense: true,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return render(context);
  }
}