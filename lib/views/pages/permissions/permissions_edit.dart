// import 'dart:convert';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_kirthan/models/permissions.dart';
// import 'package:flutter_kirthan/services/permissions_service_impl.dart';
// import 'package:flutter_kirthan/view_models/permissions_page_view_model.dart';
// import 'package:flutter_kirthan/common/constants.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
// final PermissionsPageViewModel permissionsPageVM =
// PermissionsPageViewModel(apiSvc: PermissionsAPIService());
//
//
// class EditPermissions extends StatefulWidget {
//   Permissions permissionsrequest ;
//   final String screenName = SCR_PERMISSIONS;
//
//   EditPermissions({ @required this.permissionsrequest}) ;
//
//   @override
//   _EditPermissionsState createState() => new _EditPermissionsState();
// }
//
// class _EditPermissionsState extends State<EditPermissions> {
//   final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
//   //EventRequest eventrequestobj = new EventRequest();
//   //_EditProfileViewState({Key key, @required this.eventrequest}) ;
//   //final IKirthanRestApi apiSvc = new RestAPIServices();
//   String _selectedState;
//   String state;
//   var _states = ["GOA","GUJ","MAH"];
//   // controllers for form text controllers
//   final TextEditingController _PermissionsNameController = new TextEditingController();
//   String name ;
//
//
//
//
//   @override
//   void initState() {
//     _PermissionsNameController.text = widget.permissionsrequest.name;
//
//
//     return super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData themeData = Theme.of(context);
//
//
//     return new Scaffold(
//         appBar: new AppBar(title: const Text('Edit Profile'), actions: <Widget>[
//           new Container(
//               padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
//               child: new MaterialButton(
//                 color: themeData.primaryColor,
//                 textColor: themeData.secondaryHeaderColor,
//                 child: new Text('Save'),
//                 onPressed: () {
//                   // _handleSubmitted();
//                   _formKey.currentState.save();
//                   Navigator.pop(context);
//                   print(name);
//
//                   //print(widget.eventrequest.eventDescription);
//                   //Map<String,dynamic> eventmap = widget.eventrequest.toJson();
//                   //String eventmap = widget.eventrequest.toStrJsonJson();
//                   String eventrequestStr = jsonEncode(widget.permissionsrequest.toStrJson());
//                   permissionsPageVM.submitUpdatePermissions(eventrequestStr);
//                 },
//               ))
//         ]),
//         body: new Form(
//             key: _formKey,
//             autovalidate: true,
//             //onWillPop: _warnUserAboutInvalidData,
//             child: new ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               children: <Widget>[
//
//
//                 new Container(
//                   child: new TextFormField(
//                     decoration: const InputDecoration(labelText: "Permissions Name", hintText: "What do people call this event?"),
//                     autocorrect: false,
//                     controller: _PermissionsNameController,
//                     onSaved: (String value) {
//                       widget.permissionsrequest.name = value;
//                     },
//                   ),
//                 ),
//
//
//
//
//
//               ],
//             )));
//   }
// }