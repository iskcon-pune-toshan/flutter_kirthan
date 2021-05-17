import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/pages/team/team_profile_page.dart';

final ProspectiveUserPageViewModel prospectiveUserPageVM =
    ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());
final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class RequestCode extends StatefulWidget {
  @override
  _RequestCodeState createState() => _RequestCodeState();
}

String validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

class _RequestCodeState extends State<RequestCode> {
  String invitedBy;
  String teamLeadId;

  Future<List<ProspectiveUserRequest>> ProspectiveUsers;
  List<ProspectiveUserRequest> ProspectiveUsersList =
      new List<ProspectiveUserRequest>();
  String inviteCode;
  @override
  void initState() {
    ProspectiveUsers = prospectiveUserPageVM.getProspectiveUserRequests('team');
    super.initState();
  }

  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var email = user.email;
    return email;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Create a Team"),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Container(margin: const EdgeInsets.only(top: 50)),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 100, 0, 0),
                  child: Card(
                    child: Container(
                      padding: new EdgeInsets.all(10),
                      child: Text(
                        "Enter Code",
                        style: TextStyle(fontSize: 40, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: TextField(
                    onChanged: (value) {
                      inviteCode = value;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: FlatButton(
                    child: Text(
                      'Continue without Code',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          decoration: TextDecoration.underline,
                          decorationStyle: TextDecorationStyle.solid),
                      textAlign: TextAlign.left,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => TeamWrite()));
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FutureBuilder(
                      future: getEmail(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          String mail = snapshot.data;
                          // ignore: missing_return
                          return FutureBuilder<List<ProspectiveUserRequest>>(
                              future: ProspectiveUsers,
                              builder: (context, snapshot) {
                                if (snapshot.data != null) {
                                  ProspectiveUsersList = snapshot.data;
                                  UserRequest userTeam = new UserRequest();
                                  for (var user in ProspectiveUsersList) {
                                    if (user.userEmail == mail) {
                                      invitedBy = user.invitedBy;
                                      teamLeadId = user.userEmail;

                                      return Container(
                                        margin:
                                            EdgeInsets.fromLTRB(0, 80, 40, 50),
                                        child: FlatButton(
                                            color: Colors.green,
                                            child: Text(
                                              'Next',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            onPressed: () async {
                                              UserRequest userRequestTeam =
                                                  new UserRequest();
                                              UserRequest localAdminTeam =
                                                  new UserRequest();
                                              List<UserRequest> localAdminList =
                                                  await userPageVM
                                                      .getUserRequests(
                                                          invitedBy);
                                              for (var user in localAdminList) {
                                                localAdminTeam = user;
                                              }
                                              List<UserRequest>
                                                  userRequestList =
                                                  await userPageVM
                                                      .getUserRequests(
                                                          teamLeadId);
                                              for (var user
                                                  in userRequestList) {
                                                userRequestTeam = user;
                                              }
                                              if (inviteCode ==
                                                  user.inviteCode) {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            TeamWrite(
                                                              userRequest:
                                                                  userRequestTeam,
                                                              localAdmin:
                                                                  localAdminTeam,
                                                            )));
                                              } else {
                                                Scaffold.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            'Enter Valid Code')));
                                              }
                                            }),
                                      );
                                    }
                                  }
                                }
                                return Container();
                              });
                        }
                        return Container();
                      }),
                )
              ],
            ),
          ),
        ));
  }
}
