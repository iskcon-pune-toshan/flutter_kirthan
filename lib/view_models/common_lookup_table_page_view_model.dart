import 'dart:async';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_interface.dart';
import 'package:meta/meta.dart';
import 'package:scoped_model/scoped_model.dart';

class CommonLookupTablePageViewModel extends Model {
  final ICommonLookupTableRestApi apiSvc;

  CommonLookupTablePageViewModel({@required this.apiSvc});
  Map<String, bool> accessTypes;

  Future<List<CommonLookupTable>> _rolesrequests;
  Future<List<CommonLookupTable>> get rolesrequests => _rolesrequests;

  set rolesrequests(Future<List<CommonLookupTable>> value) {
    _rolesrequests = value;
    notifyListeners();
  }

  Future<bool> setCommonLookupTable(String userType) async {
    rolesrequests = apiSvc?.getCommonLookupTable(userType);
    return rolesrequests != null;
  }

  Future<List<CommonLookupTable>> getCommonLookupTable(String userType) {
    Future<List<CommonLookupTable>> usersreqs =
        apiSvc?.getCommonLookupTable(userType);
    return usersreqs;
  }

  Future<CommonLookupTable> submitNewRoles(
      Map<String, dynamic> userrequestmap) {
    Future<CommonLookupTable> userrequest =
        apiSvc?.submitNewCommonLookupTable(userrequestmap);
    return userrequest;
  }

  Future<bool> deleteCommonLookupTable(Map<String, dynamic> processrequestmap) {
    Future<bool> deleteFlag =
        apiSvc?.deleteCommonLookupTable(processrequestmap);
    return deleteFlag;
  }

  Future<bool> submitUpdateCommonLookupTable(String userrequestmap) {
    Future<bool> updateFlag =
        apiSvc?.submitUpdateCommonLookupTable(userrequestmap);
    return updateFlag;
  }
}
