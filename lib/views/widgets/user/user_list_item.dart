import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/pref_settings.dart';
import 'package:flutter_kirthan/views/pages/user/user_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';

class UserRequestsListItem extends StatelessWidget {
  final UserRequest userrequest;
  final UserPageViewModel userPageVM;
  UserRequestsListItem({@required this.userrequest,this.userPageVM});

  @override
  Widget build(BuildContext context) {
    var title = Text(
      userrequest?.userId,
      style: TextStyle(
        color: KirthanStyles.titleColor,
        fontWeight: FontWeight.bold,
          fontSize: MyPrefSettingsApp.custFontSize,
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
        Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: Text(
            userrequest?.userName,
            style: TextStyle(
              color: KirthanStyles.subTitleColor,
              fontSize: MyPrefSettingsApp.custFontSize,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.sync),
          tooltip: "Process",
          iconSize: 25.0,
          onPressed: userPageVM.accessTypes[ACCESS_TYPE_PROCESS] == true? () {
            Map<String, dynamic> processrequestmap = new Map<String, dynamic>();
            processrequestmap["id"] = userrequest?.id;
            processrequestmap["approvalstatus"] = "Approved";
            processrequestmap["approvalcomments"] = "ApprovalComments";
            processrequestmap["usertype"] = userrequest?.userType;
            userPageVM.processUserRequest(processrequestmap);
            SnackBar mysnackbar = SnackBar(
              content: Text("User $process $successful "),
              duration: new Duration(seconds: 4),
              backgroundColor: Colors.green,
            );
            Scaffold.of(context).showSnackBar(mysnackbar);
          }: null,
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: "Delete",
          iconSize: 25.0,
          onPressed: userPageVM.accessTypes[ACCESS_TYPE_DELETE] == true? () {
            Map<String, dynamic> processrequestmap = new Map<String, dynamic>();
            processrequestmap["id"] = userrequest?.id;
            userPageVM.deleteUserRequest(processrequestmap);
            SnackBar mysnackbar = SnackBar(
              content: Text("User $delete "),
              duration: new Duration(seconds: 4),
              backgroundColor: Colors.red,
            );
            Scaffold.of(context).showSnackBar(mysnackbar);
          }:null,
        ),
        IconButton(
          icon: Icon(Icons.edit),
          tooltip: "Edit",
          iconSize: 25.0,
          onPressed: userPageVM.accessTypes[ACCESS_TYPE_DELETE] == true? () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserEdit(userrequest: userrequest)),
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
