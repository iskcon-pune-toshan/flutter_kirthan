// import 'package:flutter/material.dart';
// import 'package:flutter_kirthan/common/constants.dart';
// import 'package:flutter_kirthan/models/roles.dart';
// import 'package:flutter_kirthan/models/rolescreen.dart';
// import 'package:flutter_kirthan/services/role_screen_service_impl.dart';
// import 'package:flutter_kirthan/services/roles_service_impl.dart';
// import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
// import 'package:flutter_kirthan/view_models/roles_page_view_model.dart';
//
// final RoleScreenViewPageModel roleScreenPageVM =
// RoleScreenViewPageModel(apiSvc: RoleScreenAPIService());
//
// final RolesPageViewModel rolePageVM =
// RolesPageViewModel(apiSvc: RolesAPIService());
//
//
// class RoleScreenCreate extends StatefulWidget {
//   RoleScreenCreate({this.selectedScreens}) : super();
//   List<RoleScreen> selectedScreens;
//
//   final String screenName = SCR_ROLE_SCREEN;
//   final String title = "Role Screen Mapping";
//
//
//   @override
//   _RoleScreenCreateState createState() =>
//       _RoleScreenCreateState(selectedScreens: selectedScreens);
// }
//
// class _RoleScreenCreateState extends State<RoleScreenCreate> {
//   final _formKey = GlobalKey<FormState>();
//   List<RoleScreen> selectedScreens;
//   _RoleScreenCreateState({this.selectedScreens});
//   RoleScreen roleScreen = new RoleScreen();
//   Future<List<Roles>> roles;
//
//   /*List<Roles> _roles = [
//     Roles(id: 1, roleName: 'Role-1'),
//     Roles(id: 2, roleName: 'Role-2'),
//     Roles(id: 3, roleName: 'Role-3'),
//     Roles(id: 4, roleName: 'Role-4'),
//   ];*/
//   Roles _selectedRole;
//
//   @override
//   void initState() {
//     roles = rolePageVM.getRoles("SA");
//     super.initState();
//     //_selectedRole =  null;
//   }
//
//   FutureBuilder getTeamWidget() {
//     return FutureBuilder<List<Roles>>(
//         future: roles,
//         builder:
//             (BuildContext context, AsyncSnapshot<List<Roles>> snapshot) {
//           switch (snapshot.connectionState) {
//             case ConnectionState.none:
//             case ConnectionState.active:
//             case ConnectionState.waiting:
//               return Center(child: const CircularProgressIndicator());
//             case ConnectionState.done:
//               if (snapshot.hasData) {
//                 return Container(
//                   //width: 20.0,
//                   //height: 10.0,
//                   child: Center(
//                     child: DropdownButtonFormField<Roles>(
//                       value: _selectedRole,
//                       icon: const Icon(Icons.supervisor_account),
//                       hint: Text('Select Role'),
//                       items: snapshot.data
//                           .map((role) =>
//                           DropdownMenuItem<Roles>(
//                             value: role,
//                             child: Text(role.roleName),
//                           ))
//                           .toList(),
//                       onChanged: (input) {
//                         setState(() {
//                           _selectedRole = input;
//                         });
//                       },
//                     ),
//                   ),
//                 );
//               } else {
//                 return Container(
//                   width: 20.0,
//                   height: 10.0,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 );
//               }
//           }
//         });
//   }
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//   @override
//   Widget build(BuildContext context) {
//     //print(selectedUsers.length);
//     return Scaffold(
//       key: _scaffoldKey,
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Column(
//         mainAxisSize: MainAxisSize.min,
//         mainAxisAlignment: MainAxisAlignment.center,
//         verticalDirection: VerticalDirection.down,
//         children: <Widget>[
//           getTeamWidget(),
//           ListView.builder(
//               shrinkWrap: true,
//               itemCount: selectedScreens == null ? 0 : selectedScreens.length,
//
//               itemBuilder: (BuildContext context, int index) {
//                 return ListTile(
//                   title: Text(selectedScreens[index].screenName),
//                   subtitle: Text(selectedScreens[index].id.toString()),
//                 );
//               }),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: OutlineButton(
//                   child: Text('SELECTED ${selectedScreens.length}'),
//                   onPressed: () {
//                     List<RoleScreen> listofRoleScreen = new List<RoleScreen>();
//                     for (var screen in selectedScreens) {
//                       RoleScreen roleScreen = new RoleScreen();
//
//                       print(roleScreen.id);
//
//                       roleScreen.screenId = screen.screenId;
//                       print(screen.id);
//                       roleScreen.roleId = _selectedRole.id;
//                       roleScreen.createFlag = screen.createFlag;
//                       roleScreen.updateFlag = screen.updateFlag;
//                       roleScreen.deleteFlag = screen.deleteFlag;
//                       roleScreen.processFlag = screen.processFlag;
//                       roleScreen.viewFlag = screen.viewFlag;
//                       roleScreen.screenName = screen.screenName;
//                       roleScreen.roleName = _selectedRole.roleName;
//
//                       listofRoleScreen.add(roleScreen);
//                       SnackBar mysnackbar = SnackBar (
//                         content: Text("Role-Screen registered $successful "),
//                         duration: new Duration(seconds: 4),
//                         backgroundColor: Colors.green,
//                       );
//                       // Scaffold.of(context).showSnackBar(mysnackbar);
//                       _scaffoldKey.currentState.showSnackBar(mysnackbar);
//                     }
//                     //Map<String,dynamic> teamusermap = teamUser.toJson();
//                     print(listofRoleScreen);
//                     roleScreenPageVM.submitNewRoleScreenMapping(listofRoleScreen);
//
//
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: OutlineButton(
//                   child: Text('DELETE SELECTED'),
//                   onPressed: null,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
