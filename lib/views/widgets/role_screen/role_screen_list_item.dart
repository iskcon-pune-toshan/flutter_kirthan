import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class Choice {
  const Choice({this.id, this.description});

  final int id;
  final String description;
}

class RoleScreenRequestsListItem extends StatelessWidget {
  final RoleScreen rolescreenrequest;
  final RoleScreenViewPageModel roleScreenPageVM;
  RoleScreenRequestsListItem(
      {@required this.rolescreenrequest, @required this.roleScreenPageVM});

  List<Choice> popupList = [
    // Choice(id: 1, description: "Process"),
    Choice(id: 2, description: "Edit"),
    Choice(id: 3, description: "Delete"),
  ];

  @override
  Widget build(BuildContext context) {
    //popupList.
    //teamPageVM.accessTypes.keys
    var title = Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Text(
        rolescreenrequest?.roleId.toString(),
        style: GoogleFonts.openSans(
          //color: KirthanStyles.titleColor,
          fontWeight: FontWeight.bold,
          fontSize: notifier.custFontSize,
          //fontSize: KirthanStyles.titleFontSize,
        ),
      ),
    );
    var city = Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => Text(
        rolescreenrequest?.createFlag.toString(),
        style: GoogleFonts.openSans(
          fontWeight: FontWeight.bold,
          fontSize: notifier.custFontSize,
        ),
      ),
    );

    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Text(
              rolescreenrequest?.screenId.toString(),
              style: TextStyle(
                color: KirthanStyles.subTitleColor,
                fontSize: notifier.custFontSize,
              ),
            ),
          ),
        ),
        /*    Container(
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
                      builder: (context) =>
                          EditRoleScreen(rolescreenrequest : rolescreenrequest)),
                );
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
                                      Map<String, dynamic> teamrequestmap =
                                      new Map<String, dynamic>();
                                      teamrequestmap["id"] =
                                          rolescreenrequest?.id;
                                      roleScreenPageVM
                                          .deleteRoleScreen(teamrequestmap);
                                      SnackBar mysnackbar = SnackBar(
                                        content: Text("roleScreen $delete "),
                                        duration: new Duration(seconds: 4),
                                        backgroundColor: Colors.red,
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(mysnackbar);
                                    },
                                    child: Text(
                                      "yes",
                                      style: TextStyle(
                                          fontSize:
                                          MyPrefSettingsApp.custFontSize,
                                          color: Colors.white),
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
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          fontSize:
                                          MyPrefSettingsApp.custFontSize,
                                          color: Colors.white),
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
        ),*/
      ],
    );

    return Card(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            /* gradient: new LinearGradient(
                colors: [
                  KirthanStyles.colorPallete60,
                  KirthanStyles.colorPallete60
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp),*/
            color: notifier.currentColorStatus
                ? notifier.currentColor
                : Theme.of(context).cardColor,
          ),

          child: new Column(
            children: <Widget>[
              new ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                leading: Icon(Icons.group),
                title: title,
                subtitle: subTitle,
              ),
            ],
          ),
          //Divider(color: Colors.blue),
        ),
      ),
    );
  }
}
