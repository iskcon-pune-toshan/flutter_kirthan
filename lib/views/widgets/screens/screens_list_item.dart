// import 'package:flutter/material.dart';
// import 'package:flutter_kirthan/models/screens.dart';
// import 'package:flutter_kirthan/utils/kirthan_styles.dart';
// import 'package:flutter_kirthan/view_models/screens_page_view_model.dart';
// import 'package:flutter_kirthan/views/pages/drawer/settings/pref_settings.dart';
// import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
// import 'package:flutter_kirthan/views/pages/screens/screens_edit.dart';
// import 'package:flutter_kirthan/common/constants.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
//
// class Choice {
//   const Choice({this.id, this.description});
//
//   final int id;
//   final String description;
// }
//
// class ScreensRequestsListItem extends StatelessWidget {
//   final Screens screensrequest;
//   final ScreensPageViewModel screensPageVM;
//   ScreensRequestsListItem(
//       {@required this.screensrequest, @required this.screensPageVM});
//
//   List<Choice> popupList = [
//     // Choice(id: 1, description: "Process"),
//     Choice(id: 2, description: "Edit"),
//     Choice(id: 3, description: "Delete"),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     //popupList.
//     //teamPageVM.accessTypes.keys
//     var title = Consumer<ThemeNotifier>(
//       builder: (context, notifier, child) => Text(
//         screensrequest?.screenName,
//         style: GoogleFonts.openSans(
//           //color: KirthanStyles.titleColor,
//           fontWeight: FontWeight.bold,
//           fontSize: notifier.custFontSize,
//           //fontSize: KirthanStyles.titleFontSize,
//         ),
//       ),
//     );
//
//     var subTitle = Row(
//       mainAxisAlignment: MainAxisAlignment.end,
//       children: <Widget>[
//         Container(
//           child: PopupMenuButton<Choice>(
//             itemBuilder: (BuildContext context) {
//               return popupList.map((f) {
//                 return PopupMenuItem<Choice>(
//                   child: Text(f.description),
//                   value: f,
//                 );
//               }).toList();
//             },
//             onSelected: (choice) {
//               if (choice.id == 2) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) =>
//                           EditScreens(screensrequest: screensrequest)),
//                 );
//               } else if (choice.id == 3) {
//                 showDialog(
//                     context: context,
//                     builder: (BuildContext context) {
//                       return Dialog(
//                         shape: RoundedRectangleBorder(
//                             borderRadius:
//                                 BorderRadius.circular(20.0)), //this right here
//                         child: Container(
//                           height: 200,
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 TextField(
//                                   decoration: InputDecoration(
//                                       border: InputBorder.none,
//                                       hintText: 'Do you want to delete?'),
//                                 ),
//                                 SizedBox(
//                                   width: 320.0,
//                                   child: RaisedButton(
//                                     onPressed: () {
//                                       Map<String, dynamic> teamrequestmap =
//                                           new Map<String, dynamic>();
//                                       teamrequestmap["id"] = screensrequest?.id;
//                                       screensPageVM
//                                           .deleteScreens(teamrequestmap);
//                                       SnackBar mysnackbar = SnackBar(
//                                         content: Text("temple $delete "),
//                                         duration: new Duration(seconds: 4),
//                                         backgroundColor: Colors.red,
//                                       );
//                                       Scaffold.of(context)
//                                           .showSnackBar(mysnackbar);
//                                     },
//                                     child: Consumer<ThemeNotifier>(
//                                       builder: (context, notifier, child) =>
//                                           Text(
//                                         "yes",
//                                         style: TextStyle(
//                                             fontSize: notifier.custFontSize,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                     color: const Color(0xFF1BC0C5),
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: 320.0,
//                                   child: RaisedButton(
//                                     onPressed: () {
//                                       Navigator.pop(context);
//                                     },
//                                     child: Consumer<ThemeNotifier>(
//                                       builder: (context, notifier, child) =>
//                                           Text(
//                                         "No",
//                                         style: TextStyle(
//                                             fontSize: notifier.custFontSize,
//                                             color: Colors.white),
//                                       ),
//                                     ),
//                                     color: const Color(0xFF1BC0C5),
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     });
//               }
//             },
//           ),
//         ),
//       ],
//     );
//
//     return Card(
//       child: Consumer<ThemeNotifier>(
//         builder: (context, notifier, child) => Container(
//           decoration: new BoxDecoration(
//             borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
//             color: notifier.currentColorStatus
//                 ? notifier.currentColor
//                 : Theme.of(context).cardColor,
//           ),
//           child: new Column(
//             children: <Widget>[
//               new ListTile(
//                 contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
//                 leading: Icon(Icons.group),
//                 title: title,
//                 subtitle: subTitle,
//               ),
//             ],
//           ),
//           //Divider(color: Colors.blue),
//         ),
//       ),
//     );
//   }
// }
