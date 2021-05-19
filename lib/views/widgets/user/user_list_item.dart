import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/user/user_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

class Choice {
  const Choice({this.id, this.description});

  final int id;
  final String description;
}

class UserRequestsListItem extends StatelessWidget {
  final UserRequest userrequest;
  final UserPageViewModel userPageVM;
  UserRequestsListItem({@required this.userrequest, this.userPageVM});

  List<Choice> popupList = [
    Choice(id: 1, description: "Process"),
    Choice(id: 2, description: "Edit"),
    Choice(id: 3, description: "Delete"),
  ];

  @override
  Widget build(BuildContext context) {
    var title = Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Text(
        userrequest?.roleId.toString(),
        style: GoogleFonts.openSans(
          //color: KirthanStyles.titleColor,
          fontWeight: FontWeight.bold,
          fontSize: notifier.custFontSize,
          //fontSize: KirthanStyles.titleFontSize,
        ),
      ),
    );

    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[

        Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Text(
              userrequest?.userName,
              style: TextStyle(
                //color: KirthanStyles.subTitleColor,
                fontSize: notifier.custFontSize,
              ),
            ),
          ),
        ),
        Container(
          child: PopupMenuButton<Choice>(
            itemBuilder: (BuildContext context) {
              return popupList.map((f) {
                return PopupMenuItem<Choice>(
                  child: Text(f.description),
                  value: f,
                );
              }).toList();
            },
            onSelected: (choice) {
              if (choice.id == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserEdit(userrequest: userrequest)),
                );
              } else if (choice.id == 1) {
                Map<String, dynamic> processrequestmap =
                    new Map<String, dynamic>();
                processrequestmap["id"] = userrequest?.id;
                processrequestmap["approvalStatus"] = "Approved";
                processrequestmap["approvalComments"] = "ApprovalComments";
                processrequestmap["roleId"] = userrequest?.roleId;
                processrequestmap["firstName"] = userrequest?.firstName;
                processrequestmap["lastName"] = userrequest?.lastName;
                processrequestmap["email"] = userrequest?.email;
                processrequestmap["userName"] = userrequest?.userName;
                processrequestmap["password"] = userrequest?.password;
                processrequestmap["phoneNumber"] = userrequest?.phoneNumber;
                processrequestmap["addLineOne"] = userrequest?.addLineOne;
                processrequestmap["locality"] = userrequest?.locality;
                processrequestmap["city"] = userrequest?.city;
                processrequestmap["pinCode"] = userrequest?.pinCode;
                processrequestmap["state"] = userrequest?.state;
                processrequestmap["country"] = userrequest?.country;
                processrequestmap["govtIdType"] = userrequest?.govtIdType;
                processrequestmap["govtId"] = userrequest?.govtId;
                processrequestmap["isProcessed"] = userrequest?.isProcessed;
                processrequestmap["createdBy"] = userrequest?.createdBy;
                processrequestmap["createdTime"] = userrequest?.createdTime;

                userPageVM.processUserRequest(processrequestmap);
                SnackBar mysnackbar = SnackBar(
                  content: Text("User $process $successful "),
                  duration: new Duration(seconds: 4),
                  backgroundColor: Colors.green,
                );
                Scaffold.of(context).showSnackBar(mysnackbar);
              } else if (choice.id == 3) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0)), //this right here
                        child: Container(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Do you want to delete?'),
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      Map<String, dynamic> processrequestmap =
                                          new Map<String, dynamic>();
                                      processrequestmap["id"] = userrequest?.id;
                                      userPageVM
                                          .deleteUserRequest(processrequestmap);
                                      SnackBar mysnackbar = SnackBar(
                                        content: Text("User $delete "),
                                        duration: new Duration(seconds: 4),
                                        backgroundColor: Colors.red,
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(mysnackbar);
                                    },
                                    child: Consumer<ThemeNotifier>(
                                      builder: (context, notifier, child) =>
                                          Text(
                                        "yes",
                                        style: TextStyle(
                                            fontSize: notifier.custFontSize,
                                            color: Colors.white),
                                      ),
                                    ),
                                    color: const Color(0xFF1BC0C5),
                                  ),
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Consumer<ThemeNotifier>(
                                      builder: (context, notifier, child) =>
                                          Text(
                                        "No",
                                        style: TextStyle(
                                            fontSize: notifier.custFontSize,
                                            color: Colors.white),
                                      ),
                                    ),
                                    color: const Color(0xFF1BC0C5),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
            },
          ),
        ),
      ],
    );

    return Card(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            color: notifier.currentColorStatus
                ? notifier.currentColor
                : Theme.of(context).cardColor,
          ),
          child: new Column(
            children: <Widget>[
              new ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                leading: Icon(Icons.account_circle),
                title: title,
                subtitle: subTitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
