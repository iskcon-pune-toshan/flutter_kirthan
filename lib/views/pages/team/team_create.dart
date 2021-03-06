import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

class TeamWrite extends StatefulWidget {
  TeamWrite({Key key}) : super(key: key);

  final String screenName = SCR_TEAM;

  @override
  _TeamWriteState createState() => _TeamWriteState();
}

class _TeamWriteState extends State<TeamWrite> {
  final _formKey = GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();
  //final IKirthanRestApi apiSvc = new RestAPIServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.redAccent,
            child: Center(
              child: Form(
                // context,
                key: _formKey,
                autovalidate: true,
                // readonly: true,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(margin: const EdgeInsets.only(top: 50)),
                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child: TextFormField(
                          //attribute: "eventTitle",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.title),
                            labelText: "Title",
                            hintText: "",
                          ),
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
                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child: TextFormField(
                          //attribute: "Description",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.description),
                            labelText: "Description",
                            hintText: "",
                          ),
                          onSaved: (input) {
                            teamrequest.teamDescription = input;
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
                    new Container(margin: const EdgeInsets.only(top: 40)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: Colors.blue,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                teamrequest.isProcessed = false;
                                teamrequest.createdBy = "SYSTEM";
                                String dt =
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                        .format(DateTime.now());
                                teamrequest.createTime = dt;
                                teamrequest.updatedBy = "SYSTEM";
                                teamrequest.updateTime = dt;
                                teamrequest.approvalStatus = "Approved";
                                teamrequest.approvalComments = "AAA";
                                Map<String, dynamic> teammap =
                                    teamrequest.toJson();
                                //TeamRequest newteamrequest = await apiSvc
                                //  ?.submitNewTeamRequest(teammap);
                                TeamRequest newteamrequest = await teamPageVM
                                    .submitNewTeamRequest(teammap);

                                print(newteamrequest.id);
                                String tid = newteamrequest.id.toString();
                                SnackBar mysnackbar = SnackBar(
                                  content: Text(
                                      "Team registered $successful with $tid"),
                                  duration: new Duration(seconds: 4),
                                  backgroundColor: Colors.green,
                                );
                                Scaffold.of(context).showSnackBar(mysnackbar);
                              }
                              //String s = jsonEncode(userrequest.mapToJson());
                              //service.registerUser(s);
                              //print(s);
                            }),
                        /*MaterialButton(
                        child: Text("Reset",style: TextStyle(color: Colors.white),),
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
      }),
    );
  }
}
