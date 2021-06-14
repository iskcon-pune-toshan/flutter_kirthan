import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());
final GoogleSignIn googleSignIn = new GoogleSignIn();
final FacebookLogin facebookLogin = new FacebookLogin();
TextEditingController _oldPassword = TextEditingController();
TextEditingController _password = TextEditingController();
TextEditingController _passwordConfirm = TextEditingController();

class MyProfileSettings extends StatefulWidget {
  @override
  _MyProfileSettingsState createState() => _MyProfileSettingsState();
}

class _MyProfileSettingsState extends State<MyProfileSettings> {
  String currentPassword;
  String oldPassword;
  String errMessage;
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  String username;
  String currentUserName;
  File _image;
  String profilePic;
  String _photoUrl;
  String uemail;
  Future<String> getEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    var user = await auth.currentUser();
    var email = user.email;
    return email;
  }

  String isValidAadharNumber(String value) {
    // Regex to check valid Aadhar number.
    String pattern = r"^[2-9]{1}[0-9]{3}[0-9]{4}[0-9]{4}$";
    RegExp regExp = new RegExp(pattern);
    // Compile the ReGex
    if (value.length == 0) {
      return 'Please enter Aadhaar Number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid Aadhaar Number';
    }
    return null;
  }

  Future loadData() async {
    await userPageVM.getUserRequests(uemail);
  }

  @override
  void initState() {
    super.initState();
    userPageVM.getUserRequests(uemail);
    googleSign();
    facebookSign();
  }

  googleSign() async {
    isGoogleSign = await googleSignIn.isSignedIn();
    print(isGoogleSign);
  }

  facebookSign() async {
    isFaceBookSign = await facebookLogin.isLoggedIn;
    print(isFaceBookSign);
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      loadData();
    });

    return null;
  }

  String _isValidPhone(String value) {
    final phoneRegExp = RegExp(r'(^(?:[+0]9)?[0-9]{10}$)');
    if (!phoneRegExp.hasMatch(value))
      return 'Enter Valid Phone Number';
    else
      return null;
  }

  bool isGoogleSign;
  bool isFaceBookSign;

  @override
  Widget build(BuildContext context) {
    _cropImage(filePath) async {
      File croppedImage = await ImageCropper.cropImage(
        cropStyle: CropStyle.circle,
        sourcePath: filePath,
        maxWidth: 1080,
        maxHeight: 1080,
      );

      if (croppedImage != null) {
        setState(() {
          _image = croppedImage;
        });
      }
    }

    Future getImageFromGallery() async {
      ImagePicker imagePicker = new ImagePicker();
      var image = await imagePicker.getImage(source: ImageSource.gallery);
      await _cropImage(image.path);
    }

    Future getImageFromCamera() async {
      ImagePicker imagePicker = new ImagePicker();
      var image = await imagePicker.getImage(source: ImageSource.camera);
      await _cropImage(image.path);
    }

    Widget ProfilePages() {
      //  StorageReference ref = FirebaseStorage.instance.ref();
      // profilePic= getCurrentUser() as String;
      final FirebaseAuth auth = FirebaseAuth.instance;
      //user =  auth.currentUser() ;
      // final String email = user.email;

      return FutureBuilder(
          future: getEmail(), //ref.getDownloadURL(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              // final String email = snapshot.data.toString();
              String _email = snapshot.data + '.jpg';
              // print("\n\n\n\n\n\n\n\n\n\n\n" + _email + "\n\n\n\n\n\n\n\n");
              final ref = FirebaseStorage.instance.ref().child(_email);
              // var url = ref.getDownloadURL();
              // print("\n\n\n\n\n\n\n" + snapshot.data + "\n\n\n\n\n\n");
              //  var url =await ref.getDownloadURL();
              return FutureBuilder(
                  future: ref.getDownloadURL(),
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return new Image.network(snapshot.data,
                          height: 100.0, width: 100.0, fit: BoxFit.fill);
                    }
                    return Image.asset(
                      "assets/images/default_profile_picture.png",
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.fill,
                    );
                  });
            }
            return Image.asset(
              "assets/images/default_profile_picture.png",
              height: 100.0,
              width: 100.0,
              fit: BoxFit.fill,
            );
          });
    }

    Future uploadPic(BuildContext context) async {
      //profilePic=getEmail();
      // profilePic=getCurrentUser() as String;
      getEmail();
      final FirebaseAuth auth = FirebaseAuth.instance;
      var user = await auth.currentUser();
      uemail = user.email;
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(uemail + '.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      await uploadTask.onComplete;
      firebaseStorageRef.getDownloadURL().then((value) {
        setState(() {
          _photoUrl = value;
        });
      });
      // FirebaseStorage.instance
      //     .ref()
      //     .child(uemail + '.jpg')
      //     .getDownloadURL()
      //     .then((value) => {photoUrl = value});
      // retrievePic(photoUrl);
      // setState(() {
      //   // print("Profile Picture uploaded");
      //   // print(_photoUrl);
      //   Scaffold.of(context)
      //       .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      //   Navigator.pop(context);
      // });
    }

    Future deletePic(BuildContext context) async {
      //profilePic= getEmail();
      //String fileName = basename(_image.path);
      //profilePic=getCurrentUser() as String;
      getEmail();
      final FirebaseAuth auth = FirebaseAuth.instance;
      var user = await auth.currentUser();
      String uemail = user.email;
      StorageReference firebaseStorageRef =
      FirebaseStorage.instance.ref().child(uemail + '.jpg');
      await firebaseStorageRef.delete();
      // setState(() {
      //   //  print("Profile Picture deleted");
      //   Scaffold.of(context)
      //       .showSnackBar(SnackBar(content: Text('Deleted Profile Picture')));
      // });
    }

    return Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return Scaffold(
              appBar: AppBar(
                title: Text('Profile Settings'),
              ),
              body: RefreshIndicator(
                key: refreshKey,
                child: FutureBuilder(
                    future: getEmail(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        String email = snapshot.data;
                        return FutureBuilder(
                            future: userPageVM.getUserRequests(email),
                            builder: (context, snapshot) {
                              if (snapshot.data != null) {
                                List<UserRequest> userList = snapshot.data;
                                UserRequest user = new UserRequest();
                                for (var u in userList) {
                                  user = u;
                                  currentUserName = u.fullName;
                                }
                                return SingleChildScrollView(
                                  physics: BouncingScrollPhysics(),
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Align(
                                            alignment: Alignment.center,
                                            child: CircleAvatar(
                                              radius: 70,
                                              //backgroundColor: Color(0xff476cfb),
                                              child: Stack(
                                                children: [
                                                  ClipOval(
                                                    child: new SizedBox(
                                                        width: 140.0,
                                                        height: 140.0,
                                                        child: (_image != null)
                                                            ? Image.file(
                                                          _image,
                                                          fit: BoxFit.fill,
                                                        )
                                                        //   :(profilePic==null)
                                                        // ?Image.asset("assets/images/default_profile_picture.png",
                                                        // fit: BoxFit.fill,)
                                                            : ProfilePages()),
                                                  ),
                                                  Align(
                                                    alignment:
                                                    Alignment.bottomRight,
                                                    child: FloatingActionButton(
                                                      backgroundColor: KirthanStyles
                                                          .colorPallete30,
                                                      onPressed: () {
                                                        showMaterialModalBottomSheet(
                                                          context: context,
                                                          builder: (context) =>
                                                              Container(
                                                                width: 100,
                                                                height:
                                                                notifier.custFontSize >=
                                                                    25
                                                                    ? 300
                                                                    : 200,
                                                                child: Column(
                                                                  children: [
                                                                    Column(
                                                                      children: [
                                                                        ListTile(
                                                                            leading: Icon(
                                                                                Icons
                                                                                    .photo),
                                                                            title: Text(
                                                                              'Import from Gallery',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight
                                                                                      .bold,
                                                                                  fontSize:
                                                                                  notifier.custFontSize),
                                                                            ),
                                                                            onTap:
                                                                                () async {
                                                                              await getImageFromGallery();
                                                                              // var email =
                                                                              //     snapshot
                                                                              //         .data;
                                                                              // print(
                                                                              //     "emails");
                                                                              // print(
                                                                              //     email);
                                                                              uploadPic(
                                                                                  context);
                                                                              Navigator.pop(context);
                                                                                  Scaffold.of(context)
                                                                                  .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
                                                                              List<UserRequest>
                                                                              userrequest =
                                                                              await userPageVM
                                                                                  .getUserRequests('$email');
                                                                              if (userrequest
                                                                                  .isNotEmpty) {
                                                                                print(
                                                                                    "entered");
                                                                                UserRequest
                                                                                userreq =
                                                                                new UserRequest();
                                                                                for (var user
                                                                                in userrequest) {
                                                                                  user.profileUrl =
                                                                                      _photoUrl;
                                                                                  userreq =
                                                                                      user;
                                                                                }
                                                                                String
                                                                                userrequestmap =
                                                                                jsonEncode(userreq.toStrJson());
                                                                                userPageVM
                                                                                    .submitUpdateUserRequest(userrequestmap);
                                                                              }
                                                                            }),
                                                                        ListTile(
                                                                            leading: Icon(
                                                                                Icons
                                                                                    .camera_alt_outlined),
                                                                            title: Text(
                                                                              'Camera',
                                                                              style: TextStyle(
                                                                                  fontWeight: FontWeight
                                                                                      .bold,
                                                                                  fontSize:
                                                                                  notifier.custFontSize),
                                                                            ),
                                                                            onTap:
                                                                                () async {
                                                                              await getImageFromCamera();

                                                                              uploadPic(
                                                                                  context);
                                                                              Navigator.pop(context);
                                                                              Scaffold.of(context)
                                                                                  .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
                                                                              List<UserRequest>
                                                                              userrequest =
                                                                              await userPageVM
                                                                                  .getUserRequests('$email');
                                                                              if (userrequest
                                                                                  .isNotEmpty) {
                                                                                print(
                                                                                    "entered");
                                                                                UserRequest
                                                                                userreq =
                                                                                new UserRequest();
                                                                                for (var user
                                                                                in userrequest) {
                                                                                  user.profileUrl =
                                                                                      _photoUrl;
                                                                                  userreq =
                                                                                      user;
                                                                                }
                                                                                String
                                                                                userrequestmap =
                                                                                jsonEncode(userreq.toStrJson());
                                                                                userPageVM
                                                                                    .submitUpdateUserRequest(userrequestmap);
                                                                              }
                                                                            }),
                                                                      ],
                                                                    ),
                                                                    ListTile(
                                                                      leading: Icon(
                                                                        MaterialCommunityIcons
                                                                            .trash_can_outline,
                                                                        color:Colors.red,
                                                                      ),
                                                                      title: Text(
                                                                        'Remove current profile picture',
                                                                        style: TextStyle(
                                                                            color: Colors
                                                                                .red,
                                                                            fontSize:
                                                                            notifier
                                                                                .custFontSize),
                                                                      ),
                                                                      //padding: EdgeInsets.only(left: 00.0,top: 10.0,right: 10.0,bottom: 0.0),
                                                                      shape:
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            12.0),
                                                                      ),
                                                                      onTap: () async {
                                                                        //Image.asset('assets/images/default_profile_picture.png');
                                                                        ProfilePages();
                                                                        deletePic(
                                                                            context);
                                                                        Navigator.pop(context);
                                                                        Scaffold.of(context)
                                                                            .showSnackBar(SnackBar(content: Text('Deleted Profile Picture')));
                                                                        List<UserRequest>
                                                                        userrequest =
                                                                        await userPageVM
                                                                            .getUserRequests(
                                                                            '$uemail');
                                                                        //
                                                                        if (userrequest
                                                                            .isNotEmpty) {
                                                                          //  print('OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO');
                                                                          //print(_photoUrl);
                                                                          UserRequest
                                                                          userreq =
                                                                          new UserRequest();
                                                                          for (var user
                                                                          in userrequest) {
                                                                            user.profileUrl =
                                                                            null;
                                                                            userreq =
                                                                                user;
                                                                          }
                                                                          String
                                                                          userrequestmap =
                                                                          jsonEncode(
                                                                              userreq
                                                                                  .toStrJson());
                                                                          userPageVM
                                                                              .submitUpdateUserRequest(
                                                                              userrequestmap);
                                                                          // for()
                                                                        }
                                                                      },
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                        );
                                                      },
                                                      child: Icon(Icons.add),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                      ),
                                      // Card(
                                      //   child: ListTile(
                                      //     trailing: Icon(
                                      //       Icons.keyboard_arrow_right,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     leading: Icon(
                                      //       Icons.people,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     title: Consumer<ThemeNotifier>(
                                      //       builder: (context, notifier, child) => Text(
                                      //         'Team Name',
                                      //         style: TextStyle(
                                      //           fontSize: notifier.custFontSize,
                                      //           color: KirthanStyles.colorPallete30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => teamName(),
                                      //           ));
                                      //     },
                                      //     selected: true,
                                      //   ),
                                      // ),
                                      // Divider(),
                                      // Card(
                                      //   child: ListTile(
                                      //     trailing: Icon(
                                      //       Icons.keyboard_arrow_right,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     leading: Icon(
                                      //       Icons.perm_identity,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     title: Consumer<ThemeNotifier>(
                                      //       builder: (context, notifier, child) => Text(
                                      //         'User Name',
                                      //         style: TextStyle(
                                      //           fontSize: notifier.custFontSize,
                                      //           color: KirthanStyles.colorPallete30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => userName_profile(),
                                      //           ));
                                      //     },
                                      //     selected: true,
                                      //   ),
                                      // ),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("User Name"),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  MaterialCommunityIcons.pencil,
                                                  color:
                                                  KirthanStyles.colorPallete30,
                                                ),
                                                onPressed: () {
                                                  showMaterialModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (context) => Container(
                                                        width: 200,
                                                        height:
                                                        notifier.custFontSize >=
                                                            25
                                                            ? 300
                                                            : 200,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                alignment:
                                                                Alignment
                                                                    .centerLeft,
                                                                padding: EdgeInsets.only(
                                                                    top: 20,
                                                                    bottom:
                                                                    20,
                                                                    left:
                                                                    20),
                                                                child: Text(
                                                                    "Enter your name")),
                                                            Container(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                  bottom:
                                                                  20),
                                                              child: Form(
                                                                key:
                                                                _formKey,
                                                                child:
                                                                TextFormField(
                                                                  initialValue:
                                                                  user.fullName,
                                                                  decoration:
                                                                  InputDecoration(
                                                                    enabledBorder:
                                                                    UnderlineInputBorder(
                                                                      borderSide:
                                                                      BorderSide(color: Colors.grey),
                                                                    ),
                                                                    focusedBorder:
                                                                    UnderlineInputBorder(
                                                                      borderSide:
                                                                      BorderSide(color: Colors.green),
                                                                    ),
                                                                    icon:
                                                                    const Icon(
                                                                      Icons
                                                                          .perm_identity,
                                                                      color:
                                                                      Colors.grey,
                                                                    ),
                                                                    hintText:
                                                                    "Please enter new username",
                                                                    labelStyle:
                                                                    TextStyle(
                                                                      fontSize:
                                                                      notifier.custFontSize,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color:
                                                                      Colors.grey,
                                                                    ),
                                                                    hintStyle:
                                                                    TextStyle(
                                                                      color:
                                                                      Colors.grey,
                                                                    ),
                                                                  ),
                                                                  onChanged:
                                                                      (input) {
                                                                    username =
                                                                        input;
                                                                  },
                                                                  onSaved:
                                                                      (input) {
                                                                    user.fullName =
                                                                        input;
                                                                  },
                                                                  validator:
                                                                      (input) {
                                                                    if (input
                                                                        .trimLeft()
                                                                        .isEmpty) {
                                                                      return "Please enter valid name";
                                                                    } else if (input ==
                                                                        user.fullName) {
                                                                      return "New user name can't be same as old username";
                                                                    } else
                                                                      return null;
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                RaisedButton(
                                                                  elevation:
                                                                  0,
                                                                  child:
                                                                  Text(
                                                                    'Save',
                                                                    style: TextStyle(
                                                                        color:
                                                                        KirthanStyles.colorPallete30),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  onPressed:
                                                                      () async {
                                                                    if (_formKey
                                                                        .currentState
                                                                        .validate()) {
                                                                      _formKey
                                                                          .currentState
                                                                          .save();
                                                                      String
                                                                      userrequestStr =
                                                                      jsonEncode(user.toStrJson());
                                                                      userPageVM
                                                                          .submitUpdateUserRequestDetails(userrequestStr);

                                                                      SnackBar
                                                                      mysnackbar =
                                                                      SnackBar(
                                                                        content:
                                                                        Text("User details updated $successful"),
                                                                        duration:
                                                                        new Duration(seconds: 4),
                                                                        backgroundColor:
                                                                        Colors.green,
                                                                      );
                                                                      Scaffold.of(context)
                                                                          .showSnackBar(mysnackbar);

                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => MyProfileSettings()));
                                                                    }
                                                                  },
                                                                ),
                                                                RaisedButton(
                                                                  elevation:
                                                                  0,
                                                                  child:
                                                                  Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                              disabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                            ),
                                            initialValue: currentUserName,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text("Phone Number"),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  MaterialCommunityIcons.pencil,
                                                  color:
                                                  KirthanStyles.colorPallete30,
                                                ),
                                                onPressed: () {
                                                  showMaterialModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (context) => Container(
                                                        width: 200,
                                                        height:
                                                        notifier.custFontSize >=
                                                            25
                                                            ? 300
                                                            : 200,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                alignment:
                                                                Alignment
                                                                    .centerLeft,
                                                                padding: EdgeInsets.only(
                                                                    top: 20,
                                                                    left:
                                                                    20),
                                                                child: Text(
                                                                    "Enter your phone number")),
                                                            Form(
                                                              key: _formKey,
                                                              child:
                                                              TextFormField(
                                                                autovalidate:
                                                                true, initialValue: user
                                                                    .phoneNumber
                                                                    .toString(),
                                                                keyboardType:
                                                                TextInputType
                                                                    .number,
                                                                decoration:
                                                                InputDecoration(
                                                                  enabledBorder:
                                                                  UnderlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: Colors.grey),
                                                                  ),
                                                                  focusedBorder:
                                                                  UnderlineInputBorder(
                                                                    borderSide:
                                                                    BorderSide(color: Colors.green),
                                                                  ),
                                                                  icon:
                                                                  Icon(
                                                                    Icons
                                                                        .phone_in_talk,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  labelText:
                                                                  "Phone Number",
                                                                  labelStyle:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    notifier.custFontSize,
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                  hintText:
                                                                  "",
                                                                ),
                                                                onSaved:
                                                                    (input) {
                                                                  user.phoneNumber =
                                                                      int.parse(
                                                                          input);
                                                                },
                                                                validator:
                                                                _isValidPhone,
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                RaisedButton(
                                                                  elevation:
                                                                  0,
                                                                  child:
                                                                  Text(
                                                                    'Save',
                                                                    style: TextStyle(
                                                                        color:
                                                                        KirthanStyles.colorPallete30),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  onPressed:
                                                                      () async {
                                                                    if (_formKey
                                                                        .currentState
                                                                        .validate()) {
                                                                      _formKey
                                                                          .currentState
                                                                          .save();
                                                                      String
                                                                      userrequestStr =
                                                                      jsonEncode(user.toStrJson());
                                                                      userPageVM
                                                                          .submitUpdateUserRequestDetails(userrequestStr);
                                                                      SnackBar
                                                                      mysnackbar =
                                                                      SnackBar(
                                                                        content:
                                                                        Text("Phone details updated $successful"),
                                                                        duration:
                                                                        new Duration(seconds: 4),
                                                                        backgroundColor:
                                                                        Colors.green,
                                                                      );
                                                                      Scaffold.of(context)
                                                                          .showSnackBar(mysnackbar);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => MyProfileSettings()));
                                                                    }
                                                                  },
                                                                ),
                                                                RaisedButton(
                                                                  elevation:
                                                                  0,
                                                                  child:
                                                                  Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                              disabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                            ),
                                            initialValue:
                                            user.phoneNumber.toString(),
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text("Address"),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  MaterialCommunityIcons.pencil,
                                                  color:
                                                  KirthanStyles.colorPallete30,
                                                ),
                                                onPressed: () {
                                                  showMaterialModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (context) => Container(
                                                        padding:
                                                        EdgeInsets.only(
                                                            left: 20),
                                                        width: 200,
                                                        height: 500,
                                                        child:
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  alignment:
                                                                  Alignment
                                                                      .centerLeft,
                                                                  padding: EdgeInsets.only(
                                                                      top:
                                                                      20,
                                                                      left:
                                                                      20),
                                                                  child: Text(
                                                                      "")),
                                                              Form(
                                                                  key:
                                                                  _formKey,
                                                                  child:
                                                                  Column(
                                                                    children: [
                                                                      TextFormField(
                                                                        initialValue:
                                                                        user.city,
                                                                        decoration:
                                                                        InputDecoration(
                                                                          enabledBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: Colors.grey),
                                                                          ),
                                                                          focusedBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: Colors.green),
                                                                          ),
                                                                          icon: Icon(Icons.home, color: Colors.grey),
                                                                          labelText: "Address",
                                                                          labelStyle: TextStyle(
                                                                            fontSize: notifier.custFontSize,
                                                                            color: Colors.grey,
                                                                          ),
                                                                          hintText: "",
                                                                        ),
                                                                        onSaved:
                                                                            (input) {
                                                                          user.city = input;
                                                                        },
                                                                        validator: (input) => input.isEmpty
                                                                            ? "Please enter some text"
                                                                            : null,
                                                                      ),
                                                                      Divider(),
                                                                      TextFormField(
                                                                          autovalidate: true,
                                                                          initialValue: user.addLineOne,
                                                                          decoration: InputDecoration(
                                                                            enabledBorder: UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey),
                                                                            ),
                                                                            focusedBorder: UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.green),
                                                                            ),
                                                                            //icon: Icon(Icons.home, color: Colors.grey),
                                                                            labelText: "address",
                                                                            labelStyle: TextStyle(
                                                                              fontSize: notifier.custFontSize,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            hintText: "",
                                                                          ),
                                                                          onSaved: (input) {
                                                                            user.addLineOne = input;
                                                                          },
                                                                          validator: (input) {
                                                                            if (input.trimLeft().isEmpty) {
                                                                              return "Please enter Address";
                                                                            }
                                                                            return null;
                                                                          }),
                                                                      Divider(),
                                                                      TextFormField(
                                                                          autovalidate: true,
                                                                          initialValue: user.addLineTwo,
                                                                          decoration: InputDecoration(
                                                                            enabledBorder: UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey),
                                                                            ),
                                                                            focusedBorder: UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.green),
                                                                            ),
                                                                            //icon: Icon(Icons.home, color: Colors.grey),
                                                                            labelText: "address",
                                                                            labelStyle: TextStyle(
                                                                              fontSize: notifier.custFontSize,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            hintText: "",
                                                                          ),
                                                                          onSaved: (input) {
                                                                            user.addLineTwo = input;
                                                                          },
                                                                          validator: (input) {
                                                                            if (input.trimLeft().isEmpty) {
                                                                              return "Please enter Address";
                                                                            }
                                                                            return null;
                                                                          }),
                                                                      Divider(),
                                                                      TextFormField(
                                                                          autovalidate: true,
                                                                          initialValue: user.addLineThree,
                                                                          decoration: InputDecoration(
                                                                            enabledBorder: UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.grey),
                                                                            ),
                                                                            focusedBorder: UnderlineInputBorder(
                                                                              borderSide: BorderSide(color: Colors.green),
                                                                            ),
                                                                            //icon: Icon(Icons.home, color: Colors.grey),
                                                                            labelText: "address",
                                                                            labelStyle: TextStyle(
                                                                              fontSize: notifier.custFontSize,
                                                                              color: Colors.grey,
                                                                            ),
                                                                            hintText: "",
                                                                          ),
                                                                          onSaved: (input) {
                                                                            user.addLineThree = input;
                                                                          },
                                                                          validator: (input) {
                                                                            if (input.trimLeft().isEmpty) {
                                                                              return "Please enter Address";
                                                                            }
                                                                            return null;
                                                                          }),
                                                                      Divider(),
                                                                      TextFormField(
                                                                        initialValue:
                                                                        user.state,
                                                                        decoration:
                                                                        InputDecoration(
                                                                          enabledBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: Colors.grey),
                                                                          ),
                                                                          focusedBorder: UnderlineInputBorder(
                                                                            borderSide: BorderSide(color: Colors.green),
                                                                          ),
                                                                          icon: Icon(Icons.home, color: Colors.grey),
                                                                          labelText: "State",
                                                                          labelStyle: TextStyle(
                                                                            fontSize: notifier.custFontSize,
                                                                            color: Colors.grey,
                                                                          ),
                                                                          hintText: "",
                                                                        ),
                                                                        onSaved:
                                                                            (input) {
                                                                          user.state = input;
                                                                        },
                                                                        validator: (input) => input.isEmpty
                                                                            ? "Please enter some text"
                                                                            : null,
                                                                      ),
                                                                    ],
                                                                  )
                                                                //     TextFormField(
                                                                //   initialValue:
                                                                //       user.fullName,
                                                                //   decoration:
                                                                //       InputDecoration(
                                                                //     enabledBorder:
                                                                //         UnderlineInputBorder(
                                                                //       borderSide:
                                                                //           BorderSide(
                                                                //               color:
                                                                //                   Colors.grey),
                                                                //     ),
                                                                //     focusedBorder:
                                                                //         UnderlineInputBorder(
                                                                //       borderSide:
                                                                //           BorderSide(
                                                                //               color:
                                                                //                   Colors.green),
                                                                //     ),
                                                                //     icon:
                                                                //         const Icon(
                                                                //       Icons
                                                                //           .perm_identity,
                                                                //       color: Colors
                                                                //           .grey,
                                                                //     ),
                                                                //     hintText:
                                                                //         "Please enter new username",
                                                                //     labelStyle:
                                                                //         TextStyle(
                                                                //       fontSize: notifier
                                                                //           .custFontSize,
                                                                //       fontWeight:
                                                                //           FontWeight
                                                                //               .bold,
                                                                //       color: Colors
                                                                //           .grey,
                                                                //     ),
                                                                //     hintStyle:
                                                                //         TextStyle(
                                                                //       color: Colors
                                                                //           .grey,
                                                                //     ),
                                                                //   ),
                                                                //   onChanged:
                                                                //       (input) {
                                                                //     username =
                                                                //         input;
                                                                //   },
                                                                //   onSaved: (input) {
                                                                //     user.fullName =
                                                                //         input;
                                                                //   },
                                                                //   validator:
                                                                //       (input) {
                                                                //     if (input
                                                                //         .isEmpty) {
                                                                //       return "Please enter some text";
                                                                //     } else if (input ==
                                                                //         user.fullName) {
                                                                //       return "New user name can't be same as old username";
                                                                //     } else
                                                                //       return null;
                                                                //   },
                                                                // ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceEvenly,
                                                                children: [
                                                                  RaisedButton(
                                                                    elevation:
                                                                    0,
                                                                    child:
                                                                    Text(
                                                                      'Save',
                                                                      style:
                                                                      TextStyle(color: KirthanStyles.colorPallete30),
                                                                    ),
                                                                    color: Colors
                                                                        .transparent,
                                                                    onPressed:
                                                                        () async {
                                                                      if (_formKey
                                                                          .currentState
                                                                          .validate()) {
                                                                        _formKey.currentState.save();
                                                                        String
                                                                        userrequestStr =
                                                                        jsonEncode(user.toStrJson());
                                                                        userPageVM.submitUpdateUserRequestDetails(userrequestStr);
                                                                        SnackBar
                                                                        mysnackbar =
                                                                        SnackBar(
                                                                          content: Text("Address details updated $successful"),
                                                                          duration: new Duration(seconds: 4),
                                                                          backgroundColor: Colors.green,
                                                                        );
                                                                        Scaffold.of(context).showSnackBar(mysnackbar);
                                                                        Navigator.pop(context);
                                                                        Navigator.pop(context);
                                                                        Navigator.push(context,
                                                                            MaterialPageRoute(builder: (context) => MyProfileSettings()));
                                                                      }
                                                                    },
                                                                  ),
                                                                  RaisedButton(
                                                                    elevation:
                                                                    0,
                                                                    child:
                                                                    Text(
                                                                      'Cancel',
                                                                      style:
                                                                      TextStyle(color: Colors.grey),
                                                                    ),
                                                                    color: Colors
                                                                        .transparent,
                                                                    //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator.of(context)
                                                                          .pop();
                                                                    },
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: [
                                              TextFormField(
                                                autovalidate: true,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                                ),
                                                initialValue: user.addLineOne,
                                                validator: (input) {
                                                  if (input.trimLeft() == "") {
                                                    return "Please enter Address";
                                                  }
                                                },
                                              ),
                                              TextFormField(
                                                autovalidate: true,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                                ),
                                                initialValue: user.addLineTwo,
                                              ),
                                              TextFormField(
                                                autovalidate: true,
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.grey)),
                                                ),
                                                initialValue: user.addLineThree,
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            children: [
                                              Text("Aadhaar No."),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  MaterialCommunityIcons.pencil,
                                                  color:
                                                  KirthanStyles.colorPallete30,
                                                ),
                                                onPressed: () {
                                                  showMaterialModalBottomSheet(
                                                      context: context,
                                                      builder:
                                                          (context) => Container(
                                                        width: 200,
                                                        height:
                                                        notifier.custFontSize >=
                                                            25
                                                            ? 300
                                                            : 200,
                                                        child: Column(
                                                          children: [
                                                            Container(
                                                                alignment:
                                                                Alignment
                                                                    .centerLeft,
                                                                padding: EdgeInsets.only(
                                                                    top: 20,
                                                                    left:
                                                                    20),
                                                                child: Text(
                                                                    "Aadhaar Details")),
                                                            Form(
                                                              key: _formKey,
                                                              child: TextFormField(
                                                                  autovalidate: true,
                                                                  initialValue: user.govtId,
                                                                  decoration: InputDecoration(
                                                                    enabledBorder:
                                                                    UnderlineInputBorder(
                                                                      borderSide:
                                                                      BorderSide(color: Colors.grey),
                                                                    ),
                                                                    focusedBorder:
                                                                    UnderlineInputBorder(
                                                                      borderSide:
                                                                      BorderSide(color: Colors.green),
                                                                    ),
                                                                    icon:
                                                                    const Icon(
                                                                      Icons
                                                                          .perm_identity,
                                                                      color:
                                                                      Colors.grey,
                                                                    ),
                                                                    hintText:
                                                                    "Please enter Aadhaar Number",
                                                                    labelStyle:
                                                                    TextStyle(
                                                                      fontSize:
                                                                      notifier.custFontSize,
                                                                      fontWeight:
                                                                      FontWeight.bold,
                                                                      color:
                                                                      Colors.grey,
                                                                    ),
                                                                    hintStyle:
                                                                    TextStyle(
                                                                      color:
                                                                      Colors.grey,
                                                                    ),
                                                                  ),
                                                                  onSaved: (input) {
                                                                    user.govtId =
                                                                        input;
                                                                  },
                                                                  validator: isValidAadharNumber),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                              children: [
                                                                RaisedButton(
                                                                  elevation:
                                                                  0,
                                                                  child:
                                                                  Text(
                                                                    'Save',
                                                                    style: TextStyle(
                                                                        color:
                                                                        KirthanStyles.colorPallete30),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  onPressed:
                                                                      () async {
                                                                    if (_formKey
                                                                        .currentState
                                                                        .validate()) {
                                                                      _formKey
                                                                          .currentState
                                                                          .save();
                                                                      String
                                                                      userrequestStr =
                                                                      jsonEncode(user.toStrJson());
                                                                      userPageVM
                                                                          .submitUpdateUserRequestDetails(userrequestStr);
                                                                      SnackBar
                                                                      mysnackbar =
                                                                      SnackBar(
                                                                        content:
                                                                        Text("Aadhaar details updated $successful"),
                                                                        duration:
                                                                        new Duration(seconds: 4),
                                                                        backgroundColor:
                                                                        Colors.green,
                                                                      );
                                                                      Scaffold.of(context)
                                                                          .showSnackBar(mysnackbar);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.pop(
                                                                          context);
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => MyProfileSettings()));
                                                                    }
                                                                  },
                                                                ),
                                                                RaisedButton(
                                                                  elevation:
                                                                  0,
                                                                  child:
                                                                  Text(
                                                                    'Cancel',
                                                                    style: TextStyle(
                                                                        color:
                                                                        Colors.grey),
                                                                  ),
                                                                  color: Colors
                                                                      .transparent,
                                                                  //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ));
                                                },
                                              ),
                                            ],
                                          ),
                                          TextFormField(
                                            enabled: false,
                                            decoration: InputDecoration(
                                              disabledBorder: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.grey)),
                                            ),
                                            initialValue: user.govtId,
                                          ),
                                          SizedBox(
                                            height: 40,
                                          ),
                                          isGoogleSign || isFaceBookSign
                                              ? Container()
                                              : Column(
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                    bottom: 20),
                                                alignment:
                                                Alignment.centerLeft,
                                                child: Text(
                                                  "Change Password",
                                                  style: TextStyle(
                                                      fontSize: 17,
                                                      color: KirthanStyles
                                                          .colorPallete30),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Password",
                                                  ),
                                                  SizedBox(
                                                    width: 20,
                                                  ),
                                                  IconButton(
                                                    icon: Icon(
                                                      MaterialCommunityIcons
                                                          .pencil,
                                                      color: KirthanStyles
                                                          .colorPallete30,
                                                    ),
                                                    onPressed: () {
                                                      //TODO:to be modify afterwards
                                                      showMaterialModalBottomSheet(
                                                          context: context,
                                                          builder: (context) =>
                                                              Container(
                                                                  width: 200,
                                                                  height: notifier.custFontSize >=
                                                                      25
                                                                      ? 500
                                                                      : 400,
                                                                  child:
                                                                  SingleChildScrollView(
                                                                    padding: const EdgeInsets
                                                                        .all(
                                                                        16.0),
                                                                    child:
                                                                    Form(
                                                                      key:
                                                                      _formKey,
                                                                      autovalidate:
                                                                      true,
                                                                      child:
                                                                      Column(
                                                                        children: [
                                                                          Divider(),
                                                                          TextFormField(
                                                                            autovalidate: false,
                                                                            controller: _oldPassword,
                                                                            decoration: InputDecoration(
                                                                                enabledBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.grey),
                                                                                ),
                                                                                focusedBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.green),
                                                                                ),
                                                                                labelText: "Old Password",
                                                                                hintText: "Enter current password",
                                                                                hintStyle: TextStyle(
                                                                                  color: Colors.grey,
                                                                                ),
                                                                                labelStyle: TextStyle(
                                                                                  color: Colors.grey,
                                                                                )),
                                                                            obscureText: true,
                                                                            // onSaved: (input) {
                                                                            //   _current
                                                                            // },
                                                                            // onChanged: (input) async {
                                                                            //   // FirebaseUser firebaseUser =
                                                                            //   //     await FirebaseAuth.instance.currentUser();
                                                                            //   // var authCredentials =
                                                                            //   //     EmailAuthProvider.getCredential(
                                                                            //   //         email: firebaseUser.email,
                                                                            //   //         password: _oldPassword.text);
                                                                            //   // var authResult = await firebaseUser
                                                                            //   //     .reauthenticateWithCredential(
                                                                            //   //         authCredentials);
                                                                            //   // if (authResult.user != null) {
                                                                            //   //   setState(() {
                                                                            //   //     _validate = true;
                                                                            //   //   });
                                                                            //   // }
                                                                            // },
                                                                            validator: (value) {
                                                                              if (value.isEmpty) {
                                                                                return "Please select password";
                                                                              } else
                                                                                return null;
                                                                            }
                                                                            /*value.isNotEmpty
                                    ? null
                                    : "Please enter a value"*/
                                                                            ,
                                                                          ),
                                                                          Divider(),
                                                                          TextFormField(
                                                                            controller: _password,
                                                                            decoration: InputDecoration(
                                                                                enabledBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.grey),
                                                                                ),
                                                                                focusedBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.green),
                                                                                ),
                                                                                labelText: "New Password",
                                                                                hintText: "Enter new password",
                                                                                hintStyle: TextStyle(
                                                                                  color: Colors.grey,
                                                                                ),
                                                                                labelStyle: TextStyle(
                                                                                  color: Colors.grey,
                                                                                )),
                                                                            obscureText: true,
                                                                            // onChanged: (input) {
                                                                            //
                                                                            //   password = input;
                                                                            // },
                                                                            onSaved: (input) {
                                                                              //user.password = input;
                                                                            },
                                                                            validator: (value) {
                                                                              // ignore: missing_return
                                                                              if (value != _password.text) return 'Please enter correct password';

                                                                              if (value.length < 8 && _password.text == null) return 'Must contain 8-30 characters';

                                                                              if (_password.text == _oldPassword.text) return 'New password cannot be same as current password';
                                                                              return null;
                                                                            },
                                                                          ),
                                                                          Divider(),
                                                                          TextFormField(
                                                                            controller: _passwordConfirm,
                                                                            decoration: InputDecoration(
                                                                                enabledBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.grey),
                                                                                ),
                                                                                focusedBorder: UnderlineInputBorder(
                                                                                  borderSide: BorderSide(color: Colors.green),
                                                                                ),
                                                                                labelText: "Confirm Password",
                                                                                hintText: "Confirm the password",
                                                                                hintStyle: TextStyle(
                                                                                  color: Colors.grey,
                                                                                ),
                                                                                labelStyle: TextStyle(
                                                                                  color: Colors.grey,
                                                                                )),
                                                                            obscureText: true,
                                                                            validator: (input) {
                                                                              return _password.text != input ? "Passwords do no match" : null;
                                                                              // return password != input
                                                                              //     ? 'Passwords do not match'
                                                                              //     : null;
                                                                            },
                                                                          ),
                                                                          Divider(),
                                                                          Row(
                                                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                            children: [
                                                                              RaisedButton(
                                                                                elevation: 0,
                                                                                child: Text(
                                                                                  'Save',
                                                                                  style: TextStyle(color: KirthanStyles.colorPallete30),
                                                                                ),
                                                                                color: Colors.transparent,
                                                                                onPressed: () async {
                                                                                  if (_formKey.currentState.validate()) {
                                                                                    FirebaseUser s = await FirebaseAuth.instance.currentUser();

                                                                                    // //Pass in the password to updatePassword.
                                                                                    // SignInService signIn = new SignInService();
                                                                                    // signIn.validatePassword(_oldPassword.text).whenComplete(() => null);
                                                                                    var authCredentials = EmailAuthProvider.getCredential(email: s.email, password: _oldPassword.text);
                                                                                    try {
                                                                                      var authResult = await s.reauthenticateWithCredential(authCredentials);
                                                                                      if (authResult.user != null) {
                                                                                        s.updatePassword(_password.text).then((_) {
                                                                                          print("");
                                                                                        }).catchError((error) {
                                                                                          print('');
                                                                                          //This might happen, when the wrong password is in, the user isn't found, or if the user hasn't logged in recently.
                                                                                        });
                                                                                        _formKey.currentState.save();
                                                                                        String userrequestStr = jsonEncode(user.toStrJson());
                                                                                        userPageVM.submitUpdateUserRequestDetails(userrequestStr);
                                                                                        SnackBar mysnackbar = SnackBar(
                                                                                          content: Text("User details updated $successful"),
                                                                                          duration: new Duration(seconds: 4),
                                                                                          backgroundColor: Colors.green,
                                                                                        );
                                                                                        Scaffold.of(context).showSnackBar(mysnackbar);
                                                                                      }
                                                                                    } catch (e) {
                                                                                      if (e.toString() == null) {
                                                                                        errMessage = null;
                                                                                      }
                                                                                      if (e.code == 'ERROR_USER_NOT_FOUND') {
                                                                                        errMessage = 'No user Found';
                                                                                      } else if (e.code == 'ERROR_WRONG_PASSWORD') {
                                                                                        errMessage = 'Old password is wrong. Try Again!';
                                                                                      }
                                                                                      Scaffold.of(context).showSnackBar(SnackBar(
                                                                                        content: Text(errMessage),
                                                                                        backgroundColor: Colors.red,
                                                                                      ));
                                                                                    }
                                                                                  }
                                                                                },
                                                                              ),
                                                                              RaisedButton(
                                                                                elevation: 0,
                                                                                child: Text('Reset'),
                                                                                color: Colors.transparent,
                                                                                //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                                                                onPressed: () {
                                                                                  _passwordConfirm.clear();
                                                                                  _password.clear();
                                                                                },
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )));
                                                    },
                                                  ),
                                                ],
                                              ),
                                              TextFormField(
                                                enabled: false,
                                                decoration: InputDecoration(
                                                  disabledBorder:
                                                  UnderlineInputBorder(
                                                      borderSide:
                                                      BorderSide(
                                                          color: Colors
                                                              .grey)),
                                                ),
                                                initialValue: "0000000",
                                                obscureText: true,
                                              ),
                                            ],
                                          )
                                          // : Container(),
                                        ],
                                      ),

                                      // Card(
                                      //   child: ListTile(
                                      //     trailing: Icon(
                                      //       Icons.keyboard_arrow_right,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     leading: Icon(
                                      //       Icons.content_paste,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     title: Consumer<ThemeNotifier>(
                                      //       builder: (context, notifier, child) => Text(
                                      //         'Description/Type',
                                      //         style: TextStyle(
                                      //           fontSize: notifier.custFontSize,
                                      //           color: KirthanStyles.colorPallete30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => description_profile(),
                                      //           ));
                                      //     },
                                      //     selected: true,
                                      //   ),
                                      // ),
                                      // Divider(),
                                      // Card(
                                      //   child: ListTile(
                                      //     trailing: Icon(
                                      //       Icons.keyboard_arrow_right,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     leading: Icon(
                                      //       Icons.group_add,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     title: Consumer<ThemeNotifier>(
                                      //       builder: (context, notifier, child) => Text(
                                      //         'Members',
                                      //         style: TextStyle(
                                      //           fontSize: notifier.custFontSize,
                                      //           color: KirthanStyles.colorPallete30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => members_profile(
                                      //               show: false,
                                      //             ),
                                      //           ));
                                      //     },
                                      //     selected: true,
                                      //   ),
                                      // ),
                                      // Divider(),
                                      // Card(
                                      //   child: ListTile(
                                      //     trailing: Icon(
                                      //       Icons.keyboard_arrow_right,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     leading: Icon(
                                      //       Icons.contacts,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     title: Consumer<ThemeNotifier>(
                                      //       builder: (context, notifier, child) => Text(
                                      //         'Contact Details',
                                      //         style: TextStyle(
                                      //           fontSize: notifier.custFontSize,
                                      //           color: KirthanStyles.colorPallete30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => contact_details_profile(),
                                      //           ));
                                      //     },
                                      //     selected: true,
                                      //   ),
                                      // ),
                                      // Divider(),
                                      // Card(
                                      //   child: ListTile(
                                      //     trailing: Icon(
                                      //       Icons.keyboard_arrow_right,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     leading: Icon(
                                      //       Icons.my_location,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     title: Consumer<ThemeNotifier>(
                                      //       builder: (context, notifier, child) => Text(
                                      //         'Location',
                                      //         style: TextStyle(
                                      //           fontSize: notifier.custFontSize,
                                      //           color: KirthanStyles.colorPallete30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //           context,
                                      //           MaterialPageRoute(
                                      //             builder: (context) => location_profile(),
                                      //           ));
                                      //     },
                                      //     selected: true,
                                      //   ),
                                      // ),
                                      // Divider(),
                                      // Card(
                                      //   child: ListTile(
                                      //     trailing: Icon(
                                      //       Icons.keyboard_arrow_right,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     leading: Icon(
                                      //       Icons.keyboard,
                                      //       color: KirthanStyles.colorPallete30,
                                      //     ),
                                      //     title: Consumer<ThemeNotifier>(
                                      //       builder: (context, notifier, child) => Text(
                                      //         'Password',
                                      //         style: TextStyle(
                                      //           fontSize: notifier.custFontSize,
                                      //           color: KirthanStyles.colorPallete30,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onTap: () {
                                      //       Navigator.push(
                                      //         context,
                                      //         MaterialPageRoute(
                                      //             builder: (context) => password_profile()),
                                      //       );
                                      //     },
                                      //     selected: true,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                );
                              }
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            });
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
                onRefresh: refreshList,
              ));
        });
  }
}
