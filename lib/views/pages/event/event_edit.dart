import 'dart:convert';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
    CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

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
  final key = GlobalKey<State<Tooltip>>();
  String _selectedState;
  String state;
  String _hour, _minute, _time;
  String validatePin(String value) {
    String pattern = r'(^[1-9]{1}[0-9]{2}[0-9]{3}$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter pin code';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid pin code';
    }
    return null;
  }

  // controllers for form text controllers
  final TextEditingController _eventTitleController =
      new TextEditingController();
  String eventTitle;
  final TextEditingController _eventDateController =
      new TextEditingController();
  String eventDate;
  final TextEditingController _eventStartTimeController =
      new TextEditingController();
  final TextEditingController _eventEndTimeController =
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
  final TextEditingController _eventTypeController =
  new TextEditingController();
  String updatedBy;
  final TextEditingController _updatedTimeController =
      new TextEditingController();
  String updatedTime;
  String approvalStatus;
  String _selectedCategory;
  @override
  void initState() {
    _eventTitleController.text = widget.eventrequest.eventTitle;
    _eventDateController.text = widget.eventrequest.eventDate.substring(0, 10);
    _eventStartTimeController.text = widget.eventrequest.eventStartTime;
    _eventEndTimeController.text = widget.eventrequest.eventEndTime;
    _eventDescriptionController.text = widget.eventrequest.eventDescription;
    _lineoneController.text = widget.eventrequest.addLineOneS;
    //_eventDurationController.text = widget.eventrequest.eventDuration;
    _linetwoController.text = widget.eventrequest.addLineTwoS;
    _pincodeController.text = widget.eventrequest.pincode.toString();
    _stateController.text = widget.eventrequest.state;
    _cityController.text = widget.eventrequest.city;
    _createdTimeController.text = widget.eventrequest.createdTime;
    _updatedByController.text = getCurrentUser().toString();
    _updatedByController.text = widget.eventrequest.updatedTime;
    //approvalStatus = widget.eventrequest.approvalStatus;
    print("createdTime");
    print(widget.eventrequest.createdTime);
    print(widget.eventrequest.isPublicEvent);
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

  bool readonly(bool public) {
    if (public == true)
      return false;
    else
      return true;
  }
  DateTime selectedDate=DateTime.now();
  _selectDate(BuildContext context) async {
    selectedDate=DateTime.parse(widget.eventrequest.eventDate);
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate:DateTime.parse(widget.eventrequest.eventDate),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null) {
      setState(() {
      widget.eventrequest.eventDate =
          DateFormat("yyyy-MM-dd").format(picked).toString();
      selectedDate=selectedDate.add(new Duration(days: 2));
     selectedDate = picked;

      });
    } else
      setState(() {
      _eventDateController.text =
          widget.eventrequest.eventDate;
      selectedDate=selectedDate.add(new Duration(days: 1));
      selectedDate = picked;
  });
   /* if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });*/
  }
  _selectStartTime(BuildContext context) async {
    selectedDate=DateTime.parse(widget.eventrequest.eventDate);
   // TimeOfDay time=TimeOfDay.fromDateTime(DateTime.parse(widget.eventrequest.eventStartTime));
     final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
           DateTime.now()),
    );
    if (picked != null) {
      setState(() {
       DateTime timee= DateTimeField.convert(picked);
       // TimeOfDay.fromDateTime(DateTime.parse(picked);
          widget.eventrequest.eventStartTime =
              DateFormat("HH:mm").format(timee).toString();


      });
    } else
      setState(() {
        _eventStartTimeController.text =
            widget.eventrequest.eventStartTime;
      });
    /* if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });*/
  }
  _selectEndTime(BuildContext context) async {
    selectedDate=DateTime.parse(widget.eventrequest.eventDate);
    // TimeOfDay time=TimeOfDay.fromDateTime(DateTime.parse(widget.eventrequest.eventStartTime));
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
          DateTime.now()),
    );
    if (picked != null) {
      setState(() {
        DateTime timee= DateTimeField.convert(picked);
        // TimeOfDay.fromDateTime(DateTime.parse(picked);
        widget.eventrequest.eventEndTime =
            DateFormat("HH:mm").format(timee).toString();


      });
    } else
      setState(() {
        _eventEndTimeController.text =
            widget.eventrequest.eventEndTime;
      });
    /* if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });*/
  }
  Widget help() {
    return GestureDetector(
      onTap: () {
        final dynamic tooltip = _toolTipKey.currentState;
        tooltip.ensureTooltipVisible();
      },
      child: Tooltip(
        key: _toolTipKey,
        message: 'Title and Description can only be edited for this event',
        child: IconButton(
          icon: Icon(Icons.help_outline),
          color: KirthanStyles.colorPallete30,
        ),
      ),
    )
    ;
  }
  GlobalKey _toolTipKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final DateTime today = new DateTime.now();

    return new Scaffold(
        appBar: new AppBar(title: const Text('Edit Event'), actions: <Widget>[
          if(!widget.eventrequest.isPublicEvent)
         help(),
         /* IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => {
              setState(()
    {
    final dynamic tooltip = _toolTipKey.currentState;
    tooltip.ensureTooltipVisible();
              }), //setState
            },
            tooltip: "Private Event Cannot be edited",//onpressed
          ),*/
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
                    decoration:  InputDecoration(
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
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some title";
                      }
                    },
                  ),
                ),
                /*new Container(
                  child: new TextFormField(
                    decoration:  InputDecoration(
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
                    //readOnly: readonly(widget.eventrequest.isPublicEvent),
                    autocorrect: false,
                    controller: _eventDescriptionController,
                    onSaved: (String value) {
                      widget.eventrequest.eventDescription = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                  ),
                ),*/
                FutureBuilder(
                    future: commonLookupTablePageVM
                        .getCommonLookupTable("lookupType:Event-type-Category"),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        List<CommonLookupTable> cltList = snapshot.data;
                        List<CommonLookupTable> currCategory = cltList
                            .where((element) =>
                        element.id == widget.eventrequest.eventType)
                            .toList();

                        for (var i in currCategory) {
                          _selectedCategory = i.description;
                        }
                        List<String> _category = cltList
                            .map((user) => user.description)
                            .toSet()
                            .toList();
                        return DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          icon: const Icon(Icons.category),
                          hint: Text(_selectedCategory,
                              style: TextStyle(color: Colors.grey)),
                          items: _category
                              .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                              .toList(),
                          // onChanged: (input) {
                          //   setState(() {
                          //     _selectedCategory = input;
                          //   });
                          // },
                          // onSaved: (input) {
                          //   _selectedCategory = input;
                          // },
                        );
                      } else {
                        return Container();
                      }
                    }),
             /*   FutureBuilder(
                    future: commonLookupTablePageVM
                        .getCommonLookupTable("lookupType:Event-type-Category"),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        List<CommonLookupTable> cltList = snapshot.data;
                        List<CommonLookupTable> currCategory = cltList
                            .where((element) =>
                                element.id == widget.eventrequest.eventType)
                            .toList();

                        for (var i in currCategory) {
                          _selectedCategory = i.description;
                        }
                        List<String> _category = cltList
                            .map((user) => user.description)
                            .toSet()
                            .toList();
                        if(!widget.eventrequest.isPublicEvent)
                          return new Container(
                            child: new TextFormField(
                              decoration:  InputDecoration(
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.grey),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green),
                                  ),
                                  labelText: "Event Type",
                                  hintText: "Event Type eg: Bhajan, Kirtan",
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                  ),
                                  labelStyle: TextStyle(
                                    color: Colors.grey,
                                  )),
                              autocorrect: false,
                              controller: _,
                              onSaved: (String value) {
                                widget.eventrequest.eventTitle = value;
                              },
                              validator: (value) {
                                if (value.isEmpty) {
                                  return "Please enter some title";
                                }
                              },
                            ),
                          );
                              else
                        return DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          icon: const Icon(Icons.category),
                          hint: Text('Select Category',
                              style: TextStyle(color: Colors.grey)),
                          items: _category
                              .map((category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (input) {
                            setState(() {
                              _selectedCategory = input;
                            });
                          },
                          onSaved: (input) {
                            _selectedCategory = input;
                          },
                        );
                      } else {
                        return Container();
                      }
                    }),*/
              /*  Row(
                   // mainAxisAlignment: MainAxisAlignment.start,
    children:[*/
              if(widget.eventrequest.isPublicEvent==true)
              Container(
                  child: RaisedButton(
                      color:themeData.bottomAppBarColor,
                     // textColor: KirthanStyles.colorPallete30,
                      onPressed: () => _selectDate(context), // Refer step 3
                      child:
    Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
    Consumer<ThemeNotifier>(
    builder: (context, notifier, child) =>
    Text(
    "${widget.eventrequest.eventDate.substring(0, 10)}",
   // style:TextStyle(fontSize:notifier.custFontSize) ,
    textAlign: TextAlign.left,
    ),
    )],
    ),),
                ),
                /*  new Container(
                  child: DateTimeField(
                    format: DateFormat("yyyy-MM-dd"),
                    onShowPicker: (context, currentValue) async {
                      final date = await showDatePicker(
                          context: context,
                          firstDate:
                              DateTime.now(),
                          initialDate:
                          currentValue ?? DateTime.now(),
                          lastDate: DateTime(2100));
                      return date;
                    },
                    controller: _eventDateController,
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    onSaved: (input) {
                      if (input != null) {
                        widget.eventrequest.eventDate =
                            DateFormat("yyyy-MM-dd").format(input).toString();
                      } else
                        _eventDateController.text =
                            widget.eventrequest.eventDate;
                    },
                    //controller: _eventDateController,
                    autocorrect: false,
                  ),
               )*/
                if(widget.eventrequest.isPublicEvent==true)
                Container(
                  child: RaisedButton(

                    color:themeData.bottomAppBarColor,
                    // textColor: KirthanStyles.colorPallete30,
                    onPressed: () => _selectStartTime(context), // Refer step 3
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) =>
                              Text(
                                "${widget.eventrequest.eventStartTime}",
                                // style:TextStyle(fontSize:notifier.custFontSize) ,
                                textAlign: TextAlign.left,
                              ),
                        )],
                    ),),
                ),
                if(widget.eventrequest.isPublicEvent==true)
                Container(
                  child: RaisedButton(

                    color:themeData.bottomAppBarColor,
                    // textColor: KirthanStyles.colorPallete30,
                    onPressed: () =>  _selectEndTime(context), // Refer step 3
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) =>
                              Text(
                                "${widget.eventrequest.eventEndTime}",
                                // style:TextStyle(fontSize:notifier.custFontSize) ,
                                textAlign: TextAlign.left,
                              ),
                        )],
                    ),),
                ),
               /* Container(
                  child: RaisedButton(
                      onPressed: () => _selectEndTime(context), // Refer step 3
                      child: Text(
                        "${widget.eventrequest.eventEndTime}",
                      )),
                ),*/
                /*     new Container(
                  child: DateTimeField(
                    format: DateFormat("HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );

                      final date = DateTime.now();
                      return DateTimeField.convert(time);
                    },
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    autocorrect: false,
                    controller: _eventStartTimeController,
                    onSaved: (input) {
                      if (input != null) {
                        widget.eventrequest.eventStartTime =
                            DateFormat("HH:mm").format(input).toString();
                      } else
                        _eventStartTimeController.text =
                            widget.eventrequest.eventStartTime;
                    },
                  ),
                ),*/
              /*  new Container(
                  child: DateTimeField(
                    format: DateFormat("HH:mm"),
                    onShowPicker: (context, currentValue) async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(
                            currentValue ?? DateTime.now()),
                      );

                      final date = DateTime.now();
                      return DateTimeField.convert(time);
                    },
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    autocorrect: false,
                    controller: _eventEndTimeController,
                    onSaved: (input) {
                      if (input != null) {
                        widget.eventrequest.eventEndTime =
                            DateFormat("HH:mm").format(input).toString();
                      } else
                        _eventEndTimeController.text =
                            widget.eventrequest.eventEndTime;
                    },
                  ),
                ),*/
                if(widget.eventrequest.isPublicEvent==true)
                new Container(
                  child: new TextFormField(
                    decoration:  InputDecoration(
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
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    controller: _lineoneController,
                    onSaved: (String value) {
                      widget.eventrequest.addLineOneS = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                  ),
                ),
                if(widget.eventrequest.isPublicEvent==true)
                new Container(
                  child: new TextFormField(
                    decoration:  InputDecoration(
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
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    controller: _linetwoController,
                    onSaved: (String value) {
                      widget.eventrequest.addLineTwoS = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some text";
                      }
                      return null;
                    },
                  ),
                ),
                if(widget.eventrequest.isPublicEvent==true)
                new Container(
                  child: new TextFormField(
                    decoration:  InputDecoration(
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
                    keyboardType: TextInputType.number,
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    controller: _pincodeController,
                    onSaved: (String value) {
                     widget.eventrequest.pincode = int.parse(value);
                    },
                      validator: validatePin,
                  ),
                ),
                if(widget.eventrequest.isPublicEvent==true)
                new Container(
                  child: new TextFormField(
                    decoration:  InputDecoration(
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
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    controller: _cityController,
                    onSaved: (String value) {
                      widget.eventrequest.city = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter some city name";
                      }
                      return null;
                    },
                  ),
                ),
               /* new Container(
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
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    controller: _createdTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.createdTime = value;
                    },
                  ),
                ),*/
                if(widget.eventrequest.isPublicEvent==true)
                new Container(
                  child: new TextFormField(
                    decoration:  InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "State",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: readonly(widget.eventrequest.isPublicEvent),
                    controller: _stateController,
                    onSaved: (String value) {
                      widget.eventrequest.state = value;
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Please enter State name";
                      }
                      return null;
                    },
                  ),
                ),
               Row(  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                   children:[new Container(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
                    child:new RaisedButton(
                      color:KirthanStyles.colorPallete30,
                      textColor: themeData.secondaryHeaderColor,
                      child:Consumer<ThemeNotifier>(
    builder: (context, notifier, child) =>new Text(
                        'Save',
                        style: TextStyle(fontSize:notifier.custFontSize),
                      ),
    ),
                      onPressed: () async {
                        // _handleSubmitted();
                        //String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
                        //_createTimeController.text = dt;
                        _formKey.currentState.save();
                        List<CommonLookupTable> selectedCategory =
                        await commonLookupTablePageVM.getCommonLookupTable(
                            "description:" + _selectedCategory);
                        for (var i in selectedCategory)
                          widget.eventrequest.eventType = i.id;
                        String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                            .format(DateTime.now());
                        _updatedTimeController.text =
                            widget.eventrequest.updatedTime = dt;
                        eventPageVM.getEventRequests("MyEvent");
                       // Navigator.pop(context);
                        //Navigator.pop(context);
                        Navigator.of(context).pushNamed('/screen3');
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
                    )
                    )
              ] )
              ],
            )));
  }
}