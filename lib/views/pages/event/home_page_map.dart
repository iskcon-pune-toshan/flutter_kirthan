import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());

class MapPage extends StatefulWidget {
  @override
  EventRequest eventrequest ;
  final  bool isRadiusFixed;
  MapPage({Key key, @required this.eventrequest, this.isRadiusFixed}) : super(key: key);

  State<StatefulWidget> createState() => MapPageState();
}
class MapPageState extends State<MapPage> {
  bool mapToggle = false;
  bool locationToggle = false;
  bool resetToggle = false;
  var currentBearing;
  final Map<String, Marker> _markers = {};
  var filterdistance;
  Future<bool> latlng=eventPageVM.setEventRequests("");
/*Map<MarkerId,Marker> _marker=<MarkerId, Marker>{};
Map<MarkerId,Marker> get marker=> _marker;*/
  //Set<Marker> _markers = {};
List<Marker> myMarker=[];
  double _radius =  100 ;

  TextEditingController locationController = TextEditingController();
  static LatLng _initialPosition;
  static LatLng _destination;

  LatLng get initialPosition => _initialPosition;

  LatLng get destination => _destination;
  Set<Circle> _circles = HashSet<Circle>();
  Circle circlee;
  GoogleMapController mapController;

  Future loadData() async {
    await eventPageVM.setEventRequests("All");
  }
  resetCamera() {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: LatLng(19.119604, 74.736377), zoom: 10.0))).then((
        val) {
      setState(() {
        resetToggle = false;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Map'),

          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.filter_list),
              onPressed: getDist,

            )
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
                       //_markers.values.toSet(),
                        Set.from(myMarker),

                      initialCameraPosition: CameraPosition(
                          target: LatLng(0.0, 0.0), zoom: 16),

                    )
                        : Center(
                        child: Text(
                          'Loading.. Please wait..',
                          style: TextStyle(fontSize: 20.0),
                        ))),
                /*Positioned(
                    top: MediaQuery.of(context).size.height - 250.0,
                    left: 10.0,
                    child: Container(
                        height: 125.0,
                        width: MediaQuery.of(context).size.width,
                        child: !locationToggle
                            ? ListView(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(8.0),
                          */ /*children: locations.map((element) {
                            return clientCard(element);
                          }).toList(),*/ /*
                        )
                            : Container(height: 1.0, width: 1.0))),*/
              Positioned(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height -
                        (MediaQuery
                            .of(context)
                            .size
                            .height -
                            50.0),
                    right: 15.0,
                    child: FloatingActionButton(
                      onPressed: resetCamera,
                      mini: true,
                      backgroundColor: Colors.red,
                      child: Icon(Icons.refresh),
                    )),
                Positioned (
                  bottom :  20.0 ,
                  left :  10.0 ,
                  right :  10.0 ,
                  child :  Card (

                          child: Column (
                            children :  < Widget > [
                              Text (_radius.toInt (). toString () +  'Mtrs' ),
                              Slider (
                                max :  700 ,
                                min :  100 ,
                                value : _radius,
                                activeColor :  Colors .red,
                                inactiveColor :  Colors .grey,
                                divisions :  12 ,
                                onChanged : ( double value) {
                                  if ( ! widget.isRadiusFixed) {
                                   // _mapsBloc.add(UpdateRangeValues(radius: value));
                                  }
                                },
                              ),
                              FlatButton (
                                child :  Text (widget.isRadiusFixed!=  true
                                    ?  'Done'
                                    :  'Cancel' ),
                                onPressed : () => {

                                },
    //_mapsBloc.add(IsRadiusFixedPressed (
                                   // isRadiusFixed : widget.isRadiusFixed)),
                                color :
                                widget.isRadiusFixed!= true  ?  Colors .blue :  Colors .red,
                              )
                            ],
                          )
    ),
    ),







          ],
        ),
                          ]),
    );
    // these are the minimum required values to set
    // the camera position


    /*return GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        compassEnabled: true,
        //markers: Set<Marker>.of(markers.values),
        initialCameraPosition: CameraPosition(
            target: LatLng(0.0,0.0), zoom: 16),
        onMapCreated:_onMapCreated,
        circles: _circles,
        //Set.of((circlee !=null)? [circlee] :[] ),
    );*/
  }


  handleTap(LatLng tappedPoint){
    print(tappedPoint);
    setState(() {
      myMarker=[];
      myMarker.add(
        Marker(markerId: MarkerId(tappedPoint.toString()),
        position: tappedPoint,
        )
      );
    });
  }
    void onMapCreated(controller) {
      setState(() {
        mapController = controller;

          _markers.clear();

            final marker = Marker(
              markerId: MarkerId('Janmasthami'),
              position: LatLng(18.522066, 73.931325),
              infoWindow: InfoWindow(
                title: 'Janmasthami',
                //snippet: office.address,
              ),
            );
        final marker2 = Marker(
          markerId: MarkerId('Deepavali'),
          position: LatLng(20.687342, 77.022517),
          infoWindow: InfoWindow(
            title: 'Deepavali',
            //snippet: office.address,
          ),
        );
        final marker3 = Marker(
          markerId: MarkerId('Navaratri'),
          position: LatLng(18.949492, 72.795886),
          infoWindow: InfoWindow(
            title: 'Navaratri',
            //snippet: office.address,
          ),
        );
        final marker4 = Marker(
          markerId: MarkerId('Rama Navami'),
          position: LatLng(19.119721, 74.736376),
          infoWindow: InfoWindow(
            title: 'Rama Navami',
            //snippet: office.address,
          ),
        );
            _markers['Janmasthami'] = marker;
            _markers['Deepavali']=marker2;
            _markers['Navaratri']=marker3;
            _markers['Rama Navami']=marker4;

        });

    }
  Future<bool> getDist(){
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context){
          return AlertDialog(
            title: Text('Enter Distance in Km'),
            contentPadding: EdgeInsets.all(8.0),
            content: TextField(
              decoration: InputDecoration(hintText: 'Enter Distance'),
              onChanged: (val){
                setState(() {
                  filterdistance=val;
                });
              },
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                color: Colors.transparent,
                textColor: Colors.blue,
                onPressed: (){
                  //filterMarkers(filterdistance);
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );
  }
  Future<void> _onMapCreated(GoogleMapController controller) async {
    var title = widget.eventrequest?.eventTitle;
    final query = widget.eventrequest?.addLineOne +
        widget.eventrequest?.addLineTwo + widget.eventrequest?.locality +
        widget.eventrequest?.city + widget.eventrequest.state;
    print('object');
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print(query);
    double lat = 19.119604;
    double long = 74.736377;
    _destination = LatLng(lat, long);
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(_initialPosition.latitude, _initialPosition.longitude),
          zoom: 16,
          tilt: 50.0,
          bearing: 45.0,))

    );
    List<Placemark> destinationplacemark = await geolocator.Geolocator()
        .placemarkFromCoordinates(destination.latitude, destination.longitude);
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print(
        "the latitude is: ${position.longitude} and th longitude is: ${position
            .longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    locationController.text = placemark[0].name;
    Position startCoordinates = placemark[0].position;
    Position destinationCoordinates = destinationplacemark[0].position;





    /*  print('circle');


        }
        @override
        void initstate(){
    super.initState();
    _setcircles();
        }
void _setcircles(){
  _circles.add(Circle(circleId: CircleId(""),
    radius: 5000.0,
    center: LatLng(initialPosition.latitude,initialPosition.longitude),
    fillColor:Color.fromARGB(70, 150, 50, 50) ,
    strokeWidth: 2,
    strokeColor: Color.fromARGB(70, 150, 50, 50),
    zIndex: 1,
  ));
  print('object');
}*/
  }
  //filter markers according to the dist entered
  /*filterMarker(dist){
    for(int i=0;i<data.length;i++){
      geolocator.Geolocator().distanceBetween(startLatitude, startLongitude, endLatitude, endLongitude).then((caldist){
        if(
          caldist/1000<double.parse(dist)
        ){
          //clear markers and mark only thoses marker which are within distance
        }

      }
    }*/

  }



