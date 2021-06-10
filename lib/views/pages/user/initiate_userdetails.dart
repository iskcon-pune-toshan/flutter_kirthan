import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class InitiateUserDetails extends StatefulWidget {
  String UserName;
  InitiateUserDetails({this.UserName});
  @override
  _InitiateUserDetailsState createState() =>
      _InitiateUserDetailsState(UserName);
}

class _InitiateUserDetailsState extends State<InitiateUserDetails> {
  FirebaseUser user;
  UserRequest userRequest;
  String UserName;
  _InitiateUserDetailsState(this.UserName);
  String Email;
  int Phone;
  String photoUrl;
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  int superId;
  int prev_role_id;

  void loadPref() async {
    SignInService().firebaseAuth.currentUser().then((onValue) {
      photoUrl = onValue.photoUrl;
      // print(photoUrl);
    });
    //print(userdetails.length);
  }

  @override
  void initState() {
    Users = userPageVM.getUserRequests('Approved');
    getSuperAdminId();
    super.initState();
  }

  Widget ProfilePages() {
    return FutureBuilder<List<UserRequest>>(
        future: Users,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            userList = snapshot.data;
            for (var uname in userList)
              if (uname.fullName == UserName) {
                String _email = uname.email;
                String _photoName = _email + '.jpg';
                // print("*******" + _photoName + "*********");
                final ref = FirebaseStorage.instance.ref().child(_photoName);
                return FutureBuilder(
                    future: ref.getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return new Image.network(snapshot.data,
                            fit: BoxFit.fill);
                      }
                      return Image.asset(
                        "assets/images/default_profile_picture.png",
                        fit: BoxFit.fill,
                      );
                    });
              }
          }
          return Image.asset(
            "assets/images/default_profile_picture.png",
            fit: BoxFit.fill,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<UserRequest>>(
            future: Users,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                userList = snapshot.data;

                // print("lllll");
                // print(user.email);
                String _email = user.email;
                // print(_email);
                for (var _users in userList) {
                  // print("GGGG");
                  // print(_users.email);
                  if (_users.email == _email) {
                    superId = _users.id;
                  } else {
                    //  print("BYEBYE");
                  }
                }
                for (var uname in userList) {
                  if (uname.fullName == UserName) {
                    Email = uname.email;
                    Phone = uname.phoneNumber;
                    prev_role_id = uname.roleId;
                    return Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 0),
                              color: Colors.white,
                              width: MediaQuery.of(context).size.width,
                              height:
                                  (MediaQuery.of(context).size.height / 4) + 40,
                              child: Image.asset(
                                "assets/images/profile_back.jfif",
                                fit: BoxFit.fill,
                              ),
                            ),
                            Divider(
                              thickness: 2,
                              height: 0,
                              color: KirthanStyles.colorPallete30,
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20,
                              MediaQuery.of(context).size.height / 4, 20, 0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  decoration: BoxDecoration(
                                      //color: Colors.grey[700],
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: IntrinsicHeight(
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        UserName,
                                                        style: TextStyle(
                                                            fontSize: 20,
                                                            fontFamily:
                                                                'OpenSans'),
                                                      ),
                                                      VerticalDivider(
                                                        color: Colors.white,
                                                        thickness: 2,
                                                        width: 30,
                                                      ),
                                                      Text(
                                                        uname.roleId == 1
                                                            ? "Super Admin"
                                                            : uname.roleId == 2
                                                                ? "Local Admin"
                                                                : "User",
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.w800,
                                                            fontFamily:
                                                                'OpenSans'),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  Email,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontFamily: 'OpenSans'),
                                                ),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                Phone.toString(),
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontFamily: 'OpenSans'),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      CircleAvatar(
                                        radius: 43,
                                        backgroundColor:
                                            KirthanStyles.colorPallete30,
                                        child: CircleAvatar(
                                          radius: 40,
                                          //backgroundColor: Colors.white,
                                          child: ClipOval(
                                            child: new SizedBox(
                                              width: 100.0,
                                              height: 100.0,
                                              child: (photoUrl != null)
                                                  ? Image.network(
                                                      photoUrl,
                                                      fit: BoxFit.contain,
                                                    )
                                                  : ProfilePages(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  cursorColor: Colors.white,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 0.0),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Colors.white, width: 1.0),
                                    ),
                                    //fillColor: Colors.grey[700],
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white,
                                            style: BorderStyle.solid)),
                                    hintText: 'Add a message',
                                  ),
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              uname.roleId != 2
                                  ? Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.grey[300]
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight),
                                      ),
                                      child: FlatButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Text(
                                            'Make Local Admin',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: 'OpenSans'),
                                          ),
                                          onPressed: () {
                                            userRequest = uname;
                                            print("Printing user request");
                                            print(prev_role_id);
                                            // print(userRequest);
                                            setState(() {
                                              // print("ooooo");
                                              userRequest.roleId = 2;
                                              userRequest.prevRoleId =
                                                  prev_role_id;
                                              // print("JJJJJJ");
                                              // print(superId);
                                              userRequest.invitedBy = superId;
                                            });

                                            String userrequestStr = jsonEncode(
                                                userRequest.toStrJson());
                                            userPageVM.submitUpdateUserRequest(
                                                userrequestStr);
                                            SnackBar mysnackbar = SnackBar(
                                              content: Text(
                                                  UserName + " is now Admin"),
                                              duration:
                                                  new Duration(seconds: 4),
                                              backgroundColor: Colors.white,
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(mysnackbar);
                                          }),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        gradient: LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Colors.grey[300]
                                            ],
                                            begin: Alignment.centerLeft,
                                            end: Alignment.centerRight),
                                      ),
                                      child: FlatButton(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 50, vertical: 10),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          color: Colors.white,
                                          child: Text(
                                            'Make User',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: 'OpenSans'),
                                          ),
                                          onPressed: () {
                                            print("Printing user request");
                                            print(prev_role_id);
                                            userRequest = uname;
                                            setState(() {
                                              userRequest.roleId = 3;
                                              userRequest.invitedBy = superId;
                                              userRequest.prevRoleId =
                                                  prev_role_id;
                                            });

                                            String userrequestStr = jsonEncode(
                                                userRequest.toStrJson());
                                            userPageVM.submitUpdateUserRequest(
                                                userrequestStr);
                                            SnackBar mysnackbar = SnackBar(
                                              content: Text(
                                                  UserName + " is now User"),
                                              duration:
                                                  new Duration(seconds: 2),
                                              backgroundColor: Colors.white,
                                            );
                                            Scaffold.of(context)
                                                .showSnackBar(mysnackbar);
                                          }),
                                    )
                            ],
                          ),
                        )
                      ],
                    );
                  }
                }
              }
              return Container();
            }),
      ),
    );
  }

  void getSuperAdminId() async {
    //print("helllloo");
    final FirebaseAuth auth = FirebaseAuth.instance;
    user = await auth.currentUser();
    //print("helo");
    //print(user.email);
  }
}
