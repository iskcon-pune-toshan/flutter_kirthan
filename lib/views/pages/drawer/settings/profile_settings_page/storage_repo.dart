import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/locator.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:path/path.dart';

File _image;

class StorageRepo {
  FirebaseStorage _storage =
      FirebaseStorage(storageBucket: "gs://iskconkirthan.appspot.com");
  SignInService _authRepo = locator.get<SignInService>();

  Future<String> uploadFile(File file) async {
    UserRequest user = await _authRepo.getUser();
    var userId = user.uid;
      String fileName = basename(file.path);
    var storageRef = _storage.ref().child("profiles/$userId");
    var uploadTask = storageRef.putFile(file);
    var completedTask = await uploadTask.onComplete;
    String downloadUrl = await completedTask.ref.getDownloadURL();
    return downloadUrl;
  }

  // Future uploadPic(BuildContext context) async{
  //   String fileName = basename(_image.path);
  //   StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("profiles/").child(fileName);
  //   StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
  //   StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
  // setState(() {
  //   print("Profile Picture uploaded");
  //   Scaffold.of(context).showSnackBar(SnackBar(content: Text('Profile Picture Uploaded')));
  // });
  // }

  // Future deletePic(BuildContext context) async
  // {
  //   String fileName = basename(_image.path);
  //   StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child("profiles/").child(fileName);
  //   await firebaseStorageRef.delete();
  //   // setState(() {
  //   //   print("Profile Picture deleted");
  //   //   Scaffold.of(context).showSnackBar(SnackBar(content: Text('Deleted Profile Picture')));
  //   // });
  // }

  Future<String> getUserProfileImage(String uid) async {
    return await _storage.ref().child("profiles/uid").getDownloadURL();

  }
}
