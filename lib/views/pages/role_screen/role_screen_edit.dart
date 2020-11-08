import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/role_screen_service_impl.dart';
import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';


final RoleScreenViewPageModel roleScreenPageVM =
RoleScreenViewPageModel(apiSvc: RoleScreenAPIService());


class EditRoleScreen extends StatefulWidget {
  RoleScreen rolescreenrequest ;
  final String screenName = SCR_ROLE_SCREEN;

  EditRoleScreen({ @required this.rolescreenrequest}) ;

  @override
  _EditRoleScreenState createState() => new _EditRoleScreenState();


}

class _EditRoleScreenState extends State<EditRoleScreen> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //EventRequest eventrequestobj = new EventRequest();
  //_EditProfileViewState({Key key, @required this.eventrequest}) ;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  String _selectedState;
  int role_id;
  var _states = 3;
  // controllers for form text controllers
  final TextEditingController _roleController = new TextEditingController();
  int roleId ;
  final TextEditingController _screenController = new TextEditingController();
  int screenId ;
  final TextEditingController _createController = new TextEditingController();
  int create ;
  final TextEditingController _updateController = new TextEditingController();
  int update ;
  final TextEditingController _deleteController = new TextEditingController();
  int delete ;
  final TextEditingController _viewController = new TextEditingController();
  int view ;
  final TextEditingController _processController = new TextEditingController();
  int process ;



  @override
  void initState() {
    _roleController.text = widget.rolescreenrequest.roleId.toString();
    _screenController.text = widget.rolescreenrequest.screenId.toString();
    _createController.text = widget.rolescreenrequest.isCreated.toString();
    _updateController.text = widget.rolescreenrequest.isUpdated.toString();
    _deleteController.text = widget.rolescreenrequest.isDeleted.toString();
    _viewController.text = widget.rolescreenrequest.isViewd.toString();
    _processController.text = widget.rolescreenrequest.isProcessed.toString();

    return super.initState();
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);


    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(title: const Text('Edit Role Screen'), actions: <Widget>[
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
                  print(roleId);
                  print(screenId);
                  print(create);
                  print(update);
                  print(delete);
                  print(view);
                  print(process);
                  //print(widget.eventrequest.eventDescription);
                  //Map<String,dynamic> eventmap = widget.eventrequest.toJson();
                  //String eventmap = widget.eventrequest.toStrJsonJson();
                   String eventrequestStr = jsonEncode(widget.rolescreenrequest.toStrJson());
                  roleScreenPageVM.submitUpdateRoleScreen(eventrequestStr);
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
                        decoration: const InputDecoration(labelText: "Role Id", hintText: "What is the role id?"),
                        autocorrect: false,
                        controller: _roleController,
                        onSaved: (String value) {
                          roleId = value as int;
                        },
                      ),
                    ),


                    new Container(
                      child: new TextFormField(
                        decoration: const InputDecoration(labelText: "Screen id"),
                        autocorrect: false,
                        controller: _screenController,
                        onSaved: (String value) {
                          screenId = value as int;
                        },
                      ),
                    ),


                    new Container(
                      child: new TextFormField(
                        decoration: const InputDecoration(labelText: "Create id"),
                        autocorrect: false,
                        controller: _createController,
                        onSaved: (String value) {
                          create = value as int;
                        },
                      ),
                    ),

                    new Container(
                      child: new TextFormField(
                        decoration: const InputDecoration(labelText: "Update id"),
                        autocorrect: false,
                        controller: _updateController,
                        onSaved: (String value) {
                          update = value as int;
                        },
                      ),
                    ),
                    new Container(
                      child: new TextFormField(
                        decoration: const InputDecoration(labelText: "View id"),
                        autocorrect: false,
                        controller: _viewController,
                        onSaved: (String value) {
                          view = value as int;
                        },
                      ),
                    ),
                    new Container(
                      child: new TextFormField(
                        decoration: const InputDecoration(labelText: "Delete id"),
                        autocorrect: false,
                        controller: _deleteController,
                        onSaved: (String value) {
                          delete = value as int;
                        },
                      ),
                    ),
                    new Container(
                      child: new TextFormField(
                        decoration: const InputDecoration(labelText: "Process id"),
                        autocorrect: false,
                        controller: _processController,
                        onSaved: (String value) {
                          process = value as int;
                        },
                      ),
                    ),



                  ],
                ))));
  }
}