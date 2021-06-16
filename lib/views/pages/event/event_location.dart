import 'dart:async';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';

class Location extends StatefulWidget {
  EventRequest eventrequest;

  Location({Key key, @required this.eventrequest}) : super(key: key);

  @override
  LocationMark createState() => LocationMark();
}

class LocationMark extends State<Location> {
  String _placeDistance;
  TextEditingController locationController = TextEditingController();
  static LatLng _initialPosition;
  static LatLng _destination;
  LatLng get initialPosition => _initialPosition;
  LatLng get destination => _destination;

  GoogleMapController _controller;
  GoogleMapController get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  List<LatLng> _polylineCoordinates = [];
  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  PolylinePoints _polylinePoints;
  PolylinePoints get polylinePoints => _polylinePoints;
  String _googleAPIKey = "AIzaSyBEva3nZLgwgCW9rjFm84ux0b3ZP_AERzk";
  String get apiKey => _googleAPIKey;
  Map<PolylineId, Polyline> _polylines = {};
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder:(content, notifier,child)=> Scaffold(
        appBar: AppBar(
          title: Text("Map",
          style: TextStyle(
            fontSize: notifier.custFontSize,
          ),),
        ),
        body: Stack(
          children: <Widget>[
            _buildGoogleMap(),
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Consumer<ThemeNotifier>(
                            builder: (context, notifier, child) => Text(
                              'DISTANCE: $_placeDistance km',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: notifier.custFontSize,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
CameraPosition initialcamera;
  Widget _buildGoogleMap() {
    //var title=widget.eventrequest?.eventTitle;

    return Container(
      //   margin: EdgeInsets.only(top: 80, right: 10),
      alignment: Alignment.topRight,

      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
            CameraPosition(target: LatLng(0.0, 0.0), zoom: 16),
        onMapCreated: _onMapCreated,
        markers: _markers,
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

  // final Map<String, Marker> _markers = {};
  Set<Marker> _markers = {};
  //final Map<String, Marker> _markerss = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    var title = widget.eventrequest?.eventTitle;
    double lat;
    double long;
if(widget.eventrequest?.latitudeS==null) {
  final query = widget.eventrequest?.addLineOneS +
      widget.eventrequest?.addLineTwoS +
      widget.eventrequest?.localityS +
      widget.eventrequest?.city +
      widget.eventrequest.state;
  var addresses = await Geocoder.local.findAddressesFromQuery(query);
  var first = addresses.first;
  print(query);
   lat = first.coordinates.latitude;
  long = first.coordinates.longitude;
}
else
  {
    lat=widget.eventrequest.latitudeS;
    long=widget.eventrequest.longitudeS;
    print("else part exceuted");
  }
    _destination = LatLng(lat, long);
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 16,
      tilt: 50.0,
      bearing: 45.0,
    )));
    List<Placemark> destinationplacemark = await geolocator.Geolocator()
        .placemarkFromCoordinates(destination.latitude, destination.longitude);
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print(
        "the latitude is: ${position.longitude} and th longitude is: ${position.longitude} ");
    print("initial position is : ${_initialPosition.toString()}");
    locationController.text = placemark[0].name;
    Position startCoordinates = placemark[0].position;
    Position destinationCoordinates = destinationplacemark[0].position;

    Position _northeastCoordinates;
    Position _southwestCoordinates;

// southwest coordinate <= northeast coordinate
    if (startCoordinates.latitude <= destinationCoordinates.latitude) {
      _southwestCoordinates = startCoordinates;
      _northeastCoordinates = destinationCoordinates;
    } else {
      _southwestCoordinates = destinationCoordinates;
      _northeastCoordinates = startCoordinates;
    }
    double miny = (startCoordinates.latitude <= destinationCoordinates.latitude)
        ? startCoordinates.latitude
        : destinationCoordinates.latitude;
    double minx = (startCoordinates.longitude <= destinationCoordinates.longitude)
        ? startCoordinates.longitude
        : destinationCoordinates.longitude;
    double maxy = (startCoordinates.latitude <= destinationCoordinates.latitude)
        ? destinationCoordinates.latitude
        : startCoordinates.latitude;
    double maxx = (startCoordinates.longitude <= destinationCoordinates.longitude)
        ? destinationCoordinates.longitude
        : startCoordinates.longitude;

    double southWestLatitude = miny;
    double southWestLongitude = minx;

    double northEastLatitude = maxy;
    double northEastLongitude = maxx;

// Accommodate the two locations within the
// camera view of the map
    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(northEastLatitude, northEastLongitude),
          southwest: LatLng(southWestLatitude, southWestLongitude),
        ),
        100.0,
      ),
    );
// camera view of the map (both locations)
  /* controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          northeast: LatLng(
            _northeastCoordinates.latitude,
            _northeastCoordinates.longitude,
          ),
          southwest: LatLng(
            _southwestCoordinates.latitude,
            _southwestCoordinates.longitude,
          ),
        ),
        100.0, // padding
      ),
   );*/
    double totalDistance = 0.0;
    await createPolylines(startCoordinates, destinationCoordinates);
    setState(() {
      _markers.clear();

      _markers.add(
        Marker(
          markerId: MarkerId(title),
          position: LatLng(lat, long),
          infoWindow: InfoWindow(
            title: title,
          ),
          //icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );

      for (int i = 0; i < polylineCoordinates.length - 1; i++) {
        totalDistance += _coordinateDistance(
          polylineCoordinates[i].latitude,
          polylineCoordinates[i].longitude,
          polylineCoordinates[i + 1].latitude,
          polylineCoordinates[i + 1].longitude,
        );
      }
      _placeDistance = totalDistance.toStringAsFixed(2);
      print('DISTANCE: $_placeDistance km');
    });

    //  double totalDistance = 0.0;

// Calculating the total distance by adding the distance
    for (int i = 0; i < polylineCoordinates.length - 1; i++) {
      totalDistance += _coordinateDistance(
        polylineCoordinates[i].latitude,
        polylineCoordinates[i].longitude,
        polylineCoordinates[i + 1].latitude,
        polylineCoordinates[i + 1].longitude,
      );
    }
  }

  createPolylines(Position start, Position destination) async {
    _polylinePoints = PolylinePoints();

    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      apiKey, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.driving,
    );

    // adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      PolylineId id = PolylineId('poly');

      // Polyline
      Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.red,
        points: polylineCoordinates,
        width: 4,
      );

      // polylines to the map
      polylines[id] = polyline;
    });
    // id of polylines
  }

  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}
