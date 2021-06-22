import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final UserTemplePageViewModel usertemplePageVM =
    UserTemplePageViewModel(apiSvc: UserTempleAPIService());
final TemplePageViewModel templePageVM =
    TemplePageViewModel(apiSvc: TempleAPIService());
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
  Temple templeRequest;
  UserTemple userTempleRequest;
  String UserName;
  _InitiateUserDetailsState(this.UserName);
  String Email;
  int Phone;
  String photoUrl;
  Future<List<UserRequest>> Users;
 // Future<List<Temple>> Temple;
  List<UserRequest> userList = new List<UserRequest>();
  List<Temple> templelist = new List<Temple>();
  List<UserTemple> usertemplelist = new List<UserTemple>();
  //List<Temple> templelist = new List<Temple>();
  int superId;
  int prev_role_id;
  String _selectedCategory;
  void loadPref() async {
    SignInService().firebaseAuth.currentUser().then((onValue) {
      photoUrl = onValue.photoUrl;
      // print(photoUrl);
    });
    //print(userdetails.length);
  }
  Future<List<Temple>> temples;
  @override
  void initState() {
    Users = userPageVM.getUserRequests('Approved');
    temples = templePageVM.getTemples("All");
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
  Temple _selectedTemple;
  FutureBuilder getTempleWidget() {
    return FutureBuilder<List<Temple>>(
        future: temples,
        builder:
            (BuildContext context, AsyncSnapshot<List<Temple>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: const CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Container(
                  //width: 20.0,
                  //height: 10.0,
                  child: Center(
                    child: DropdownButtonFormField<Temple>(
                      value: _selectedTemple,
                      icon: const Icon(Icons.supervisor_account),
                      hint: Text('Select Temple'),
                      items: snapshot.data
                          .map((team) => DropdownMenuItem<Temple>(
                        value: team,
                        child: Text(team.templeName),
                      ))
                          .toList(),
                      onChanged: (input) {
                        setState(() {
                          _selectedTemple = input;
                        });
                      },
                    ),
                  ),
                );
              } else {
                return Container(
                  width: 20.0,
                  height: 10.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
          }
        });
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder:(context, notifier, child)=> Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text('Profile',style: TextStyle(fontSize: notifier.custFontSize),),
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
                  String _email = user.email;
                  for (var _users in userList) {
                    if (_users.email == _email) {
                      superId = _users.id;
                    } else {
                      null;
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
                                                              fontSize: 4+notifier.custFontSize,
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
                                                              fontSize: notifier.custFontSize,
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
                                                        fontSize: notifier.custFontSize,
                                                        fontFamily: 'OpenSans'),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  Phone.toString(),
                                                  style: TextStyle(
                                                      fontSize: notifier.custFontSize,
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
                                  height: 60,
                                ),
                                if(uname.roleId==3||uname.roleId==4)
                            getTempleWidget(),
                                SizedBox(
                                  height: 60,
                                ),
                                uname.roleId != 2
                                    ? Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          color: KirthanStyles.colorPallete30
                                          // gradient: LinearGradient(
                                          //     colors: [
                                          //       Colors.white,
                                          //       Colors.grey[300]
                                          //     ],
                                          //     begin: Alignment.centerLeft,
                                          //     end: Alignment.centerRight),
                                        ),
                                        child: FlatButton(
                                          color:KirthanStyles.colorPallete30,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Text(
                                              'Make Local Admin',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: notifier.custFontSize,
                                                  fontFamily: 'OpenSans'),
                                            ),
                                            onPressed: () {

                                              userRequest = uname;
                                              print("Printing user request");
                                              print(prev_role_id);
                                              // print(userRequest);
                                              setState(() {
                                                // print("ooooo");
                                                //userTempleRequest.templeId = _selectedCategory.
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
                                                    UserName + " is now Admin",style: TextStyle(color: Colors.black),),
                                                duration:
                                                    new Duration(seconds: 4),
                                                backgroundColor: Colors.green,
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(mysnackbar);
                                               List<UserTemple> listofUserTemples = new List<UserTemple>();
                                                //for (var user in templelist) {
                                                  UserTemple userTemple = new UserTemple();
                                                  userTemple.templeId = _selectedTemple.id;
                                                  userTemple.userId = uname.id;
                                                  userTemple.roleId = 2;
                                                  //userTemple.userName = uname.fullName;
                                                 // userTemple.templeName = user.templeName;

                                                  listofUserTemples.add(
                                                      userTemple);
                                               // }
                                              usertemplePageVM.submitNewUserTempleMapping(listofUserTemples);
                                              SnackBar mysnackbar2 = SnackBar(
                                                content: Text(
                                                  "usertemple registered",style: TextStyle(fontSize: notifier.custFontSize),),
                                                duration:
                                                new Duration(seconds: 8),
                                                backgroundColor: Colors.white,
                                              );
                                              Scaffold.of(context)
                                                  .showSnackBar(mysnackbar2);
                                            }),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        //   gradient: LinearGradient(
                                        //       // colors: [
                                        //       //   Colors.white,
                                        //       //   Colors.grey[300]
                                        //       // ],
                                        //       begin: Alignment.centerLeft,
                                        //       end: Alignment.centerRight),
                                        ),
                                        child: FlatButton(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 50, vertical: 10),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            color: KirthanStyles.colorPallete30,
                                            child: Text(
                                              'Make User',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize:notifier.custFontSize,
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
                                                    UserName + " is now User",style: TextStyle(fontSize: notifier.custFontSize),),
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
