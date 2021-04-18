import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());

class EditEvent extends StatefulWidget {
  EventRequest eventrequest;
  LoginApp loginApp;
  final String screenName = SCR_EVENT;
  UserRequest userrequest;
  EditEvent({Key key, @required this.eventrequest, @required this.loginApp})
      : super(key: key);

  @override
  _EditEventState createState() => new _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  String _selectedState;
  String state;
  String _hour, _minute, _time;
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
  //String createdTime;

  @override
  void initState() {
    _eventTitleController.text = widget.eventrequest.eventTitle;
    _eventTypeController.text = widget.eventrequest.eventType;
    _eventDateController.text = widget.eventrequest.eventDate.substring(0,10);
    _eventTimeController.text = widget.eventrequest.eventTime.substring(11,16);
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

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final DateTime today = new DateTime.now();

    return new Scaffold(
        appBar: new AppBar(title: const Text('Edit Profile'), actions: <Widget>[
          new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
              child: new MaterialButton(
                color: themeData.primaryColor,
                textColor: themeData.secondaryHeaderColor,
                child: new Text('Save',style: TextStyle(color: KirthanStyles.colorPallete30),),
                onPressed: () {
                  // _handleSubmitted();
                  //String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
                  //_createTimeController.text = dt;
                  _formKey.currentState.save();
                  String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                      .format(DateTime.now());
                  _updatedTimeController.text =
                      widget.eventrequest.updatedTime = dt;

                  Navigator.pop(context);
                  print(eventTitle);
                  print(eventDate);
                  print(eventDuration);
                  print(widget.eventrequest.eventDescription);
                  //Map<String,dynamic> eventmap = widget.eventrequest.toJson();
                  //String eventmap = widget.eventrequest.toStrJsonJson();
                  String eventrequestStr =
                      jsonEncode(widget.eventrequest.toStrJson());
                  eventPageVM.submitUpdateEventRequest(eventrequestStr);
                },
              ))
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
                    controller: _eventTypeController,
                    onSaved: (String value) {
                      eventType = value;
                    },
                  ),
                ),
                new Container(
                  child: DateTimeField(

                    format: DateFormat("yyyy-MM-dd"),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate: DateTime.parse(widget.eventrequest.eventDate),
                          initialDate: currentValue ?? widget.eventrequest.eventDate,
                          lastDate: DateTime(2100));
                      return date;
                    },
                    onSaved: (input) {
                      widget.eventrequest.eventDate =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                              .format(input)
                              .toString();
                    },
                    controller: _eventDateController,
                    autocorrect: false,
                  ),
                ),
                new Container(
                 child: DateTimeField(
                    format: DateFormat("HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                      );

                      final date = DateTime.now();
                      return DateTimeField.convert(time);
                    },
                   autocorrect: false,
                   controller: _eventTimeController,
                    onSaved: (input) {
                      widget.eventrequest.eventTime =
                          DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                              .format(input)
                              .toString();
                    },

                  ),
                ),
                  /*child: new TextFormField(
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
                    controller: _eventTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.eventTime = value;
                    },
                  ),*//*
                ),*/
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
                    controller: _cityController,
                    onSaved: (String value) {
                      widget.eventrequest.city = value;
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
                        labelText: "CreatedTime",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    controller: _createdTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.createdTime = value;
                    },
                  ),
                ),
                DropdownButtonFormField<String>(
                  value: widget.eventrequest.state,
                  icon: const Icon(Icons.location_city),
                  hint: Text('Select State'),
                  items: _states
                      .map((state) => DropdownMenuItem(
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
              ],
            )));
  }
}
