import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_location.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/event/event_team_user_register.dart';


class Choice {
  const Choice({this.id, this.description});

  final int id;
  final String description;
}

class EventRequestsListItem extends StatelessWidget {
  final EventRequest eventrequest;
  final EventPageViewModel eventPageVM;
  bool _isFavorited = false;
  EventRequestsListItem({@required this.eventrequest, this.eventPageVM});

  List<Choice> popupList = [
    Choice(id: 1, description: "Process"),
    Choice(id: 2, description: "Edit"),
    Choice(id: 3, description: "Delete"),
    //Choice(id: 4, description: "Location"),
  ];
  String duration() {
    var format = DateFormat("HH:mm");
    var one = format.parse(eventrequest.eventStartTime);
    var two = format.parse(eventrequest.eventEndTime);
    if(two.difference(one).toString().substring(0,2).contains(":"))
    return two.difference(one).toString().substring(0,1);
    else
      return two.difference(one).toString().substring(0,2);
  }
  String get index => null;

  @override
  Widget build(BuildContext context) {
    var title = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Consumer<ThemeNotifier>(
                builder: (context, notifier, child) => Text(
                  eventrequest?.eventTitle,
                  style: TextStyle(
                    //color: KirthanStyles.titleColor,
                    fontWeight: FontWeight.bold,
                    fontSize: notifier.custFontSize,
                  ),
                ),
              ),
            ],
          ),
          Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            EventTeamUserRegister(eventrequest: eventrequest),
            SizedBox(width: 5),
            FlatButton(
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(15.0),
              // ),
              highlightColor: Colors.grey,
              padding: EdgeInsets.all(0),
              //color: Colors.black,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(0),
                    child: Icon(
                      Icons.location_on_sharp,
                      color: KirthanStyles.colorPallete30,
                      size: 20,
                    ),
                  ),
                  Text(
                    "Location",
                    style: TextStyle(
                      color: KirthanStyles.colorPallete30,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Location(eventrequest: eventrequest)),
                );
              },
              //splashColor: Colors.red,
//shape: Border.all(width: 2.0, color: Colors.black)
            ),
/*              Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  //alignment: Alignment.topRight,
                  child: PopupMenuButton<Choice>(
                    tooltip: null,
                    icon: Icon(
                      Icons.more_vert,
                      color: KirthanStyles.colorPallete30,
                    ),
                    itemBuilder: (BuildContext context) {
                      return popupList.map((f) {
                        return PopupMenuItem<Choice>(
                          child: Text(f.description),
                          value: f,
                        );
                      }).toList();
                    },
                    onSelected: (choice) {
                      if (choice.id == 2) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditEvent(eventrequest: eventrequest)),
                        );
                      } else if (choice.id == 1) {
                        Map<String, dynamic> processrequestmap =
                            new Map<String, dynamic>();
                        processrequestmap["id"] = eventrequest?.id;
                        processrequestmap["approvalStatus"] = "Approved";
                        processrequestmap["approvalComments"] =
                            "ApprovalComments";
                        processrequestmap["eventType"] =
                            eventrequest?.eventType;
                        processrequestmap["addLineOne"] =
                            eventrequest?.addLineOne;
                        processrequestmap["city"] = eventrequest?.city;
                        processrequestmap["country"] = eventrequest?.country;
                        processrequestmap["phoneNumber"] =
                            eventrequest?.phoneNumber;
                        processrequestmap["pincode"] = eventrequest?.pincode;
                        processrequestmap["eventTitle"] =
                            eventrequest?.eventTitle;
                        processrequestmap["eventDescription"] =
                            eventrequest?.eventDescription;
                        processrequestmap["eventDate"] =
                            eventrequest?.eventDate;
                        processrequestmap["eventDuration"] =
                            eventrequest?.eventDuration;
                        processrequestmap["eventLocation"] =
                            eventrequest?.eventLocation;
                        processrequestmap["locality"] = eventrequest?.locality;
                        processrequestmap["state"] = eventrequest?.state;
                        processrequestmap["isProcessed"] =
                            eventrequest?.isProcessed;
                        processrequestmap["createdBy"] =
                            eventrequest?.createdBy;
                        processrequestmap["createdTime"] =
                            eventrequest?.createdTime;

                        eventPageVM.processEventRequest(processrequestmap);
                        SnackBar mysnackbar = SnackBar(
                          content: Text("Event $process $successful "),
                          duration: new Duration(seconds: 4),
                          backgroundColor: Colors.green,
                        );
                        Scaffold.of(context).showSnackBar(mysnackbar);
                      } else if (choice.id == 3) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20.0)), //this right here
                                child: Container(
                                  height: 200,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextField(
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  'Do you want to delete?'),
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: RaisedButton(
                                            onPressed: () {
                                              Map<String, dynamic>
                                                  processrequestmap =
                                                  new Map<String, dynamic>();
                                              processrequestmap["id"] =
                                                  eventrequest?.id;
                                              eventPageVM.deleteEventRequest(
                                                  processrequestmap);
                                              SnackBar mysnackbar = SnackBar(
                                                content: Text("Event $delete "),
                                                duration:
                                                    new Duration(seconds: 4),
                                                backgroundColor: Colors.red,
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(mysnackbar);
                                            },
                                            child: Consumer<ThemeNotifier>(
                                              builder:
                                                  (context, notifier, child) =>
                                                      Text(
                                                "yes",
                                                style: TextStyle(
                                                    fontSize:
                                                        notifier.custFontSize,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 320.0,
                                          child: RaisedButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Consumer<ThemeNotifier>(
                                              builder:
                                                  (context, notifier, child) =>
                                                      Text(
                                                "No",
                                                style: TextStyle(
                                                    fontSize:
                                                        notifier.custFontSize,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            color: const Color(0xFF1BC0C5),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                      }
                    },
                  ),
                ),
              ),*/

/*    Consumer<int_item>(
    builder: (context, int_item, child) => IconButton(
    icon: (_isFavorited ? Icon(Icons.star) : Icon(Icons.star_border)),
    color: Colors.yellow[600],
    onPressed: () {
    if (_isFavorited == true) {
    _isFavorited = false;
    int_item.removeitem("Event:" +
    "--" +
    eventrequest.eventTitle +
    "\n"
    "Description:" +
    "--" +
    eventrequest.eventDescription +
    "\n" +
    "Event Duration:" +
    "--" +
    eventrequest.eventDuration +
    " hrs" +
    "\n" +
    "Event Date:" +
    "--" +
    eventrequest.eventDate.substring(0, 10)
    +
    "\n" +
    "Event Time:" +
    "--" +
    eventrequest.eventDate.substring(11, 16));
    } else {
    _isFavorited = true;
    int_item.addtoitem("Event:" +
    "--" +
    eventrequest.eventTitle +
    "\n"
    "Description:" +
    "--" +
    eventrequest.eventDescription +
    "\n" +
    "Event Duration:" +
    "--" +
    eventrequest.eventDuration +
    " hrs" +
    "\n" +
    "Event Date:" +
    "--" +
    eventrequest.eventDate.substring(0, 10) +
    "\n" +
    "Event Time:" +
    "--" +
    eventrequest.eventDate.substring(11, 16));
    }
    print(int_item.itemlist);
    },
    ),
    )*/
          ]),
        ]);
    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        /*Icon(
          Icons.movie,
          color: KirthanStyles.subTitleColor,
          size: KirthanStyles.subTitleFontSize,
        ),
        */
        Container(
          //margin: const EdgeInsets.only(left: 4.0),
          child: Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Text(
              eventrequest?.eventDescription,
              style: TextStyle(
                // color: KirthanStyles.subTitleColor,
                fontSize: notifier.custFontSize,
              ),
            ),
          ),
        ),
      ],
    );
    var daysToGo = Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
        padding: EdgeInsets.only(bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 20.0),

        //margin: const EdgeInsets.only(left: 4.0),
        child: Consumer<ThemeNotifier>(builder: (context, notifier, child) {
          final eventDate = eventrequest.eventDate;
          DateTime EventDate = DateTime.parse(eventDate);
          DateTime dateTimeNow = DateTime.now();
          int daysRemaining = EventDate.difference(dateTimeNow).inDays;
          if (daysRemaining >= 0) {
            return Text(
              daysRemaining.toString() + ' days to go',
              style: TextStyle(
                  // color: KirthanStyles.subTitleColor,
                  fontSize: notifier.custFontSize,
                  color: Colors.green[700]),
            );
          } else if (daysRemaining < 0) {
            return Text(
              'Event ended',
              //daysRemaining.abs().toString() + ' days ago',
              style: TextStyle(
                  // color: KirthanStyles.subTitleColor,
                  fontSize: notifier.custFontSize,
                  color: Colors.red[700]),
            );
          } else {
            return Container();
          }
        }),
      )
    ]);
    return new Card(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Container(
          decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            color: notifier.currentColorStatus
                ? notifier.currentColor
                : Theme.of(context).cardColor,
            /*gradient: new LinearGradient(
                colors: [Colors.white, Colors.white],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp),*/
          ),
          child: new Column(children: <Widget>[
            new ListTile(
// contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
//leading: Icon(Icons.event),
              title: title,
              subtitle: subTitle,
            ),
            Divider(),
            Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: [
                            Text(
                              "Date",
                              style: GoogleFonts.openSans(
                                //color: KirthanStyles.titleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: notifier.custFontSize,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15.0),
                              child: Text(
                                eventrequest?.eventDate.substring(0, 10),
//0,10 date
//11,16 time

                                style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                  //color: KirthanStyles.subTitleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Time",
                              style: GoogleFonts.openSans(
                                //color: KirthanStyles.titleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: notifier.custFontSize,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                eventrequest?.eventStartTime,
                                style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                  //color: KirthanStyles.subTitleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              "Duration ",
                              style: GoogleFonts.openSans(
                                //color: KirthanStyles.titleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: notifier.custFontSize,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(bottom: 15),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Text(
                                //notifier.duration
                                duration() == notifier.duration
                                    ? duration() + " Hrs"
                                    : duration() + " Hrs",
                                style: TextStyle(
                                  fontSize: notifier.custFontSize,
                                  // color: KirthanStyles.subTitleColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                  daysToGo,
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
