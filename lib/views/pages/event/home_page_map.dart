
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/MapsState.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/SearchWidget.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoder/geocoder.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
List<EventRequest> eventRequest;
class MapPage extends StatefulWidget {
  EventRequest eventrequest;

  MapPage({Key key, @required this.eventrequest}) : super(key: key);

  @override
  LocationMark createState() => LocationMark();
}

class LocationMark extends State<MapPage> {
  String _placeDistance;
  TextEditingController locationController = TextEditingController();
  static LatLng _initialPosition;
  static LatLng _destination;
  final Set<Marker> listMarkers = {};
  BitmapDescriptor customIcon;

  LatLng get initialPosition => _initialPosition;

  LatLng get destination => _destination;

  GoogleMapController _controller;

  GoogleMapController get controller => _controller;

  Map<PolylineId, Polyline> get polylines => _polylines;

  List<LatLng> _polylineCoordinates = [];

  List<LatLng> get polylineCoordinates => _polylineCoordinates;

  PolylinePoints _polylinePoints;

  PolylinePoints get polylinePoints => _polylinePoints;
  String _googleAPIKey = "AIzaSyAP-fPygrSTNBltu-IwiVmnIiCq35IDl5M";

  String get apiKey => _googleAPIKey;
  Map<PolylineId, Polyline> _polylines = {};
  @override
  final Map<String, Marker> _markers = {};

  void initState() {
    //getloc();
    super.initState();
  }
  //Set<Marker> _markers = {};
  //final Map<String, Marker> _markerss = {};
/*  getloc() async {
    double lat;
    double long;
    if (widget.eventrequest?.latitudeS == null) {
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
    else {
      lat = widget.eventrequest.latitudeS;
      long = widget.eventrequest.longitudeS;
      print("else part exceuted");
    }
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best);
    List<Placemark> placemark = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    _initialPosition = LatLng(position.latitude, position.longitude);
    print(_initialPosition.longitude);
    print("locationssss");
  }*/
  _onMapCreated(GoogleMapController controller) async {
    eventRequest = await eventPageVM.getEventRequests("All");

      for (var eventName in eventRequest) {
        print("length is");
        print(eventRequest.length);
        double lat;
        double long;
        if (eventName.latitudeS == null) {
          final query = eventName.addLineOneS+
              eventName.addLineTwoS+
              eventName.localityS+
              eventName.city+
              eventName.state;
          var addresses = await Geocoder.local.findAddressesFromQuery(query);
          var first = addresses.first;
          print(query);
          lat = first.coordinates.latitude;
          long = first.coordinates.longitude;
        }
        else {
          lat = eventName.latitudeS;
          long = eventName.longitudeS;
          print("else part exceuted");
        }
        Position position = await Geolocator()
            .getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.best);
        List<Placemark> placemark = await Geolocator()
            .placemarkFromCoordinates(position.latitude, position.longitude);
        _initialPosition = LatLng(position.latitude, position.longitude);
        print(_initialPosition.longitude);
        print("locationssss");
        controller.animateCamera(
          CameraUpdate.newCameraPosition(CameraPosition(
              target: LatLng(_initialPosition.latitude,_initialPosition.longitude), zoom: 12))
          /*.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(_initialPosition, northEastLongitude),
              southwest: LatLng(southWestLatitude, southWestLongitude),
            ),
            100.0,
          ),*/
        );
String id=eventName.id.toString();
        setState(() {
          listMarkers.add(Marker(
              markerId: MarkerId(id),
              position: LatLng(lat, long),
              infoWindow: InfoWindow(title: eventName.eventTitle),
              icon: customIcon
          ));
        });
        print('length of markerssss');
        print(listMarkers.length);
      }
  }






  Widget _buildGoogleMap()  {

    return Container(
      //   margin: EdgeInsets.only(top: 80, right: 10),
      alignment: Alignment.topRight,

      child: GoogleMap(
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        mapType: MapType.normal,
        initialCameraPosition:
        CameraPosition(
            target: LatLng(17,22), zoom: 16),
        onMapCreated: _onMapCreated,
        markers: listMarkers,
        //polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }

    MapType currentMapType = MapType.normal;

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


          ],
        ),
      ),
    );
  }
}
