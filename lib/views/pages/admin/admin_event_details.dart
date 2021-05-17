import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/notification.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/notification_service_impl.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/notification_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/notifications/notification_view.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());
final NotificationViewModel notificationPageVM =
    NotificationViewModel(apiSvc: NotificationManager());
int user_id;
String user_name;

class AdminEventDetails extends StatefulWidget {
  String UserName;
  EventRequest eventRequest;
  NotificationModel data;
  AdminEventDetails({Key key, this.UserName, this.eventRequest, this.data})
      : super(key: key);
  @override
  _AdminEventDetailsState createState() => _AdminEventDetailsState();
}

class _AdminEventDetailsState extends State<AdminEventDetails> {
  String currUserRole;
  String photoUrl;
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  UserRequest userrequest = new UserRequest();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  NotificationView ntf = new NotificationView();
  void loadPref() async {
    SignInService().firebaseAuth.currentUser().then((onValue) {
      photoUrl = onValue.photoUrl;
      print(photoUrl);
    });
    //print(userdetails.length);
  }

  @override
  void initState() {
    Users = userPageVM.getUserRequests('Approved');
    getUserId();
    super.initState();
  }

  int currentUserId;
  getUserId() async {
    final FirebaseUser user = await auth.currentUser();
    userList = await userPageVM.getUserRequests("Approved");
    for (var users in userList) {
      print("Role Id is");
      if (users.email == user.email) {
        setState(() {
          user_id = users.id;
          currentUserId = user_id;
        });
      }
    }
    //print(email);
    // print(role_id.toString());
  }

  Widget ProfilePages() {
    return FutureBuilder<List<UserRequest>>(
        future: Users,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            userList = snapshot.data;
            for (var uname in userList)
              if (uname.userName == widget.UserName) {
                String _email = uname.email;
                String _photoName = _email + '.jpg';
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

  bool UserRole(List<UserRequest> userList) {
    for (var user in userList) {
      // UserName = user.userName;
      print("In User Role function, role id is");
      print(user.roleId);
      if (user.roleId == 1) {
        currUserRole = "Admin";
      } else if (user.roleId == 2) {
        currUserRole = "Local Admin";
      } else if (user.roleId == 3) {
        currUserRole = "User";
      } else if (user.roleId == 4) {
        currUserRole = "Team lead";
      }
      print("Admin EVENT VIEW User role $currUserRole");
    }
    if (currUserRole != null)
      return true;
    else
      return false;
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // notificationPageVM.getNotificationsBySpec("Today");
      notificationPageVM.getNotifications();
    });

    return null;
  }

  Widget _buildNtf(NotificationModel data) {
    IconData icon;
    Widget actions = Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FlatButton(child: Icon(Icons.check)),
              FlatButton(child: Icon(Icons.close)),
            ]));

    if (data.action == null) {
      icon = null;
    } else {
      String val = data.action;
      val = val.toLowerCase();
      if (val == "rejected")
        icon = Icons.close;
      else if (val == "approved")
        icon = Icons.check;
      else
        icon = Icons.pause;
    }
    if (icon == Icons.pause)
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
            textColor: KirthanStyles.colorPallete60,
            color: KirthanStyles.colorPallete30,
            child: Text('Accept'),
            onPressed: () {
              notificationPageVM.updateNotifications(() {
                setState(() {
                  notificationPageVM.getNotifications();
                });
              }, data.uuid, true);
            },
          ),
          SizedBox(
            width: 10,
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              side: BorderSide(
                  color: Colors.grey[700], width: 1, style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(12),
            ),
            textColor: Colors.grey[700],
            child: Text('Reject'),
            onPressed: () {
              notificationPageVM.updateNotifications(() {
                setState(() {
                  notificationPageVM.getNotifications();
                });
              }, data.uuid, false);
            },
          ),
        ],
      );
    else if (icon == Icons.close || icon == Icons.check)
      return Center(
        child: icon == Icons.close
            ? Text(
                "Rejected",
                style: TextStyle(
                  color: Colors.red,
                ),
              )
            : Text(
                "Accepted",
                style: TextStyle(
                  color: Colors.green,
                ),
              ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
        title: Text(
          'Request received for ' + widget.eventRequest.eventTitle,
          style: TextStyle(color: KirthanStyles.colorPallete60),
        ),
        backgroundColor: KirthanStyles.colorPallete30,
      ),
      body: RefreshIndicator(
        key: refreshKey,
        child: Center(
          child: OrientationBuilder(
            builder: (context, orientation) => FutureBuilder<List<UserRequest>>(
                future: Users,
                builder: (context, snapshot) {
                  if (snapshot.data != null) {
                    userList = snapshot.data
                        .where(
                            (element) => element.email == widget.data.createdBy)
                        .toList();
                    for (var uname in userList) {
                      if (uname.userName == widget.UserName) {
                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            FractionallySizedBox(
                              alignment: Alignment.topCenter,
                              heightFactor: 0.2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: KirthanStyles.colorPallete30,
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.bottomCenter,
                              heightFactor: 0.95,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  color: Colors.grey[800],
                                ),
                                child: SingleChildScrollView(
                                  child: Column(children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Color(0xf0000000),
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
                                        SizedBox(
                                          width: 30,
                                        ),
                                        Container(
                                          margin: EdgeInsets.fromLTRB(
                                              10, 20, 10, 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              UserRole(userList)
                                                  ? Text(
                                                      currUserRole,
                                                      style: TextStyle(
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    )
                                                  : null,
                                              Divider(),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                widget.UserName,
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              SizedBox(
                                                height: 5,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Title: ' +
                                            widget.eventRequest.eventTitle,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        'Description: ' +
                                            widget
                                                .eventRequest.eventDescription,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(20, 0, 5, 5),
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color: Colors.grey,
                                                    )),
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      widget.eventRequest
                                                          .eventDate
                                                          .substring(0, 10),
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(Icons.calendar_today),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color: Colors.grey,
                                                    )),
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      widget.eventRequest
                                                          .eventTime,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                      color: Colors.grey,
                                                    )),
                                                    padding: EdgeInsets.all(5),
                                                    child: Text(
                                                      "AM",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            'Duration: ' +
                                                widget.eventRequest
                                                    .eventDuration +
                                                ' hrs',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                        color: Colors.grey,
                                      )),
                                      padding: EdgeInsets.all(5),
                                      child: Text(
                                        'Location:  ' +
                                            widget.eventRequest.city,
                                        style: TextStyle(
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    if (widget.eventRequest.phoneNumber != null)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.all(15),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                              color: Colors.grey,
                                            )),
                                            padding: EdgeInsets.all(5),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.call,
                                                ),
                                                Text(
                                                  " : " +
                                                      widget.eventRequest
                                                          .phoneNumber
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Icon(Icons.mail),
                                        ],
                                      ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    if (widget.data != null)
                                      _buildNtf(widget.data),
                                  ]),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    }
                  }
                  return Container();
                }),
          ),
        ),
        onRefresh: refreshList,
      ),
    );
  }
}
