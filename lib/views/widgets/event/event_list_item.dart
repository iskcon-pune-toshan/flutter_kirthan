import 'package:flutter/material.dart';
//import 'package:flutter_kirthan/location/home.dart';
import 'package:flutter_kirthan/models/event.dart';

import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_kirthan/views/pages/event/event_location.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'int_item.dart';

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

  String get index => null;

  @override
  Widget build(BuildContext context) {
    var title =
    Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
      Text(
        eventrequest?.eventTitle,
        style: TextStyle(
          color: KirthanStyles.titleColor,
          fontWeight: FontWeight.bold,
          fontSize: MyPrefSettingsApp.custFontSize,
        ),
      ),
      Expanded(
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
            Widget>[
          Container(
            child: Align(
              alignment: Alignment.bottomCenter,
              //alignment: Alignment.topRight,
              child: PopupMenuButton<Choice>(
                tooltip: null,
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
                    processrequestmap["approvalComments"] = "ApprovalComments";
                    processrequestmap["eventType"] = eventrequest?.eventType;
                    processrequestmap["addLineOne"] = eventrequest?.addLineOne;
                    processrequestmap["city"] = eventrequest?.city;
                    processrequestmap["country"] = eventrequest?.country;
                    processrequestmap["phoneNumber"] =
                        eventrequest?.phoneNumber;
                    processrequestmap["pincode"] = eventrequest?.pincode;
                    processrequestmap["eventTitle"] = eventrequest?.eventTitle;
                    processrequestmap["eventDescription"] =
                        eventrequest?.eventDescription;
                    processrequestmap["eventDate"] = eventrequest?.eventDate;
                    processrequestmap["eventDuration"] =
                        eventrequest?.eventDuration;
                    processrequestmap["eventLocation"] =
                        eventrequest?.eventLocation;
                    processrequestmap["locality"] = eventrequest?.locality;
                    processrequestmap["state"] = eventrequest?.state;
                    processrequestmap["isProcessed"] =
                        eventrequest?.isProcessed;
                    processrequestmap["createdBy"] = eventrequest?.createdBy;
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextField(
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Do you want to delete?'),
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
                                            duration: new Duration(seconds: 4),
                                            backgroundColor: Colors.red,
                                          );
                                          Scaffold.of(context)
                                              .showSnackBar(mysnackbar);
                                        },
                                        child: Text(
                                          "yes",
                                          style: TextStyle(
                                              fontSize: MyPrefSettingsApp
                                                  .custFontSize,
                                              color: Colors.white),
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
                                        child: Text(
                                          "No",
                                          style: TextStyle(
                                              fontSize: MyPrefSettingsApp
                                                  .custFontSize,
                                              color: Colors.white),
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
          ),
          Consumer<int_item>(
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
          )
        ]),
      ),
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
          child: Text(
            eventrequest?.eventDescription,
            style: TextStyle(
              color: KirthanStyles.subTitleColor,
              fontSize: MyPrefSettingsApp.custFontSize,
            ),
          ),
        ),
/*        Container(
          child: PopupMenuButton<Choice>(
            tooltip: null,
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
                processrequestmap["approvalComments"] = "ApprovalComments";
                processrequestmap["eventType"] = eventrequest?.eventType;
                processrequestmap["addLineOne"] = eventrequest?.addLineOne;
                processrequestmap["city"] = eventrequest?.city;
                processrequestmap["country"] = eventrequest?.country;
                processrequestmap["phoneNumber"] = eventrequest?.phoneNumber;
                processrequestmap["pincode"] = eventrequest?.pincode;
                processrequestmap["eventTitle"] = eventrequest?.eventTitle;
                processrequestmap["eventDescription"] =
                    eventrequest?.eventDescription;
                processrequestmap["eventDate"] = eventrequest?.eventDate;
                processrequestmap["eventDuration"] =
                    eventrequest?.eventDuration;
                processrequestmap["eventLocation"] =
                    eventrequest?.eventLocation;
                processrequestmap["locality"] = eventrequest?.locality;
                processrequestmap["state"] = eventrequest?.state;
                processrequestmap["isProcessed"] = eventrequest?.isProcessed;
                processrequestmap["createdBy"] = eventrequest?.createdBy;
                processrequestmap["createdTime"] = eventrequest?.createdTime;

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
                            borderRadius:
                                BorderRadius.circular(20.0)), //this right here
                        child: Container(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextField(
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Do you want to delete?'),
                                ),
                                SizedBox(
                                  width: 320.0,
                                  child: RaisedButton(
                                    onPressed: () {
                                      Map<String, dynamic> processrequestmap =
                                          new Map<String, dynamic>();
                                      processrequestmap["id"] =
                                          eventrequest?.id;
                                      eventPageVM.deleteEventRequest(
                                          processrequestmap);
                                      SnackBar mysnackbar = SnackBar(
                                        content: Text("Event $delete "),
                                        duration: new Duration(seconds: 4),
                                        backgroundColor: Colors.red,
                                      );
                                      Scaffold.of(context)
                                          .showSnackBar(mysnackbar);
                                    },
                                    child: Text(
                                      "yes",
                                      style: TextStyle(
                                          fontSize:
                                              MyPrefSettingsApp.custFontSize,
                                          color: Colors.white),
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
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          fontSize:
                                              MyPrefSettingsApp.custFontSize,
                                          color: Colors.white),
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
        ),*/
      ],
    );

    /*return Card(
      elevation: 10,
      child: Container(
        decoration: new BoxDecoration(
            borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
            gradient: new LinearGradient(
                colors: [Colors.blue[200], Colors.purpleAccent],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                tileMode: TileMode.clamp)),
        child: new Column(
          children: <Widget>[
            new ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              leading: Icon(Icons.event),
              title: title,
              subtitle: subTitle,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text("Date:",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: MyPrefSettingsApp.custFontSize,
                    )),
                Text("Duration:",
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: MyPrefSettingsApp.custFontSize,
                    )),
                Text("Location: "+eventrequest.city,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.bold,
                      fontSize: MyPrefSettingsApp.custFontSize,
                    )),
              ],
            ),

            // Divider(color: Colors.lightBlue),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                //Text("Date:"),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    eventrequest?.eventDate.substring(0,10),
                    //0,10 date
                    //11,16 time

                    style: TextStyle(
                      fontSize: MyPrefSettingsApp.custFontSize,
                      //    color: KirthanStyles.subTitleColor,
                    ),
                  ),
                ),
                //Text("Duration:"),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    eventrequest?.eventDuration,
                    style: TextStyle(
                      fontSize: MyPrefSettingsApp.custFontSize,
                      //    color: KirthanStyles.subTitleColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),

                  child: IconButton(icon: Icon(Icons.location_on),
                    onPressed:  () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Location (eventrequest: eventrequest)),
                        //MapView(eventrequest: eventrequest)),

                        //do something
                      )
                    },),
                ),

              ],
            ),
            //Divider(color: Colors.blue),
          ],
        ),
      ),
    );*/
    return Card(
        elevation: 10,
        child: Container(
          decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(new Radius.circular(10.0)),
              gradient: new LinearGradient(
                  colors: [Colors.blue[100], Colors.blue],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp)),
          child: new Column(children: <Widget>[
            new ListTile(
              // contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
              //leading: Icon(Icons.event),
              title: title,
              subtitle: subTitle,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text("Date:",
                      style: GoogleFonts.openSans(
                        color: KirthanStyles.titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MyPrefSettingsApp.custFontSize,
                      )),
                  Text("Time:",
                      style: GoogleFonts.openSans(
                        color: KirthanStyles.titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MyPrefSettingsApp.custFontSize,
                      )),
                  Text("Duration: ",
                      style: GoogleFonts.openSans(
                        color: KirthanStyles.titleColor,
                        fontWeight: FontWeight.bold,
                        fontSize: MyPrefSettingsApp.custFontSize,
                      )),
                ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                //Text("Date:"),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    eventrequest?.eventDate.substring(0, 10),
                    //0,10 date
                    //11,16 time

                    style: TextStyle(
                      fontSize: MyPrefSettingsApp.custFontSize,

                      //    color: KirthanStyles.subTitleColor,
                    ),
                  ),
                ),
                //Text("Duration:"),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    eventrequest?.eventDate.substring(11, 16),
                    style: TextStyle(
                      fontSize: MyPrefSettingsApp.custFontSize,
                      //    color: KirthanStyles.subTitleColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    eventrequest?.eventDuration + "Hrs",
                    style: TextStyle(
                      fontSize: MyPrefSettingsApp.custFontSize,
                      //    color: KirthanStyles.subTitleColor,
                    ),
                  ),
                ),
                /* Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20.0),

                      child: IconButton(icon: Icon(Icons.location_on),
                        onPressed:  () => {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Location (eventrequest: eventrequest)),
                            //MapView(eventrequest: eventrequest)),

                            //do something
                          )
                        },),
                    ),*/
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                //Text("Date:"),
                /* Text("Location:",
                    style: GoogleFonts.openSans(
                      color: KirthanStyles.titleColor,
                      fontWeight: FontWeight.bold,
                      fontSize: MyPrefSettingsApp.custFontSize,
                    )),*/

                FlatButton(
                  child: Text(
                    "Location",
                    style: TextStyle(color: KirthanStyles.subTitleColor),
                  ),
                  //color: KirthanStyles.subTitleColor,

                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Location(eventrequest: eventrequest)),
                      //MapView(eventrequest: eventrequest)),

                      //do something
                    );
                  },
                  splashColor: Colors.red,
                  //shape: Border.all(width: 2.0, color: Colors.black)
                ),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Icon(
                    Icons.location_on,
                    color: KirthanStyles.subTitleColor,
                  ), /*Icon(icon: Icon(Icons.location_on),

                   */ /* onPressed:  () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Location (eventrequest: eventrequest)),
                        //MapView(eventrequest: eventrequest)),

                        //do something
                      )
                    },*/ /*),*/
                ),
              ],
            ),
          ]),
        ));
  }
}
