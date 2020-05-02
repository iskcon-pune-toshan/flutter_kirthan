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

}