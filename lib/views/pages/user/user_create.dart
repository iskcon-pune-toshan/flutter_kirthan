import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());

class UserWrite extends StatefulWidget {
  UserWrite({Key key}) : super(key: key);

  @override
  _UserWriteState createState() => _UserWriteState();
}

class _UserWriteState extends State<UserWrite> {
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
  static UserRequest userrequest = new UserRequest();
  final String screenName = SCR_REGISTER_USER;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  //UserRequest newuserrequest = new UserRequest();
  static List<String> _states = [
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    "Gujarat",
    "Haryana",
    "Himachal Pradesh",
    "Jammu and Kashmir",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    "Uttar Pradesh",
    "West Bengal",
    "Andaman and Nicobar Islands",
    "Chandigarh",
    "Dadra and Nagar Haveli",
    "Daman and Diu",
    "Delhi",
    "Lakshadweep",
    "Puducherry"
  ];
  static List<String> _cities = [
    'Adilabad',
    'Anantapur',
    'Chittoor',
    'Kakinada',
    'Guntur',
    'Hyderabad'
  ];
  static String _selectedCity;
  static String _selectedState;
  static String _selectedCountry;

  List<Step> steps = [
    Step(
      title: const Text('New Account'),
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
                  labelText: "Username"),
              onChanged: (input) {
                userrequest.fullName = input;
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
                icon: const Icon(Icons.security),
                labelText: "Password",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.password = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            /*TextFormField(
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
            ),*/
          ],
        ),
      ),
    ),
    Step(
      isActive: false,
      state: StepState.editing,
      title: const Text('Personal Info'),
      content: Form(
        key: formkeys[1],
        autovalidate: true,
        child: Column(
          children: <Widget>[
            // TextFormField(
            //   //attribute: "FirstName",
            //   decoration: InputDecoration(
            //     icon: const Icon(Icons.people_outline),
            //     labelText: "FirstName",
            //     hintText: "",
            //   ),
            //   onChanged: (input) {
            //     userrequest.firstName = input;
            //   },
            //   validator: (value) {
            //     if (value.isEmpty) {
            //       return "Please enter some text";
            //     }
            //     return null;
            //   },
            // ),
            // TextFormField(
            //   //attribute: "FirstName",
            //   decoration: InputDecoration(
            //     icon: const Icon(Icons.people_outline),
            //     labelText: "LastName",
            //     hintText: "",
            //   ),
            //   onChanged: (input) {
            //     userrequest.lastName = input;
            //   },
            //   validator: (value) {
            //     if (value.isEmpty) {
            //       return "Please enter some text";
            //     }
            //     return null;
            //   },
            // ),
            TextFormField(
              //attribute: "Email",
              decoration: InputDecoration(
                icon: const Icon(Icons.email),
                labelText: "Email",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.email = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "Phonenumber",
              decoration: InputDecoration(
                icon: const Icon(Icons.phone_iphone),
                labelText: "PhoneNumber",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.phoneNumber = int.parse(input);
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
    Step(
      isActive: false,
      state: StepState.editing,
      title: const Text('Address'),
      content: Form(
        key: formkeys[2],
        autovalidate: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              //attribute: "Address",
              decoration: InputDecoration(
                icon: const Icon(Icons.home),
                labelText: "Line One",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.addLineOne = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "line2",
              decoration: InputDecoration(
                labelText: "Line 2",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.addLineTwo = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "line3",
              decoration: InputDecoration(
                labelText: "Line 3",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.addLineThree = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "locality",
              decoration: InputDecoration(
                labelText: "Locality",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.locality = input;
              },
              validator: (value) {
                if (value.isEmpty) {
                  return "Please enter some text";
                }
                return null;
              },
            ),
            TextFormField(
              //attribute: "PinCode",
              decoration: InputDecoration(
                labelText: "PinCode",
                hintText: "",
              ),
              onChanged: (input) {
                userrequest.pinCode = int.parse(input);
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
    Step(
      title: const Text('GovtDetails'),
      isActive: false,
      state: StepState.editing,
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
      appBar: new AppBar(title: const Text('Register User'), actions: <Widget>[
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
                            /*userrequest.roleId = userrequest.firstName +
                          '_' +
                          userrequest.lastName;*/
                            userrequest.city = "Pune";
                            userrequest.state = "Maharashtra";
                            userrequest.country = "IND";
                            //userrequest.userType = "Admin";
                            //userrequest.isProcessed = false;
                            userrequest.createdBy = "SYSTEM";
                            String dt = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS")
                                .format(DateTime.now());
                            userrequest.createdTime = dt;
                            userrequest.updatedBy = "SYSTEM";
                            //userrequest.updateTime = dt;
                            userrequest.approvalStatus = "approved";
                            // userrequest.approvalComments = "AAA";

                            Map<String, dynamic> usermap = userrequest.toJson();
                            print(usermap);
                            UserRequest newuserrequest =
                                await userPageVM.submitNewUserRequest(usermap);
                            print(newuserrequest.id);
                            String uid = newuserrequest.id.toString();
                            SnackBar mysnackbar = SnackBar(
                              content: Text(
                                  "User registered $successful with id : $uid "),
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
