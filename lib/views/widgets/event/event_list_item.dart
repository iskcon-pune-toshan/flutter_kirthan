import 'dart:async';
import 'dart:math';

import 'package:flip_card/flip_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_location.dart';
import 'package:flutter_kirthan/views/pages/event/event_team_user_register.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart' as geolocation;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Choice {
  const Choice({this.id, this.description});

  final int id;
  final String description;
}

class EventRequestsListItem extends StatefulWidget {
  final EventRequest eventrequest;
  final EventPageViewModel eventPageVM;

  EventRequestsListItem({@required this.eventrequest, this.eventPageVM});

  @override
  _EventRequestsListItemState createState() => _EventRequestsListItemState();
}

class _EventRequestsListItemState extends State<EventRequestsListItem> {
  LatLng _destination;
  bool _isFavorited = false;

  List<Choice> popupList = [
    Choice(id: 1, description: "Process"),
    Choice(id: 2, description: "Edit"),
    Choice(id: 3, description: "Delete"),
    //Choice(id: 4, description: "Location"),
  ];

  String duration() {
    var format = DateFormat("HH:mm");
    var one = format.parse(widget.eventrequest.eventStartTime);
    var two = format.parse(widget.eventrequest.eventEndTime);
    if (two.difference(one).toString().substring(0, 2).contains(":"))
      return two.difference(one).toString().substring(0, 1);
    else
      return two.difference(one).toString().substring(0, 2);
  }

  String get index => null;

  getdate() {
    List<String> months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    DateTime date = DateTime.parse(widget.eventrequest?.eventDate)
        .add(new Duration(days: 1));
    return '${date.day.toString() + " " + months[date.month - 1].toString()}';
    //.substring(0,10)
  }

  getDestination() async {
    double lat;
    double long;
    if (widget.eventrequest?.latitudeS == null) {
      final query = widget.eventrequest?.addLineOneS +
          widget.eventrequest?.addLineTwoS +
          widget.eventrequest?.localityS +
          widget.eventrequest?.city +
          widget.eventrequest.state;
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      print(query);
      lat = first.coordinates.latitude;
      long = first.coordinates.longitude;
    } else {
      lat = widget.eventrequest.latitudeS;
      long = widget.eventrequest.longitudeS;
    }
    _destination = LatLng(lat, long);
  }

  getDetails() async {
    double lat;
    double long;
    if (widget.eventrequest?.latitudeS == null) {
      final query = widget.eventrequest?.addLineOneS +
          widget.eventrequest?.addLineTwoS +
          widget.eventrequest?.localityS +
          widget.eventrequest?.city +
          widget.eventrequest.state;
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
     // print(query);
      lat = first.coordinates.latitude;
      long = first.coordinates.longitude;
    } else {
      lat = widget.eventrequest.latitudeS;
      long = widget.eventrequest.longitudeS;
    }
    _destination = LatLng(lat, long);

    geolocator.Position position = await geolocation.Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best);
    return await _coordinateDistance(position.latitude, position.longitude,
        _destination?.latitude, _destination?.longitude);
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  LatLng currentPosition;
  StreamSubscription subscription;
  getUserLocation() async {
    geolocator.Position position = await geolocation.Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best);
    // subscription = geolocator
    //     .getPositionStream(locationOptions)
    //     .listen((Position position) {
    //   currentPosition = LatLng(position.latitude, position.longitude);
    // });
  }

  // @override
  // void dispose() {
  //   subscription?.cancel();
  //   getDetails();
  //   super.dispose();
  // }
  var distanceValue;
  @override
  Widget build(BuildContext context) {
    print("distance");
    //print(getDetails().toString());

    var title = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Container(
              width: notifier.custFontSize >= 20
                  ? MediaQuery.of(context).size.width * 1.2
                  : MediaQuery.of(context).size.width,
              child: Row(
                //crossAxisAlignment: CrossAxisAlignment.stret
                // ch,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width*0.4,
                      padding: EdgeInsets.only(left: 10),
                      child: Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) => Text(
                          widget.eventrequest?.eventTitle,
                          style: TextStyle(
                            //color: KirthanStyles.titleColor,
                            fontWeight: FontWeight.bold,
                            fontSize: notifier.custFontSize,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(right: 33),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              EventTeamUserRegister(
                                  eventrequest: widget.eventrequest),
                              SizedBox(width: 5),
                              Container(
                                child: FlatButton(
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
                                          color:
                                          KirthanStyles.colorPallete30,
                                          size: notifier.custFontSize,
                                        ),
                                      ),
                                      Text(
                                        "Location",
                                        style: TextStyle(
                                          color:
                                          KirthanStyles.colorPallete30,
                                          fontWeight: FontWeight.bold,
                                          fontSize: notifier.custFontSize,
                                        ),
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Location(
                                              eventrequest:
                                              widget.eventrequest)),
                                    );
                                  },
                                  //splashColor: Colors.red,
//shape: Border.all(width: 2.0, color: Colors.black)
                                ),
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
    "--"
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
            )));
    var subTitle = Wrap(
      children: [
        Row(
          children: <Widget>[
            /*Icon(
          Icons.movie,
          color: KirthanStyles.subTitleColor,
          size: KirthanStyles.subTitleFontSize,
        ),
        */
            Container(
              width: MediaQuery.of(context).size.width - 33,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Consumer<ThemeNotifier>(
                  builder: (context, notifier, child) => Center(
                    child: Text(
                      widget.eventrequest?.eventDescription,
                      style: TextStyle(
                        // color: KirthanStyles.subTitleColor,
                        color: Colors.grey,
                        fontSize: notifier.custFontSize - 1,
                      ),
                    ),
                  )),
            ),
          ],
        )
      ],
    );

    var daysToGo = Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Container(
        padding: EdgeInsets.only(bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10.0),

        //margin: const EdgeInsets.only(left: 4.0),
        child: Consumer<ThemeNotifier>(builder: (context, notifier, child) {
          final eventDate = widget.eventrequest.eventDate;
          DateTime EventDate = DateTime.parse(eventDate);
          DateTime now = DateTime.now();
          var dateTime = DateFormat('yyyy-MM-dd').format(now);
          DateTime dateTimeNow = DateTime.parse(dateTime);
          int daysRemaining = EventDate.difference(dateTimeNow).inDays;
          if (daysRemaining == 0) {
            return Text(
              'Today',
              //daysRemaining.abs().toString() + ' days ago',
              style: TextStyle(
                // color: KirthanStyles.subTitleColor,
                  fontSize: notifier.custFontSize,
                  color: Colors.green[700]),
            );
          }
          if (daysRemaining > 1) {
            return Text(
              (daysRemaining).toString() + ' days to go',
              style: TextStyle(
                  fontSize: notifier.custFontSize, color: Colors.green[700]),
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
          } else if (daysRemaining == 1) {
            return Text(
              'Tomorrow',
              //daysRemaining.abs().toString() + ' days ago',
              style: TextStyle(
                // color: KirthanStyles.subTitleColor,
                  fontSize: notifier.custFontSize,
                  color: Colors.green[700]),
            );
          } else {
            return Container();
          }
        }),
      )
    ]);
    return Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Container(
          padding: EdgeInsets.fromLTRB(8, 4, 5, 0),
          child: new Card(
            elevation: 8,
            child: Consumer<ThemeNotifier>(
              builder: (context, notifier, child) => Container(
                decoration: new BoxDecoration(
                  borderRadius:
                  new BorderRadius.all(new Radius.circular(10.0)),
                  color: notifier.currentColorStatus
                      ? notifier.currentColor
                      : Theme.of(context).cardColor,
                  /*gradient: new LinearGradient(
                  colors: [Colors.white, Colors.white],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  tileMode: TileMode.clamp),*/
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: FlipCard(
                    front: new Column(children: <Widget>[
                      title,
                      Divider(),
                      Consumer<ThemeNotifier>(
                        builder: (context, notifier, child) => Container(
                          // color: Colors.green,
                          width: notifier.custFontSize >= 20
                              ? MediaQuery.of(context).size.width * 1.4
                              : MediaQuery.of(context).size.width,
                          child: Row(children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  //color: Colors.yellow,
                                  child: Text(
                                    "Date",
                                    style: GoogleFonts.openSans(
                                      //color: KirthanStyles.titleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: notifier.custFontSize,
                                    ),
                                  ),
                                ),
                                Container(
                                  //color: Colors.yellow,
                                  padding: EdgeInsets.only(bottom: 15),
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: Text(
                                    getdate(),
                                    //eventrequest?.eventDate.substring(0, 10),
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
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    //color: Colors.yellow,
                                    child: Text(
                                      "Time",
                                      style: GoogleFonts.openSans(
                                        //color: KirthanStyles.titleColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: notifier.custFontSize,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    //color: Colors.yellow,
                                    padding: EdgeInsets.only(bottom: 15),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 40.0),
                                    child: Text(
                                      widget.eventrequest?.eventStartTime,
                                      style: TextStyle(
                                        fontSize: notifier.custFontSize,
                                        //color: KirthanStyles.subTitleColor,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  // color: Colors.red,
                                  child: Text(
                                    "Duration",
                                    style: GoogleFonts.openSans(
                                      //color: KirthanStyles.titleColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: notifier.custFontSize,
                                    ),
                                  ),
                                ),
                                Container(
                                  //color: Colors.yellow,
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
                      FutureBuilder(
                          future: getDetails(),
                          builder: (_, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              distanceValue = snapshot.data;
                              if (distanceValue < 3) {
                                return Container(
                                  width: notifier.custFontSize >= 20
                                      ? MediaQuery.of(context).size.width *
                                      1.2
                                      : MediaQuery.of(context).size.width,
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          color:
                                          KirthanStyles.colorPallete30,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20.0),
                                            bottomRight:
                                            Radius.circular(20.0),
                                          ),
                                        ),
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          bottom: 10,
                                          right: 10,
                                          top: 10,
                                        ),
                                        margin: EdgeInsets.only(bottom: 15),
                                        child: Text(
                                          "Near to You",
                                          style: TextStyle(
                                              fontSize:
                                              notifier.custFontSize),
                                        ),
                                      ),
                                      Container(
                                          padding:
                                          EdgeInsets.only(right: 23),
                                          child: daysToGo),
                                    ],
                                  ),
                                );
                              } else {
                                return Container(
                                    width:
                                    MediaQuery.of(context).size.width,
                                    padding: EdgeInsets.only(right: 23),
                                    child: daysToGo);
                              }
                            }
                            return Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(right: 23),
                                child: daysToGo);
                            ;
                          })
                    ]),
                    back: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Event Description",
                                style: TextStyle(
                                    fontSize: notifier.custFontSize),
                              ),
                            ),
                          ),
                          subTitle,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
