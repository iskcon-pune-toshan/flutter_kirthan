import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:http/http.dart';

class contact_details_profile extends StatefulWidget {
  UserRequest userRequest;
  contact_details_profile({Key key, @required this.userRequest})
      : super(key: key);
  @override
  _contact_details_profileState createState() =>
      _contact_details_profileState();
}

class _contact_details_profileState extends State<contact_details_profile> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final TextEditingController _emailController =
  new TextEditingController();
  final TextEditingController _phoneController =
  new TextEditingController();
  final TextEditingController _addressController =
  new TextEditingController();
   String emaill;
  final FirebaseAuth auth = FirebaseAuth.instance;
  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    String email = user.email;
     _emailController.text=email;
    //widget.userRequest.updatedBy = email;
    print(email);
    return email;
  }
  void initState() {
    getCurrentUser();

    return super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Divider(),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                icon: Icon(
                  Icons.phone_in_talk,
                  color: Colors.grey,
                ),
                labelText: "Phone Number",
                labelStyle: TextStyle(
                  fontSize: MyPrefSettingsApp.custFontSize,
                  color: Colors.grey,
                ),
                hintText: "",
              ),

            ),
            Divider(),

      new Container(
        child: new TextFormField(
          decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              labelText: "Email",
              hintStyle: TextStyle(
                color: Colors.grey,
              ),
              labelStyle: TextStyle(
                color: Colors.grey,
              )),
          autocorrect: false,
          controller: _emailController,
          onSaved: (String value) {
           value=getCurrentUser();
          },
        ),
      ),
            Divider(),
            TextFormField(
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.green),
                ),
                icon: Icon(Icons.home, color: Colors.grey),
                labelText: "Address",
                labelStyle: TextStyle(
                  fontSize: MyPrefSettingsApp.custFontSize,
                  color: Colors.grey,
                ),
                hintText: "",
              ),
              
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  child: Text('Save'),
                  color: Colors.green,
                  onPressed: () {},
                ),
                RaisedButton(
                  child: Text('Cancel'),
                  color: Colors.redAccent,
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
    );
  }
}
