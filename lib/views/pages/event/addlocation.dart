import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_kirthan/views/pages/event/addlocation.dart';
class AddLocation extends StatefulWidget {
  @override
  EventRequest eventrequest ;

  AddLocation({Key key, @required this.eventrequest}) : super(key: key);

  State<StatefulWidget> createState() => MapPageState();
}
class MapPageState extends State<AddLocation> {
  bool mapToggle = false;
  bool locationToggle = false;
  bool resetToggle = false;

  List<Marker> myMarker=[];
  List<Marker> get markers => myMarker;

  TextEditingController locationController = TextEditingController();

  GoogleMapController mapController;

  LatLng tappedPoint1,tappedPoint2;

  @override
  Widget build(BuildContext context) {
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

                handleTap(tappedPoint1);
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
  handleTap(LatLng tappedPoint1){
    print(tappedPoint1);
    //print(tappedPoint2);
    setState(() {

      myMarker=[];

      myMarker.add(
          Marker(markerId: MarkerId(tappedPoint1.toString()),
            infoWindow: InfoWindow(
              title: 'Event Location') ,
            position: tappedPoint1,
          ),
      );
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


  }





