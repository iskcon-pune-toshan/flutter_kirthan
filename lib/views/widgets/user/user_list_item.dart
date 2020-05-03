import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/interfaces/i_restapi_svcs.dart';
import 'package:flutter_kirthan/services/data_services.dart';
import 'package:flutter_kirthan/views/pages/user/user_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';

class UserRequestsListItem extends StatelessWidget {
  final UserRequest userrequest;
  final IKirthanRestApi apiSvc = new RestAPIServices();
  UserRequestsListItem({@required this.userrequest});

  @override
  Widget build(BuildContext context) {
    var title = Text(
      userrequest?.userId,
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
        Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: Text(
            userrequest?.userName,
            style: TextStyle(
              color: KirthanStyles.subTitleColor,
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.sync),
          tooltip: "Process",
          iconSize: 25.0,
          onPressed: () {
            Map<String, dynamic> processrequestmap = new Map<String, dynamic>();
            processrequestmap["id"] = userrequest?.id;
            processrequestmap["approvalstatus"] = "Approved";
            processrequestmap["approvalcomments"] = "ApprovalComments";
            processrequestmap["usertype"] = userrequest?.userType;
            apiSvc?.processUserRequest(processrequestmap);
            SnackBar mysnackbar = SnackBar(
              content: Text("User $process $successful "),
              duration: new Duration(seconds: 4),
              backgroundColor: Colors.green,
            );
            Scaffold.of(context).showSnackBar(mysnackbar);
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          tooltip: "Delete",
          iconSize: 25.0,
          onPressed: () {
            Map<String, dynamic> processrequestmap = new Map<String, dynamic>();
            processrequestmap["id"] = userrequest?.id;
            apiSvc?.deleteUserRequest(processrequestmap);
            SnackBar mysnackbar = SnackBar(
              content: Text("User $delete "),
              duration: new Duration(seconds: 4),
              backgroundColor: Colors.red,
            );
            Scaffold.of(context).showSnackBar(mysnackbar);
          },
        ),
        IconButton(
          icon: Icon(Icons.edit),
          tooltip: "Edit",
          iconSize: 25.0,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserEdit(userrequest: userrequest)),
            );
          },
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
