import  'dart:async' ;
import  'package:bloc/bloc.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/LocationModel.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/RadiusModel.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';

import  'package:flutter/material.dart' ;
import 'package:flutter_kirthan/views/pages/event/home_page_map/MapsEvent.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/MapsState.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:great_circle_distance/great_circle_distance.dart';
import 'package:location/location.dart';
import  'package:flutter/services.dart' ;


class MapsBloc extends Bloc<MapsEvent, MapsState> {
  @override
  MapsState get initialState => InitialMapsState();

  @override
  Stream<MapsState> mapEventToState(
      MapsEvent event,
      ) async* {
    if (event is MapTypeButtonPressed) {
      yield* _mapTypeButtonPressedToState(event.currentMapType);
    } else if (event is GetUserLocationPressed) {
      yield* _mapGetLocationToState();
    } else if (event is GenerateMarkerWithRadius) {
      yield* _mapGenerateMarkerwithRadiusToMap(
          event.lastPosition, event.radius);
    } else if (event is UpdateRangeValues) {
      yield* _mapUpdateRangeValues(event.radius);
    } else if (event is IsRadiusFixedPressed) {
      yield* _mapRadiusFixedToMap(event.isRadiusFixed);
    } else if (event is GenerateMarkerToCompareLocation) {
      yield* _mapGenerateMarkerToCompareToMap(
          event.mapPosition, event.radiusLocation, event.radius);
    } else if (event is FetchPlaceFromAddressPressed) {
      yield* _mapFetchPlaceFromAdrressToMap(event.place);
    }
  }

  Stream<MapsState> _mapTypeButtonPressedToState(MapType _maptype) async* {
    try {
      yield Loading();
      if (_maptype == MapType.normal) {
        yield MapTypeChanged(mapType: MapType.satellite);
      } else {
        yield MapTypeChanged(mapType: MapType.normal);
      }
    } catch (_) {
      yield Failure();
    }
  }

  Stream<MapsState> _mapGetLocationToState() async* {
    try {
      yield Loading();
      var _locationService = new Location();
      LocationData _currentLocation = await _locationService.getLocation();

      yield LocationUserfound(
          locationModel: LocationModel(
              lat: _currentLocation.latitude,
              long: _currentLocation.longitude));
    } on PlatformException catch (_) {
      yield Failure();
    }
  }

  Stream<MapsState> _mapGenerateMarkerwithRadiusToMap(
      LatLng _position, double _radius) async* {
    try {
      yield Loading();
      Marker _marker = Marker(
        markerId: MarkerId(_position.toString()),
        position: _position,
        infoWindow: InfoWindow(
          title: 'Radius is $_radius Mts',
        ),
        icon: BitmapDescriptor.defaultMarker,
      );
      Circle _circle = Circle(
        circleId: CircleId(_position.toString()),
        center: _position,
        radius: _radius,
        fillColor: Color(1778384895),
        strokeColor: Colors.red,
      );

      yield MarkerWithRadius(
          raidiusModel: RadiusModel(marker: _marker, circle: _circle));
    } catch (_) {
      yield Failure();
    }
  }

  Stream<MapsState> _mapUpdateRangeValues(double _radius) async* {
    yield Loading();
    double _zoom;
    if (_radius >= 1000 && _radius < 2000) {
      _zoom = 17;
    } else if (_radius >= 2000 && _radius < 3000) {
      _zoom = 16.5;
    } else if (_radius >= 3000 && _radius<4000) {
      _zoom = 16;
    }else if (_radius >= 4000 && _radius<5000) {
      _zoom = 15.5;
    } else if (_radius >= 5000 && _radius<6000){
      _zoom = 15;
    } else if (_radius >= 6000 && _radius < 7000){
      _zoom = 14.5;
    } else if (_radius >= 7000 && _radius < 8000) {
      _zoom = 14;
    } else if (_radius>= 8000 && _radius <9000) {
      _zoom = 13.5;
    } else if (_radius>= 9000 && _radius <10000) {
      _zoom = 13;
    }
      else
      _zoom=12.5;
    yield RadiusUpdate(radius: _radius, zoom: _zoom);
  }

  Stream<MapsState> _mapRadiusFixedToMap(bool _isRadiusFixed) async* {
    if (_isRadiusFixed)
      yield RadiusFixedUpdate(radiusFixed: false);
    else
      yield RadiusFixedUpdate(radiusFixed: true);
  }

  Stream<MapsState> _mapGenerateMarkerToCompareToMap(
      LatLng _mapPostion, LatLng _radiusPostion, double _radius) async* {
    try {
      yield Loading();
      String message;
      Color colorSnack;
      var gcd = new GreatCircleDistance.fromDegrees(
          latitude1: _radiusPostion.latitude,
          longitude1: _radiusPostion.longitude,
          latitude2: _mapPostion.latitude,
          longitude2: _mapPostion.longitude);
      if (_radius >= gcd.haversineDistance()) {
        message =
        'Location is in range ${gcd.haversineDistance().toInt()} Mts';
        colorSnack = Colors.green;
      } else {
        message =
        'Location is out of range ${gcd.haversineDistance().toInt()} Mts';
        colorSnack = Colors.red;
      }
      final _snackbar = SnackBar(
          content: Text(message),
          duration: Duration(seconds: 3),
          backgroundColor: colorSnack);

      final _marker = Marker(
        markerId: MarkerId(_mapPostion.toString()),
        position: _mapPostion,
        infoWindow: InfoWindow(
          title: '${gcd.haversineDistance().toInt()} Mts radius',
        ),
        icon: colorSnack == Colors.green
            ? BitmapDescriptor.defaultMarkerWithHue(130.0)
            : BitmapDescriptor.defaultMarker,
      );
      yield MarkerWithSnackbar(marker: _marker, snackBar: _snackbar);
    } catch (_) {
      yield Failure();
    }
  }

  Stream<MapsState> _mapFetchPlaceFromAdrressToMap(String _place) async* {
    try {
      yield Loading();
      var addresses = await Geocoder.local.findAddressesFromQuery(_place);
      if (addresses != null && addresses.first != null) {
        var first = addresses.first;
        yield LocationFromPlaceFound(
            locationModel: LocationModel(
                name: first.featureName,
                address: first.addressLine,
                lat: first.coordinates.latitude,
                long: first.coordinates.longitude));
      }
    } catch (_) {
      yield Failure();
    }
  }
}
