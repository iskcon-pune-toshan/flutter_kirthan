import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_team_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/myevent/myevent_list_item.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:scoped_model/scoped_model.dart';

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
                  print("INSIDE SNAPSHOT");
                  var eventRequests = snapshot.data;
                  return eventRequests.isNotEmpty
                      ? new Column(
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
                          child: Container(
                            color: Colors.black12,
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
                  )
                  //TODO:added no event created
                      : Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "No events created",
                      style: TextStyle(fontSize: 20),
                    ),
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
                return Container();
            }
          },
        );
      },
    );
  }

  Widget eventTeam(var eventteamrequest) {
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
                            )),
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
            return null;
          },
        );
      },
    );
  }
}
