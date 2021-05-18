import 'dart:io';
import 'package:flutter_kirthan/locator.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/profile_settings_page/storage_repo.dart';

class UserController {
  UserRequest _currentUser;
  SignInService _authRepo = locator.get<SignInService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  Future init;

  UserController() {
    init = initUser();
  }

  Future<UserRequest> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserRequest get currentUser => _currentUser;
  Future<void> uploadProfilePicture(File image) async {
    _currentUser.avatarUrl = await _storageRepo.uploadFile(image);
  }


  Future<String> getDownloadUrl() async {
    return await _storageRepo.getUserProfileImage(currentUser.id.toString());
  }

  Future<void> signInWithEmailAndPassword(
      {String email, String password}) async {
    _currentUser = await _authRepo.signInWithEmailAndPassword(
        email: email, password: password);

    _currentUser.avatarUrl = await getDownloadUrl();
  }

  void updateDisplayName(String displayName) {
    _currentUser.userName = displayName;
    _authRepo.updateDisplayName(displayName);
  }


  Future<bool> validateCurrentPassword(String password) async {
    return await _authRepo.validatePassword(password);
  }

  void updateUserPassword(String password) {
    _authRepo.updatePassword(password);
  }
}


