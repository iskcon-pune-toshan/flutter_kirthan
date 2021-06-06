import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map.dart';
import 'package:flutter_kirthan/views/widgets/event/event_list_item.dart';
import 'package:provider/provider.dart';

class EventsPanel extends StatelessWidget {
  String eventType;
  EventRequest eventRequest;

  final String screenName = "Event";

  EventsPanel({@required this.eventType, @required this.eventRequest});
  @override
  Widget build(BuildContext context) {
    String dropdownValue = eventRequest?.city;
    return FutureBuilder<List<EventRequest>>(
      future: eventPageVM.getEventRequests("All"),
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

                      /* RaisedButton(
                            color: KirthanStyles.colorPallete30,
                            child: const Text(
                              "Event-User Add",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => TeamUserView()));
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
                      /*RaisedButton(
                            //child: const Text("This Week"),
                            color: KirthanStyles.colorPallete30,
                            child: const Text(
                              "Event-User View",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EventUserView()));
                            },
                          ),*/
                    ],
                  ),
                  SizedBox(
                    height: 3,
                  ),
                  new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Container(
                        height: 110,
                        decoration: new BoxDecoration(
                          image: new DecorationImage(
                            image: new AssetImage('assets/images/map.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: FlatButton(
                          //child: const Text("This Week"),
                          child: Center(
                            child: Consumer<ThemeNotifier>(
                                builder: (context, notifier, child) => Text(
                                  'Map',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: notifier.custFontSize),
                                )),
                          ),

                          // child: const Text("Map"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MapPage(eventrequest: eventRequest)));
                            /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (BuildContext context) =>
                                          MapsBloc(),
                                      child: Maps(),
                                    ),
                                  ),
                                );*/
                          },
                          //child: Image.asset("assets/images/map.jpg")
                        ),
                      ),
                      //          ),
                    ],
                  ),
                  Expanded(
                    child: Scrollbar(
                      controller: ScrollController(
                        initialScrollOffset: 2,
                        keepScrollOffset: false,
                      ),
                      child: Container(
                        //TODO
                        color: Colors.black12,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                          eventRequests == null ? 0 : eventRequests.length,
                          itemBuilder: (_, int index) {
                            //TODO:sorting of events according to date
                            eventRequests.sort(
                                    (a, b) => a.eventDate.compareTo(b.eventDate));
                            var eventrequest = eventRequests[index];
                            return EventRequestsListItem(
                              eventrequest: eventrequest,
                              eventPageVM: eventPageVM,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else if (snapshot.hasError) {
              print("error");
              print(snapshot.error);
//TODO
              return Center(
                child: CircularProgressIndicator(),
              );

              //   NoInternetConnection(
              //   action: () async {
              //     //await model.setSuperAdminUserRequests("SuperAdmin");
              //     //await model.setUserRequests("All");
              //     await eventPageVM.setEventRequests("All");
              //   },
              // );
            }
        }
      },
    );
  }
}
