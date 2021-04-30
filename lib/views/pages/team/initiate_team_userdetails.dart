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

class TeamInitiateUserDetails extends StatefulWidget {
  String UserName;
  TeamInitiateUserDetails({this.UserName});
  @override
  _TeamInitiateUserDetailsState createState() =>
      _TeamInitiateUserDetailsState(UserName);
}

class _TeamInitiateUserDetailsState extends State<TeamInitiateUserDetails> {
  String UserName;
  _TeamInitiateUserDetailsState(this.UserName);
  String Email;
  int Phone;
  String photoUrl;
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();

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
    super.initState();
  }

  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var email = user.email;
    return email;
  }

  Widget ProfilePages() {
    return FutureBuilder<List<UserRequest>>(
        future: Users,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            userList = snapshot.data;
            for (var uname in userList)
              if (uname.userName == UserName) {
                String _email = uname.email;
                String _photoName = _email + '.jpg';
                print("*********************" +
                    _photoName +
                    "*************************");
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
        elevation: 0.0,
        iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
        title: Text(
          'User Details(DUMMY)',
          style: TextStyle(color: KirthanStyles.colorPallete60),
        ),
        backgroundColor: KirthanStyles.colorPallete30,
      ),
      body: FutureBuilder<List<UserRequest>>(
          future: Users,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              userList = snapshot.data;
              for (var uname in userList) {
                if (uname.userName == UserName) {
                  Email = uname.email;
                  Phone = uname.phoneNumber;
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
                                    margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'User',
                                          style: TextStyle(
                                              fontSize: 35,
                                              fontWeight: FontWeight.w800),
                                        ),
                                        Divider(),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          UserName,
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
                                  'Contact Details:',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.call,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ': ' + Phone.toString(),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.mail,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    ': ' + Email,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Divider(thickness: 3,),
                                  SizedBox(height: 5),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.pin_drop,
                                    size: 30,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                    child: Container(
                                      padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      height: 30,
                                      margin:
                                      EdgeInsets.fromLTRB(10, 10, 20, 0),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[500],
                                          border: Border.all(
                                            style: BorderStyle.solid,
                                          )),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          uname.locality,
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Divider(thickness: 1,),
                              SizedBox(height: 20),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextField(
                                  decoration: InputDecoration(
                                      fillColor: Colors.grey[700],
                                      border: OutlineInputBorder(),
                                      hintText: 'Add a message',
                                      icon: Icon(Icons.add)
                                  ),
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              RaisedButton(
                                  color: KirthanStyles.colorPallete30,
                                  child: Text('Send invite'),
                                  onPressed: () {})
                            ]),
                          ),
                        ),
                      ),
                    ],
                  );
                  //               return Container(
                  //         margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  //         child: Column(
                  //         children: <Widget> [
                  //           Container(
                  //             padding: EdgeInsets.all(20),
                  //             decoration: BoxDecoration(
                  //               color: Colors.grey[700],
                  //               borderRadius: BorderRadius.circular(10)
                  //             ),
                  //             child: Column(
                  //               children: <Widget> [
                  //                 Row(
                  //                   children: <Widget>[
                  //                     CircleAvatar(
                  //                       radius: 50,
                  //                       backgroundColor: Color(0xf0000000),
                  //                       child: ClipOval(
                  //                         child: new SizedBox(
                  //                           width: 100.0,
                  //                           height: 100.0,
                  //                           child: (photoUrl != null)
                  //                               ? Image.network(
                  //                             photoUrl,
                  //                             fit: BoxFit.contain,
                  //                           )
                  //                               : ProfilePages(),
                  //                         ),
                  //                       ),
                  //                     ),
                  //                     SizedBox(width: 30,),
                  //                     Container(
                  //                       margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  //                       child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  //                         children: <Widget>[
                  //                           Text('User',style: TextStyle(fontSize: 35,fontWeight: FontWeight.w800),),
                  //                           SizedBox(height: 10,),
                  //                           Text(UserName,style: TextStyle(fontSize: 18),),
                  //                           SizedBox(height: 5,),
                  //                         ],
                  //                       ),
                  //                     )
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 5,),
                  //                 Row(
                  //                   children: <Widget> [
                  //                     Icon(Icons.call,size: 30,),
                  //                     SizedBox(width: 10,),
                  //                     Text(': '+ Phone.toString(),style: TextStyle(fontSize: 16),),
                  //                   ],
                  //                 ),
                  //                 SizedBox(height: 20,),
                  //                 Row(
                  //                   children: <Widget> [
                  //                     Icon(Icons.mail,size: 30,),
                  //                     SizedBox(width: 10,),
                  //                     Text(': '+Email,style: TextStyle(fontSize: 16),),
                  //                   ],
                  //                 ),
                  //                 Center(
                  //                   child: Container(padding: EdgeInsets.fromLTRB(10, 3, 0, 0),
                  //                     width: MediaQuery.of(context).size.width* 0.7,
                  //                     height: 30,
                  //                     margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                  //                     decoration: BoxDecoration(
                  //                         color: Colors.grey[500],
                  //                       border:Border.all(
                  //                         style: BorderStyle.solid,
                  //                       )
                  //                     ),
                  //                     child: Align(
                  //                       alignment: Alignment.centerLeft,
                  //                       child: Text(uname.locality,
                  //                       style: TextStyle(color: Colors.black),),
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //           SizedBox(height: 30,),
                  //           Align(
                  //             alignment: Alignment.centerLeft,
                  //             child: TextField(
                  //               decoration: InputDecoration(
                  //                 fillColor: Colors.grey[700],
                  //                 border: OutlineInputBorder(),
                  //                 hintText: 'Add a message',
                  //               ),
                  //               style: TextStyle(color: Colors.white70),
                  //             ),
                  //           ),
                  //           SizedBox(height: 10,),
                  //           RaisedButton(
                  //             color: KirthanStyles.colorPallete30,
                  //               child: Text('Send a code'),
                  //               onPressed: (){
                  //
                  //           })
                  //   ],
                  // ),
                  //       );
                }
              }
            }
            return Container();
          }),
    );
  }
}
