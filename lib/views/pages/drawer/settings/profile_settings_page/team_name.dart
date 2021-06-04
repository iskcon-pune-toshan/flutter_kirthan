import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/common/constants.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

class teamName extends StatefulWidget {
  teamName({Key key}) : super(key: key);

  final String screenName = SCR_TEAM;

  @override
  _teamNameState createState() => _teamNameState();
}

class _teamNameState extends State<teamName> {
  final _formKey = GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Team Name',
        ),
      ),
      body: FutureBuilder(
          future: getEmail(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              String email = snapshot.data;
              return FutureBuilder(
                  future: teamPageVM.getTeamRequests("teamLead:" + email),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      List<TeamRequest> teamList = snapshot.data;
                      if (teamList.isNotEmpty) {
                        for (var u in teamList) {
                          teamrequest = u;
                        }
                        return SingleChildScrollView(
                          child: Container(
                            //color: Colors.white,
                            child: Center(
                              child: Form(
                                // context,
                                key: _formKey,
                                autovalidate: true,
                                // readonly: true,
                                child: Column(
                                  //crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    new Container(
                                        margin: const EdgeInsets.only(top: 50)),
                                    Card(
                                      child: Container(
                                        padding: new EdgeInsets.all(10),
                                        child: TextFormField(
                                          initialValue: teamrequest.teamTitle,
                                          decoration: InputDecoration(
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.grey),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.green),
                                              ),
                                              /*icon: const Icon(
                                Icons.title,
                                color: Colors.grey,
                              ),*/
                                              labelText: "Title",
                                              hintText: "Add a title",
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                              ),
                                              labelStyle: TextStyle(
                                                color: Colors.grey,
                                              )),
                                          onSaved: (input) {
                                            teamrequest.teamTitle = input;
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Please enter some text";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      elevation: 5,
                                    ),
                                    new Container(
                                        margin: const EdgeInsets.only(top: 40)),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        MaterialButton(
                                          color: Colors.white,
                                          child: Text("Cancel"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        MaterialButton(
                                            child: Text(
                                              "Submit",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: KirthanStyles.colorPallete30,
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                String dt = DateFormat(
                                                        "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                                    .format(DateTime.now());
                                                teamrequest.updatedTime = dt;
                                                teamrequest.updatedBy = email;
                                                String teamrequestStr =
                                                    jsonEncode(teamrequest
                                                        .toStrJson());
                                                teamPageVM
                                                    .submitUpdateTeamRequest(
                                                        teamrequestStr);
                                                SnackBar mysnackbar = SnackBar(
                                                  content: Text(
                                                      "Team details updated $successful"),
                                                  duration:
                                                      new Duration(seconds: 4),
                                                  backgroundColor: Colors.green,
                                                );
                                                Scaffold.of(context)
                                                    .showSnackBar(mysnackbar);
                                              }
                                              //String s = jsonEncode(userrequest.mapToJson());
                                              //service.registerUser(s);
                                              //print(s);
                                            }),
                                        /*MaterialButton(
                        child: Text("Reset",style: TextStyle(color:
Colors.white),),
                        color: Colors.pink,
                        onPressed: () {
                          _fbKey.currentState.reset();
                        },
                      ),*/
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          padding: new EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                  child: Text(
                                      "It seems like you don't have a team.")),
                              Center(
                                  child: Text(
                                      "Click on the button below to create one")),
                              SizedBox(
                                height: 10,
                              ),
                              FlatButton(
                                textColor: KirthanStyles.colorPallete60,
                                color: KirthanStyles.colorPallete30,
                                child: Text("Create team"),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TeamWrite(
                                                userRequest: null,
                                                localAdmin: null,
                                              )));
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return Container();
                  });
            }
            return Container();
          }),
    );
  }
}
