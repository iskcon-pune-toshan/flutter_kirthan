import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());
final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

class NotificationDetails extends StatefulWidget {
  int eventId;
  int teamId;
  String status;
  @override
  _NotificationDetailsState createState() => _NotificationDetailsState();
  NotificationDetails({@required this.eventId, this.status, this.teamId});
}

class _NotificationDetailsState extends State<NotificationDetails> {
  List<EventRequest> eventRequest;
  List<TeamRequest> teamRequest;
  EventRequest finalEvent;
  TeamRequest finalTeam;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  Future loadData() async {
    await eventPageVM.getEventRequests("All");
    await teamPageVM.getTeamRequests("All");
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      loadData();
    });

    return null;
  }

  @override
  Widget build(BuildContext context) {
    print("Target");
    print(widget.teamId);
    return widget.eventId != null
        ? Consumer<ThemeNotifier>(
            builder: (context, ThemeNotifier notifier, child) {
            return Scaffold(
                appBar: AppBar(
                  title: Text('Event Details'),
                ),
                body: RefreshIndicator(
                  key: refreshKey,
                  child: FutureBuilder<List<EventRequest>>(
                      future: eventPageVM.getEventRequests(widget.status),
                      builder: (_, AsyncSnapshot<List<EventRequest>> snapshot) {
                        if (snapshot.hasData) {
                          eventRequest = snapshot.data;
                          for (var event in eventRequest) {
                            if (event.id == widget.eventId) {
                              finalEvent = event;
                            }
                          }
                          return SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Event Title",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue: finalEvent.eventTitle,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Event Description",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  //enabled: false,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue: finalEvent.eventDescription,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Event Date",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue:
                                      finalEvent.eventDate.split("T")[0],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Event Start Time",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue: finalEvent.eventStartTime,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Event end time",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue: finalEvent.eventEndTime,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue:
                                      finalEvent.phoneNumber.toString(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Address",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),

                                Column(
                                  children: [
                                    TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                      ),
                                      initialValue: finalEvent.addLineOneS,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                      ),
                                      initialValue: finalEvent.addLineTwoS,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                      ),
                                      initialValue: finalEvent.localityS,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Pincode",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue: finalEvent.pincode.toString(),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "City",
                                      style: TextStyle(
                                          fontSize: notifier.custFontSize,
                                          color: KirthanStyles.colorPallete30),
                                    ),
                                  ],
                                ),
                                TextFormField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    disabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                  ),
                                  initialValue: finalEvent.city,
                                ),

                                // : Container(),
                              ],
                            ),
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }),
                  onRefresh: refreshList,
                ));
          })
        : widget.teamId != null
            ? Consumer<ThemeNotifier>(
                builder: (context, ThemeNotifier notifier, child) {
                return Scaffold(
                    appBar: AppBar(
                      title: Text('Team Details'),
                    ),
                    body: RefreshIndicator(
                      key: refreshKey,
                      child: FutureBuilder<List<TeamRequest>>(
                          future: teamPageVM.getTeamRequests(widget.status),
                          builder:
                              (_, AsyncSnapshot<List<TeamRequest>> snapshot) {
                            if (snapshot.hasData) {
                              teamRequest = snapshot.data;
                              for (var team in teamRequest) {
                                if (team.id == widget.teamId) {
                                  finalTeam = team;
                                }
                              }
                              return SingleChildScrollView(
                                physics: BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Team Title",
                                          style: TextStyle(
                                              fontSize: notifier.custFontSize,
                                              color:
                                                  KirthanStyles.colorPallete30),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                      ),
                                      initialValue: finalTeam.teamTitle,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Team Description",
                                          style: TextStyle(
                                              fontSize: notifier.custFontSize,
                                              color:
                                                  KirthanStyles.colorPallete30),
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      //enabled: false,
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        disabledBorder: UnderlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey)),
                                      ),
                                      initialValue: finalTeam.teamDescription,
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Event Date",
                                          style: TextStyle(
                                              fontSize: notifier.custFontSize,
                                              color:
                                                  KirthanStyles.colorPallete30),
                                        ),
                                      ],
                                    ),
                                    // TextFormField(
                                    //   readOnly: true,
                                    //   decoration: InputDecoration(
                                    //     disabledBorder: UnderlineInputBorder(
                                    //         borderSide:
                                    //             BorderSide(color: Colors.grey)),
                                    //   ),
                                    //   initialValue:
                                    //       finalTeam..split("T")[0],
                                    // ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Event Start Time",
                                    //       style: TextStyle(
                                    //           fontSize: notifier.custFontSize,
                                    //           color: KirthanStyles.colorPallete30),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TextFormField(
                                    //   readOnly: true,
                                    //   decoration: InputDecoration(
                                    //     disabledBorder: UnderlineInputBorder(
                                    //         borderSide:
                                    //             BorderSide(color: Colors.grey)),
                                    //   ),
                                    //   initialValue: finalEvent.eventStartTime,
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Event end time",
                                    //       style: TextStyle(
                                    //           fontSize: notifier.custFontSize,
                                    //           color: KirthanStyles.colorPallete30),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TextFormField(
                                    //   readOnly: true,
                                    //   decoration: InputDecoration(
                                    //     disabledBorder: UnderlineInputBorder(
                                    //         borderSide:
                                    //             BorderSide(color: Colors.grey)),
                                    //   ),
                                    //   initialValue: finalEvent.eventEndTime,
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Phone Number",
                                    //       style: TextStyle(
                                    //           fontSize: notifier.custFontSize,
                                    //           color: KirthanStyles.colorPallete30),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TextFormField(
                                    //   readOnly: true,
                                    //   decoration: InputDecoration(
                                    //     disabledBorder: UnderlineInputBorder(
                                    //         borderSide:
                                    //             BorderSide(color: Colors.grey)),
                                    //   ),
                                    //   initialValue:
                                    //       finalEvent.phoneNumber.toString(),
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Address",
                                    //       style: TextStyle(
                                    //           fontSize: notifier.custFontSize,
                                    //           color: KirthanStyles.colorPallete30),
                                    //     ),
                                    //   ],
                                    // ),
                                    //
                                    // Column(
                                    //   children: [
                                    //     TextFormField(
                                    //       readOnly: true,
                                    //       decoration: InputDecoration(
                                    //         disabledBorder: UnderlineInputBorder(
                                    //             borderSide:
                                    //                 BorderSide(color: Colors.grey)),
                                    //       ),
                                    //       initialValue: finalEvent.addLineOneS,
                                    //     ),
                                    //     TextFormField(
                                    //       readOnly: true,
                                    //       decoration: InputDecoration(
                                    //         disabledBorder: UnderlineInputBorder(
                                    //             borderSide:
                                    //                 BorderSide(color: Colors.grey)),
                                    //       ),
                                    //       initialValue: finalEvent.addLineTwoS,
                                    //     ),
                                    //     TextFormField(
                                    //       readOnly: true,
                                    //       decoration: InputDecoration(
                                    //         disabledBorder: UnderlineInputBorder(
                                    //             borderSide:
                                    //                 BorderSide(color: Colors.grey)),
                                    //       ),
                                    //       initialValue: finalEvent.localityS,
                                    //     ),
                                    //   ],
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "Pincode",
                                    //       style: TextStyle(
                                    //           fontSize: notifier.custFontSize,
                                    //           color: KirthanStyles.colorPallete30),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TextFormField(
                                    //   readOnly: true,
                                    //   decoration: InputDecoration(
                                    //     disabledBorder: UnderlineInputBorder(
                                    //         borderSide:
                                    //             BorderSide(color: Colors.grey)),
                                    //   ),
                                    //   initialValue: finalEvent.pincode.toString(),
                                    // ),
                                    // SizedBox(
                                    //   height: 20,
                                    // ),
                                    // Row(
                                    //   children: [
                                    //     Text(
                                    //       "City",
                                    //       style: TextStyle(
                                    //           fontSize: notifier.custFontSize,
                                    //           color: KirthanStyles.colorPallete30),
                                    //     ),
                                    //   ],
                                    // ),
                                    // TextFormField(
                                    //   readOnly: true,
                                    //   decoration: InputDecoration(
                                    //     disabledBorder: UnderlineInputBorder(
                                    //         borderSide:
                                    //             BorderSide(color: Colors.grey)),
                                    //   ),
                                    //   initialValue: finalEvent.city,
                                    // ),

                                    // : Container(),
                                  ],
                                ),
                              );
                            }
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }),
                      onRefresh: refreshList,
                    ));
              })
            : Container();
  }
}
