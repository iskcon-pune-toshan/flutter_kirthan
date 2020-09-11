import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_kirthan/views/pages/event/addlocation.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/addlocation.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());


class EventWrite extends StatefulWidget {
 // EventWrite({Key key}) : super(key: key);
  final String screenName = SCR_EVENT;
EventRequest eventrequest;

  @override
  _EventWriteState createState() => _EventWriteState();

  EventWrite({@required this.eventrequest});
}
class _EventWriteState extends State<EventWrite> {


  final _formKey = GlobalKey<FormState>();
  EventRequest eventrequest = new EventRequest();
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  List<String> _states = [ "Andhra Pradesh",
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
    "Puducherry"];

  List<String> _cities = ['Adilabad',
    'Anantapur',
    'Chittoor',
    'Kakinada',
    'Guntur',
    'Hyderabad'];
  String _selectedCity;
  String _selectedState;
  String _selectedCountry;


  List type=["Stationary","Moving"];

  String select;
  Row addRadioButton(int btnValue, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[

        Radio(
          activeColor: Theme.of(context).primaryColor,
          value: type[btnValue],
          groupValue: select,
          onChanged: (value){
            setState(() {
              print(value);
              select=value;
              eventrequest.statmoving=value;
              print('saved statmoving');
            });

          },
    ),


        Text(title)
      ],
    );

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Builder(builder: (context){
        return SingleChildScrollView(
          child: Container(
            color: Colors.redAccent,
            child: Center(
              child:Form(
                // context,
                key: _formKey,
                autovalidate: true,
                // readonly: true,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        margin: const EdgeInsets.only(top: 50)
                    ),

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

                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "eventTitle",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.title),
                            labelText: "Title",
                            hintText: "",
                          ),
                          onSaved: (input){
                            eventrequest.eventTitle = input;
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
                    ),

                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "Description",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.description),
                            labelText: "Description",
                            hintText: "",
                          ),
                          onSaved: (input){
                            eventrequest.eventDescription = input;
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
                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            Text("Select Event Date"),
                            DateTimeField(
                              format: DateFormat("yyyy-MM-dd"),
                              onShowPicker: (context, currentValue) {
                                return showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    initialDate: currentValue ?? DateTime.now(),
                                    lastDate: DateTime(2100));},
                              onSaved: (input){
                                eventrequest.eventDate = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(input).toString();
                              },
                              validator: (value) {
                                if(value.toString().isEmpty) {
                                  return "Please enter some text";
                                }
                                return null;
                              },
                            ),

                          ],
                        ),
                      ),
                      elevation: 5,
                    ),
                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "Duration",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.timelapse),
                            labelText: "Duration",
                            hintText: "",
                          ),
                          onSaved: (input){
                            eventrequest.eventDuration = input;
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
                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "Type",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.low_priority),
                            labelText: "Type",
                            hintText: "",
                          ),
                          onSaved: (input){
                            eventrequest.eventType = input;
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
                    ),
                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "PhoneNumber",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.phone_iphone),
                            labelText: "PhoneNumber",
                            hintText: "",
                          ),
                          onSaved: (input){
                            eventrequest.phoneNumber = int.parse(input);
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
                    ),
                    Card(
                      child: Column(
                        children: <Widget>[
                          Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                addRadioButton(0, 'Stationary'),
                                addRadioButton(1, 'Moving'),

                              ],
                            ),

                          ]),


                          RaisedButton.icon(
                            onPressed: () {
                             Navigator.push( context,MaterialPageRoute(
                                builder: (context) =>
                                    BlocProvider(
                                      create: (BuildContext context) => MapsBloc(),
                                      child:
                                      AddLocation(),
                                    ),
                              ),);


                            },

                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))),
                            label: Text('Add Location',
                              style: TextStyle(color: Colors.black),),
                            icon: Icon(Icons.location_on,
                              color:Colors.black,),
                            textColor: Colors.black,
                            splashColor: Colors.red,
                            color: Colors.white,
                          ),
                          TextFormField(
                            //attribute: "Address",
                            decoration: InputDecoration(
                              icon: const Icon(Icons.home),
                              labelText: "Address",
                              hintText: "",
                            ),
                            onSaved: (input){
                              eventrequest.addLineOne = input;
                            },
                            validator: (value) {
                              if(value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            //attribute: "line2",
                            decoration: InputDecoration(

                              labelText: "Line 2",
                              hintText: "",
                            ),
                            onSaved: (input){
                              eventrequest.addLineTwo = input;
                            },
                            validator: (value) {
                              if(value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            //attribute: "line3",
                            decoration: InputDecoration(

                              labelText: "Line 3",
                              hintText: "",
                            ),
                            onSaved: (input){
                              eventrequest.addLineThree = input;
                            },
                            validator: (value) {
                              if(value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },

                          ),
                          TextFormField(
                            //attribute: "locality",
                            decoration: InputDecoration(

                              labelText: "Locality",
                              hintText: "",
                            ),
                            onSaved: (input){
                              eventrequest.locality = input;
                            },
                            validator: (value) {
                              if(value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            //attribute: "PinCode",
                            decoration: InputDecoration(
                              labelText: "PinCode",
                              hintText: "",
                            ),
                            onSaved: (input){
                              eventrequest.pinCode = int.parse(input);
                            },
                            validator: (value) {
                              if(value.isEmpty) {
                                return "Please enter some text";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      elevation: 5,
                    ),



                    Card(
                      child: Column(
                        children: <Widget>[
                          DropdownButtonFormField<String>(
                            value: _selectedCity,
                            icon: const Icon(Icons.location_city),
                            hint: Text('Select City'),
                            items: _cities
                                .map((city) => DropdownMenuItem<String>(
                              value: city,
                              child: Text(city),
                            )).toList(),

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
                            hint: Text('Select State'),
                            items: _states
                                .map((state) => DropdownMenuItem(
                              value: state,
                              child: Text(state),
                            )).toList(),
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
                            hint: Text('Select Country'),
                            items: ['IND']
                                .map((country) => DropdownMenuItem(
                              value: country,
                              child: Text(country),
                            )).toList(),
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
                      elevation: 5,
                    ),




                    new Container(
                        margin: const EdgeInsets.only(top: 40)
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                            child: Text("Submit",style: TextStyle(color: Colors.white),),
                            color: Colors.blue,
                            onPressed: () async{

                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                eventrequest.isProcessed = false;
                                eventrequest.createdBy = "SYSTEM";
                                String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
                                eventrequest.createTime =  dt;
                                eventrequest.updatedBy = "SYSTEM";
                                eventrequest.updateTime = dt;
                                eventrequest.approvalStatus = "Approved";
                                eventrequest.approvalComments = "AAA";
                                Map<String,dynamic> eventmap = eventrequest.toJson();
                                EventRequest neweventrequest =await eventPageVM.submitNewEventRequest(eventmap);
                                print(neweventrequest.id);
                                String uid = neweventrequest.id.toString();
                                SnackBar mysnackbar = SnackBar (
                                  content: Text("Event registered $successful "),
                                  duration: new Duration(seconds: 4),
                                  backgroundColor: Colors.green,
                                );
                                Scaffold.of(context).showSnackBar(mysnackbar);
                              }
                              //String s = jsonEncode(userrequest.mapToJson());
                              //service.registerUser(s);
                              //print(s);
                            }
                        ),
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
        );}
      ),
    );
  }
  bool mapToggle = false;
  List<Marker> myMarker=[];
  List<Marker> get markers => myMarker;


  GoogleMapController mapController;

  LatLng tappedPoint1;
  LatLng get tappedPoint=>tappedPoint1;

  @override
  location(){
    return Scaffold(
        appBar: AppBar(
          title: Text('Location'),
          actions: <Widget>[
            IconButton(

              icon: Icon(Icons.refresh),
              onPressed:  () => {
                setState(() {
                  markers.clear();
                }),//setState
              },//onpressed
            ),

            IconButton(
              icon: Icon(Icons.done),
              onPressed: (){
                print('saved');

                // onsaved();

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
                    height: MediaQuery
                        .of(context)
                        .size
                        .height - 80.0,
                    width: double.infinity,
                    child: !mapToggle
                        ? GoogleMap(
                      myLocationButtonEnabled: true,
                      myLocationEnabled: true,
                      compassEnabled: true,
                      onMapCreated: onMapCreated,
                      onTap: handleTap,
                      markers:

                      Set.from(myMarker),

                      initialCameraPosition: CameraPosition(
                          target: LatLng(0.0, 0.0), zoom: 16),

                    )
                        : Center(
                        child: Text(
                          'Loading.. Please wait..',
                          style: TextStyle(fontSize: 20.0),
                        ))),





              ],
            )
          ],
        ));

  }
  handleTap(LatLng tappedPoint1) async{
    print(tappedPoint1);
    print('latitude is '+tappedPoint1.latitude.toString());
    print('longitude is '+tappedPoint1.longitude.toString());
/*    eventrequest.latitude=tappedPoint1.latitude.toString();
    eventrequest.longitude=tappedPoint1.longitude.toString();*/
    setState(() {

      myMarker=[];

      myMarker.add(
        Marker(markerId: MarkerId(tappedPoint1.toString()),
          infoWindow: InfoWindow(
              title: 'Event Location') ,
          position: tappedPoint1,
        ),
      );
      eventrequest.latitude=tappedPoint1.latitude.toString();
      eventrequest.longitude=tappedPoint1.longitude.toString();
      print('saved');

    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }
}

