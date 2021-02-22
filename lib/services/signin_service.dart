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

  FirebaseUser fireUser = null;

  Future<FirebaseUser> signUpWithEmail(String email, String password) async {
    AuthResult authResult = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    String url = 'https://banner2.cleanpng.com/20180331/eow/kisspng-computer-icons-user-clip-art-user-5abf13db298934.2968784715224718991702.jpg';
    //String  url = 'assets/images/default_icon.png';

    if (authResult != null) {
      UserUpdateInfo updateInfo = UserUpdateInfo();
      updateInfo.displayName = email;
      updateInfo.photoUrl = url ;
      FirebaseUser firebaseUser = authResult.user;

      if (firebaseUser != null) {
        await firebaseUser.updateProfile(updateInfo);

        await firebaseUser.reload();

        FirebaseUser currentuser = await firebaseAuth.currentUser();


        return currentuser;
      }
    }
    return null;
  }

  Future<FirebaseUser> signInWithEmail(String email, String password) async {
    AuthResult authResult = await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser firebaseUser;

    /*if (authResult != null) {
       firebaseUser = await firebaseAuth.currentUser();

      if (firebaseUser != null) {
        return firebaseUser;
      }
    }*/

    assert(email !=
        null); //its a way to check the condition & returns a boolean by the result of which further execution proceeds
    assert(password != null);

    final AuthCredential auth = EmailAuthProvider.getCredential(
        email: email,
        password:
            password); // to fetch the user Credential by signInwithemailandpassword method

    FirebaseUser user = (await firebaseAuth.signInWithCredential(auth)).user;

    fireUser =
        user; //once onComplete returning the user to able to fetch the credentials
    return user;

    //return null;
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

    fireUser = user;
    print(user);
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

  Future<bool> signOut() async {
    bool signout = true;
    firebaseAuth.currentUser() != null
        ? firebaseAuth.signOut()
        : print("User not signed in Firebase");
    googleSignIn.isSignedIn().then((onValue) => onValue == true
        ? googleSignIn.disconnect()
        : print("User not signed in Google"));
    facebookLogin.isLoggedIn.then((onValue) => onValue == true
        ? facebookLogin.logOut()
        : print("User not signed in Facebook"));

    return signout;
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
