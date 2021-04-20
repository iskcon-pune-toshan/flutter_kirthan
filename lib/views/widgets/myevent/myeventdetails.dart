import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/event_team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/view_models/event_team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import 'package:flutter_kirthan/views/pages/myevent/myevent_view.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
/*final EventTeamPageViewModel eventTeamPageVM =
    EventTeamPageViewModel(apiSvc: EventTeamAPIService());*/
final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());
class EventDetails extends StatefulWidget {
  EventRequest eventrequest;
  //EventTeam eventTeam;
  //TeamRequest selectedteam;
  LoginApp loginApp;
  final String screenName = SCR_EVENT;
  UserRequest userrequest;
  EventDetails({Key key, @required this.eventrequest, @required this.loginApp})
      : super(key: key);

  @override
  _EventDetailsState createState() => new _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with BaseAPIService{
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //EventRequest eventrequestobj = new EventRequest();
  //_EditProfileViewState({Key key, @required this.eventrequest}) ;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  String _selectedState;
  String state;

  var _states = [
    "Kant",
    "Andhra Pradesh",
    "MH",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry"
  ];
  // controllers for form text controllers
  final TextEditingController _eventTitleController =
  new TextEditingController();
  String eventTitle;
  final TextEditingController _eventTypeController =
  new TextEditingController();
  String eventType;
  final TextEditingController _eventDateController =
  new TextEditingController();
  String eventDate;
  final TextEditingController _eventTimeController =
  new TextEditingController();
  String eventTime;
  final TextEditingController _eventDescriptionController =
  new TextEditingController();
  String eventDescription;
  final TextEditingController _lineoneController = new TextEditingController();
  String lineOne;
  final TextEditingController _eventDurationController =
  new TextEditingController();
  String eventDuration;
  final TextEditingController _linetwoController = new TextEditingController();
  String lineTwo;
  final TextEditingController _linethreeController =
  new TextEditingController();
  String lineThree;
  final TextEditingController _cityController = new TextEditingController();
  String city;
  final TextEditingController _pincodeController = new TextEditingController();
  String pinCode;
  final TextEditingController _createdTimeController =
  new TextEditingController();
  String createdTime;
  final TextEditingController _stateController = new TextEditingController();
  final TextEditingController _updatedByController =
  new TextEditingController();
  String updatedBy;
  final TextEditingController _updatedTimeController =
  new TextEditingController();
  String updatedTime;
  String approvalStatus;
final TextEditingController _teamName = new TextEditingController();

List<String> eventss;
  String radioItem = '';
  //String createdTime;

  int t;
  Map<String, bool> usercehckmap = new Map<String, bool>();



  @override
  void initState() {

    _eventTitleController.text = widget.eventrequest.eventTitle;
    _eventTypeController.text = widget.eventrequest.eventType;
    _eventDateController.text = widget.eventrequest.eventDate.substring(0, 10);
    _eventTimeController.text = widget.eventrequest.eventTime.substring(11, 16);
    _eventDescriptionController.text = widget.eventrequest.eventDescription;
    _lineoneController.text = widget.eventrequest.addLineOne;
    _eventDurationController.text = widget.eventrequest.eventDuration;
    _linetwoController.text = widget.eventrequest.addLineTwo;
    _linethreeController.text = widget.eventrequest.addLineThree;
    _pincodeController.text = widget.eventrequest.pincode.toString();
    _stateController.text = widget.eventrequest.state;
    _cityController.text = widget.eventrequest.city;
    _createdTimeController.text = widget.eventrequest.createdTime;
    _updatedByController.text = getCurrentUser().toString();
    _updatedByController.text = widget.eventrequest.updatedTime;
    approvalStatus = widget.eventrequest.approvalStatus;
    print("createdTime");
    print(widget.eventrequest.createdTime);
    //_teamName.text = widget.selectedteam.teamTitle;
 t=widget.eventrequest.id;
    //eventTeamPageVM.setEvenTeamMappings(widget.eventrequest.id);
    //eventteam=eventTeamPageVM.getEventTeamMappings(widget.eventrequest.id);
    //print(eventteam);




//print(eventss);

//print(eventteam);

    //print(teamname);
    return super.initState();

  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    widget.eventrequest.updatedBy = email;
    print(email);
    return email;
  }
  int _groupValue=-1;
  List type = ["Health issues/injury", "Emergency","Important Event", "Other"];
  Widget _myRadioButton(String title, int value, Function onchanged) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onchanged,/*(value) {
        setState(() {
          print(value);
          widget.eventrequest.cancelReason = title;
          print(title);
          //_groupValue = value;

        });
      },*/
      title:  Consumer<ThemeNotifier>(
          builder:
              (context, notifier,
              child) => Text(title,style:
          TextStyle(fontSize: notifier
              .custFontSize)),),



      selected: false,

    );
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
            title: const Text('Event Details'), actions: <Widget>[
          new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
              child: new IconButton(icon: Icon(Icons.edit),
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditEvent(eventrequest: widget.eventrequest,)),
                  );
                },)
          )
        ]),
        body: new Form(
            key: _formKey,
            autovalidate: true,
            //onWillPop: _warnUserAboutInvalidData,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Event Title",
                        hintText: "What do people call this event?",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventTitleController,
                    onSaved: (String value) {
                      widget.eventrequest.eventTitle = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelText: "Event Type",
                      hintStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventTypeController,
                    onSaved: (String value) {
                      eventType = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Date",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventDateController,
                    onSaved: (String value) {
                      widget.eventrequest.eventDate = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Time",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.eventTime = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Event Duration",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventDurationController,
                    onSaved: (String value) {
                      widget.eventrequest.eventDuration = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Description",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventDescriptionController,
                    onSaved: (String value) {
                      widget.eventrequest.eventDescription = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Address",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _lineoneController,
                    onSaved: (String value) {
                      widget.eventrequest.addLineOne = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Line 2",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _linetwoController,
                    onSaved: (String value) {
                      widget.eventrequest.addLineTwo = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Line 3",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _linethreeController,
                    onSaved: (String value) {
                      widget.eventrequest.addLineThree = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Pincode",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _pincodeController,
                    onSaved: (String value) {
                      //  widget.eventrequest.pincode = value;
                    },
                  ),
                ),

                /*new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Locality"),
                    autocorrect: false,
                    controller: _linethreeController,
                    onSaved: (String value) {
                      lineThree = value;
                    },
                  ),
                ),
*/
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "City",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _cityController,
                    onSaved: (String value) {
                      widget.eventrequest.city = value;
                    },
                  ),
                ),
                /*      new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "CreatedTime",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _createdTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.createdTime = value;
                    },
                  ),
                ),*/
                DropdownButtonFormField<String>(
                  value: widget.eventrequest.state,
                  icon: const Icon(Icons.location_city),
                  hint: Text('Select State'),

                  items: _states
                      .map((state) =>
                      DropdownMenuItem(
                        value: state,
                        child: Text(state),
                      ))
                      .toList(),
                  onChanged: (input) {
                    setState(() {
                      _selectedState = input;
                    });
                  },
                  onSaved: (input) {
                    widget.eventrequest.state = input;
                  },
                ),

                RaisedButton(
                    color: KirthanStyles.colorPallete10,
                    child: Text('Cancel Invite'),
                    onPressed: () {

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
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceEvenly,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Consumer<ThemeNotifier>(
                                          builder: (context, notifier, child) =>
                                              Text(
                                                  "Do you really want to cancel?",
                                                  style:
                                                  TextStyle(fontSize: notifier
                                                      .custFontSize)),
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .spaceEvenly,
                                          children: <Widget>[
                                            RaisedButton(
                                              onPressed: () {

                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return StatefulBuilder (
                                                      builder: (context, setState) {
                                                        return Dialog(
                                                          shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius
                                                                  .circular(
                                                                  20.0)),
                                                          //this right here
                                                          child: Container(
                                                            height: 500,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                  .all(12.0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment
                                                                    .spaceEvenly,
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                                children: [
                                                                  new Container(
                                                                    child: new Column(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .center,
                                                                      children: <
                                                                          Widget>[
                                                                        Consumer<
                                                                            ThemeNotifier>(
                                                                          builder:
                                                                              (
                                                                              context,
                                                                              notifier,
                                                                              child) =>
                                                                              Text(
                                                                                  'Why do you want to cancel?',
                                                                                  style:
                                                                                  TextStyle(
                                                                                      fontSize: notifier
                                                                                          .custFontSize)),),
                                                                        Column(
                                                                          children: <
                                                                              Widget>[
                                                                            _myRadioButton( 'Health issues/injury',
                                                                               1,(value) {
                                                                                setState(() {
                                                                                  print(value);
                                                                                  widget.eventrequest.cancelReason = 'Health issues/injury';
                                                                                  print('Health issues/injury');
                                                                                  //_groupValue = value;

                                                                                });
                                                                              },


                                                                            ),
                                                                            _myRadioButton(
                                                                               'Emergency',
                                                                               2,(value) {
                                                                              setState(() {
                                                                                print(value);
                                                                                widget.eventrequest.cancelReason = 'Emergency';
                                                                                print('Emergency');
                                                                                //_groupValue = value;

                                                                              });
                                                                            },

                                                                            ),
                                                                            _myRadioButton(
                                                                               'Important Event',
                                                                               3,(value) {
                                                                              setState(() {
                                                                                print(value);
                                                                                widget.eventrequest.cancelReason = 'Important Event';
                                                                                print('Important Event');
                                                                                //_groupValue = value;

                                                                              });
                                                                            },


                                                                            ),
                                                                            _myRadioButton(
                                                                               'Other',
                                                                               4,(value) {
                                                                              setState(() {
                                                                                print(value);
                                                                                widget.eventrequest.cancelReason = 'Other ';
                                                                                print('Other');
                                                                                //_groupValue = value;

                                                                              });
                                                                            },


                                                                            ),


                                                                            //Text('$radioItem', style: TextStyle(fontSize: 23),)

                                                                          ],
                                                                        ),
                                                                      ],
                                                                    )
                                                                    ,
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment: MainAxisAlignment
                                                                          .spaceEvenly,
                                                                      children: <
                                                                          Widget>[
                                                                        RaisedButton(
                                                                          onPressed: () {
                                                                            Map<String, dynamic>
                                                                                processrequestmap =
                                                                                new Map<String, dynamic>();
                                                                            processrequestmap["id"] =
                                                                                widget.eventrequest?.id;
                                                                            //widget.eventrequest?.isProcessed=false;
                                                                            //widget.eventrequest?.approvalStatus="Cancelled";
                                                                            widget.eventrequest?.status = 3;
                                                                            String eventrequestStr =
                                                                            jsonEncode(widget.eventrequest.toStrJson());
                                                                            eventPageVM.submitUpdateEventRequest(eventrequestStr);
                                                                            //eventPageVM.deleteEventRequest(processrequestmap);
                                                                            SnackBar
                                                                                mysnackbar =
                                                                                SnackBar(
                                                                              content: Text("Event $delete "),
                                                                              duration: new Duration(seconds: 4),
                                                                              backgroundColor: Colors.red,
                                                                            );
                                                                            Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => App()),
                                                                            );
                                                                          },
                                                                          child: Consumer<
                                                                              ThemeNotifier>(
                                                                            builder:
                                                                                (
                                                                                context,
                                                                                notifier,
                                                                                child) =>
                                                                                Text(
                                                                                  "Send",
                                                                                  style: TextStyle(
                                                                                      fontSize:
                                                                                      notifier
                                                                                          .custFontSize,
                                                                                      color: Colors
                                                                                          .white),
                                                                                ),
                                                                          ),
                                                                          color: const Color(
                                                                              0xFF1BC0C5),
                                                                        ),


                                                                      ]),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  });

                                              },
                                              child: Consumer<ThemeNotifier>(
                                                builder:
                                                    (context, notifier,
                                                    child) =>
                                                    Text(
                                                      "Yes",
                                                      style: TextStyle(
                                                          fontSize:
                                                          notifier.custFontSize,
                                                          color: Colors.white),
                                                    ),
                                              ),
                                              color: const Color(0xFF1BC0C5),
                                            ),


                                            RaisedButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Consumer<ThemeNotifier>(
                                                builder:
                                                    (context, notifier,
                                                    child) =>
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

                                          ]),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }),
              ],
            )));
  }


}
