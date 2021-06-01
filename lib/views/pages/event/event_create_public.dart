import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/Map_Options.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/SearchWidget.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/locationuserwidget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final EventPageViewModel eventPageVM =
    EventPageViewModel(apiSvc: EventAPIService());
final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
    CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

class EventWritePublic extends StatefulWidget {
  final String screenName = SCR_EVENT;
  EventRequest eventrequest;
  UserRequest userRequest;
  UserLogin userLogin;
  UserDetail userDetail;
  @override
  _EventWriteState createState() => _EventWriteState();

  EventWritePublic({@required this.eventrequest, @required this.userLogin})
      : super();
}

class _EventWriteState extends State<EventWritePublic> {
  FocusNode myFocusNode = new FocusNode();
  TeamRequest selectedTeam;
  List<Marker> myMarker = [];
  List<Marker> get markers => myMarker;
  List<Marker> myMarkersource = [];
  List<Marker> get markerssource => myMarkersource;
  GoogleMapController mapController;
  LatLng tappedPoint1;

  final _formKey = GlobalKey<FormState>();
  EventRequest eventrequest = new EventRequest();
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
    'Hyderabad'
  ];
  String _selectedCity;
  String _selectedState;
  String _selectedCountry;
  String _selectedCategory;

  void initState() {
    _getUserLocation();
    super.initState();
  }

  handleTap(LatLng tappedPoint1) {
    // print(tappedPoint1);
    setState(() {
      myMarkersource = [];

      myMarkersource.add(
        Marker(
          markerId: MarkerId(tappedPoint1.toString()),
          infoWindow: InfoWindow(title: 'Event Location'),
          position: tappedPoint1,
        ),
      );
      CircularProgressIndicator();
      eventrequest.longitudeS = tappedPoint1.longitude;
      eventrequest.latitudeS = tappedPoint1.latitude;
      //print(eventrequest.sourceLatitude);
    });
  }

  handleTap2(LatLng tappedPoint1) {
    //  print(tappedPoint1);
    setState(() {
      myMarker = [];
      myMarker.add(
        Marker(
          markerId: MarkerId(tappedPoint1.toString()),
          infoWindow: InfoWindow(title: 'Destination Location'),
          position: tappedPoint1,
        ),
      );
      eventrequest.longitudeD = tappedPoint1.longitude;
      eventrequest.latitudeD = tappedPoint1.latitude;
      //print(eventrequest.destinationLatitude);
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    eventrequest.createdBy = email;
    // print("created by " + eventrequest.createdBy);

    //  print(email);
    return email;
  }

  GoogleMapController _controller;
  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _controller = controller;
    });
  }

  void _animateCamera() {
    _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _lastMapPosition,
          zoom: 14.4746,
        ),
      ),
    );
  }

  Widget _googleMapsWidget(MapsState state) {
    return GoogleMap(
      onTap: handleTap2,
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 14.4746,
      ),
      markers: Set.from(myMarker),
    );
  }

  Widget _googleMapsWidget2(MapsState state) {
    return GoogleMap(
      onTap: handleTap,
      onMapCreated: _onMapCreated,
      myLocationButtonEnabled: true,
      initialCameraPosition: CameraPosition(
        target: _initialPosition,
        zoom: 14.4746,
      ),
      //circles: _circle,
      markers: Set.from(myMarkersource),
    );
  }

  LatLng _lastMapPosition = _center;
  static const LatLng _center = const LatLng(-25.4157807, -54.6166762);
  MapsBloc _mapsBloc;
  static LatLng _initialPosition;

  void _getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
  }

  List type = ["Stationary", "Moving"];
  bool isVisible = false;
  String select;
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Radio(
          activeColor: KirthanStyles.colorPallete30,
          value: type[btnValue],
          groupValue: select,
          onChanged: (value) {
            setState(() {
              //  print(value);
              eventrequest.eventMobility = value;
              select = value;
              if (value == 'Moving') {
                isVisible = true;
              } else
                isVisible = false;
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
    String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
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
          title: Text('Create Public Event',
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
              //  autovalidate: true,
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
                              // print(eventrequest.eventDate);
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
                            "Event Start Time",
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
                              eventrequest.eventStartTime =
                                  DateFormat("HH:mm").format(input).toString();
                              // print(eventrequest.eventStartTime);
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
                            "Event End Time",
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
                              eventrequest.eventEndTime =
                                  DateFormat("HH:mm").format(input).toString();
                              // print(eventrequest.eventEndTime);
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

                    FutureBuilder(
                        future: commonLookupTablePageVM.getCommonLookupTable(
                            "lookupType:Event-type-Category"),
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            List<CommonLookupTable> cltList = snapshot.data;
                            List<String> _category = cltList
                                .map((user) => user.description)
                                .toSet()
                                .toList();
                            return DropdownButtonFormField<String>(
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
                                _selectedCategory = input;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return "Please select event type";
                                }
                                return null;
                              },
                            );
                          } else {
                            return Container();
                          }
                        }),

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
                          validator: validateMobile),
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
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              addRadioButton(0, 'Stationary'),
                              addRadioButton(1, 'Moving'),
                            ]),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
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
                                                    markerssource.clear();
                                                  }), //setState
                                                }, //onpressed
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.done),
                                                onPressed: () {
                                                  //handleTap(tappedPoint1);
                                                  Navigator.pop(context);
                                                },
                                                //onpressed
                                              ),
                                            ],
                                          ),
                                          body: BlocListener(
                                            listener: (BuildContext context,
                                                MapsState state) {
                                              if (state
                                                  is LocationFromPlaceFound) {
                                                Scaffold.of(context)
                                                  ..hideCurrentSnackBar();
                                                _lastMapPosition = LatLng(
                                                    state.locationModel.lat,
                                                    state.locationModel.long);
                                              }

                                              if (state is LocationUserfound) {
                                                Scaffold.of(context)
                                                  ..hideCurrentSnackBar();
                                                _lastMapPosition = LatLng(
                                                    state.locationModel.lat,
                                                    state.locationModel.long);
                                                _animateCamera();
                                              }
                                              if (state is Failure) {
                                                // print('Failure');
                                                Scaffold.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Error'),
                                                          Icon(Icons.error)
                                                        ],
                                                      ),
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  );
                                              }
                                              if (state is Loading) {
                                                // print('loading');
                                                Scaffold.of(context)
                                                  ..hideCurrentSnackBar()
                                                  ..showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text('Loading'),
                                                          CircularProgressIndicator(),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                              }
                                              // handleTap(tappedPoint1);
                                            },
                                            bloc: _mapsBloc,
                                            child: BlocBuilder(
                                                bloc: _mapsBloc,
                                                builder: (BuildContext context,
                                                    MapsState state) {
                                                  return Scaffold(
                                                    body: Stack(
                                                      children: <Widget>[
                                                        _googleMapsWidget2(
                                                            state),
                                                        MapOption(
                                                            mapType:
                                                                MapType.normal),
                                                        LocationUser(),
                                                        SearchPlace(
                                                            onPressed:
                                                                _animateCamera),
                                                        //RangeRadius(isRadiusFixed: _isRadiusFixed),
                                                      ],
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                label: Text(
                                  'Add Source',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 12.5),
                                ),
                                icon: Icon(
                                  Icons.location_on,
                                  color: Colors.black,
                                ),
                                textColor: Colors.black,
                                splashColor: Colors.red,
                                color: Colors.white,
                              ),
                            ]),
                        TextFormField(
                          //attribute: "Address",
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              icon: const Icon(Icons.home, color: Colors.grey),
                              labelText: "Line One",
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.addLineOneS = input;
                            //eventrequest.eventLocation = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          //attribute: "line2",
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: "Line Two",
                              hintText: "",
                              hintStyle: TextStyle(
                                color: Colors.grey,
                              ),
                              labelStyle: TextStyle(
                                color: Colors.grey,
                              )),
                          onSaved: (input) {
                            eventrequest.addLineTwoS = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          //attribute: "locality",
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
                            eventrequest.localityS = input;
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                        Visibility(
                          visible: isVisible,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
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
                                                    //handleTap(tappedPoint1);
                                                    Navigator.pop(context);
                                                  },
                                                  //onpressed
                                                ),
                                              ],
                                            ),
                                            body: BlocListener(
                                              listener: (BuildContext context,
                                                  MapsState state) {
                                                if (state
                                                    is LocationFromPlaceFound) {
                                                  Scaffold.of(context)
                                                    ..hideCurrentSnackBar();
                                                  _lastMapPosition = LatLng(
                                                      state.locationModel.lat,
                                                      state.locationModel.long);
                                                }

                                                if (state
                                                    is LocationUserfound) {
                                                  Scaffold.of(context)
                                                    ..hideCurrentSnackBar();
                                                  _lastMapPosition = LatLng(
                                                      state.locationModel.lat,
                                                      state.locationModel.long);
                                                  _animateCamera();
                                                }
                                                if (state is Failure) {
                                                  // print('Failure');
                                                  Scaffold.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(
                                                      SnackBar(
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Error'),
                                                            Icon(Icons.error)
                                                          ],
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                }
                                                if (state is Loading) {
                                                  // print('loading');
                                                  Scaffold.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(
                                                      SnackBar(
                                                        content: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text('Loading'),
                                                            CircularProgressIndicator(),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                }
                                                // handleTap(tappedPoint1);
                                              },
                                              bloc: _mapsBloc,
                                              child: BlocBuilder(
                                                  bloc: _mapsBloc,
                                                  builder:
                                                      (BuildContext context,
                                                          MapsState state) {
                                                    return Scaffold(
                                                      body: Stack(
                                                        children: <Widget>[
                                                          _googleMapsWidget(
                                                              state),
                                                          MapOption(
                                                              mapType: MapType
                                                                  .normal),
                                                          LocationUser(),
                                                          SearchPlace(
                                                              onPressed:
                                                                  _animateCamera),
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0))),
                                  label: Text(
                                    'Add Destination',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 12.5),
                                  ),
                                  icon: Icon(
                                    Icons.location_on,
                                    color: Colors.black,
                                  ),
                                  textColor: Colors.black,
                                  splashColor: Colors.red,
                                  color: Colors.white,
                                ),
                              ]),
                        ),
                        Visibility(
                          visible: isVisible,
                          child: TextFormField(
                            //attribute: "Address",
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                icon:
                                    const Icon(Icons.home, color: Colors.grey),
                                labelText: "Destination-Line One",
                                hintText: "",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                )),
                            onSaved: (input) {
                              eventrequest.addLineOneD = input;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: isVisible,
                          child: TextFormField(
                            //attribute: "line2",
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                labelText: "Destination-Line Two",
                                hintText: "",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                )),
                            onSaved: (input) {
                              eventrequest.addLineTwoD = input;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ),
                        Visibility(
                          visible: isVisible,
                          child: TextFormField(
                            //attribute: "locality",
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                labelText: "Destination Locality",
                                hintText: "",
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                ),
                                labelStyle: TextStyle(
                                  color: Colors.grey,
                                )),
                            onSaved: (input) {
                              eventrequest.localityD = input;
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ),
                        TextFormField(
                          //attribute: "PinCode",
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
                        Container(
                          child:SelectState(
                            onCountryChanged: (value) {
                              setState(() {
                                eventrequest.country = value;
                              });
                            },
                            onStateChanged:(value) {
                              setState(() {
                                eventrequest.state = value;
                              });
                            },
                            onCityChanged:(value) {
                              setState(() {
                                eventrequest.city = value;
                              });
                            },

                          ),
                        )
                      ],
                    ),

                /*    Column(
                      children: *//*<Widget>[
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
                      ],*//*
                    ),*/
                    //getTeamsWidget(),
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
                                // print("created by " + eventrequest.createdBy);
                                // print(email);

                                _formKey.currentState.save();
                                //eventrequest.isProcessed = true;
                                eventrequest.isPublicEvent = true;
                                // eventrequest.createdBy =getCurrentUser().toString(); //"afrah.17u278@viit.ac.in";
                                // print(eventrequest.createdBy);
                                List<CommonLookupTable> selectedCategory =
                                    await commonLookupTablePageVM
                                        .getCommonLookupTable(
                                            "description:" + _selectedCategory);
                                for (var i in selectedCategory)
                                  eventrequest.eventType = i.id;
                                String dt =
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                        .format(DateTime.now());
                                eventrequest.createdTime = dt;
                                eventrequest.updatedBy = email;
                                eventrequest.updatedTime = null;
                                //eventrequest.approvalStatus = "Processing";
                                //eventrequest.approvalComments = "AAA";
                                Map<String, dynamic> teammap =
                                    eventrequest.toJson();
                                //TeamRequest newteamrequest = await apiSvc
                                //  ?.submitNewTeamRequest(teammap);
                                EventRequest neweventrequest = await eventPageVM
                                    .submitNewEventRequest(teammap);

                                // print(neweventrequest.id);
                                String eid = neweventrequest.id.toString();

                                SnackBar mysnackbar = SnackBar(
                                  content: Text(
                                      "Event registered $successful with $eid"),
                                  duration: new Duration(seconds: 4),
                                  backgroundColor: Colors.green,
                                );

                                String dta =
                                    DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                        .format(DateTime.now());

                                //eventteam.updatedBy = "SYSTEM";
                                //eventteam.updatedTime = dt;

                                _scaffoldKey.currentState
                                    .showSnackBar(mysnackbar);
                                Scaffold.of(context).showSnackBar(mysnackbar);

                                //eventteamPageVM.submitNewEventTeamMapping(listofEventUsers);
                              }
                            }),
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
}
