import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_location.dart';
import 'package:flutter_kirthan/views/widgets/myevent/myeventdetails.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Choice {
  const Choice({this.id, this.description});

  final int id;
  final String description;
}

class MyEventRequestsListItem extends StatelessWidget {
  final EventRequest eventrequest;
  final EventPageViewModel eventPageVM;
  //final EventTeam eventteam;
  bool _isFavorited = false;
  MyEventRequestsListItem({@required this.eventrequest, this.eventPageVM});

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
    if (two.difference(one).toString().substring(0, 2).contains(":"))
      return two.difference(one).toString().substring(0, 1);
    else
      return two.difference(one).toString().substring(0, 2);
  }

  String get index => null;
  // var filteredMap;
  // List<EventRequest> filtereMap = eventrequest
  //     .where((x) => x.eventDuration.contains(notifier.duration))
  //     .toList();
  Color getcolor() {
    if (eventrequest?.teamInviteStatus == 2)
      return Colors.green;
    else if (eventrequest?.teamInviteStatus == 1)
      return Colors.blue;
    else if (eventrequest?.teamInviteStatus == 0)
      return Colors.red;
    else
      Colors.red;
  }

  Text getstatus() {
    if (eventrequest?.teamInviteStatus == 1)
      return Text(
        'Processing',
        style: TextStyle(
          color: getcolor(),
          fontSize: 16,
        ),
        textAlign: TextAlign.end,
      );
    else if (eventrequest?.teamInviteStatus == 2)
      return Text(
        'Approved',
        style: TextStyle(
          color: getcolor(),
          fontSize: 16,
        ),
        textAlign: TextAlign.end,
      );
    else if (eventrequest?.teamInviteStatus == 0)
      return Text(
        'Not Initiated',
        style: TextStyle(
          color: getcolor(),
          fontSize: 16,
        ),
        textAlign: TextAlign.end,
      );
    else
      return Text(
        'Cancelled',
        style: TextStyle(
          color: getcolor(),
          fontSize: 16,
        ),
        textAlign: TextAlign.end,
      );
  }

  @override
  Widget build(BuildContext context) {
    var title = Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Container(
              width: notifier.custFontSize >= 20
                  ? MediaQuery.of(context).size.width * 1.2
                  : MediaQuery.of(context).size.width,
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Container(
                            padding: EdgeInsets.only(left: 8),
                            child: Text(
                              eventrequest?.eventTitle,
                              style: TextStyle(
                                //color: KirthanStyles.titleColor,
                                fontWeight: FontWeight.bold,
                                fontSize: notifier.custFontSize,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 15),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                padding: EdgeInsets.all(0),
                                child: Row(
                                  children: [
                                    Text(
                                      "Location",
                                      style: TextStyle(
                                        color: KirthanStyles.colorPallete60,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(0),
                                      child: Icon(
                                        Icons.location_on,
                                        color: KirthanStyles.colorPallete60,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
//color: KirthanStyles.subTitleColor,

                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Location(
                                            eventrequest: eventrequest)),
//MapView(eventrequest: eventrequest)),

//do something
                                  );
                                },
                                //splashColor: Colors.red,
                                color: KirthanStyles.colorPallete30,
//shape: Border.all(width: 2.0, color: Colors.black)
                              ),
                              IconButton(
                                icon: Icon(Icons.keyboard_arrow_right),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EventDetails(eventrequest: eventrequest)),
//MapView(eventrequest: eventrequest)),

//do something
                                  );

                                },
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
                      ),
                    ),
                  ]),
            ));
    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        /*Icon(
        Icons.movie,
        color: KirthanStyles.subTitleColor,
        size: KirthanStyles.subTitleFontSize,
      ),
      */
        Container(
          //margin: const EdgeInsets.only(left: 4.0),
          margin: const EdgeInsets.only(left: 10.0),
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
        Expanded(
          child: Container(
            padding: EdgeInsets.only(right: 33),
            alignment: Alignment.centerRight,
            //margin: const EdgeInsets.only(left: 4.0),

            child: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => getstatus(),
              /*Text(

           // eventrequest?.approvalStatus,

            style: TextStyle(
              color: getcolor(),
              fontSize: notifier.custFontSize,
            ),
            textAlign: TextAlign.end,
          ),*/
            ),
          ),
        ),
      ],
    );

    return new GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EventDetails(eventrequest: eventrequest)),
//MapView(eventrequest: eventrequest)),

//do something
          );
         // print("Clicked on Card");
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: new Card(
            elevation: 8,
            child: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => Container(
                decoration: new BoxDecoration(
                  borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
                  color: notifier.currentColorStatus
                      ? notifier.currentColor
                      : Theme.of(context).cardColor,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: new Column(children: <Widget>[
// contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
//leading: Icon(Icons.event),
                    title,
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          subTitle,
                        ],
                      ),
                    ),
                    Divider(),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                        width: notifier.custFontSize >= 20
                            ? MediaQuery.of(context).size.width * 1.4
                            : MediaQuery.of(context).size.width,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40.0),
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
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          ),
        ));
  }
}
