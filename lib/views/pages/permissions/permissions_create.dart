import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/services/permissions_service_impl.dart';
import 'package:flutter_kirthan/view_models/permissions_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/permissions.dart';
import 'package:shared_preferences/shared_preferences.dart';

final PermissionsPageViewModel permissionssPageVM =
PermissionsPageViewModel(apiSvc: PermissionsAPIService());


class PermissionsWrite extends StatefulWidget {
  PermissionsWrite({Key key}) : super(key: key);

  @override
  _PermissionsWriteState createState() => _PermissionsWriteState();
}

class _PermissionsWriteState extends State<PermissionsWrite> {
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
  static Permissions permissionsrequest = new Permissions();
  final String screenName = SCR_PERMISSIONS;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  //UserRequest newuserrequest = new UserRequest();



  List<Step> steps = [
    Step(
      title: const Text('New Permission'),
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
                  labelText: "Permission Name"),
              onChanged: (input) {
                permissionsrequest.name = input;
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


    /*Step(
      isActive: false,
      state: StepState.editing,
      title: const Text('Government ID'),
      content: Form(
        key: formkeys[3],
        autovalidate: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              //attribute: "govtidtype",
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
                labelText: "GovtID Type",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.govtIdType = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "Govtid",
              decoration: InputDecoration(
                icon: const Icon(Icons.perm_identity),
                labelText: "Govtid",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.govtId = input;
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
    ),*/
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: const Text('Register Permission'), actions: <Widget>[
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
                      /*_formKey.currentState.save();
                            _formKey1.currentState.save();
                            _formKey2.currentState.save();
                            _formKey3.currentState.save();
                            */
                      //userrequest.userId = userrequest.firstName +
                        //  '_' +
                          //userrequest.lastName;



                      Map<String, dynamic> usermap = permissionsrequest.toJson();
                      print(usermap);
                      Permissions newscreensrequest =
                      await permissionssPageVM.submitNewPermissions(usermap);
                      print(newscreensrequest.id);
                      String uid = newscreensrequest.id.toString();
                      SnackBar mysnackbar = SnackBar(
                        content: Text(
                            "Permissions registered $successful with id : $uid "),
                        duration: new Duration(seconds: 4),
                        backgroundColor: Colors.green,
                      );
                      Scaffold.of(context).showSnackBar(mysnackbar);

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
                ],
              ),
            ),
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
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.list),
        onPressed: switchStepType,
      ),*/
    );
  }
}
