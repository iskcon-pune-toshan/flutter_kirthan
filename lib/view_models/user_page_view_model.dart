import 'dart:async';
import 'package:meta/meta.dart';
import 'package:flutter_kirthan/services/user_service_interface.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/models/user.dart';


class UserPageViewModel extends Model {
  final IUserRestApi apiSvc;

  UserPageViewModel({@required this.apiSvc});


  Future<List<UserRequest>> _userrequests;
  Future<List<UserRequest>> get userrequests => _userrequests;

  set userrequests(Future<List<UserRequest>> value) {
    _userrequests = value;
    notifyListeners();
  }


  Future<bool> setUserRequests(String userType) async {
    userrequests = apiSvc?.getUserRequests(userType);
    return userrequests != null;
  }

  Future<UserRequest> submitNewUserRequest(Map<String, dynamic> userrequestmap) {
    Future<UserRequest> userrequest = apiSvc?.submitNewUserRequest(userrequestmap);
    return userrequest;
  }

  Future<bool> processUserRequest(Map<String, dynamic> processrequestmap) {
    Future<bool> processFlag = apiSvc?.processUserRequest(processrequestmap);
    return processFlag;
  }

  Future<bool> deleteUserRequest(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag = apiSvc?.deleteUserRequest(processrequestmap);
    return deleteFlag;
  }

  Future<bool> submitUpdateUserRequest(String userrequestmap) {
    Future<bool> updateFlag = apiSvc?.submitUpdateUserRequest(userrequestmap);
    return updateFlag;
  }


}