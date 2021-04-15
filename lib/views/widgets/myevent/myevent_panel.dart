import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/Widget.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';
import 'package:flutter_kirthan/views/widgets/event/event_list_item.dart';
import 'package:flutter_kirthan/views/widgets/myevent/myevent_list_item.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/eventuser/eventuser_view.dart';
import 'package:flutter_kirthan/views/pages/teamuser/teamuser_view.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

class MyEventsPanel extends StatelessWidget {
  String eventType;
  EventRequest eventRequest;


  final String screenName = "My Events";

  MyEventsPanel({@required this.eventType, @required this.eventRequest});
  @override
  Widget build(BuildContext context) {
    String dropdownValue = eventRequest?.city;
    return ScopedModelDescendant<EventPageViewModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<EventRequest>>(
          future: model.eventrequests,
          builder: (_, AsyncSnapshot<List<EventRequest>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var eventRequests = snapshot.data;
                  return new Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          /*RaisedButton(
                            child: const Text("Today"),
                            onPressed: () {
                              print("Today");
                              model.setEventRequests("1");
                            },
                          ),*/


                          /*RaisedButton(
                            child: const Text("Map v"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeamUserView()));
                            },
                          ),*/

                        ],
                      ),

                      Expanded(
                        child: Scrollbar(
                          controller: ScrollController(
                            initialScrollOffset: 2,
                            keepScrollOffset: false,
                          ),
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: eventRequests == null
                                  ? 0
                                  : eventRequests.length,
                              itemBuilder: (_, int index) {
                                var eventrequest = eventRequests[index];
                                return MyEventRequestsListItem(
                                  eventrequest: eventrequest,
                                  eventPageVM: model,
                                  //eventteam: eventteam,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      //await model.setSuperAdminUserRequests("SuperAdmin");
                      //await model.setUserRequests("All");
                      await model.setEventRequests("MyEvent");

                    },
                  );
                }
            }
          },
        );
      },
    );
  }
  Widget eventTeam(var eventteamrequest){
    //String dropdownValue = eventteam.teamName;
    return ScopedModelDescendant<EventTeamPageViewModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<EventTeam>>(
          future: model.teamUsers,
          builder: (_, AsyncSnapshot<List<EventTeam>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var eventRequests = snapshot.data;
                  return new Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          /*RaisedButton(
                            child: const Text("Today"),
                            onPressed: () {
                              print("Today");
                              model.setEventRequests("1");
                            },
                          ),*/


                          /*RaisedButton(
                            child: const Text("Map v"),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeamUserView()));
                            },
                          ),*/

                        ],
                      ),

                      Expanded(
                        child: Scrollbar(
                          controller: ScrollController(
                            initialScrollOffset: 2,
                            keepScrollOffset: false,
                          ),
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: eventRequests == null
                                  ? 0
                                  : eventRequests.length,
                              itemBuilder: (_, int index) {
                                eventteamrequest = eventRequests[index];
                                return MyEventRequestsListItem(
                                 // eventteam: eventteamrequest,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      //await model.setSuperAdminUserRequests("SuperAdmin");
                      //await model.setUserRequests("All");
                      //await model.setEvenTeamMappings(eventteam?.id);
                    },
                  );
                }
            }
          },
        );
      },
    );
  }
  }

