import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';


final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());


class contact_details_profile extends StatefulWidget {
  UserRequest userrequest;
  contact_details_profile({Key key, @required this.userrequest}) : super(key: key);
  @override
  _contact_details_profileState createState() =>
      _contact_details_profileState();
}

class _contact_details_profileState extends State<contact_details_profile> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  String phoneNumber;
  final TextEditingController userPhoneNumberController =
      new TextEditingController();
  String address;
  final TextEditingController userAddressController =
      new TextEditingController();
  String email;
  final TextEditingController userEmailController =
      new TextEditingController();

  void initState() {
    userEmailController.text = widget.userrequest.email;
    userPhoneNumberController.text = widget.userrequest.phoneNumber.toString();
    userAddressController.text = widget.userrequest.addLineOne;
    return super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact Details"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Divider(),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                icon: Icon(Icons.phone_in_talk),
                labelText: "Phone Number",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
              autocorrect: false,
              controller: userPhoneNumberController,
              onSaved: (String value) {
                widget.userrequest.phoneNumber = int.parse(value);
              },
            ),
            Divider(),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                icon: Icon(Icons.email),
                labelText: "Email Id",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
              autocorrect: false,
              controller: userEmailController,
              onSaved: (String value) {
                widget.userrequest.email = value;
              },
            ),
            Divider(),
            TextFormField(
              decoration: InputDecoration(
                icon: Icon(Icons.home),
                labelText: "Address",
                labelStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                hintText: "",
              ),
              autocorrect: false,
              controller: userAddressController,
              onSaved: (String value) {
                widget.userrequest.addLineOne = value;
              },
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  child: Text('Save'),
                  color: Colors.green,
                  onPressed: () {
                    _formKey.currentState.save();
                    Navigator.pop(context);
                    print(widget.userrequest.phoneNumber);
                    print(widget.userrequest.email);
                    print(widget.userrequest.addLineOne);
                    String userrequestStr =
                        jsonEncode(widget.userrequest.toStrJson());
                    userPageVM.submitUpdateUserRequest(userrequestStr);
                  },
                ),
                MaterialButton(
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
