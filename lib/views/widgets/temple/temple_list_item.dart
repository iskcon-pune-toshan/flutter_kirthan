import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/temple/temple_edit.dart';
//import 'package:flutter_kirthan/views/temple/temple_edit.dart';
import 'package:google_fonts/google_fonts.dart';

class Choice {
  const Choice({this.id, this.description});

  final int id;
  final String description;
}

class TempleRequestsListItem extends StatelessWidget {
  final Temple templerequest;
  final TemplePageViewModel templePageVM;
  TempleRequestsListItem({@required this.templerequest, @required this.templePageVM});

  List<Choice> popupList = [
   // Choice(id: 1, description: "Process"),
    Choice(id: 2, description: "Edit"),
    Choice(id: 3, description: "Delete"),
  ];



  @override
  Widget build(BuildContext context) {
    //popupList.
    //teamPageVM.accessTypes.keys
    var title = Text(
      templerequest?.templeName,
      style: GoogleFonts.openSans(
        //color: KirthanStyles.titleColor,
        fontWeight: FontWeight.bold,
        fontSize: MyPrefSettingsApp.custFontSize,
        //fontSize: KirthanStyles.titleFontSize,
      ),
    );
    var city = Text(
    templerequest?.city,
    style: GoogleFonts.openSans(
    fontWeight: FontWeight.bold,
    fontSize: MyPrefSettingsApp.custFontSize,
    ),
    );

    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: Text(
            templerequest?.city,
            style: TextStyle(
              color: KirthanStyles.subTitleColor,
              fontSize: MyPrefSettingsApp.custFontSize,
            ),
          ),),
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
                      builder: (context) =>
                          EditTemple(templerequest: templerequest)),
                );
              } else  if (choice.id == 3) {
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
                                      teamrequestmap["id"] = templerequest?.id;
                                      templePageVM
                                          .deleteTemple(teamrequestmap);
                                      SnackBar mysnackbar = SnackBar(
                                        content: Text("temple $delete "),
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
        ),
      ],
    );

    return Card(
      elevation: 10,
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            gradient: new LinearGradient(
                colors: [Colors.blue[200], Colors.purpleAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp)),
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
    );
  }
}