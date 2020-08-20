import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/signin/profile_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';

class SignInApp extends StatefulWidget {
  @override
  _SignInAppState createState() => _SignInAppState();
}

class _SignInAppState extends State<SignInApp> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = new GoogleSignIn();
  final FacebookLogin facebookLogin = FacebookLogin();

  Future<FirebaseUser> googSignIn(BuildContext context) async {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign In'),
    ));

    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;



    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    FirebaseUser userDetails =
        (await _firebaseAuth.signInWithCredential(credential)).user;
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

    return userDetails;
  }

  Future<FirebaseUser> facebookSignIn(BuildContext context) async {
    Scaffold.of(context).showSnackBar(new SnackBar(
      content: new Text('Sign In'),
    ));

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

    return userDetails;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
          builder: (context) => Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: 300.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: GoogleSignInButton (
                            darkMode: true,
                            onPressed: () => googSignIn(context)
                                .then((FirebaseUser user) => print(user))
                                .catchError((e) => print(e)),
                          ),
                        ),
                      ),
                      Container(
                        width: 300.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: FacebookSignInButton(
                            onPressed: () => facebookSignIn(context)
                                .then((FirebaseUser user) => print(user))
                                .catchError((e) => print(e)),
                          ),
                        ),
                      ),
                      Container(
                        width: 250.0,
                        child: Align(
                          alignment: Alignment.center,
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            color: Color(0xffffffff),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.solidEnvelope,
                                  color: Color(0xffCE107C),
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Sign in with Email',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18.0),
                                ),
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
    );
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
