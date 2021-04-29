import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/event_team_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/team_name.dart';
import 'package:flutter_kirthan/views/pages/event/addlocation.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/Widget.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';
//import 'package:flutter_kirthan/views/pages/eventteam/team_selection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());
final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());

class EventWrite extends StatefulWidget {
  // EventWrite({Key key}) : super(key: key);
  //TeamUserCreate({this.selectedUsers}) : super();
  TeamRequest selectedTeam;
  final String screenName = SCR_EVENT;
  EventRequest eventrequest;
  UserRequest userRequest;
  UserLogin userLogin;
  UserDetail userDetail;
  @override
  _EventWriteState createState() =>
      _EventWriteState(selectedTeam: selectedTeam);

  EventWrite(
      {this.selectedTeam,
      @required this.eventrequest,
      @required this.userLogin})
      : super();
}

class _EventWriteState extends State<EventWrite> {
  bool mapToggle = false;
  FocusNode myFocusNode = new FocusNode();
  bool locationToggle = false;
  bool resetToggle = false;
  TeamRequest selectedTeam;
  TeamRequest selectedTeamfor;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  _EventWriteState({this.selectedTeam});
  List<Marker> myMarker = [];
  List<Marker> get markers => myMarker;

  TextEditingController locationController = TextEditingController();

  GoogleMapController mapController;

  LatLng tappedPoint1, tappedPoint2;

  final _formKey = GlobalKey<FormState>();
  EventRequest eventrequest = new EventRequest();
  TeamRequest _selectedTeam;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  List<String> _states = [
    "Kant",
    "Andhra Pradesh",
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

  List<String> _cities = [
    'Pune',
    'Kant',
    'Adilabad',
    'Delhi',
    'Ahmednagar',
    'Anantapur',
    'Chittoor',
    'Kakinada',
    'Guntur',
    'Hyderabad',
    'Mumbai',
  ];

  List<String> _category = [
    'Bhajan',
    'Kirthan',
    'Bhajan & Kirthan',
    'Dance',
    'Music',
    'Lecture'
  ];

  String _selectedCity;
  String _selectedState;
  String _selectedCountry;
  String _selectedCategory;
  bool selected;
  Future<List<TeamRequest>> teams;
  void initState() {
    super.initState();
  }

  handleTap(LatLng tappedPoint1) {
    print(tappedPoint1);
    //print(tappedPoint2);
    setState(() {
      myMarker = [];

      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint1.toString()),
          infoWindow: InfoWindow(title: 'Event Location'),
          position: tappedPoint1,
        ),
      );

      eventrequest.sourceLongitude = tappedPoint1.longitude;
      eventrequest.sourceLatitude = tappedPoint1.latitude;
      /*myMarker.add(Marker(markerId: MarkerId(tappedPoint2.toString()),
      infoWindow: InfoWindow(
        title: 'End Point') ,
      position: tappedPoint2,
      ),
      );*/
    });
  }

  handleTap2(LatLng tappedPoint1) {
    print(tappedPoint1);
    //print(tappedPoint2);
    setState(() {
      myMarker = [];

      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint1.toString()),
          infoWindow: InfoWindow(title: 'Event Location'),
          position: tappedPoint1,
        ),
      );

      eventrequest.destinationLongitude = tappedPoint1.longitude;
      eventrequest.destinationLatitude = tappedPoint1.latitude;
      /*myMarker.add(Marker(markerId: MarkerId(tappedPoint2.toString()),
      infoWindow: InfoWindow(
        title: 'End Point') ,
      position: tappedPoint2,
      ),
      );*/
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  List type = ["Stationary", "Moving"];

  String select;
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: Colors.black,
          value: type[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              print(value);
              eventrequest.eventMobility = value;
              select = value;
            });
          },
        ),
        Text(
          title,
          style: TextStyle(
              //color:  KirthanStyles.titleColor ,
              fontWeight: FontWeight.normal),
        )
      ],
    );
  }

  String validateMobile(String value) {
    String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //resizeToAvoidBottomInset: false,

      appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: KirthanStyles.colorPallete60, //change your color here
          ),
          backgroundColor: KirthanStyles.colorPallete30,
          title: Text('Create Event',
              style: TextStyle(color: KirthanStyles.colorPallete60))),
      body: Builder(builder: (context) {
        return SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(5),
            //color: Colors.black,
            child: Center(
              child: Form(
                // context,
                key: _formKey,
                autovalidate: true,
                // readonly: true,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        alignment: Alignment.centerLeft,
                        // margin: const EdgeInsets.only(top: 30),
                        child: new Text(
                          "About Event",
                          style: new TextStyle(
                              fontSize: 17.0,
                              color: KirthanStyles.colorPallete30),
                        )),

                    /* Card(
                    child: Container(
                      padding: new EdgeInsets.all(10),
                      child: TextFormField(
                        maxLength: 30,
                        //attribute: "Username",
                        decoration: InputDecoration(
                            icon: const Icon(Icons.tag_faces),
                            hintText: "",
                            labelText:"eventID"
                        ),
                        onSaved: (input){
                          eventrequest.id = input;
                        },=
                        validator: (value) {
                          if(value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                    elevation: 5,
                  ),*/

                    Container(
                      //padding: new EdgeInsets.all(10),
                      child: TextFormField(
                        focusNode: myFocusNode,
                        //attribute: "eventTitle",
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            //icon: const Icon(Icons.title, color: Colors.grey),
                            labelText: "Title",
                            hintText: "Type title of Event",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(
                                color: myFocusNode.hasFocus
                                    ? Colors.black
                                    : Colors.grey)),
                        onSaved: (input) {
                          eventrequest.eventTitle = input;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                      //padding: new EdgeInsets.all(10),
                      child: TextFormField(
                        //attribute: "Description",
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            //icon: const Icon(Icons.description,
                            //   color: Colors.grey),
                            labelText: "Description",
                            hintText: "Type Description of event",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            )),
                        onSaved: (input) {
                          eventrequest.eventDescription = input;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      ),
                    ),

                    /*Card(
                    child: Container(
                      padding: new EdgeInsets.all(10),
                      child:TextFormField(
                        //attribute: "Date",
                        decoration: InputDecoration(
                          icon: const Icon(Icons.timelapse),
                          labelText: "Date",
                          hintText: "",
                        ),
                        onSaved: (input){
                          eventrequest.eventDate = input;
                        },
                        validator: (value) {
                          if(value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      ),
                    ),
                    elevation: 5,
                  ),*/
                    /*Container(
                      padding: new EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                        Text("Event Date",textAlign: TextAlign.start,style: TextStyle(color: Colors.grey),),
                          DateTimeField(
                            format: DateFormat("yyyy-MM-dd h:mm a"),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              if (date != null) {
                                final time = await showTimePicker(
                                  context: context,
                                  initialTime:
                                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                                );
                                return DateTimeField.combine(date, time);
                              } else {
                                return currentValue;
                              }
                            },
                          ),
                    ]),
                    ),*/
                    Container(
                      padding: new EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Event Date",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey),
                          ),
                          DateTimeField(
                            format: DateFormat("yyyy-MM-dd"),
                            onShowPicker: (context, currentValue) async {
                              final date = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  initialDate: currentValue ?? DateTime.now(),
                                  lastDate: DateTime(2100));
                              return date;
                            },
                            onSaved: (input) {
                              eventrequest.eventDate = DateFormat("yyyy-MM-dd")
                                  .format(input)
                                  .toString();
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: new EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            "Event Time",
                            textAlign: TextAlign.start,
                            style: TextStyle(color: Colors.grey),
                          ),
                          DateTimeField(
                            format: DateFormat("HH:mm"),
                            onShowPicker: (context, currentValue) async {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              return DateTimeField.convert(time);
                            },
                            onSaved: (input) {
                              eventrequest.eventTime =
                                  DateFormat("HH:mm").format(input).toString();
                            },
                            validator: (value) {
                              if (value.toString().isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      //padding: new EdgeInsets.all(10),
                      child: TextFormField(
                        //attribute: "Duration",
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green),
                            ),
                            //icon: const Icon(Icons.timelapse,
                            //  color: Colors.grey),
                            labelText: "Duration",
                            hintText: "Duration of event in hrs",
                            hintStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            )),
                        onSaved: (input) {
                          eventrequest.eventDuration = input;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter some text";
                          }
                          return null;
                        },
                      ),
                    ),

                    /*    Card(
                        child: Container(
                          padding: new EdgeInsets.all(10),
                          child: RaisedButton.icon(
                            onPressed: (){ Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddLocation(eventrequest: eventrequest,)
                                )
                            ); },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            label: Text('Add Location',
                              style: TextStyle(color: Colors.black),),
                            icon: Icon(Icons.location_on, color:Colors.black,),
                            textColor: Colors.black,
                            splashColor: Colors.red,
                            color: Colors.white,
                          ),

                        ),
                        elevation: 5,
                      ),*/
                    /* Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "Location",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.location_city),
                            labelText: "Location",
                            hintText: "",
                          ),
                          onSaved: (input){
                            eventrequest.eventLocation = input;
                          },
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      elevation: 5,
                    ),*/
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      icon: const Icon(Icons.category),
                      hint: Text('Select Event Type',
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
                        eventrequest.eventType = input;
                      },
                    ),
                    /*Container(
                        //padding: new EdgeInsets.all(10),
                        child: TextFormField(

                          //focusNode: myFocusNode,
                          //attribute: "Type",
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                             // icon: const Icon(Icons.low_priority,
                               //   color: Colors.grey),
                              labelText: "Event Type",

                              hintText: "Event Type eg: Bhajan",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: myFocusNode.hasFocus ? Colors.black : Colors.grey
                              )),
                          onSaved: (input) {
                            eventrequest.eventType = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ),*/

                    Container(
                      //padding: new EdgeInsets.all(10),
                      child: TextFormField(

                          //attribute: "PhoneNumber",
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              // icon: const Icon(Icons.phone_iphone,
                              //   color: Colors.grey),
                              labelText: "Phone Number",
                              hintText: "Type Phone Number",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.phoneNumber = int.parse(input);
                          },
                          validator: validateMobile
                          /*  (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },*/
                          ),
                    ),
                    new Container(
                        alignment: Alignment.centerLeft,
                        margin: const EdgeInsets.only(top: 20),
                        child: new Text(
                          "About Event Venue",
                          style: new TextStyle(
                              fontSize: 17.0,
                              color: KirthanStyles.colorPallete30),
                        )),

                    Column(
                      children: <Widget>[
                        /*Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    addRadioButton(0, 'Stationary'),
                                    addRadioButton(1, 'Moving'),
                              ]),*/
                        /*  Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:<Widget>[
                              RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (BuildContext context) =>
                                        MapsBloc(),

                                    child: Scaffold(
                                        appBar: AppBar(

                                          actions: <Widget>[

                                            IconButton(
                                              icon: Icon(Icons.refresh),
                                              onPressed: () => {
                                                setState(() {
                                                  markers.clear();
                                                }), //setState
                                              }, //onpressed
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.done),
                                              onPressed: () {
                                                handleTap(tappedPoint1);
                                                eventrequest.sourceLongitude =
                                                    tappedPoint1.longitude;
                                                eventrequest.sourceLatitude =
                                                    tappedPoint1.latitude;
                                                print(eventrequest
                                                    .sourceLongitude);
                                                print(eventrequest
                                                    .sourceLatitude);
                                                handleTap(tappedPoint2);
                                                //widget.eventrequest.destinationLongitude=tappedPoint1.longitude;
                                                //widget.eventrequest.destinationLatitude=tappedPoint1.latitude;

                                                // widget.eventrequest.eventLocation=tappedPoint1.toString();
                                              },
                                              //onpressed
                                            ),
                                          ],
                                        ),
                                        body: Column(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            80.0,
                                                    width: double.infinity,
                                                    child: !mapToggle
                                                        ? GoogleMap(
                                                            myLocationButtonEnabled:
                                                                true,
                                                            myLocationEnabled:
                                                                true,
                                                            compassEnabled:
                                                                true,
                                                            onMapCreated:
                                                                onMapCreated,
                                                            onTap: handleTap,
                                                            markers: Set.from(
                                                                myMarker),
                                                            initialCameraPosition:
                                                                CameraPosition(
                                                                    target:
                                                                        LatLng(
                                                                            0.0,
                                                                            0.0),
                                                                    zoom: 16),
                                                          )
                                                        : Center(
                                                            child: Text(
                                                            'Loading.. Please wait..',
                                                            style: TextStyle(
                                                                fontSize: 20.0),
                                                          ))),
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),

                            label: Text(
                              'Add Source',
                              style: TextStyle(color: Colors.black,fontSize:12.5),
                            ),
                            icon: Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                            textColor: Colors.black,
                            splashColor: Colors.red,
                            color: Colors.white,
                          ),
                          RaisedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BlocProvider(
                                    create: (BuildContext context) =>
                                        MapsBloc(),
                                    child: Scaffold(
                                        appBar: AppBar(
                                          title: Text('Location'),
                                          actions: <Widget>[
                                            IconButton(
                                              icon: Icon(Icons.refresh),
                                              onPressed: () => {
                                                setState(() {
                                                  markers.clear();
                                                }), //setState
                                              }, //onpressed
                                            ),
                                            IconButton(
                                              icon: Icon(Icons.done),
                                              onPressed: () {
                                                handleTap2(tappedPoint2);
                                                eventrequest
                                                        .destinationLongitude =
                                                    tappedPoint1.longitude;
                                                eventrequest
                                                        .destinationLatitude =
                                                    tappedPoint1.latitude;
                                                print(eventrequest
                                                    .destinationLongitude);
                                                print(eventrequest
                                                    .destinationLatitude);

                                                //widget.eventrequest.destinationLongitude=tappedPoint1.longitude;
                                                //widget.eventrequest.destinationLatitude=tappedPoint1.latitude;

                                                // widget.eventrequest.eventLocation=tappedPoint1.toString();
                                              },
                                              //onpressed
                                            ),
                                          ],
                                        ),
                                        body: Column(
                                          children: <Widget>[
                                            Stack(
                                              children: <Widget>[
                                                Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height -
                                                            80.0,
                                                    width: double.infinity,
                                                    child: !mapToggle
                                                        ? GoogleMap(
                                                            myLocationButtonEnabled:
                                                                true,
                                                            myLocationEnabled:
                                                                true,
                                                            compassEnabled:
                                                                true,
                                                            onMapCreated:
                                                                onMapCreated,
                                                            onTap: handleTap,
                                                            markers: Set.from(
                                                                myMarker),
                                                            initialCameraPosition:
                                                                CameraPosition(
                                                                    target:
                                                                        LatLng(
                                                                            0.0,
                                                                            0.0),
                                                                    zoom: 16),
                                                          )
                                                        : Center(
                                                            child: Text(
                                                            'Loading.. Please wait..',
                                                            style: TextStyle(
                                                                fontSize: 20.0),
                                                          ))),
                                              ],
                                            )
                                          ],
                                        )),
                                  ),
                                ),
                              );
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0))),
                            label: Text(
                              'Add Destination',
                              style: TextStyle(color: Colors.black,fontSize: 12.5),
                            ),
                            icon: Icon(
                              Icons.location_on,
                              color: Colors.black,
                            ),
                            textColor: Colors.black,
                            splashColor: Colors.red,
                            color: Colors.white,
                          ),
            ]),*/

                        TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              icon: const Icon(Icons.home, color: Colors.grey),
                              labelText: "Address",
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.addLineOne = input;
                            eventrequest.eventLocation = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: "Line 2",
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.addLineTwo = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          //attribute: "line3",
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: "Line 3",
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.addLineThree = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: "Locality",
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.locality = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: "PinCode",
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.pincode = int.parse(input);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),

                    Column(
                      children: <Widget>[
                        DropdownButtonFormField<String>(
                          value: _selectedCity,
                          icon: const Icon(Icons.location_city),
                          hint: Text('Select City',
                              style: TextStyle(color: Colors.grey)),
                          items: _cities
                              .map((city) => DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(city),
                                  ))
                              .toList(),
                          onChanged: (input) {
                            setState(() {
                              _selectedCity = input;
                            });
                          },
                          onSaved: (input) {
                            eventrequest.city = input;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedState,
                          icon: const Icon(Icons.location_city),
                          hint: Text(
                            'Select State',
                            style: TextStyle(color: Colors.grey),
                          ),
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
                            eventrequest.state = input;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          value: _selectedCountry,
                          icon: const Icon(Icons.location_city),
                          hint: Text('Select Country',
                              style: TextStyle(color: Colors.grey)),
                          items: ['IND', 'Kyrgyzstan']
                              .map((country) => DropdownMenuItem(
                                    value: country,
                                    child: Text(country),
                                  ))
                              .toList(),
                          onChanged: (input) {
                            setState(() {
                              _selectedCountry = input;
                            });
                          },
                          onSaved: (input) {
                            eventrequest.country = input;
                          },
                        ),
                      ],
                    ),
                    //getTeamsWidget(),
                    new Container(margin: const EdgeInsets.only(top: 40)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          color: KirthanStyles.colorPallete60,
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        MaterialButton(
                            child: Text(
                              "Submit",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: KirthanStyles.colorPallete30,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                final FirebaseUser user =
                                    await auth.currentUser();
                                final String email = user.email;
                                eventrequest.createdBy = email;
                                print("created by " + eventrequest.createdBy);
                                print(email);

                                _formKey.currentState.save();
                                eventrequest.isProcessed = true;
                                eventrequest.isPublicEvent = false;
                                // eventrequest.createdBy =getCurrentUser().toString(); //"afrah.17u278@viit.ac.in";
                                // print(eventrequest.createdBy);
                                String dt =
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                        .format(DateTime.now());
                                eventrequest.createdTime = dt;
                                eventrequest.updatedBy = null;
                                eventrequest.updatedTime = null;
                                //eventrequest.approvalStatus = "Processing";
                                eventrequest.approvalComments = "AAA";
                                Map<String, dynamic> teammap =
                                    eventrequest.toJson();
                                //TeamRequest newteamrequest = await apiSvc
                                //  ?.submitNewTeamRequest(teammap);
                                EventRequest neweventrequest = await eventPageVM
                                    .submitNewEventRequest(teammap);

                                print(neweventrequest.id);
                                String eid = neweventrequest.id.toString();

                                SnackBar mysnackbar = SnackBar(
                                  content: Text(
                                      "Event registered $successful with $eid"),
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
                                _scaffoldKey.currentState
                                    .showSnackBar(mysnackbar);
                                // Scaffold.of(context).showSnackBar(mysnackbar);

                                // Scaffold.of(context).showSnackBar(mysnackbar);

                                //eventteamPageVM.submitNewEventTeamMapping(listofEventUsers);
                              }
                              //String s = jsonEncode(userrequest.mapToJson());
                              //service.registerUser(s);
                              //print(s);
                            }),
                        /*MaterialButton(
                        child: Text("Reset",style: TextStyle(color: Colors.white),),
                        color: Colors.pink,
                        onPressed: () {
                          _fbKey.currentState.reset();
                        },
                      ),*/
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    eventrequest.createdBy = email;
    print("created by " + eventrequest.createdBy);

    print(email);
    return email;
  }
}
