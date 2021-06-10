import 'dart:async';
import 'package:flutter_kirthan/models/eventuser.dart';
import 'package:flutter_kirthan/services/event_user_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class EventUserPageViewModel extends Model {
  Future<List<EventUser>> _eventUsers;
  final IEventUserRestApi apiSvc;

  Map<String, bool> accessTypes;

  EventUserPageViewModel({@required this.apiSvc});

  Future<List<EventUser>> get eventUsers => _eventUsers;

  set eventUsers(Future<List<EventUser>> value) {
    _eventUsers = value;
    notifyListeners();
  }

  Future<List<EventUser>> getEventTeamUserMappings() {
    Future<List<EventUser>> eventusers = apiSvc?.getEventTeamUserMappings();
    return eventusers;
  }

  Future<List<EventUser>> submitNewEventTeamUserMapping(
      List<EventUser> listofeventsermap, var callback) {
    Future<List<EventUser>> eventusers =
        apiSvc?.submitNewEventTeamUserMapping(listofeventsermap, callback);
    return eventusers;
  }

  Future<List<EventUser>> submitDeleteEventTeamUserMapping(
      List<EventUser> listofeventsermap) {
    Future<List<EventUser>> eventusers =
        apiSvc?.submitDeleteEventTeamUserMapping(listofeventsermap);
    return eventusers;
  }
}
