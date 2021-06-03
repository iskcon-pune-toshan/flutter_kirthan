import 'package:country_state_city_picker/country_state_city_picker.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/service_type.dart';
//import 'package:flutter_kirthan/views/pages/eventteam/team_selection.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

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

      eventrequest.longitudeS = tappedPoint1.longitude;
      eventrequest.latitudeS = tappedPoint1.latitude;
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

      eventrequest.longitudeD = tappedPoint1.longitude;
      eventrequest.latitudeD = tappedPoint1.latitude;
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
    String patttern = r'(^(?:[+0]9)?[0-9]{10}$)';
    RegExp regExp = new RegExp(patttern);
    if (value.length == 0) {
      return 'Please enter mobile number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid mobile number';
    }
    return null;
  }

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
          title: Text('Invite a Team',
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        //focusNode: myFocusNode,
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
                            return "Please enter some title";
                          }
                          return null;
                        },
                      ),
                    ),

                    Container(
                      //padding: new EdgeInsets.all(10),
                      child: TextFormField(
                        //attribute: "Description",
                        autovalidateMode: AutovalidateMode.onUserInteraction,
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
                            return "Please enter some description";
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
                            },
                            validator: (value) {
                              if (value.toString().isEmpty || value == null) {
                                return "Please select a date";
                              } else
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
                            },
                            onChanged: (input) {
                              eventrequest.eventStartTime =
                                  DateFormat("HH:mm").format(input).toString();
                              // print(eventrequest.eventStartTime);
                            },
                            validator: (value) {
                              if (value.toString().isEmpty || value == null) {
                                return "Please select time";
                              } else
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
                            },
                            validator: (value) {
                              if (value.toString().isEmpty || value == null) {
                                return "Please select time";
                              } else {
                                String time =
                                    "${value.hour < 10 ? ("0" + value.hour.toString()) : value.hour}:${value.minute < 10 ? ("0" + value.minute.toString()) : value.minute}";
                                print(time.compareTo(
                                    eventrequest.eventStartTime != null
                                        ? eventrequest.eventStartTime
                                        : ""));

                                return time.compareTo(
                                    eventrequest.eventStartTime != null
                                        ? eventrequest.eventStartTime
                                        : "") ==
                                    1
                                    ? null
                                    : "End time must be more than start time";
                              }
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
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        TextFormField(
                            keyboardType: TextInputType.number,
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
                            validator: validatePin),
                        Container(
                          child: SelectState(
                            onCountryChanged: (value) {
                              setState(() {
                                eventrequest.country = value;
                              });
                            },
                            onStateChanged: (value) {
                              setState(() {
                                eventrequest.state = value;
                              });
                            },
                            onCityChanged: (value) {
                              setState(() {
                                eventrequest.city = value;
                              });
                            },
                          ),
                        )
                      ],
                    ),
                    TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        isCollapsed: true,
                        errorBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      validator: (value) {
                        if (eventrequest.city == null) {
                          if (eventrequest.state == null) {
                            if (eventrequest.country == null) {
                              return "Please select country, state & city";
                            }
                            return "Please select state & city";
                          }
                          return "Please select city";
                        }
                        return null;
                      },
                    ),
                    new Container(margin: const EdgeInsets.only(top: 40)),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                          color: KirthanStyles.colorPallete60,
                          child: Text("Back"),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        MaterialButton(
                            child: Text(
                              "Next",
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
                                List<CommonLookupTable> selectedCategory =
                                await commonLookupTablePageVM
                                    .getCommonLookupTable(
                                    "description:" + _selectedCategory);
                                for (var i in selectedCategory)
                                  eventrequest.eventType = i.id;
                                // eventrequest.isProcessed = true;
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
                                //eventrequest.approvalComments = "AAA";

//TeamRequest newteamrequest = await apiSvc
//  ?.submitNewTeamRequest(teammap);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ServiceType(
                                            eventRequest: eventrequest)));
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
