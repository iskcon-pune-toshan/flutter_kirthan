import 'package:csc_picker/csc_picker.dart';
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
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_view.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

TextEditingController pincodeController = new TextEditingController();
final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

class EventWrite extends StatefulWidget {
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
  List<String> pinCode;

  getPinCode(String city) async {
    List<Location> location;
    List<Placemark> placemark;
    print("city");
    print(city);
    location = await locationFromAddress(city);
    print("location");
    print(location);

    placemark = await placemarkFromCoordinates(
        location[0].latitude, location[0].longitude);
    pincodeController.text = placemark[0].postalCode;
  }

  bool mapToggle = false;
  FocusNode myFocusNode = new FocusNode();
  bool locationToggle = false;
  bool resetToggle = false;
  TeamRequest selectedTeam;
  TeamRequest selectedTeamfor;
  bool isDisabled;

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
    pincodeController.text = "";
    isDisabled = false;
  }
  void incrementCounter(){
    setState(() {
      isDisabled = true;

    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
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
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: IconThemeData(
            color: KirthanStyles.colorPallete60, //change your color here
          ),
          backgroundColor: KirthanStyles.colorPallete30,
          title: Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Text('Invite a Team',
                style: TextStyle(
                    color: KirthanStyles.colorPallete60,
                    fontSize: notifier.custFontSize)),
          )),
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
                child: Column(
                  children: <Widget>[
                    new Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                          alignment: Alignment.centerLeft,
                          child: new Text(
                            "About Event",
                            style: new TextStyle(
                                fontSize: notifier.custFontSize,
                                color: KirthanStyles.colorPallete30),
                          )),
                    ),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                        //padding: new EdgeInsets.all(10),
                        child: TextFormField(
                          style: TextStyle(fontSize: notifier.custFontSize),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
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
                                  fontSize: notifier.custFontSize),
                              labelStyle: TextStyle(
                                  color: myFocusNode.hasFocus
                                      ? Colors.black
                                      : Colors.grey,
                                  fontSize: notifier.custFontSize)),
                          onSaved: (input) {
                            eventrequest.eventTitle = input;
                          },
                          validator: (value) {
                            if (value.trimLeft().isEmpty) {
                              return "Please enter some title";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                        //padding: new EdgeInsets.all(10),
                        child: TextFormField(
                          style: TextStyle(fontSize: notifier.custFontSize),
                          //attribute: "Description",
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.green),
                              ),
                              labelText: "Description",
                              hintText: "Type Description of event",
                              hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: notifier.custFontSize),
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: notifier.custFontSize)),
                          onSaved: (input) {
                            eventrequest.eventDescription = input;
                          },
                          validator: (value) {
                            if (value.trimLeft().isEmpty) {
                              return "Please enter some description";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),


                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                        padding: new EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "Event Date",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: notifier.custFontSize),
                            ),
                            DateTimeField(
                              style: TextStyle(fontSize: notifier.custFontSize),
                              format: DateFormat("yyyy-MM-dd"),
                              onShowPicker: (context, currentValue) async {
                                final date = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));
                                return date;
                              },
                              onChanged: (input) {
                                eventrequest.eventDate =
                                    DateFormat("yyyy-MM-dd")
                                        .format(input)
                                        .toString();
                              },
                              onSaved: (input) {
                                eventrequest.eventDate =
                                    DateFormat("yyyy-MM-dd")
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
                    ),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                        padding: new EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "Event Start Time",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: notifier.custFontSize),
                            ),
                            DateTimeField(
                              style: TextStyle(fontSize: notifier.custFontSize),
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
                                    DateFormat("HH:mm")
                                        .format(input)
                                        .toString();
                              },
                              onChanged: (input) {
                                eventrequest.eventStartTime =
                                    DateFormat("HH:mm")
                                        .format(input)
                                        .toString();
                                // print(eventrequest.eventStartTime);
                              },
                              validator: (value) {
                                if (value.toString().isEmpty || value == null) {
                                  return "Please select time";
                                } else
                                {
                                  DateFormat dateFormat = new DateFormat.Hm();
                                  DateTime currenttime=dateFormat.parse(DateTime.now().toString().substring(11,15));
                                  if(eventrequest.eventDate ==  DateFormat("yyyy-MM-dd")
                                      .format(DateTime.now())
                                      .toString()){
                                    return value.isAfter(currenttime) ==true
                                        ? null
                                        : "Enter correct time";
                                  }
                                  else
                                    return null;

                                }

                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                        padding: new EdgeInsets.all(10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text(
                              "Event End Time",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: notifier.custFontSize),
                            ),
                            DateTimeField(
                              style: TextStyle(fontSize: notifier.custFontSize),
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
                                eventrequest.eventEndTime = DateFormat("HH:mm")
                                    .format(input)
                                    .toString();
                              },
                              validator: (value) {
                                if (value.toString().isEmpty || value == null) {
                                  return "Please select time";
                                } else {
                                  String time =
                                      "${value.hour < 10 ? ("0" + value.hour.toString()) : value.hour}:${value.minute < 10 ? ("0" + value.minute.toString()) : value.minute}";

                                  return time.compareTo(
                                      eventrequest.eventStartTime !=
                                          null
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
                            return Consumer<ThemeNotifier>(
                              builder: (context, notifier, child) =>
                                  DropdownButtonFormField<String>(
                                    style: TextStyle(
                                        fontSize: notifier.custFontSize > 20
                                            ? notifier.custFontSize + 10
                                            : notifier.custFontSize),
                                    value: _selectedCategory,
                                    icon: const Icon(Icons.category),
                                    hint: Text('Select Event Type',
                                        style: TextStyle(color: Colors.grey)),
                                    items: _category
                                        .map((category) => DropdownMenuItem<String>(
                                      value: category,
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                            fontSize:
                                            notifier.custFontSize,color: notifier.darkTheme
                                            ?Colors.white:Colors.black),
                                      ),
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
                                  ),
                            );
                          } else {
                            return Container();
                          }
                        }),
                    new Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(top: 20),
                          child: new Text(
                            "About Event Venue",
                            style: new TextStyle(
                                fontSize: notifier.custFontSize,
                                color: KirthanStyles.colorPallete30),
                          )),
                    ),
                    Column(
                      children: <Widget>[
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => TextFormField(
                            style: TextStyle(fontSize: notifier.custFontSize),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
                            decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                                icon:
                                const Icon(Icons.home, color: Colors.grey),
                                labelText: "Address",
                                hintText: "",
                                hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: notifier.custFontSize),
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: notifier.custFontSize)),
                            onSaved: (input) {
                              eventrequest.addLineOneS = input;
                            },
                            validator: (value) {
                              if (value.trimLeft().isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ),
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => TextFormField(
                            style: TextStyle(fontSize: notifier.custFontSize),
                            autovalidateMode:
                            AutovalidateMode.onUserInteraction,
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
                                    fontSize: notifier.custFontSize),
                                labelStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: notifier.custFontSize)),
                            onSaved: (input) {
                              eventrequest.addLineTwoS = input;
                            },
                            validator: (value) {
                              if (value.trimLeft().isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ),
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => TextFormField(
                            style: TextStyle(fontSize: notifier.custFontSize),
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
                                    fontSize: notifier.custFontSize),
                                labelStyle: TextStyle(
                                  fontSize: notifier.custFontSize,
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
                        ),

                        // Consumer<ThemeNotifier>(
                        //     builder: (context, notifier, child) =>
                        //         FutureBuilder(
                        //             future: getPinCode(eventrequest.city),
                        //             builder: (context, snapshot) {
                        //               if (snapshot.hasData) {
                        //                 List<Placemark> cltList = snapshot.data;
                        //                 print("cltlist");
                        //                 print(cltList);
                        //                 List<String> _category = cltList
                        //                             .length !=
                        //                         0
                        //                     ? cltList
                        //                         .map((user) => user.postalCode)
                        //                         .toSet()
                        //                         .toList()
                        //                     : ["No Pincode"];
                        //
                        //                 return DropdownButtonFormField<String>(
                        //                   style: TextStyle(
                        //                       fontSize: notifier.custFontSize >
                        //                               20
                        //                           ? notifier.custFontSize + 10
                        //                           : notifier.custFontSize),
                        //                   value: _selectedPin,
                        //                   icon: const Icon(Icons.category),
                        //                   hint: Text('Select Pincode',
                        //                       style: TextStyle(
                        //                           color: Colors.grey)),
                        //                   items: _category
                        //                       .map((category) =>
                        //                           DropdownMenuItem<String>(
                        //                             value: category,
                        //                             child: Text(
                        //                               category,
                        //                               style: TextStyle(
                        //                                   fontSize: notifier
                        //                                       .custFontSize),
                        //                             ),
                        //                           ))
                        //                       .toList(),
                        //                   onChanged: (input) {
                        //                     setState(() {
                        //                       _selectedPin = input;
                        //                     });
                        //                   },
                        //                   onSaved: (input) {
                        //                     _selectedPin = input;
                        //                   },
                        //                   validator: (value) {
                        //                     if (value == null) {
                        //                       return "Please select event type";
                        //                     }
                        //                     return null;
                        //                   },
                        //                 );
                        //               }
                        //               return Container();
                        //             })),
                        Consumer<ThemeNotifier>(
                          builder: (context, notifier, child) => Container(
                            padding: EdgeInsets.only(top: 30),
                            //TODO:added search bar
                            child: CSCPicker(
                              disabled: notifier.darkTheme ? false : true,
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
                                getPinCode(eventrequest.city);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) =>
                          TextFormField(
                            style: TextStyle(fontSize: notifier.custFontSize),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            readOnly: true,
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
                                  if (eventrequest.country == null) {
                                    return "Please select country, state & city";
                                  }
                              return null;
                            },
                          ),
                    ),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => TextFormField(
                          style: TextStyle(fontSize: notifier.custFontSize),
                          keyboardType: TextInputType.number,
                          controller: pincodeController,
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
                                  fontSize: notifier.custFontSize),
                              labelStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: notifier.custFontSize)),
                          onSaved: (input) {
                            eventrequest.pincode = int.parse(input);
                          },
                          validator: validatePin),
                    ),
                    new Container(margin: const EdgeInsets.only(top: 40)),
                    Consumer<ThemeNotifier>(
                      builder: (context, notifier, child) => Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          MaterialButton(
                            color: KirthanStyles.colorPallete60,
                            child: Text(
                              "Back",
                              style: TextStyle(fontSize: notifier.custFontSize),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          MaterialButton(
                              child: Text(
                                //TODO:changed next to submit
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: notifier.custFontSize),
                              ),
                              color: KirthanStyles.colorPallete30,
                              onPressed:isDisabled?null: () async {
                                if (_formKey.currentState.validate()) {
                                  incrementCounter();
                                  final FirebaseUser user =
                                  await auth.currentUser();
                                  final String email = user.email;
                                  eventrequest.createdBy = email;
                                  print("created by " + eventrequest.createdBy);
                                  print(email);
                                  _formKey.currentState.save();
                                  List<CommonLookupTable> selectedCategory =
                                  await commonLookupTablePageVM
                                      .getCommonLookupTable("description:" +
                                      _selectedCategory);
                                  for (var i in selectedCategory)
                                    eventrequest.eventType = i.id;
                                  eventrequest.isPublicEvent = false;
                                  String dt =
                                  DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                      .format(DateTime.now());
                                  eventrequest.createdTime = dt;
                                  eventrequest.updatedBy = null;
                                  eventrequest.updatedTime = null;
                                  eventrequest.serviceType = "Free";

                                  Map<String, dynamic> teammap =
                                  eventrequest.toJson();
                                  EventRequest neweventrequest =
                                  await eventPageVM
                                      .submitNewEventRequest(teammap);

                                  print(neweventrequest.id);
                                  String eid = neweventrequest.id.toString();
                                  SnackBar mysnackbar = SnackBar(
                                    content: Text(
                                        "Event registered $successful"),
                                    duration: new Duration(seconds: 4),
                                    backgroundColor: Colors.green,
                                  );
                                  _scaffoldKey.currentState
                                      .showSnackBar(mysnackbar);
                                  new Future.delayed(const Duration(seconds: 3),
                                          () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => EventView()));
                                      });

                                }
                              })
                        ],
                      ),
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