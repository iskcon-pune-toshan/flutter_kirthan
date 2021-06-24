import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'profile_settings_page/description_profile_settings.dart';
import 'profile_settings_page/members_name_profile.dart';
import 'profile_settings_page/team_name.dart';

final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());

class Team_Settings extends StatefulWidget {
  @override
  _Team_SettingsState createState() => _Team_SettingsState();
}

class _Team_SettingsState extends State<Team_Settings> {
  TeamRequest teamrequest = new TeamRequest();
  String teamemail;
  Future<String> getEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    teamemail = user.email;
    return email;
  }

  // @override
  // void initState() {
  //   getEmail();
  //   List<TeamRequest> teamList;
  //   teamPageVM
  //       .getTeamRequests("teamLead:" + teamemail)
  //       .then((value) => teamList = value);
  //   for (var u in teamList) {
  //     teamrequest = u;
  //   }
  //   teamrequest.approvalStatus == "Rejected" ? _showDialog() : null;
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => (Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: Text(
              'Team Settings',
              style: TextStyle(fontSize: notifier.custFontSize),
            ),
          ),
          body: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => FutureBuilder(
                  future: getEmail(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      String email = snapshot.data;
                      return FutureBuilder(
                          future: teamPageVM
                              .getTeamRequests("teamLead:" + email),
                          builder: (context, snapshot) {
                            if (snapshot.data != null) {
                              List<TeamRequest> teamList = snapshot.data;
                              if (teamList.isNotEmpty) {
                                for (var u in teamList) {
                                  teamrequest = u;
                                }
                                return teamrequest.approvalStatus ==
                                    "Waiting"
                                    ? Center(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      SpinKitPouringHourglass(
                                        color: KirthanStyles
                                            .colorPallete30,
                                        size: 50,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Team Request under process',
                                        style:
                                        TextStyle(fontSize: 20),
                                      ),
                                    ],
                                  ),
                                )
                                    : teamrequest.approvalStatus ==
                                    "Rejected"
                                    ? Container(
                                  padding: new EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Container(
                                            child: Text(
                                                "Your previous team request for "),
                                          )),
                                      Center(
                                          child: Container(
                                            child: Text(
                                              teamrequest.teamTitle,
                                              style: TextStyle(
                                                  color: KirthanStyles
                                                      .colorPallete30),
                                            ),
                                          )),
                                      Center(
                                          child: Container(
                                            child: Text(
                                              "has been rejected" +
                                                  "\n",
                                            ),
                                          )), //     child: RichText(

                                      Center(
                                          child: Text(
                                            "Click on the button below to create other",
                                            style: TextStyle(
                                              fontSize: notifier
                                                  .custFontSize,
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FlatButton(
                                        textColor: KirthanStyles
                                            .colorPallete60,
                                        color: KirthanStyles
                                            .colorPallete30,
                                        child: Text(
                                          "Create team",
                                          style: TextStyle(
                                            fontSize: notifier
                                                .custFontSize,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder:
                                                      (context) =>
                                                      TeamWrite(
                                                        userRequest:
                                                        null,
                                                        localAdmin:
                                                        null,
                                                      )));
                                        },
                                      ),
                                    ],
                                  ),
                                )
                                    : SingleChildScrollView(
                                    padding:
                                    const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Card(
                                          shape:
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors
                                                      .black,
                                                  width: 0.5),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  8)),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.group_outlined,
                                              color: KirthanStyles
                                                  .colorPallete30,
                                            ),
                                            title: Consumer<
                                                ThemeNotifier>(
                                              builder: (context,
                                                  notifier,
                                                  child) =>
                                                  Text(
                                                    'Team Name',
                                                    style: TextStyle(
                                                      fontSize: notifier
                                                          .custFontSize,
                                                      color: notifier
                                                          .darkTheme
                                                          ? Colors.white
                                                          : Colors
                                                          .black,
                                                      //color: KirthanStyles.colorPallete30,
                                                    ),
                                                  ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                        teamName(),
                                                  ));
                                            },
                                            selected: true,
                                          ),
                                        ),
                                        Card(
                                          shape:
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors
                                                      .black,
                                                  width: 0.5),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  8)),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons
                                                  .group_add_outlined,
                                              color: KirthanStyles
                                                  .colorPallete30,
                                            ),
                                            title: Consumer<
                                                ThemeNotifier>(
                                              builder: (context,
                                                  notifier,
                                                  child) =>
                                                  Text(
                                                    'Members',
                                                    style: TextStyle(
                                                      fontSize: notifier
                                                          .custFontSize,
                                                      color: notifier
                                                          .darkTheme
                                                          ? Colors.white
                                                          : Colors
                                                          .black,
                                                      //color: KirthanStyles.colorPallete30,
                                                    ),
                                                  ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                        members_profile(
                                                          show: false,
                                                        ),
                                                  ));
                                            },
                                            selected: true,
                                          ),
                                        ),
                                        Card(
                                          shape:
                                          RoundedRectangleBorder(
                                              side: BorderSide(
                                                  color: Colors
                                                      .black,
                                                  width: 0.5),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(
                                                  8)),
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.content_paste,
                                              color: KirthanStyles
                                                  .colorPallete30,
                                            ),
                                            title: Consumer<
                                                ThemeNotifier>(
                                              builder: (context,
                                                  notifier,
                                                  child) =>
                                                  Text(
                                                    'Description',
                                                    style: TextStyle(
                                                      fontSize: notifier
                                                          .custFontSize,
                                                      color: notifier
                                                          .darkTheme
                                                          ? Colors.white
                                                          : Colors
                                                          .black,
                                                      //color: KirthanStyles.colorPallete30,
                                                    ),
                                                  ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                        description_profile(),
                                                  ));
                                            },
                                            selected: true,
                                          ),
                                        ),
                                      ],
                                    ));
                              }
                              else {
                                return Container(
                                  padding: new EdgeInsets.all(10),
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Center(
                                          child: Text(
                                            "It seems like you don't have a team.",
                                            style: TextStyle(
                                              fontSize: notifier.custFontSize,
                                            ),
                                          )),
                                      Center(
                                          child: Text(
                                            "Click on the button below to create one",
                                            style: TextStyle(
                                              fontSize: notifier.custFontSize,
                                            ),
                                          )),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      FlatButton(
                                        textColor:
                                        KirthanStyles.colorPallete60,
                                        color: KirthanStyles.colorPallete30,
                                        child: Text(
                                          "Create team",
                                          style: TextStyle(
                                            fontSize: notifier.custFontSize,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      TeamWrite(
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
                  })),
        )));
  }

  Widget _showDialog() {
    return AlertDialog(
        actions: [
          FlatButton(
            child: Text("Ok"),
            onPressed: () {},
          )
        ],
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        content: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.cancel_outlined,
                size: 50,
                color: Colors.red,
              ),
              Text(
                'Team Request rejected',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
