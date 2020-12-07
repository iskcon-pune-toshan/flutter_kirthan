import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());

class EditTeam extends StatefulWidget {
  TeamRequest teamrequest ;
  final String screenName = SCR_TEAM;

  EditTeam({Key key, @required this.teamrequest}) : super(key: key);

  @override
  _EditTeamState createState() => new _EditTeamState();
}

class _EditTeamState extends State<EditTeam> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  TeamRequest teamrequest= new TeamRequest();
  //final IKirthanRestApi apiSvc = new RestAPIServices();



  final TextEditingController _teamTitleController = new TextEditingController();
  String teamTitle ;
  final TextEditingController _teamDescriptionController = new TextEditingController();
  String teamDescription ;
  final TextEditingController _teamupdatedBy = new TextEditingController();
  String teamupdatedBy ;



  @override
  void initState() {
    _teamTitleController.text = widget.teamrequest.teamTitle;
    _teamDescriptionController.text = widget.teamrequest.teamDescription;

    _teamupdatedBy.text = getCurrentUser().toString();
    return super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    widget.teamrequest.updatedBy=email;
    print(email);
    return email;

  }


  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final DateTime today = new DateTime.now();

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
                  print(widget.teamrequest.teamTitle);
                  print(widget.teamrequest.teamDescription);
                  String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
                  _teamupdatedBy.text=widget.teamrequest.updatedTime=dt;


                  String teamrequestStr = jsonEncode(widget.teamrequest.toStrJson());
                  teamPageVM.submitUpdateTeamRequest(teamrequestStr);
                  //apiSvc?.submitUpdateTeamRequest(teamrequestStr);
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
                    decoration: const InputDecoration(labelText: "Team Title", hintText: "What do people call this event?"),
                    autocorrect: false,
                    controller: _teamTitleController,
                    onSaved: (String value) {
                      widget.teamrequest.teamTitle = value;
                    },
                  ),
                ),


                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Description"),
                    autocorrect: false,
                    controller: _teamDescriptionController,
                    onSaved: (String value) {
                      widget.teamrequest.teamDescription = value;
                    },
                  ),
                ),


              ],
            )));
  }
}