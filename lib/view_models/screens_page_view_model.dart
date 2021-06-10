// import 'dart:async';
// import 'package:meta/meta.dart';
// import 'package:flutter_kirthan/services/screens_service_interface.dart';
// import 'package:scoped_model/scoped_model.dart';
// import 'package:flutter_kirthan/models/screens.dart';
//
//
// class ScreensPageViewModel extends Model {
//   final IScreensRestApi apiSvc;
//
//   ScreensPageViewModel({@required this.apiSvc});
//   Map<String,bool> accessTypes;
//
//   Future<List<Screens>> _screensrequests;
//   Future<List<Screens>> get screensrequests => _screensrequests;
//
//   set screensrequests(Future<List<Screens>> value) {
//     _screensrequests = value;
//     notifyListeners();
//   }
//
//
//   Future<bool> setScreens(String userType) async {
//     screensrequests = apiSvc?.getScreens(userType);
//     return screensrequests != null;
//   }
//
//   Future<List<Screens>> getScreens(String userType) {
//     Future<List<Screens>> usersreqs = apiSvc?.getScreens(userType);
//     return usersreqs;
//   }
//
//
//   Future<Screens> submitNewScreens(Map<String, dynamic> userrequestmap) {
//     Future<Screens> userrequest = apiSvc?.submitNewScreens(userrequestmap);
//     return userrequest;
//   }
//
//
//   Future<bool> deleteScreens(Map<String, dynamic> processrequestmap) {
//     Future<bool> deleteFlag = apiSvc?.deleteScreens(processrequestmap);
//     return deleteFlag;
//   }
//
//
//   Future<bool> submitUpdateScreens(String userrequestmap) {
//     Future<bool> updateFlag = apiSvc?.submitUpdateScreens(userrequestmap);
//     return updateFlag;
//   }
//
//
// }