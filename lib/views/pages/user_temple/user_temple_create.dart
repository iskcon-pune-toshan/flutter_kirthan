import 'dart:async';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/role_screen_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/addlocation.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final UserTemplePageViewModel userTemplePageVM =
UserTemplePageViewModel(apiSvc: UserTempleAPIService());


class UserTempleCreate extends StatefulWidget {
  // EventWrite({Key key}) : super(key: key);
  final String screenName = SCR_USER_TEMPLE;
  RoleScreen userTempleRequest;

  @override
  _UserTempleCreateState createState() => _UserTempleCreateState();

  UserTempleCreate({@required this.userTempleRequest});
}
class _UserTempleCreateState extends State<UserTempleCreate> {

  final _formKey = GlobalKey<FormState>();
  UserTemple userTemple = new UserTemple();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Builder(builder: (context){
        return SingleChildScrollView(
          child: Container(
            color: Colors.teal,
            child: Center(
              child:Form(
                // context,
                key: _formKey,
                autovalidate: true,
                // readonly: true,
                child: Column(
                  //crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    new Container(
                        margin: const EdgeInsets.only(top: 50)
                    ),

                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "eventTitle",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.title),
                            labelText: "Temple Id",
                            hintText: "",
                          ),
                          onSaved: (input){
                            userTemple.templeId = input as int;
                          },
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      elevation: 5,
                    ),

                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "Description",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.description),
                            labelText: "Role Id",
                            hintText: "",
                          ),
                          onSaved: (input){
                            userTemple.roleId = input as int;
                          },
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      elevation: 5,
                    ),


                    Card(
                      child: Container(
                        padding: new EdgeInsets.all(10),
                        child:TextFormField(
                          //attribute: "Duration",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.timelapse),
                            labelText: "User id",
                            hintText: "",
                          ),
                          onSaved: (input){
                            userTemple.userId = input as int;
                          },
                          validator: (value) {
                            if(value.isEmpty) {
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                      elevation: 5,
                    ),

                    new Container(
                        margin: const EdgeInsets.only(top: 40)
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        MaterialButton(
                            child: Text("Submit",style: TextStyle(color: Colors.white),),
                            color: Colors.blue,
                            onPressed: () async{

                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                userTemple.templeId = 1;
                                userTemple.roleId = 1;
                                userTemple.userId ;

                                Map<String,dynamic> userTemplemap = userTemple.toJson();
                                UserTemple newuserTemplerequest = await userTemplePageVM.submitNewUserTemple(userTemplemap);
                                print(newuserTemplerequest.id);
                                String uid = newuserTemplerequest.id.toString();
                                SnackBar mysnackbar = SnackBar (
                                  content: Text("User Temple added $successful "),
                                  duration: new Duration(seconds: 4),
                                  backgroundColor: Colors.green,
                                );
                                Scaffold.of(context).showSnackBar(mysnackbar);
                              }

                            }
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );}
      ),
    );
  }
}

