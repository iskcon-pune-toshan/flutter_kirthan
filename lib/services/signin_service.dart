import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class SignInService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  Future<FirebaseUser> googSignIn(BuildContext context) async {
    /*Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign In'),
    ));
*/
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
    await googleUser.authentication;


    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser userDetails =
        (await _firebaseAuth.signInWithCredential(credential)).user;

    /*ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

    List<ProviderDetails> provderData = new List<ProviderDetails>();
    provderData.add(providerInfo);



    UserDetails details = new UserDetails(
        userDetails.providerId,
        userDetails.displayName,
        userDetails.photoUrl,
        userDetails.email,
        provderData);

    print(details);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(detailsUser: details)));
*/
    return userDetails;
  }

  Future<FirebaseUser> facebookSignIn(BuildContext context) async {

    /*
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign In'),
    ));
*/
    //final FacebookLogin facebookLogin = FacebookLogin();
    final FacebookLoginResult result = await facebookLogin.logIn(['email']);


    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
    );

    FirebaseUser userDetails;

    if (result.status == FacebookLoginStatus.loggedIn) {
      userDetails = (await _firebaseAuth.signInWithCredential(credential)).user;
      print(userDetails.displayName);
    }

/*
    ProviderDetails providerInfo = new ProviderDetails(userDetails.providerId);

    List<ProviderDetails> provderData = new List<ProviderDetails>();
    provderData.add(providerInfo);

    UserDetails details = new UserDetails(
        userDetails.providerId,
        userDetails.displayName,
        userDetails.photoUrl,
        userDetails.email,
        provderData);

    print(details);

    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfileScreen(detailsUser: details)));

    */

    return userDetails;
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
