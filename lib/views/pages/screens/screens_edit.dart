import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/screens.dart';
import 'package:flutter_kirthan/services/screens_service_impl.dart';
import 'package:flutter_kirthan/view_models/screens_page_view_model.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:screen/screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


final ScreensPageViewModel screensPageVM =
ScreensPageViewModel(apiSvc: ScreensAPIService());


class EditScreens extends StatefulWidget {
  Screens screensrequest ;
  final String screenName = SCR_SCREENS;

  EditScreens({ @required this.screensrequest}) ;

  @override
  _EditScreensState createState() => new _EditScreensState();
}

class _EditScreensState extends State<EditScreens> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  //EventRequest eventrequestobj = new EventRequest();
  //_EditProfileViewState({Key key, @required this.eventrequest}) ;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  String _selectedState;
  String state;
  var _states = ["GOA","GUJ","MAH"];
  // controllers for form text controllers
  final TextEditingController _screenNameController = new TextEditingController();
  String screenName ;




  @override
  void initState() {
    _screenNameController.text = widget.screensrequest.screenName;


    return super.initState();
  }



  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);


    return new Scaffold(
        appBar: new AppBar(title: const Text('Edit Profile'), actions: <Widget>[
          new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
              child: new RaisedButton(
                color: themeData.primaryColor,
                textColor: themeData.secondaryHeaderColor,
                child: new Text('Save'),
                onPressed: () {
                  // _handleSubmitted();
                  _formKey.currentState.save();
                  Navigator.pop(context);
                  print(screenName);

                  //print(widget.eventrequest.eventDescription);
                  //Map<String,dynamic> eventmap = widget.eventrequest.toJson();
                  //String eventmap = widget.eventrequest.toStrJsonJson();
                  String eventrequestStr = jsonEncode(widget.screensrequest.toStrJson());
                  screensPageVM.submitUpdateScreens(eventrequestStr);
                },
              ))
        ]),
        body: new Form(
            key: _formKey,
            autovalidate: true,
            //onWillPop: _warnUserAboutInvalidData,
            child: new ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: <Widget>[


                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Screen Name", hintText: "What do people call this event?"),
                    autocorrect: false,
                    controller: _screenNameController,
                    onSaved: (String value) {
                      widget.screensrequest.screenName = value;
                    },
                  ),
                ),





              ],
            )));
  }
}