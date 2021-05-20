import 'dart:convert';
import 'dart:ui';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:intl/intl.dart';

final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());
final TeamUserPageViewModel teamUserPageVM =
    TeamUserPageViewModel(apiSvc: TeamUserAPIService());
final TemplePageViewModel templePageVM =
    TemplePageViewModel(apiSvc: TempleAPIService());
final UserTemplePageViewModel userTemplePageVM =
    UserTemplePageViewModel(apiSvc: UserTempleAPIService());

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class Preference extends StatefulWidget {
  UserRequest user;
  Preference({Key key, this.user}) : super(key: key);
  @override
  _PreferenceState createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  final _formKey = GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  List<String> _category = [
    'Bhajan',
    'Kirthan',
    'Bhajan & Kirthan',
    'Dance',
    'Music',
    'Lecture'
  ];

  List<String> _requestAcceptance = [
    'One week before',
    '15 days before',
    'One month before',
    'Any time'
  ];
  Future<List<UserRequest>> Users;
  Future<List<Temple>> Temples;
  Future<List<UserTemple>> UserTemples;
  List<UserRequest> userList = new List<UserRequest>();
  List<Temple> templeList = new List<Temple>();
  List<UserTemple> userTempleList = new List<UserTemple>();

  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    Temples = templePageVM.getTemples("All");
    UserTemples = userTemplePageVM.getUserTempleMapping("All");
    //getLocalAdminTemple();
    super.initState();
  }

  List<UserTemple> userTemples;
  String _selectedRequestAcceptance;
  String _selectedTempleArea;
  String _selectedLocalAdmin;
  int _selectedtempleId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
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
                        return Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                FutureBuilder(
                                    future:
                                        userPageVM.getUserRequests("Approved"),
                                    builder: (context, snapshot) {
                                      if (snapshot.data != null) {
                                        List<UserRequest> tempList =
                                            snapshot.data;

                                        return Column(
                                          children: <Widget>[
                                            SizedBox(height: 35),

                                            FutureBuilder<List<UserTemple>>(
                                                future: UserTemples,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            List<UserTemple>>
                                                        snapshot) {
                                                  if (snapshot.data != null) {
                                                    userTempleList =
                                                        snapshot.data.toList();
                                                    if (widget.user != null) {
                                                      List<UserTemple>
                                                          templeArea =
                                                          userTempleList
                                                              .where((user) =>
                                                                  user.userId ==
                                                                  widget
                                                                      .user.id)
                                                              .toList();
                                                      for (var temple
                                                          in templeArea) {
                                                        _selectedtempleId =
                                                            temple.templeId;
                                                        print(
                                                            "work man $_selectedtempleId");
                                                      }
                                                    }
                                                    return FutureBuilder<
                                                            List<Temple>>(
                                                        future: Temples,
                                                        builder: (BuildContext
                                                                context,
                                                            AsyncSnapshot<
                                                                    List<
                                                                        Temple>>
                                                                snapshot) {
                                                          if (snapshot.data !=
                                                              null) {
                                                            if (widget.user ==
                                                                null) {
                                                              templeList =
                                                                  snapshot.data;
                                                            } else {
                                                              templeList = snapshot
                                                                  .data
                                                                  .where((element) =>
                                                                      element
                                                                          .id ==
                                                                      _selectedtempleId)
                                                                  .toList();
                                                              for (var temple
                                                                  in templeList) {
                                                                _selectedTempleArea =
                                                                    temple.area;
                                                                print(
                                                                    "this is temple area : $_selectedTempleArea");
                                                              }
                                                            }
                                                            List<String>
                                                                templeArea =
                                                                snapshot.data
                                                                    .map((user) =>
                                                                        user.area)
                                                                    .toSet()
                                                                    .toList();
                                                            return Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(10),
                                                              child:
                                                                  DropdownButtonFormField<
                                                                      String>(
                                                                value:
                                                                    _selectedTempleArea,
                                                                icon: const Icon(
                                                                    Icons
                                                                        .account_circle),
                                                                hint: Text(
                                                                    'Select Temple Area',
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .grey)),
                                                                items: templeArea
                                                                    .map((templeArea) => DropdownMenuItem<String>(
                                                                          value:
                                                                              templeArea,
                                                                          child:
                                                                              Text(templeArea),
                                                                        ))
                                                                    .toList(),
                                                                onChanged:
                                                                    (input) {
                                                                  setState(() {
                                                                    _selectedTempleArea =
                                                                        input;
                                                                    _selectedtempleId =
                                                                        templeList.indexWhere((element) =>
                                                                                element.area ==
                                                                                _selectedTempleArea) +
                                                                            1;
                                                                    print(
                                                                        _selectedtempleId);
                                                                    _selectedLocalAdmin =
                                                                        null;
                                                                  });
                                                                },
                                                                onSaved:
                                                                    (input) {
                                                                  teamrequest
                                                                          .localAdminArea =
                                                                      input;
                                                                },
                                                              ),
                                                            );
                                                          }
                                                          return Container();
                                                        });
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text("Error");
                                                  } else {
                                                    return Text(
                                                        "Retrieved null values");
                                                  }
                                                }),
                                            SizedBox(height: 35),
                                            //UserTemple
                                            FutureBuilder<List<UserTemple>>(
                                                future: UserTemples,
                                                builder: (BuildContext context,
                                                    AsyncSnapshot<
                                                            List<UserTemple>>
                                                        snapshot) {
                                                  if (snapshot.data != null) {
                                                    userTempleList = snapshot
                                                        .data
                                                        .where((element) =>
                                                            element.templeId ==
                                                            _selectedtempleId)
                                                        .toList();
                                                    List<String> templeArea =
                                                        userTempleList
                                                            .map((user) =>
                                                                user.userName)
                                                            .toSet()
                                                            .toList();

                                                    return Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      child:
                                                          DropdownButtonFormField<
                                                              String>(
                                                        value: widget.user ==
                                                                null
                                                            ? _selectedLocalAdmin
                                                            : widget
                                                                .user.userName,
                                                        icon: const Icon(Icons
                                                            .account_circle),
                                                        hint: Text(
                                                            'Select Local Admin',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey)),
                                                        items: templeArea
                                                            .map((templeArea) =>
                                                                DropdownMenuItem<
                                                                    String>(
                                                                  value:
                                                                      templeArea,
                                                                  child: Text(
                                                                      templeArea),
                                                                ))
                                                            .toList(),
                                                        onChanged: (input) {
                                                          setState(() {
                                                            _selectedLocalAdmin =
                                                                input;
                                                            // _selectedtempleId =
                                                            //     templeList.indexWhere((element) =>
                                                            //         element.area ==
                                                            //         _selectedTempleArea);
                                                            print(
                                                                _selectedtempleId);
                                                          });
                                                        },
                                                        onSaved: (input) {
                                                          teamrequest
                                                                  .localAdminName =
                                                              input;
                                                        },
                                                      ),
                                                    );
                                                  } else if (snapshot
                                                      .hasError) {
                                                    return Text("Error");
                                                  } else {
                                                    return Text(
                                                        "Retrieved null values");
                                                  }
                                                }),
                                          ],
                                        );
                                      } else if (snapshot.hasError) {
                                        return Text("Error");
                                      } else {
                                        return Text("Retrieved null values");
                                      }
                                    }),
                                Divider(),
                                Divider(),
                                Container(
                                  padding: EdgeInsets.all(10),
                                  child: TextFormField(
                                    initialValue: teamrequest.duration == null
                                        ? "0"
                                        : teamrequest.duration.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green),
                                      ),
                                      suffixIcon: Icon(
                                        Icons.timelapse,
                                        color: Colors.grey,
                                      ),
                                      labelText: "Duration in hours",
                                      labelStyle: TextStyle(
                                        fontSize: notifier.custFontSize,
                                        color: Colors.grey,
                                      ),
                                      hintText:
                                          "Enter duration for which you are available",
                                    ),
                                    onSaved: (input) {
                                      teamrequest.duration = int.parse(input);
                                    },
                                  ),
                                ),
                                Divider(),
                                Container(
                                  padding: new EdgeInsets.all(10),
                                  child: DropdownButtonFormField<String>(
                                    value: _selectedRequestAcceptance,
                                    icon: const Icon(Icons.add),
                                    hint: Text(
                                      'Select request acceptance ',
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                    items: _requestAcceptance
                                        .map((weekday) => DropdownMenuItem(
                                              value: weekday,
                                              child: Text(weekday),
                                            ))
                                        .toList(),
                                    onChanged: (input) {
                                      setState(() {
                                        _selectedRequestAcceptance = input;
                                      });
                                    },
                                    onSaved: (input) {
                                      if (input.contains("One week before"))
                                        teamrequest.requestAcceptance = 7;
                                      else if (input.contains("15 days before"))
                                        teamrequest.requestAcceptance = 15;
                                      else if (input
                                          .contains("One month before"))
                                        teamrequest.requestAcceptance = 31;
                                      else if (input.contains("Any time"))
                                        teamrequest.requestAcceptance = null;
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Divider(
                                      thickness: 100.0,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: RaisedButton(
                                          color: KirthanStyles.colorPallete30,
                                          child: Text('Submit'),
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
                                                  jsonEncode(
                                                      teamrequest.toStrJson());
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
                                          },
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(50.0),
                                          //     side: BorderSide(
                                          //         color: Colors.blue,
                                          //         width: 2)),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 20.0),
                                      child: SizedBox(
                                        width: 150,
                                        height: 50,
                                        child: RaisedButton(
                                          color: Colors.redAccent,
                                          child: Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(50.0),
                                          //     side: BorderSide(
                                          //         color: Colors.blue,
                                          //         width: 2)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
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
