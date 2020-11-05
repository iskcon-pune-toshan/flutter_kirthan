import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/event_user_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_user_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EventUserPageViewModel eventUserPageVM =
EventUserPageViewModel(apiSvc: EventUserAPIService());

final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());


class EventUserCreate extends StatefulWidget {
  EventUserCreate({this.selectedTeamUsers}) : super();
  List<TeamUser> selectedTeamUsers;

  final String title = "Event User Mapping";
  final String screenName = SCR_EVENT_USER;

  @override
  _EventUserCreateState createState() =>
      _EventUserCreateState(selectedTeamUsers: selectedTeamUsers);
}

class _EventUserCreateState extends State<EventUserCreate> {
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  List<TeamUser> selectedTeamUsers;
  Future<List<EventRequest>> events;

  EventRequest _selectedEvent;
  EventUser eventUser;

  _EventUserCreateState({this.selectedTeamUsers});
  bool sort;

  @override
  void initState() {
    sort = false;
    //events = eventPageVM.getEventRequests("AA");
    events = eventPageVM.getEventRequests("AA");
    super.initState();
    //_selectedTeam =  null;
  }

  onSelectedRow(bool selected, TeamUser teamuser) async {
    setState(() {
      print("selected: ${selected}");
      if (selected) {
        selectedTeamUsers.add(teamuser);
      } else {
        selectedTeamUsers.remove(teamuser);
      }
    });
  }

  FutureBuilder getEventsWidget() {
    return FutureBuilder<List<EventRequest>>(
        future: events,
        builder:
            (BuildContext context, AsyncSnapshot<List<EventRequest>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: const CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Container(
                  //width: 20.0,
                  //height: 10.0,
                  child: Center(
                    child: DropdownButtonFormField<EventRequest>(
                      value: _selectedEvent,
                      icon: const Icon(Icons.supervisor_account),
                      hint: Text('Select Team'),
                      items: snapshot.data
                          .map((event) => DropdownMenuItem<EventRequest>(
                                value: event,
                                child: Text(event.eventTitle),
                              ))
                          .toList(),
                      onChanged: (input) {
                        setState(() {
                          _selectedEvent = input;
                        });
                      },
                    ),
                  ),
                );

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
        });
  }

  Widget rederDataTable() {
    return DataTable(
      sortAscending: sort,
      sortColumnIndex: 0,
      columns: [
        DataColumn(
            label: Text("Team Name",overflow: TextOverflow.ellipsis,),
            //numeric: false,
            onSort: (columnIndex, ascending) {
              setState(() {
                sort = !sort;
                if (ascending) {
                  selectedTeamUsers
                      .sort((a, b) => a.userId.compareTo(b.userId));
                } else {
                  selectedTeamUsers
                      .sort((a, b) => b.userId.compareTo(a.userId));
                }
              });
              //onSortColum(columnIndex, ascending);
            }),
        DataColumn(
          label: Text("User Name",overflow: TextOverflow.ellipsis,),
          numeric: false,
        ),
        DataColumn(
          label: Text("Id"),
          numeric: false,
        ),
      ],
      rows: selectedTeamUsers
          .map(
            (teamuser) => DataRow(
                selected: selectedTeamUsers.contains(teamuser),
                onSelectChanged: (b) {
                  //onSelectedRow(b, teamuser);
                },
                cells: [
                  DataCell(
                    Text(teamuser.teamName.toString(), overflow: TextOverflow.ellipsis,),
                    onTap: () {
                      print('Selected ${teamuser.teamId.toString()}');
                    },
                  ),
                  DataCell(
                    Text(teamuser.userName.toString(),overflow: TextOverflow.ellipsis,),
                  ),
                  DataCell(
                    Text(teamuser.id.toString()),
                  ),
                ]),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          verticalDirection: VerticalDirection.down,
          children: <Widget>[
            getEventsWidget(),
            rederDataTable(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: OutlineButton(
                    child: Text('SELECTED ${selectedTeamUsers.length}'),
                    onPressed: () {
                      List<EventUser> listofEventUsers = new List<EventUser>();
                      for (var teamuser in selectedTeamUsers) {
                        EventUser eventUser = new EventUser();
                        eventUser.userId = teamuser.userId;
                        eventUser.teamId = teamuser.teamId;
                        eventUser.eventId = _selectedEvent.id;
                        eventUser.createdBy = "SYSTEM";
                        String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                            .format(DateTime.now());
                        eventUser.createdTime = dt;
                        eventUser.updatedBy = "SYSTEM";
                        eventUser.updatedTime = dt;
                        listofEventUsers.add(eventUser);
                      }
                      //Map<String,dynamic> teamusermap = teamUser.toJson();
                      print(listofEventUsers);
                      eventUserPageVM.submitNewEventTeamUserMapping(listofEventUsers);
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: OutlineButton(
                    child: Text('DELETE SELECTED'),
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ]),
    );
  }
}
