import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/color_picker.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

class Choice {
  const Choice({this.id, this.description});

  final int id;
  final String description;
}

class UserTempleRequestsListItem extends StatelessWidget {
  final UserTemple usertemplerequest;
  final UserTemplePageViewModel userTemplePageVM;
  UserTempleRequestsListItem(
      {@required this.usertemplerequest, @required this.userTemplePageVM});

  /*List<Choice> popupList = [
    // Choice(id: 1, description: "Process"),
    Choice(id: 2, description: "Edit"),
    Choice(id: 3, description: "Delete"),
  ];*/

  @override
  Widget build(BuildContext context) {
    //popupList.
    //teamPageVM.accessTypes.keys
    var title = Text(
      usertemplerequest?.templeId.toString(),
      style: GoogleFonts.openSans(
        //color: KirthanStyles.titleColor,
        fontWeight: FontWeight.bold,
        fontSize: MyPrefSettingsApp.custFontSize,
        //fontSize: KirthanStyles.titleFontSize,
      ),
    );
    var city = Text(
      usertemplerequest?.roleId.toString(),
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
            usertemplerequest?.userId.toString(),
            style: TextStyle(
              color: KirthanStyles.subTitleColor,
              fontSize: MyPrefSettingsApp.custFontSize,
            ),
          ),
        ),
      ],
    );

    return Card(
      elevation: 10,
      child: Consumer(
        builder: (context, notifier, child) => SwitchListTile(
          title: Container(
            decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                gradient: new LinearGradient(
                    //colors: [notifier.currentColor, notifier.currentColor],
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
        ),
      ),
    );
  }
}
