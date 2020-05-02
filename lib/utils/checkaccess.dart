import 'package:flutter_kirthan/models/user.dart';

class CheckAccess {

  UserEntitlements getAccessForScreen(List<UserAccess> entitlements, UserLogin user, String screenName) {
    UserEntitlements userEntitlements = UserEntitlements();
    UserAccess userAccess = entitlements.singleWhere((access) => access.userType == user.usertype);
    //Map<String,List<String>> userRole = userAccess.role;

    userEntitlements.dataEntitlements = userAccess.dataEntitlement;
    userEntitlements.screenName = screenName;
    userEntitlements.screenAccess = userAccess.role[screenName];
    return userEntitlements;
  }

}