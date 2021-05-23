import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/prospectiveuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:random_string/random_string.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final ProspectiveUserPageViewModel prospectiveUserPageVM =
    ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());

class InviteUser extends StatefulWidget {
  @override
  _InviteUserState createState() => _InviteUserState();
}

class _InviteUserState extends State<InviteUser> {
  Future<List<UserRequest>> Users;
  String inviteCode = randomAlphaNumeric(6);
  bool present = false;
  Future<List<ProspectiveUserRequest>> ProspectiveUsers;
  List<UserRequest> userList = List<UserRequest>();
  List<ProspectiveUserRequest> prospectiveList = List<ProspectiveUserRequest>();
  ProspectiveUserRequest prospectiveUserRequest = ProspectiveUserRequest();
  final TextEditingController _emailController = new TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;
  String email;
  String user_id;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    email = user.email;
    print(email);
  }

  @override
  void initState() {
    Users = userPageVM.getUserRequests("Approved");
    getCurrentUser();

    super.initState();
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
    return Scaffold(
      appBar: AppBar(
        title: Text("Invite a LocalAdmin"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Enter E-mail'),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            RaisedButton.icon(
              icon: Icon(Icons.keyboard),
              onPressed: () async {
                print("clicked");
                print("CHECK0");
                userList = await Users;
                present = false;
                String userType = "uEmail:" + _emailController.text;
                print(userType);
                ProspectiveUsers =
                    prospectiveUserPageVM.getProspectiveUserRequests(userType);
                prospectiveList = await ProspectiveUsers;
                for (var puser in prospectiveList) {
                  if (puser.userEmail == _emailController.text) {
                    present = true;
                  }
                }
                for (var user in userList) {
                  print("check3");
                  print(email);
                  if (email == user.email) {
                    user_id = user.email;
                    print("CHECK4");
                    print(user_id);
                  }
                  print("PRESENT");
                  print(present);

                  if (user.email == _emailController.text || present) {
                    print("HELLO");
                    SnackBar mysnackbar = SnackBar(
                      content: Text("User is in system"),
                      duration: new Duration(seconds: 4),
                      backgroundColor: Colors.red,
                    );
                    Scaffold.of(context).showSnackBar(mysnackbar);
                    return Container(
                      child: Text("User in system"),
                    );
                  }
                }
                String uemail = _emailController.text;
                prospectiveUserRequest.invitedBy = user_id;
                prospectiveUserRequest.userEmail = _emailController.text;
                prospectiveUserRequest.inviteCode = inviteCode;
                prospectiveUserRequest.inviteType = "local_admin";
                prospectiveUserRequest.isProcessed = false;
                Map<String, dynamic> prospectivemap =
                    prospectiveUserRequest.toJson();
                prospectiveUserPageVM
                    .submitNewProspectiveUserRequest(prospectivemap);
                emailLaunch('mailto:$uemail?'
                    'subject=Invitiation%20to%20become%20a%20local admin&'
                    'body=Hello\n\nI%20would%20like%20to%20inivte%20you%20to%20download%20our%20app%20using%20the%20link\n\n'
                    'https://drive.google.com/file/d/1HR4NYkhIbbjgFB4RFF-JidjFkb0HwdGQ/view?usp=sharing\n\n'
                    'And%20become%20a%20local admin%20using%20the%20code\n"$inviteCode"\n\nThank%20You');
                // SnackBar mysnackbar = SnackBar(
                //   content: Text("Invited Successfully"),
                //   duration: new Duration(seconds: 4),
                //   backgroundColor: Colors.green,
                // );
                // Scaffold.of(context).showSnackBar(mysnackbar);
              },
              label: Text("Send a code"),
            )
          ],
        ),
      ),
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_kirthan/models/prospectiveuser.dart';
// import 'package:flutter_kirthan/models/user.dart';
// import 'package:flutter_kirthan/services/prospective_user_service_impl.dart';
// import 'package:flutter_kirthan/services/user_service_impl.dart';
// import 'package:flutter_kirthan/view_models/prospective_user_page_view_model.dart';
// import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
//
// final UserPageViewModel userPageVM =
//     UserPageViewModel(apiSvc: UserAPIService());
// final ProspectiveUserPageViewModel prospectiveUserPageVM =
//     ProspectiveUserPageViewModel(apiSvc: ProspectiveUserAPIService());
// final TextEditingController _emailController = new TextEditingController();
//
// class InviteUser extends StatefulWidget {
//   @override
//   _InviteUserState createState() => _InviteUserState();
// }
//
// class _InviteUserState extends State<InviteUser> {
//   Future<List<UserRequest>> Users;
//   bool present = false;
//   Future<List<ProspectiveUserRequest>> ProspectiveUsers;
//   List<UserRequest> userList = List<UserRequest>();
//   List<ProspectiveUserRequest> prospectiveList = List<ProspectiveUserRequest>();
//   ProspectiveUserRequest prospectiveUserRequest = ProspectiveUserRequest();
//
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   String email;
//   String user_id;
//   getCurrentUser() async {
//     final FirebaseUser user = await auth.currentUser();
//     email = user.email;
//     print(email);
//   }
//
//   @override
//   void initState() {
//     Users = userPageVM.getUserRequests("Approved");
//     getCurrentUser();
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Invite a LocalAdmin"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
//               child: TextField(
//                 controller: _emailController,
//                 decoration: InputDecoration(
//                     border: OutlineInputBorder(), hintText: 'Enter E-mail'),
//               ),
//             ),
//             SizedBox(
//               height: 40,
//             ),
//             RaisedButton.icon(
//               icon: Icon(Icons.keyboard),
//               onPressed: () async {
//                 print("clicked");
//                 print("CHECK0");
//                 userList = await Users;
//                 present = false;
//                 String userType = "uEmail:" + _emailController.text;
//                 print(userType);
//                 ProspectiveUsers =
//                     prospectiveUserPageVM.getProspectiveUserRequests(userType);
//                 prospectiveList = await ProspectiveUsers;
//                 for (var puser in prospectiveList) {
//                   if (puser.userEmail == _emailController.text) {
//                     present = true;
//                   }
//                 }
//                 for (var user in userList) {
//                   print("check3");
//                   print(email);
//                   if (email == user.email) {
//                     user_id = user.email;
//                     print("CHECK4");
//                     print(user_id);
//                   }
//                   print("PRESENT");
//                   print(present);
//
//                   if (user.email == _emailController.text || present) {
//                     print("HELLO");
//                     SnackBar mysnackbar = SnackBar(
//                       content: Text("User is in system"),
//                       duration: new Duration(seconds: 4),
//                       backgroundColor: Colors.red,
//                     );
//                     Scaffold.of(context).showSnackBar(mysnackbar);
//                     return Container(
//                       child: Text("User in system"),
//                     );
//                   }
//                 }
//                 prospectiveUserRequest.invitedBy = user_id;
//                 prospectiveUserRequest.userEmail = _emailController.text;
//                 prospectiveUserRequest.inviteCode = "xyz123";
//                 prospectiveUserRequest.inviteType = "local_admin";
//                 prospectiveUserRequest.isProcessed = false;
//                 Map<String, dynamic> prospectivemap =
//                     prospectiveUserRequest.toJson();
//                 prospectiveUserPageVM
//                     .submitNewProspectiveUserRequest(prospectivemap);
//                 SnackBar mysnackbar = SnackBar(
//                   content: Text("Invited Successfully"),
//                   duration: new Duration(seconds: 4),
//                   backgroundColor: Colors.green,
//                 );
//                 Scaffold.of(context).showSnackBar(mysnackbar);
//               },
//               label: Text("Send a code"),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
