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

class profilePicture extends StatefulWidget {
  @override
  _profilePictureState createState() => _profilePictureState();
}

class _profilePictureState extends State<profilePicture> {
  File _image;

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);

      setState(() {
        _image = image;
        print('Image Path $_image');
      });
    }

    /*Future uploadPic(BuildContext context) async{
      String fileName = basename(_image.path);
      //StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
      FirebaseStorage fstorage = FirebaseStorage.instance;
      String mainurl = "gs://fir-project-61838.appspot.com";
      StorageReference storageReference = await fstorage.getReferenceFromUrl(mainurl);
      //StorageReference ref = FirebaseStorage.
      //var gsReference = storage.refFromURL('gs://bucket/images/stars.jpg');
      StorageUploadTask uploadTask = storageReference.putFile(_image);
      StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }
  */

    Future uploadPic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("profiles/").child(fileName);
      StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      setState(() {
        print("Profile Picture uploaded");
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
      });
    }

    Future deletePic(BuildContext context) async {
      String fileName = basename(_image.path);
      StorageReference firebaseStorageRef =
          FirebaseStorage.instance.ref().child("profiles/").child(fileName);
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
                              : Image.asset(
                                  "assets/images/default_profile_picture.png",
                                  fit: BoxFit.fill,
                                ),
                        ),
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
                                  Text(
                                    'Username:    ',
                                    style: TextStyle(
                                        fontSize: notifier.custFontSize),
                                  ),
                                  Text(
                                    'User 1',
                                    style: TextStyle(
                                        fontSize: notifier.custFontSize,
                                        fontWeight: FontWeight.bold),
                                  ),
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
