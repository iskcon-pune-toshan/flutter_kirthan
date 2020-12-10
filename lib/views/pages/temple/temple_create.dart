import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/services/temple_service_impl.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/addlocation.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/MapsBloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:shared_preferences/shared_preferences.dart';

final TemplePageViewModel templePageVM =
TemplePageViewModel(apiSvc: TempleAPIService());


class TempleWrite extends StatefulWidget {
  TempleWrite({Key key}) : super(key: key);

  @override
  _TempleWriteState createState() => _TempleWriteState();
}

class _TempleWriteState extends State<TempleWrite> {
  static final _formKey = GlobalKey<FormState>();
  static final _formKey1 = GlobalKey<FormState>();
  static final _formKey2 = GlobalKey<FormState>();
  static final _formKey3 = GlobalKey<FormState>();
  static List<GlobalKey<FormState>> formkeys = [
    _formKey,
    _formKey1,
    _formKey2,
    _formKey3
  ];
  int i = 0;
  static Temple templerequest = new Temple();
  final String screenName = SCR_TEMPLE;
  BuildContext context;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  //UserRequest newuserrequest = new UserRequest();



  List<Step> steps = [
    Step(
      title: const Text('New Temple'),
      isActive: true,
      state: StepState.complete,
      content: Form(
        key: formkeys[0],
        autovalidate: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              maxLength: 30,
              //attribute: "Username",
              decoration: InputDecoration(
                  icon: const Icon(Icons.tag_faces),
                  hintText: "",
                  labelText: "Temple Name"),
              onChanged: (input) {
                templerequest.templeName = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "Password",
              decoration: InputDecoration(
                icon: const Icon(Icons.location_on),
                labelText: "Area",
                hintText: "",
              ),
              onChanged: (input) {
                templerequest.area = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "govtidtype",
              decoration: InputDecoration(
                icon: const Icon(Icons.location_city),
                labelText: "City",
                hintText: "",
              ),
              onChanged: (input) {
                templerequest.city = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),


          ],

        ),

      ),
    ),



  ];

  int currentStep = 0;
  bool complete = false;

  next() {
    if (formkeys[i].currentState.validate()) {
      // _formKey.currentState.save();
      currentStep + 1 != steps.length
          ? goTo(currentStep + 1)
          : setState(() => complete = true);
      i++;
    }
  }

  cancel() {
    if (currentStep > 0) {
      goTo(currentStep - 1);
    }
  }

  goTo(int step) {
    setState(() => currentStep = step);
  }

  StepperType stepperType = StepperType.vertical;

  switchStepType() {
    setState(() => stepperType == StepperType.horizontal
        ? stepperType = StepperType.vertical
        : stepperType = StepperType.horizontal);
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(title: const Text('Register Temple'), actions: <Widget>[
        new Container(
          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
        )
      ]),
      body: Column(
        children: <Widget>[
          complete
              ? Expanded(
              child: Center(
                child: AlertDialog(
                    title: new Text("Details Filled !"),
                    content: new Text(
                      "Click Submit on top right corner of the screen.",
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Submit"),
                        onPressed: () async {

                          Map<String, dynamic> usermap = templerequest.toJson();
                          print(usermap);
                          Temple newtemplerequest =
                          await templePageVM.submitNewTemple(usermap);
                          print(newtemplerequest.id);
                          String uid = newtemplerequest.id.toString();
                          SnackBar mysnackbar = SnackBar(
                            content: Text(
                                "Temple registered $successful with id : $uid "),
                            duration: new Duration(seconds: 4),
                            backgroundColor: Colors.green,
                          );

                          _scaffoldKey.currentState.showSnackBar(mysnackbar);

                          //String s = jsonEncode(userrequest.mapToJson());
                          //service.registerUser(s);
                          //print(s);
                        },
                      ),
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          setState(() => complete = false);
                        },
                      ),
                      Card(
                        child: Column(
                          children: <Widget>[




                            RaisedButton.icon(
                              onPressed: () {
                                Navigator.push( context,MaterialPageRoute(
                                  builder: (context) =>
                                      BlocProvider(
                                        create: (BuildContext context) => MapsBloc(),
                                        child:
                                        AddLocation(),
                                      ),
                                ),);


                              },

                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                              label: Text('Add Location',
                                style: TextStyle(color: Colors.black),),
                              icon: Icon(Icons.location_on,
                                color:Colors.black,),
                              textColor: Colors.black,
                              splashColor: Colors.red,
                              color: Colors.white,

                            ),
                          ],
                        ),
                      ),
                    ]),
              )
          )
              : Expanded(
            child: Stepper(
              type: stepperType,
              steps: steps,
              currentStep: currentStep,
              onStepContinue: next,
              onStepTapped: (step) => goTo(step),
              onStepCancel: cancel,
            ),
          ),
        ],
      ),

    );

  }
}
