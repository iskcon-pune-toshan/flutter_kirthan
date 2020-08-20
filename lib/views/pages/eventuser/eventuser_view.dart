import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/services/event_user_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_user_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EventUserPageViewModel eventUserPageVM =
EventUserPageViewModel(apiSvc: EventUserAPIService());


class EventUserView extends StatefulWidget {
  final String title = "Event User Mapping View";
  final String screenName = SCR_EVENT_USER;

  @override
  _EventUserViewState createState() => _EventUserViewState();
}

class _EventUserViewState extends State<EventUserView> {
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  Future<List<EventUser>> eventusers;

  List<EventUser> listofeventusers = new List<EventUser>();
  List<EventUser> selectedEventUsers = new List<EventUser>();
  Map<String, bool> usercehckmap = new Map<String, bool>();

  /*Map<String, bool> usercehckmap = {
    '1TU1': false,
    '1TU2': false,
    '1TU5': false,
    '2TU2': false,
    '3TU2': false,
    '4TU1': false,
    '4TU2': false,
    '4TU4': false,
    '4TU5': false,
    '5TU1': false,
    '5TU2': false,
    '5TU3': false,
    '6TU1': false,
    '6TU2': false,
    '6TU4': false,
    '6TU5': false,
  };
*/
  /*= [
    TeamUser(
        id: 1,
        teamId: 1,
        userId: 1,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 2,
        teamId: 1,
        userId: 2,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 3,
        teamId: 1,
        userId: 3,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 4,
        teamId: 2,
        userId: 1,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 5,
        teamId: 2,
        userId: 2,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 6,
        teamId: 2,
        userId: 3,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
    TeamUser(
        id: 7,
        teamId: 2,
        userId: 4,
        createdBy: "SYSTEM",
        createTime: "2020-04-19T15:41:04.783",
        updatedBy: "SYSTEM",
        updateTime: "2020-04-19T15:41:04.783"),
  ];
*/
  @override
  void initState() {
    eventusers = eventUserPageVM.getEventTeamUserMappings("SA");
    eventusers.then((neweventusers) {
      neweventusers.forEach((eventuser) => usercehckmap[
              eventuser.eventId.toString() +
                  "E" +
                  eventuser.teamId.toString() +
                  "TU" +
                  eventuser.userId.toString()] = false
          //usercehckmap.putIfAbsent(, () => )
          );
      /*listofteamusers.addAll(teamusers);
      print(teamusers.length);
      print("Vardhan: ");
      print(listofteamusers.length);
      print("Geetha: ");
      //listofteamusers.

       */
    });

    //listofteamusers.forEach((myteamuser) => print(myteamuser.teamId.toString()+"Manju:"+myteamuser.userId.toString()));
    //print("Manjunath: 1:  ${listofteamusers.length.toString()}");
    //listofteamusers.forEach((myteamuser) => print("Manju:"));
    //print("Manju: 2");
    super.initState();
    //usercehckmap = new Map<String,bool>();
  }

  List<Widget> populateChildren(String eventname) {
    List<Widget> children = new List<Widget>();
    List<EventUser> listofusers =
        listofeventusers.where((user) => user.eventName == eventname).toList();
    for (var user in listofusers) {
      //print(user.teamId.toString()+"TU"+user.userId.toString());
      children.add(Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Checkbox(
            value: usercehckmap[(user.eventId.toString() +
                    "E" +
                    user.teamId.toString() +
                    "TU" +
                    user.userId.toString())
                .toString()],
            onChanged: (input) {
              setState(() {
                usercehckmap[user.eventId.toString() +
                    "E" +
                    user.teamId.toString() +
                    "TU" +
                    user.userId.toString()] = input;
                if (input == true)
                  selectedEventUsers.add(user);
                else
                  selectedEventUsers.remove(user);
                //print(input);
              });
            },
          ),
          Text(user.userName.toString() + " [from] " + user.teamName.toString()),
        ],
      ));
    }
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        verticalDirection: VerticalDirection.down,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          ScrollConfiguration(
            behavior: ScrollBehavior(),
            child: Expanded(
              child: Scrollbar(
                //scrollDirection: Axis.vertical,
                //padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: FutureBuilder<List<EventUser>>(
                    future: eventusers,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<EventUser>> snapshot) {
                      switch (snapshot.connectionState) {
                        // ignore: missing_return
                        case ConnectionState.none:
                        case ConnectionState.active:
                        case ConnectionState.waiting:
                          return Center(
                              child: const CircularProgressIndicator());
                        case ConnectionState.done:
                          if (snapshot.hasData) {
                            listofeventusers = snapshot.data;
                            listofeventusers
                                .sort((a, b) => b.eventId.compareTo(a.eventId));
                            List<String> setofEvents = listofeventusers
                                .map((user) => user.eventName)
                                .toSet()
                                .toList();
                            //setofTeams.reversed;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: setofEvents.length,
                                itemBuilder: (context, index) {
                                  return ExpansionTile(
                                    title: Text(
                                        "Event Name: ${setofEvents[index]}"),
                                    subtitle: Text("Hello Manjunath"),
                                    children:
                                        populateChildren(setofEvents[index]),
                                  );
                                });
                          } else {
                            return Container(
                              width: 20.0,
                              height: 10.0,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                      }
                    }),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('SELECTED ${selectedEventUsers.length}'),
                  onPressed: () {
                    /*List<TeamUser> listofTeamUsers = new List<TeamUser>();
                    for (var user in selectedlistofteamusers) {
                      TeamUser teamUser = new TeamUser();
                      teamUser.userId = user.id;
                      //print(user.id);
                      teamUser.teamId = _selectedTeam.id;
                      teamUser.createdBy = "SYSTEM";
                      String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                          .format(DateTime.now());
                      teamUser.createTime = dt;
                      teamUser.updatedBy = "SYSTEM";
                      teamUser.updateTime = dt;
                      listofTeamUsers.add(teamUser);
                    }
                    //Map<String,dynamic> teamusermap = teamUser.toJson();
                    print(listofTeamUsers);
                    apiSvc?.submitNewTeamUserMapping(listofTeamUsers);
                    */
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('DELETE SELECTED ${selectedEventUsers.length}'),
                  onPressed: () {
                    print(selectedEventUsers);
                    eventUserPageVM.submitDeleteEventTeamUserMapping(selectedEventUsers);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
