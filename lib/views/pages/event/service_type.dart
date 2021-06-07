import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
import 'package:provider/provider.dart';

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
    return Consumer<ThemeNotifier>(
      builder: (context, ThemeNotifier notifier, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
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
                              color: notifier.darkTheme
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            radius: MediaQuery.of(context).size.width / 6,
                            backgroundColor: notifier.darkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Free",
                              style: TextStyle(
                                  color: notifier.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18),
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
                          //TODO:added theme notifier
                          CircleAvatar(
                            child: Icon(
                              Icons.monetization_on_outlined,
                              size: MediaQuery.of(context).size.width / 6,
                              color: notifier.darkTheme
                                  ? Colors.black
                                  : Colors.white,
                            ),
                            radius: MediaQuery.of(context).size.width / 6,
                            backgroundColor: notifier.darkTheme
                                ? Colors.white
                                : Colors.black,
                          ),
                          Container(
                            padding: EdgeInsets.only(top: 10),
                            child: Text(
                              "Premium",
                              style: TextStyle(
                                  color: notifier.darkTheme
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: 18),
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
                  } else if (color2 == true) {
                    widget.eventRequest.serviceType = "Premium";
                  } else if (color1 == false && color2 == false) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text('Select a service type'),
                      backgroundColor: Colors.red,
                    ));
                  }
                  if (color1 || color2) {
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
                    _scaffoldKey.currentState.showSnackBar(mysnackbar);
                    new Future.delayed(const Duration(seconds: 3), () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                    /*Navigator.pop(context);
                  Navigator.pop(context);*/
                  }
                },
                child: Text("Submit"),
              )
            ],
          ),
        );
      },
    );
  }
}
