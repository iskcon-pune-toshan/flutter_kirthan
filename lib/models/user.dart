import 'package:scoped_model/scoped_model.dart';

class UserLogin {
  String username;
  String password;
  String usertype;

//Typically called form service layer to create a new user
  UserLogin({this.username, this.password, this.usertype});

//Typically called from the data_source layer after getting data from an external source.
  UserLogin.fromJson(Map<String, dynamic> map) {
    username = map['username'];
    password = map['password'];
    usertype = map['usertype'];
  }

//Typically called from service or data_source layer just before persisting data.
  //Here is the appropriate place to check data validity before persistence.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    //data['id'] = this.id;
    //data['userid'] = this.userid;
    data['username'] = this.username;
    data['password'] = this.password;
    data['usertype'] = this.usertype;
    return data;
  }

  // static List<UserLogin> getUsers() {
  //   List<UserLogin> users = List<UserLogin>();
  //   users.add(UserLogin(
  //       username: "manjunath_biji@yahoo.com", password: "", usertype: "Admin"));
  //   users.add(UserLogin(
  //       username: "srinivasvn84@gmail.com", password: "", usertype: "Admin"));
  //   users.add(UserLogin(
  //       username: "meetkashyap@outlook.com", password: "", usertype: "Team"));
  //   users.add(UserLogin(
  //       username: "writetoanuka@gmail.com", password: "", usertype: "User"));
  //   users.add(UserLogin(
  //       username: "janicem995@gmail.com",
  //       password: "",
  //       usertype: "Local Admin"));
  //   users.add(UserLogin(
  //       username: "vardhan.biji@yahoo.co.uk", password: "", usertype: "User"));
  //   users.add(UserLogin(
  //       username: "toshannimaidas@gmail.com", password: "", usertype: "User"));
  //   users.add(UserLogin(
  //       username: "parthprandas.rns@gmail.com",
  //       password: "",
  //       usertype: "User"));
  //   users.add(UserLogin(
  //       username: "afrah.17u278@viit.ac.in", password: "", usertype: "Admin"));
  //
  //   users.add(UserLogin(
  //       username: "nisha.khandelwal1225@gmail.com",
  //       password: "",
  //       usertype: "Admin"));
  //   return users;
  // }
}

class UserRequest extends Model {
  final int id;

  String uid;
  int roleId;
  int prevRoleId;
  String fullName;
  String password;

  //String userType;
  // String firstName;
  // String lastName;
  String email;
  int phoneNumber;
  String addLineOne;
  String addLineTwo;
  String addLineThree;
  String locality;
  String city;
  int pinCode;
  String state;
  String country;
  String govtIdType;
  String govtId;
  //bool isProcessed;
  String createdBy;
  String createdTime;
  String updatedBy;
  String updatedTime;
  String approvalStatus;
  String avatarUrl;
  int invitedBy;
  String profileUrl;

//Typically called form service layer to create a new user
  UserRequest(
      {this.id,
      this.uid,
      this.fullName,
      this.password,
      this.prevRoleId,
      this.roleId,
      // this.firstName,
      // this.lastName,
      this.email,
      this.phoneNumber,
      this.addLineOne,
      this.addLineTwo,
      this.addLineThree,
      this.locality,
      this.city,
      this.pinCode,
      this.state,
      this.country,
      this.govtIdType,
      this.govtId,
      //this.isProcessed,
      this.createdBy,
      this.createdTime,
      this.updatedBy,
      this.updatedTime,
      this.approvalStatus,
      this.avatarUrl,
      this.invitedBy,
      this.profileUrl});

//Typically called from the data_source layer after getting data from an external source.
  factory UserRequest.fromJson(Map<String, dynamic> data) {
    return UserRequest(
      id: data['id'],
      uid: data['uid'],
      fullName: data['fullName'],
      password: data['password'],
      prevRoleId: data['prevRoleId'],
      roleId: data['roleId'],
      // firstName: data['firstName'],
      // lastName: data['lastName'],
      email: data['email'],
      phoneNumber: data['phoneNumber'],
      addLineOne: data['addLineOne'],
      addLineTwo: data['addLineTwo'],
      addLineThree: data['addLineThree'],
      locality: data['locality'],
      city: data['city'],
      pinCode: data['pinCode'],
      state: data['state'],
      country: data['country'],
      govtIdType: data['govtIdType'],
      govtId: data['govtId'],
      //isProcessed: data['isProcessed'],
      createdBy: data['createdBy'],
      createdTime: data['createdTime'],
      updatedBy: data['updatedBy'],
      updatedTime: data['updatedTime'],
      approvalStatus: data['approvalStatus'],
      // approvalComments: data['approvalComments'],
      avatarUrl: data['avatarUrl'],
      invitedBy: data['invitedBy'],
      profileUrl: data['profileUrl'],
    );
  }

  factory UserRequest.fromMap(Map<String, dynamic> map) {
    return UserRequest(
      id: map['id'],
      uid: map['uid'],
      fullName: map['fullName'],
      password: map['password'],
      prevRoleId: map['prevRoleId'],
      roleId: map['roleId'],
      // firstName: map['firstName'],
      // lastName: map['lastName'],
      email: map['email'],
      phoneNumber: map['phoneNumber'],
      addLineOne: map['addLineOne'],
      addLineTwo: map['addLineTwo'],
      addLineThree: map['addLineThree'],
      locality: map['locality'],
      city: map['city'],
      pinCode: map['pinCode'],
      state: map['state'],
      country: map['country'],
      govtIdType: map['govtIdType'],
      govtId: map['govtId'],
      //isProcessed: map['isProcessed'],
      createdBy: map['createdBy'],
      createdTime: map['createdTime'],
      updatedBy: map['updatedBy'],
      updatedTime: map['updatedTime'],
      approvalStatus: map['approvalStatus'],
      //approvalComments: map['approvalComments'],
      avatarUrl: map['avatarUrl'],
      invitedBy: map['invitedBy'],
      profileUrl: map['profileUrl'],
    );
  }

//Typically called from service or data_source layer just before persisting data.
  //Here is the appropriate place to check data validity before persistence.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['fullName'] = this.fullName;
    data['password'] = this.password;
    data['prevRoleId'] = this.prevRoleId;
    data['roleId'] = this.roleId;
    // data['firstName'] = this.firstName;
    // data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phoneNumber'] = this.phoneNumber;
    data['addLineOne'] = this.addLineOne;
    data['addLineTwo'] = this.addLineTwo;
    data['addLineThree'] = this.addLineThree;
    data['locality'] = this.locality;
    data['city'] = this.city;
    data['pinCode'] = this.pinCode;
    data['state'] = this.state;
    data['country'] = this.country;
    data['govtIdType'] = this.govtIdType;
    data['govtId'] = this.govtId;
    //data['isProcessed'] = this.isProcessed;
    data['createdBy'] = this.createdBy;
    data['createdTime'] = this.createdTime;
    data['updatedBy'] = this.updatedBy;
    data['updatedTime'] = this.updatedTime;
    data['approvalStatus'] = this.approvalStatus;
    // data['approvalComments'] = this.approvalComments;
    data['avatarUrl'] = this.avatarUrl;
    data['invitedBy'] = this.invitedBy;
    data['profileUrl'] = this.profileUrl;
    return data;
  }

  Map toStrJson() {
    return {
      "id": this.id,
      "uid": this.uid,
      "fullName": this.fullName,
      "prevRoleId": this.prevRoleId,
      "roleId": this.roleId,
      "password": this.password,
      // "firstName": this.firstName,
      // "lastName": this.lastName,
      "email": this.email,
      "phoneNumber": this.phoneNumber,
      "addLineOne": this.addLineOne,
      "addLineTwo": this.addLineTwo,
      "addLineThree": this.addLineThree,
      "locality": this.locality,
      "city": this.city,
      "pinCode": this.pinCode,
      "state": this.state,
      "country": this.country,
      "govtIdType": this.govtIdType,
      "govtId": this.govtId,
      //"isProcessed": this.isProcessed,
      "createdBy": this.createdBy,
      "updatedBy": this.updatedBy,
      "updatedTime": this.updatedTime,
      "createdTime": this.createdTime,
      "approvalStatus": this.approvalStatus,
      // "approvalComments": this.approvalComments,
      "avatarUrl": this.avatarUrl,
      "invitedBy": this.invitedBy,
      "profileUrl": this.profileUrl,
    };
  }
}

class UserDetail {
  String firstname;
  String lastname;
  String username;

  UserDetail({this.firstname, this.lastname, this.username});

  static List<UserDetail> getUsers() {
    List<UserDetail> users = List<UserDetail>();
    users.add(UserDetail(
        firstname: "Manjunath",
        lastname: "Bijinepalli",
        username: "manjunath_biji"));
    users.add(UserDetail(
        firstname: "Kashyap", lastname: "Kale", username: "kashyap.kale"));
    users.add(
        UserDetail(firstname: "Janice", lastname: "M", username: "janice.m"));
    users.add(UserDetail(
        firstname: "Anuj", lastname: "Kakde", username: "anuj.kakde"));

    return users;
  }
}

class UserAccess {
  String userType;
  Map<String, List<String>> role;
  String dataEntitlement;

  List<String> _accessTypes = ["Create", "Edit", "Delete", "View", "Process"];
  List<String> _screenNames = [
    "Register User",
    "Forgot password",
    "Login screen",
    "Team",
    "Event",
    "Team-user",
    "Event-User",
    "Notification Hub"
  ];

  //List<String> roles = [];
  //List<Map<String,List<String>>> roles;
  static Map<String, List<String>> _userRole = {
    "Register User": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:false"
    ],
    "Forgot password": [
      "Create:true",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Login screen": [
      "Create:true",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Team": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Event": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:false"
    ],
    "Team-user": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Event-User": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Notification Hub": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:true"
    ],
  };

  static Map<String, List<String>> _teamRole = {
    "Register User": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:false"
    ],
    "Forgot password": [
      "Create:true",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Login screen": [
      "Create:true",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Team": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Event": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:false"
    ],
    "Team-user": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Event-User": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:false"
    ],
    "Notification Hub": [
      "Create:false",
      "Edit:false",
      "Delete:false",
      "View:false",
      "Process:true"
    ],
  };

  static Map<String, List<String>> _localAdminRole = {
    "Register User": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Forgot password": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Login screen": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Team": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Event": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Team-user": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Event-User": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Notification Hub": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ]
  };

  static Map<String, List<String>> _adminRole = {
    "Register User": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Forgot password": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Login screen": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Team": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Event": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Team-user": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Event-User": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ],
    "Notification Hub": [
      "Create:true",
      "Edit:true",
      "Delete:true",
      "View:true",
      "Process:true"
    ]
  };

  UserAccess({this.userType, this.role, this.dataEntitlement});

  static List<UserAccess> getUserEntitlements() {
    List<UserAccess> entitlements = List<UserAccess>();
    entitlements.add(UserAccess(
        userType: "Admin", role: _adminRole, dataEntitlement: "global"));
    entitlements.add(UserAccess(
        userType: "Local Admin",
        role: _localAdminRole,
        dataEntitlement: "location"));
    entitlements.add(
        UserAccess(userType: "Team", role: _teamRole, dataEntitlement: "team"));
    entitlements.add(
        UserAccess(userType: "User", role: _userRole, dataEntitlement: "self"));

    return entitlements;
  }
}

class UserEntitlements {
  List<String> _screenAccess;
  String _dataEntitlements;
  String _screenName;

  List<String> get screenAccess => _screenAccess;

  String get dataEntitlements => _dataEntitlements;

  String get screenName => _screenName;

  set dataEntitlements(String value) {
    _dataEntitlements = value;
  }

  set screenName(String value) {
    _screenName = value;
  }

  set screenAccess(List<String> value) {
    _screenAccess = value;
  }
}

class User {
  final String uid;
  User({this.uid});
}
