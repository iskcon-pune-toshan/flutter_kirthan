import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:geocoder/geocoder.dart';
final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
class LocationModel {
  EventRequest eventrequest;
  int id;
  String name;
  String address;
  double lat;
  double long;
  LocationModel({this.eventrequest,this.id, this.name, this.address, this.lat, this.long});
  @override
  String toString() {
    eventPageVM.setEventRequests('All');
    address="Ahmednagar";
    return 'LocationModel { name: $name, address: $address, lat: $lat, long: $long}';
  }
}