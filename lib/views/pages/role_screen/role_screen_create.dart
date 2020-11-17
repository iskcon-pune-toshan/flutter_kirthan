import 'dart:async';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/role_screen_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/addlocation.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final RoleScreenViewPageModel roleScreenPageVM =
RoleScreenViewPageModel(apiSvc: RoleScreenAPIService());


class RoleScreenWrite extends StatefulWidget {
  // EventWrite({Key key}) : super(key: key);
  final String screenName = SCR_ROLE_SCREEN;
  RoleScreen roleScreenrequest;

  @override
  _RoleScreenWriteState createState() => _RoleScreenWriteState();

  RoleScreenWrite({@required this.roleScreenrequest});
}
class _RoleScreenWriteState extends State<RoleScreenWrite> {

  final _formKey = GlobalKey<FormState>();
  RoleScreen roleScreen = new RoleScreen();
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
                            labelText: "Role Id",
                            hintText: "",
                          ),
                          onSaved: (input){
                            roleScreen.roleId = input as int;
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
                            labelText: "Screen Id",
                            hintText: "",
                          ),
                          onSaved: (input){
                            roleScreen.screenId = input as int;
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
                            labelText: "Create",
                            hintText: "",
                          ),
                          onSaved: (input){
                            roleScreen.isCreated = input as bool;
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
                          //attribute: "Type",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.low_priority),
                            labelText: "View",
                            hintText: "",
                          ),
                          onSaved: (input){
                            roleScreen.isViewd = input as bool;
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
                          //attribute: "PhoneNumber",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.phone_iphone),
                            labelText: "Updated",
                            hintText: "",
                          ),
                          onSaved: (input){
                            roleScreen.isUpdated = int.parse(input) as bool;
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
                          //attribute: "PhoneNumber",
                          decoration: InputDecoration(
                            icon: const Icon(Icons.phone_iphone),
                            labelText: "Delete",
                            hintText: "",
                          ),
                          onSaved: (input){
                            roleScreen.isDeleted = int.parse(input) as bool;
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
                                roleScreen.isProcessed = false;
                                roleScreen.roleId = 1;
                                //String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS").format(DateTime.now());
                                roleScreen.screenId ;
                                roleScreen.isCreated = false;
                                roleScreen.isUpdated = false;
                                roleScreen.isDeleted = false;
                                roleScreen.isViewd = false;

                                List<RoleScreen> roleScreenmap = roleScreen.toJson() as List<RoleScreen>;
                                List<RoleScreen> newroleScreenrequest =await roleScreenPageVM.submitNewRoleScreenMapping(roleScreenmap);
                                //print(newroleScreenrequest.id);
                                //String uid = newroleScreenrequest.id.toString();
                                SnackBar mysnackbar = SnackBar (
                                  content: Text("Role Screen added $successful "),
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

