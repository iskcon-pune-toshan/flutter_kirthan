import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/provider.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';

class profilePicture extends StatefulWidget {
  @override
  _profilePictureState createState() => _profilePictureState();
}

class _profilePictureState extends State<profilePicture> {
  File _image;
  String profilePic;
  String photoUrl;
  // final FirebaseAuth auth = FirebaseAuth.instance;
  // getCurrentUser() async {
  //   final FirebaseUser user = await auth.currentUser() ;
  //   final String email = user.email.toString();
  //   print(email);
  //   return email;
  // }
  //   getEmail()async{
  //   String _profilePic = await getCurrentUser();
  //   return _profilePic;
  // }
  // _profilePictureState(this.profilePic);
  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    // Widget ProfilePages() {
    //   profilePic=getEmail() ;
    //   //profilePic = getCurrentUser() as String;
    //   //  StorageReference ref = FirebaseStorage.instance.ref();
    //   final ref = FirebaseStorage.instance.ref().child(
    //       profilePic+'.jpg');
    //   return FutureBuilder(
    //       future: ref.getDownloadURL(),
    //       builder: (context, snapshot) {
    //         if (snapshot.data != null) {
    //           print("\n\n\n\n\n\n\n" + snapshot.data + "\n\n\n\n\n\n");
    //           // return new CachedNetworkImage(
    //           //   height: 110,
    //           //   width: 140,
    //           //   fit: BoxFit.fill,
    //           //   imageUrl: snapshot.data,
    //           //   placeholder: (context, url) => CircularProgressIndicator(),
    //           //   errorWidget: (context, url, error) => Icon(Icons.error),
    //           // );
    //
    //           return new Image.network(snapshot.data,
    //               height: 100.0, width: 100.0, fit: BoxFit.fill);
    //
    //         }
    //         return CircularProgressIndicator();
    //       });
    // }
    Future<String> getEmail() async {
      final FirebaseAuth auth = FirebaseAuth.instance;
      var user = await auth.currentUser();
      var email = user.email;
      return email;
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
              print("\n\n\n\n\n\n\n\n\n\n\n" + _email + "\n\n\n\n\n\n\n\n");
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
      String uemail = user.email;
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child(uemail + '.jpg');
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      FirebaseStorage.instance
          .ref()
          .child(fileName)
          .getDownloadURL()
          .then((value) => {photoUrl = value});
      // retrievePic(photoUrl);
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
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
      setState(() {
        print("Profile Picture deleted");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Deleted Profile Picture')));
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Picture'),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Align(
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 100,
                      backgroundColor: Color(0xff476cfb),
                      child: ClipOval(
                        child: new SizedBox(
                            width: 180.0,
                            height: 180.0,
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
                    ),
                  ),
                ],
              ),
              Card(
                //margin: const EdgeInsets.only(top: 200.0),
                child: SizedBox(
                    height: 300.0,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Consumer<ThemeNotifier>(
                              builder: (context, notifier, child) => Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                 /* Text(
                                    'Username:    ',
                                    style: TextStyle(
                                        fontSize: notifier.custFontSize),
                                  ),
                                  Text(
                                    'User 1',
                                    style: TextStyle(
                                        fontSize: notifier.custFontSize,
                                        fontWeight: FontWeight.bold),
                                  ),*/
                                ],
                              ),
                            ),
                            FlatButton(
                              child: Text('Change Profile Picture'),
                              onPressed: () {
                                getImage();
                              },
                              highlightColor: Colors.amber,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              color: KirthanStyles.colorPallete30,
                            ),
                            FlatButton(
                              child: Text('Delete Profile Picture'),
                              //padding: EdgeInsets.only(left: 00.0,top: 10.0,right: 10.0,bottom: 0.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              color: KirthanStyles.colorPallete30,
                              onPressed: () {
                                //Image.asset('assets/images/default_profile_picture.png');
                                ProfilePages();
                                deletePic(context);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                RaisedButton(
                                  child: Text('Save'),
                                  color: Colors.blueGrey,
                                  onPressed: () {
                                    uploadPic(context);
                                  },
                                ),
                                RaisedButton(
                                  child: Text('Cancel'),
                                  color: Colors.blueGrey,
                                  //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
