import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';

class ServiceType extends StatefulWidget {
  EventRequest eventRequest;
  ServiceType({this.eventRequest});
  @override
  _ServiceTypeState createState() => _ServiceTypeState();
}

class _ServiceTypeState extends State<ServiceType> {
  bool color1 = false;
  bool color2 = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: KirthanStyles.colorPallete60, //change your color here
          ),
          backgroundColor: KirthanStyles.colorPallete30,
          title: Text('Service Type',
              style: TextStyle(color: KirthanStyles.colorPallete60))
    ),
      key: _scaffoldKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    color1 = !color1;
                    color2 = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color1
                        ? KirthanStyles.colorPallete30.withOpacity(0.4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Icon(
                          Icons.monetization_on_outlined,
                          size: MediaQuery.of(context).size.width / 6,
                        ),
                        radius: MediaQuery.of(context).size.width / 6,
                        backgroundColor: Colors.white,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Free",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    color2 = !color2;
                    color1 = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: color2
                        ? KirthanStyles.colorPallete30.withOpacity(0.4)
                        : Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(20.0),
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 3,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        child: Icon(
                          Icons.monetization_on_outlined,
                          size: MediaQuery.of(context).size.width / 6,
                        ),
                        radius: MediaQuery.of(context).size.width / 6,
                        backgroundColor: Colors.white,
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "Premium",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 150,
          ),
          RaisedButton(
            onPressed: () async {
              //TODO
              if (color1 == true) {
                widget.eventRequest.serviceType = "Free";
              }
              if (color2 == true) {
                widget.eventRequest.serviceType = "Premium";
              }

              Map<String, dynamic> teammap = widget.eventRequest.toJson();
              EventRequest neweventrequest =
                  await eventPageVM.submitNewEventRequest(teammap);

              print(neweventrequest.id);
              String eid = neweventrequest.id.toString();

              SnackBar mysnackbar = SnackBar(
                content: Text("Event registered $successful with $eid"),
                duration: new Duration(seconds: 4),
                backgroundColor: Colors.green,
              );
/*
                                List<EventTeam> listofEventUsers = new List<
                                    EventTeam>();

                                  EventTeam eventteam = new EventTeam();
                                  //eventteam.eventId = team.eventId;
                                  eventteam.teamId = selectedTeam.id;
                                  eventteam.eventId = neweventrequest.id;
                                  eventteam.createdBy = email;
                                  eventteam.teamName = selectedTeam.teamTitle;

                                  String dta = DateFormat(
                                      "yyyy-MM-dd'T'HH:mm:ss.SSS")
                                      .format(DateTime.now());
                                  eventteam.createdTime = dt;
                                  //eventteam.updatedBy = "SYSTEM";
                                  //eventteam.updatedTime = dt;
                                  listofEventUsers.add(eventteam);
                                  print("event-team created");*/
/*SnackBar mysnackbar = SnackBar(
                                    content: Text(
                                        "Event-Team registered $successful "),
                                    duration: new Duration(seconds: 4),
                                    backgroundColor: Colors.green,
                                  );*/
// Scaffold.of(context).showSnackBar(mysnackbar);
              _scaffoldKey.currentState.showSnackBar(mysnackbar);
              /*Navigator.push(context,
                  MaterialPageRoute(builder: (context) => App()));*/
// Scaffold.of(context).showSnackBar(mysnackbar);
Navigator.pop(context);
Navigator.pop(context);
// Scaffold.of(context).showSnackBar(mysnackbar);

//eventteamPageVM.submitNewEventTeamMapping(listofEventUsers);
            },
            child: Text("Submit"),
          )
        ],
      ),
    );
  }
}
