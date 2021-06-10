import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/roles.dart';
import 'package:flutter_kirthan/services/roles_service_impl.dart';
import 'package:flutter_kirthan/view_models/roles_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';


final RolesPageViewModel rolesPageVM =
RolesPageViewModel(apiSvc: RolesAPIService());


class EditRoles extends StatefulWidget {
  Roles rolesrequest ;
  final String screenName = SCR_ROLES;

  EditRoles({ @required this.rolesrequest}) ;

  @override
  _EditRolesState createState() => new _EditRolesState();
}

class _EditRolesState extends State<EditRoles> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //EventRequest eventrequestobj = new EventRequest();
  //_EditProfileViewState({Key key, @required this.eventrequest}) ;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  String _selectedState;
  String state;
  var _states = ["GOA","GUJ","MAH"];
  // controllers for form text controllers
  final TextEditingController _RolesNameController = new TextEditingController();
  String role_name ;




  @override
  void initState() {
    _RolesNameController.text = widget.rolesrequest.roleName;


    return super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);


    return new Scaffold(
        appBar: new AppBar(title: const Text('Edit Profile'), actions: <Widget>[
          new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
              child: new MaterialButton(
                color: themeData.primaryColor,
                textColor: themeData.secondaryHeaderColor,
                child: new Text('Save'),
                onPressed: () {
                  // _handleSubmitted();
                  _formKey.currentState.save();
                  Navigator.pop(context);
                  print(role_name);

                  //print(widget.eventrequest.eventDescription);
                  //Map<String,dynamic> eventmap = widget.eventrequest.toJson();
                  //String eventmap = widget.eventrequest.toStrJsonJson();
                  String eventrequestStr = jsonEncode(widget.rolesrequest.toStrJson());
                  rolesPageVM.submitUpdateRoles(eventrequestStr);
                },
              ))
        ]),
        body: new Form(
            key: _formKey,
            autovalidate: true,
            //onWillPop: _warnUserAboutInvalidData,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[


                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Role Name", hintText: "What do people call this event?"),
                    autocorrect: false,
                    controller: _RolesNameController,
                    onSaved: (String value) {
                      widget.rolesrequest.roleName = value;
                    },
                  ),
                ),





              ],
            )));
  }
}