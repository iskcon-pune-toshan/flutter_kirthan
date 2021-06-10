import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_string/random_string.dart';

final ProspectiveUserPageViewModel prospectiveUserPageVM =
    ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());

class NonUserTeamInvite extends StatefulWidget {
  @override
  _NonUserTeamInviteState createState() => _NonUserTeamInviteState();
}

class _NonUserTeamInviteState extends State<NonUserTeamInvite> {
  String userEmail;
  var Url;
  Uri params;
  String inviteCode = randomAlphaNumeric(6);
  String invitedBy;
  Future<String> getEmail() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    return email;
  }

  Future<void> emailLaunch(var Url) async {
    if (await canLaunch(Url)) {
      await launch(Url);
    } else {
      null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Initiate a Team"),
      ),
      body: FutureBuilder(
          future: getEmail(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              invitedBy = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          userEmail = value;
                          // print(userEmail);
                        });
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter E-mail'),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (EmailValidator.validate(userEmail) == true) {
                        List<ProspectiveUserRequest> puList =
                            await prospectiveUserPageVM
                                .getProspectiveUserRequests("team:4");
                        List<UserRequest> uList =
                            await userPageVM.getUserRequests(userEmail);
                        if (puList
                            .where((element) => element.userEmail == userEmail)
                            .toList()
                            .isNotEmpty) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User is already invited'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (uList.isNotEmpty) {
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User is already exists'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } else if (puList
                            .where((element) => element.userEmail == userEmail)
                            .toList()
                            .isEmpty) {
                          //  print(userEmail);
                          ProspectiveUserRequest prospectiveUserRequest =
                              new ProspectiveUserRequest();
                          prospectiveUserRequest.userEmail = userEmail;
                          prospectiveUserRequest.invitedBy = invitedBy;
                          prospectiveUserRequest.inviteCode = inviteCode;
                          prospectiveUserRequest.inviteType = 4;
                          prospectiveUserRequest.isProcessed = false;
                          Map<String, dynamic> eventrequestmap =
                              prospectiveUserRequest.toJson();
                          ProspectiveUserRequest newuserrequest =
                              await prospectiveUserPageVM
                                  .submitNewProspectiveUserRequest(
                                      eventrequestmap);
                          params = Uri(
                              scheme: 'mailto',
                              path: "$userEmail",
                              query:
                                  'subject=Invitation to create a team&body=Hello\n\nI would like to invite you to download our app using the link\nhttps://drive.google.com/file/d/1HR4NYkhIbbjgFB4RFF-JidjFkb0HwdGQ/view?usp=sharing\n\nAnd create a team using the code\n"$inviteCode"\n\nThanks & Regards ');
                          Url = params.toString();
                          emailLaunch(Url);
                        } else {
                          Scaffold.of(context).showSnackBar(
                              SnackBar(content: Text('Enter Valid Email')));
                        }
                      }
                      ;
                    },
                    child: Text('Send Code'),
                    color: KirthanStyles.colorPallete30,
                  ),
                ],
              );
            }
            return Container();
          }),
    );
  }
}
