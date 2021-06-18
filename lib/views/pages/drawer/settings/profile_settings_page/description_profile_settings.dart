import 'dart:convert';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());

final CommonLookupTablePageViewModel commonLookupTablePageVM =
CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

class description_profile extends StatefulWidget {
  @override
  _description_profileState createState() => _description_profileState();
}

class _description_profileState extends State<description_profile> {
  int _currentvalue=0;

  FocusNode myFocusNode = new FocusNode();
  String _selectedCategory;
  final _formKey = GlobalKey<FormState>();
  TeamRequest teamrequest = new TeamRequest();
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  Future _showIntegerDialog() async {
    await showDialog<int>(
      context: context,
      builder: (BuildContext context) {
        return Consumer<ThemeNotifier>(
            builder: (context, notifier, child) =>  NumberPickerDialog.integer(
              selectedTextStyle:TextStyle(
                fontSize: notifier.custFontSize,
                fontWeight: FontWeight.bold,
                color: KirthanStyles.titleColor,
              ),
              textStyle: TextStyle(
                fontSize: notifier.custFontSize,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
              minValue: 0,
              maxValue: 10,
              initialIntegerValue: _currentvalue,
              title: new Text("Experience: "),
            )
        );
      },
    ).then(_handleValueChanged);
  }
  _handleValueChanged(num value) {
    if (value != null) {
      if (value is int) {
        setState(() => _currentvalue = value);
      } else {
        setState(() => _currentvalue = value);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, notifier, child) =>(
        Scaffold(
          appBar: AppBar(
            title: Text('Description', style: TextStyle(
                fontSize: notifier.custFontSize),),
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
                            return Form(
                              key: _formKey,
                              autovalidate: true,
                              child: Column(
                                children: [
                                  Card(
                                    child: Container(
                                      //color: Colors.black26,
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        style: TextStyle(fontSize: notifier.custFontSize),
                                        initialValue:
                                        teamrequest.teamDescription,
                                        decoration: InputDecoration(
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.grey),
                                          ),
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide:
                                            BorderSide(color: Colors.green),
                                          ),
                                          labelText: "Enter team description",
                                          hintText:
                                          "Please enter the team description",
                                          labelStyle: TextStyle(
                                              fontSize: notifier.custFontSize,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey),
                                          hintStyle: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                        validator: (input) {
                                          if (input.isEmpty) {
                                            return "Enter valid description";
                                          } else {
                                            return null;
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                  FutureBuilder(
                                      future: commonLookupTablePageVM
                                          .getCommonLookupTable(
                                          "lookupType:Event-type-Category"),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          List<CommonLookupTable> cltList =
                                              snapshot.data;
                                          List<CommonLookupTable> currCategory =
                                          cltList
                                              .where((element) =>
                                          element.id ==
                                              teamrequest.category)
                                              .toList();
                                          for (var i in currCategory) {
                                            _selectedCategory = i.description;
                                          }

                                          List<String> _category = cltList
                                              .map((user) => user.description)
                                              .toSet()
                                              .toList();
                                          return Card(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 20.0,
                                                  top: 20.0,
                                                  left: 10.0,
                                                  right: 10.0),
                                              child:
                                              Consumer<ThemeNotifier>(
                                                builder: (context, notifier, child) =>(
                                                    DropdownButtonFormField<String>(
                                                      style: TextStyle(fontSize: notifier.custFontSize+10, color: Colors.grey
                                                      ),
                                                      value: _selectedCategory,
                                                      //icon: const Icon(Icons.category),
                                                      hint: Text('Select Category',
                                                          style: TextStyle(
                                                              fontSize: notifier.custFontSize,
                                                              color: Colors.black)),
                                                      items: _category
                                                          .map((category) =>
                                                          DropdownMenuItem<String>(
                                                            value: category,
                                                            child: Consumer<ThemeNotifier>(
                                                              builder: (context, notifier, child) =>(

                                                                  Text(category,style: TextStyle(
                                                                      fontSize: notifier.custFontSize > 20
                                                                          ? notifier.custFontSize + 10
                                                                          : notifier.custFontSize, color: notifier.darkTheme ? Colors.white : Colors.black),)),
                                                            ),
                                                          ))
                                                          .toList(),
                                                      onChanged: (input) {
                                                        setState(() {
                                                          _selectedCategory = input;
                                                        });
                                                      },
                                                      onSaved: (input) {
                                                        _selectedCategory = input;
                                                      },
                                                    )
                                                ),
                                              ),
                                            ),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Container();
                                        } else {
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
                                                        "It seems like you don't have a team.", style: TextStyle(fontSize: notifier.custFontSize))),
                                                Center(
                                                    child: Text(
                                                        "Click on the button below to create one", style: TextStyle(fontSize: notifier.custFontSize))),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                FlatButton(
                                                  textColor: KirthanStyles
                                                      .colorPallete60,
                                                  color: KirthanStyles
                                                      .colorPallete30,
                                                  child: Text("Create team",
                                                      style: TextStyle(fontSize: notifier.custFontSize)),
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
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
                                          );
                                        }
                                      }),

                                  Card(
                                    child: Container(
                                      width: double.infinity,
                                      //color: Colors.white,
                                      padding: const EdgeInsets.all(10),
                                      child: Consumer<ThemeNotifier>(
                                        builder: (context, notifier, child) =>
                                            FlatButton(
                                              focusColor: myFocusNode.hasFocus
                                                  ? Colors.black
                                                  : Colors.grey,
                                              focusNode: myFocusNode,
                                              onPressed: () => _showIntegerDialog(),
                                              child: new Align(
                                                alignment: Alignment.topLeft,
                                                child: new Text(
                                                  "Experience: $_currentvalue",
                                                  style: TextStyle(
                                                      fontSize: notifier.custFontSize > 20
                                                          ? notifier.custFontSize + 10
                                                          : notifier.custFontSize, color: notifier.darkTheme ? Colors.white : Colors.black),),
                                              ),
                                            ),), //
                                    ),
                                    //),
                                    elevation: 5,
                                  ),
                                  SizedBox( height: 20),

                                  /*  Card(
                                      child: Container(
                                        padding: new EdgeInsets.all(10),
                                        child: TextFormField(
                                          style: TextStyle(fontSize: notifier.custFontSize),
                                          initialValue: teamrequest.experience,
                                          decoration: InputDecoration(
                                              enabledBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.grey),
                                              ),
                                              focusedBorder: UnderlineInputBorder(
                                                borderSide:
                                                BorderSide(color: Colors.green),
                                              ),
                                              labelText: "Experience",
                                              hintText: "Add experience",
                                              hintStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: notifier.custFontSize
                                              ),
                                              labelStyle: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: notifier.custFontSize
                                              )),
                                         onSaved: (input) {
                                            teamrequest.experience = input;
                                          },
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Please enter some text";
                                            }
                                            return null;
                                          },
                                        ),
                                      )
                                       elevation: 5,
                                    ),*/



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
                                            child: Text('Submit', style: TextStyle(fontSize: notifier.custFontSize)),
                                            onPressed: () async {
                                              if (_formKey.currentState
                                                  .validate()) {
                                                _formKey.currentState.save();
                                                List<CommonLookupTable>
                                                selectedCategory =
                                                await commonLookupTablePageVM
                                                    .getCommonLookupTable(
                                                    "description:" +
                                                        _selectedCategory);
                                                for (var i in selectedCategory) {
                                                  teamrequest.category = i.id;
                                                }
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
                                                      "Team details updated $successful", style: TextStyle(fontSize: notifier.custFontSize)),
                                                  duration:
                                                  new Duration(seconds: 4),
                                                  backgroundColor: Colors.green,
                                                );
                                                Scaffold.of(context)
                                                    .showSnackBar(mysnackbar);
                                              }
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(50.0),
                                                side: BorderSide(width: 2)),
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
                                            child: Text('Cancel',style: TextStyle(fontSize: notifier.custFontSize)),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius.circular(50.0),
                                                side: BorderSide(width: 2)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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
                                          "It seems like you don't have a team.", style: TextStyle(fontSize: notifier.custFontSize))),
                                  Center(
                                      child: Text(
                                        "Click on the button below to create one", style: TextStyle(fontSize: notifier.custFontSize),)),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  FlatButton(
                                    textColor: KirthanStyles.colorPallete60,
                                    color: KirthanStyles.colorPallete30,
                                    child: Text("Create team", style: TextStyle(fontSize: notifier.custFontSize),),
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
        )
    ),
    );
  }
}
