import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SignInService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  static final SignInService _internal = SignInService.internal();

  factory SignInService() => _internal;

  SignInService.internal();

  Future<FirebaseUser> signUpWithEmail(String email, String password) async {
    FirebaseUser user = (await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;

    return user;
  }

  Future<FirebaseUser> signInWithEmail(String email, String password) async {

    AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    print(authResult.additionalUserInfo.providerId);

    FirebaseUser user = authResult.user;

    return user;

  }

  Future<FirebaseUser> googSignIn(BuildContext context) async {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser user =
        (await firebaseAuth.signInWithCredential(credential)).user;

    return user;
  }

  Future<FirebaseUser> facebookSignIn(BuildContext context) async {
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);

    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );

    FirebaseUser user;

    if (result.status == FacebookLoginStatus.loggedIn) {
      user = (await firebaseAuth.signInWithCredential(credential)).user;
      print(user.displayName);
    }
    return user;
  }

  void signOut() async {
    firebaseAuth.currentUser() != null
        ? firebaseAuth.signOut()
        : print("User not signed in FIrebase");
    googleSignIn.isSignedIn().then((onValue) => onValue == true
        ? googleSignIn.signOut()
        : print("User not signed in Google"));
    facebookLogin.isLoggedIn.then((onValue) => onValue == true
        ? facebookLogin.logOut()
        : print("User not signed in Facebook"));
  }
}

class UserDetails {
  final String provderDetails;
  final String UserName;
  final String photoUrl;
  final String userEmail;
  final List<ProviderDetails> providerData;

  UserDetails(this.provderDetails, this.UserName, this.photoUrl, this.userEmail,
      this.providerData);
}

class ProviderDetails {
  final String providerDetails;
  ProviderDetails(this.providerDetails);
}
