/*
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


final UserTemplePageViewModel userTemplePageVM =
UserTemplePageViewModel(apiSvc: UserTempleAPIService());


class EditUserTemple extends StatefulWidget {
  UserTemple usertemplerequest ;
  final String screenName = SCR_USER_TEMPLE;

  EditUserTemple({ @required this.usertemplerequest}) ;

  @override
  _EditUserTempleState createState() => new _EditUserTempleState();


}

class _EditUserTempleState extends State<EditUserTemple> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _selectedState;
  int  temple_id;
  var _states = 3;
  // controllers for form text controllers
  final TextEditingController _templeController = new TextEditingController();
  int templeId ;
  final TextEditingController _roleController = new TextEditingController();
  int roleId ;
  final TextEditingController _userController = new TextEditingController();
  int userId ;



  @override
  void initState() {
    _templeController.text = widget.usertemplerequest.templeId.toString();
    _roleController.text = widget.usertemplerequest.roleId.toString();
    _userController.text = widget.usertemplerequest.userId.toString();


    return super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);


    return new Scaffold(
        key: _scaffoldKey,
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
                  print(templeId);
                  print(roleId);
                  print(userId);
                  //print(widget.eventrequest.eventDescription);
                  //Map<String,dynamic> eventmap = widget.eventrequest.toJson();
                  //String eventmap = widget.eventrequest.toStrJsonJson();
                  String eventrequestStr = jsonEncode(widget.usertemplerequest.toStrJson());
                  userTemplePageVM.submitNewTeamUserMapping(List<UserTemple> eventrequestStr);
                },
              ))
        ]),

        body: Builder(
            builder : (context) =>Form(
            key: _formKey,
            autovalidate: true,
            //onWillPop: _warnUserAboutInvalidData,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[


                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Temple Id", hintText: "What is the temple id?"),
                    autocorrect: false,
                    controller: _templeController,
                    onSaved: (String value) {
                      temple_id = value as int;
                    },
                  ),
                ),


                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Role id"),
                    autocorrect: false,
                    controller: _roleController,
                    onSaved: (String value) {
                      roleId = value as int;
                    },
                  ),
                ),


                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "User id"),
                    autocorrect: false,
                    controller: _userController,
                    onSaved: (String value) {
                      userId = value as int;
                    },
                  ),
                ),



              ],
            ))));
  }
}*/
