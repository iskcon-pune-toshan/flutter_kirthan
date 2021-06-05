import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';
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

  Future<void> emailLaunch(String userEmail) async {
    if (await canLaunch(userEmail)) {
      await launch(userEmail);
    } else {
      print('Could not launch $userEmail');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(builder: (context, notifier, child) =>(
        Scaffold(
          appBar: AppBar(
            title: Text("Initiate a Team", style: TextStyle(fontSize: notifier.custFontSize)),
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
                          style: TextStyle(fontSize: notifier.custFontSize),
                          onChanged: (value) {
                            setState(() {
                              userEmail = value;
                              // print(userEmail);
                            });
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Enter E-mail', hintStyle: TextStyle(fontSize: notifier.custFontSize)),
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
                                  content: Text('User is already invited', style: TextStyle(fontSize: notifier.custFontSize)),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            } else if (uList.isNotEmpty) {
                              Scaffold.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('User is already exists', style: TextStyle(fontSize: notifier.custFontSize)),
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
                              emailLaunch('mailto:$userEmail?'
                                  'subject=Invitiation%20to%20create%20a%20team&body=Hello\n\nI%20would%20like%20to%20invite%20you%20to%20download%20our%20app%20using%20the%20link\nhttps://bit.ly/3yQGZG5\n\nAnd%20create%20a%20team%20using%20the%20code%20:%20"$inviteCode"%20\nThank%20You');
                            } else {
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(content: Text('Enter Valid Email', style: TextStyle(fontSize: notifier.custFontSize))));
                            }
                          }

                        },
                        child: Text('Send Code', style: TextStyle(fontSize: notifier.custFontSize)),
                        color: KirthanStyles.colorPallete30,
                      ),
                    ],
                  );
                }
                return Container();
              }),
        )
    ),
    );
  }
}
