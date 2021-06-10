import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/eventteam.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/services/event_team_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/view_models/event_team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import 'package:flutter_kirthan/views/pages/signin/login.dart';
import 'package:flutter_kirthan/views/pages/team/team_profile_page.dart';
import 'package:flutter_kirthan/views/widgets/BottomNavigationBar/app.dart';
import 'package:provider/provider.dart';

/*final EventTeamPageViewModel eventTeamPageVM =
    EventTeamPageViewModel(apiSvc: EventTeamAPIService());*/
final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());
final EventTeamPageViewModel eventTeamVM =
EventTeamPageViewModel(apiSvc: EventTeamAPIService());
final TeamPageViewModel teamPageVM =
TeamPageViewModel(apiSvc: TeamAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

class EventDetails extends StatefulWidget {
  EventRequest eventrequest;

  //EventTeam eventTeam;
  //TeamRequest selectedteam;
  LoginApp loginApp;
  final String screenName = SCR_EVENT;
  UserRequest userrequest;

  EventDetails({Key key, @required this.eventrequest, @required this.loginApp})
      : super(key: key);

  @override
  _EventDetailsState createState() => new _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> with BaseAPIService {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  //EventRequest eventrequestobj = new EventRequest();
  //_EditProfileViewState({Key key, @required this.eventrequest}) ;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  String _selectedState;
  String state;

  var _states = [
    "Kant",
    "Andhra Pradesh",
    "MH",
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

  // controllers for form text controllers
  final TextEditingController _eventTitleController =
  new TextEditingController();
  String eventTitle;
  // final TextEditingController _eventTypeController =
  //     new TextEditingController();
  // String eventType;
  final TextEditingController _eventDateController =
  new TextEditingController();
  String eventDate;
  final TextEditingController _eventEndTimeController =
  new TextEditingController();
  final TextEditingController _eventStartTimeController =
  new TextEditingController();
  String eventTime;
  final TextEditingController _eventDescriptionController =
  new TextEditingController();
  String eventDescription;
  final TextEditingController _lineoneController = new TextEditingController();
  String lineOne;
  final TextEditingController _eventDurationController =
  new TextEditingController();
  String eventDuration;
  final TextEditingController _linetwoController = new TextEditingController();
  String lineTwo;
  final TextEditingController _linethreeController =
  new TextEditingController();
  String lineThree;
  final TextEditingController _cityController = new TextEditingController();
  String city;
  final TextEditingController _pincodeController = new TextEditingController();
  String pinCode;
  final TextEditingController _createdTimeController =
  new TextEditingController();
  String createdTime;
  final TextEditingController _stateController = new TextEditingController();
  final TextEditingController _updatedByController =
  new TextEditingController();
  String updatedBy;
  final TextEditingController _updatedTimeController =
  new TextEditingController();
  String updatedTime;
  String approvalStatus;
  final TextEditingController _teamName = new TextEditingController();

  List<String> eventss;
  String radioItem = '';

  //String createdTime;

  int t;
  Map<String, bool> usercehckmap = new Map<String, bool>();

  String UserName;
  String Email;
  int Phone;
  String photoUrl;
  String _selectedCategory;
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();

  @override
  void initState() {
    _eventTitleController.text = widget.eventrequest.eventTitle;
    // _eventTypeController.text = widget.eventrequest.eventType;
    _eventDateController.text = widget.eventrequest.eventDate.substring(0, 10);
    _eventStartTimeController.text = widget.eventrequest.eventStartTime;
    _eventEndTimeController.text = widget.eventrequest.eventEndTime;
    _eventDescriptionController.text = widget.eventrequest.eventDescription;
    _lineoneController.text = widget.eventrequest.addLineOneS;
    //  _eventDurationController.text = widget.eventrequest.eventDuration;
    _linetwoController.text = widget.eventrequest.addLineTwoS;
    _pincodeController.text = widget.eventrequest.pincode.toString();
    _stateController.text = widget.eventrequest.state;
    _cityController.text = widget.eventrequest.city;
    _createdTimeController.text = widget.eventrequest.createdTime;
    _updatedByController.text = getCurrentUser().toString();
    _updatedByController.text = widget.eventrequest.updatedTime;
    // approvalStatus = widget.eventrequest.approvalStatus;
    // print("createdTime");
    //print(widget.eventrequest.createdTime);
    //_teamName.text = widget.selectedteam.teamTitle;
    t = widget.eventrequest.id;
    //eventTeamPageVM.setEvenTeamMappings(widget.eventrequest.id);
    //eventteam=eventTeamPageVM.getEventTeamMappings(widget.eventrequest.id);
    //print(eventteam);

//print(eventss);

//print(eventteam);

    //print(teamname);
    Users = userPageVM.getUserRequests('Approved');
    return super.initState();
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    final FirebaseUser user = await auth.currentUser();
    final String email = user.email;
    widget.eventrequest.updatedBy = email;
    // print(email);
    return email;
  }

  int _groupValue = -1;
  List type = ["Health issues/injury", "Emergency", "Important Event", "Other"];

  @override
  Widget ProfilePages() {
    return FutureBuilder<List<UserRequest>>(
        future: Users,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            userList = snapshot.data;
            for (var uname in userList)
              if (uname.fullName == UserName) {
                String _email = uname.email;
                String _photoName = _email + '.jpg';
                /*  print("*********************" +
                    _photoName +
                    "*************************");*/
                final ref = FirebaseStorage.instance.ref().child(_photoName);
                return FutureBuilder(
                    future: ref.getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        return new Image.network(snapshot.data,
                            fit: BoxFit.fill);
                      }
                      return Image.asset(
                        "assets/images/default_profile_picture.png",
                        fit: BoxFit.fill,
                      );
                    });
              }
          }
          return Image.asset(
            "assets/images/default_profile_picture.png",
            fit: BoxFit.fill,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar:
        new AppBar(title: const Text('Event Details'), actions: <Widget>[
          if (widget.eventrequest.teamInviteStatus != 3)
            new Container(
                padding: const EdgeInsets.fromLTRB(0.0, 10.0, 5.0, 10.0),
                child: new IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditEvent(
                            eventrequest: widget.eventrequest,
                          )),
                    );
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
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Event Title",
                        hintText: "What do people call this event?",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventTitleController,
                    onSaved: (String value) {
                      widget.eventrequest.eventTitle = value;
                    },
                  ),
                ),
                FutureBuilder(
                    future: commonLookupTablePageVM
                        .getCommonLookupTable("lookupType:Event-type-Category"),
                    builder: (context, snapshot) {
                      if (snapshot.data != null) {
                        List<CommonLookupTable> cltList = snapshot.data;
                        List<CommonLookupTable> currCategory = cltList
                            .where((element) =>
                        element.id == widget.eventrequest.eventType)
                            .toList();

                        for (var i in currCategory) {
                          _selectedCategory = i.description;
                        }
                        List<String> _category = cltList
                            .map((user) => user.description)
                            .toSet()
                            .toList();
                        return DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          icon: const Icon(Icons.category),
                          hint: Text(_selectedCategory,
                              style: TextStyle(color: Colors.grey)),
                          items: _category
                              .map((category) => DropdownMenuItem<String>(
                            value: category,
                            child: Text(category),
                          ))
                              .toList(),
                          // onChanged: (input) {
                          //   setState(() {
                          //     _selectedCategory = input;
                          //   });
                          // },
                          // onSaved: (input) {
                          //   _selectedCategory = input;
                          // },
                        );
                      } else {
                        return Container();
                      }
                    }),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Date",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventDateController,
                    onSaved: (String value) {
                      widget.eventrequest.eventDate = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Start Time",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventStartTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.eventStartTime = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "End Time",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventEndTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.eventEndTime = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Description",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _eventDescriptionController,
                    onSaved: (String value) {
                      widget.eventrequest.eventDescription = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Address",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _lineoneController,
                    onSaved: (String value) {
                      widget.eventrequest.addLineOneS = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Line 2",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _linetwoController,
                    onSaved: (String value) {
                      widget.eventrequest.addLineTwoS = value;
                    },
                  ),
                ),
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "Pincode",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _pincodeController,
                    onSaved: (String value) {
                      //  widget.eventrequest.pincode = value;
                    },
                  ),
                ),

                /*new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(labelText: "Locality"),
                    autocorrect: false,
                    controller: _linethreeController,
                    onSaved: (String value) {
                      lineThree = value;
                    },
                  ),
                ),
*/
                new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "City",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _cityController,
                    onSaved: (String value) {
                      widget.eventrequest.city = value;
                    },
                  ),
                ),
                /*      new Container(
                  child: new TextFormField(
                    decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green),
                        ),
                        labelText: "CreatedTime",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        )),
                    autocorrect: false,
                    readOnly: true,
                    controller: _createdTimeController,
                    onSaved: (String value) {
                      widget.eventrequest.createdTime = value;
                    },
                  ),
                ),*/
                DropdownButtonFormField<String>(
                  value: widget.eventrequest.state,
                  icon: const Icon(Icons.location_city),
                  hint: Text(widget.eventrequest.state),
                  items: _states
                      .map((state) => DropdownMenuItem(
                    value: state,
                    child: Text(state),
                  ))
                      .toList(),
                ),
                SizedBox(
                  width: 30,
                  height: 20,
                ),
                FutureBuilder<List<EventTeam>>(
                    future: eventTeamVM
                        .getEventTeamMappings(widget.eventrequest.id),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<EventTeam> eventTeam = snapshot.data;
                        int teamId;
                        for (var team in eventTeam) teamId = team.teamId;
                        return FutureBuilder(
                            future:
                            teamPageVM.getTeamRequests(teamId.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<TeamRequest> teamList = snapshot.data;
                                TeamRequest team = new TeamRequest();
                                for (var t in teamList) {
                                  team = t;
                                }
                                return Container(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: Color(0xf0000000),
                                        child: ClipOval(
                                          child: new SizedBox(
                                            width: 100.0,
                                            height: 100.0,
                                            child: (photoUrl != null)
                                                ? Image.network(
                                              photoUrl,
                                              fit: BoxFit.contain,
                                            )
                                                : ProfilePages(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            Text(
                                              "Team: " + team.teamTitle,
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              "Desc: " + team.teamDescription,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            FlatButton(
                                              color:
                                              KirthanStyles.colorPallete30,
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TeamProfilePage(
                                                          teamTitle: team.teamTitle,
                                                          teamLeadId:
                                                          team.teamLeadId,
                                                        ),
                                                  ),
                                                );
                                              },
                                              child: Text("View Team Details"),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                // print(snapshot.error);
                                return Container();
                              } else {
                                return Container();
                              }
                            });
                      } else if (snapshot.hasError) {
                        // print(snapshot.error);
                        return Container();
                      } else {
                        return Container();
                      }
                    }),
                SizedBox(
                  width: 30,
                ),
                if (widget.eventrequest.teamInviteStatus == 3)
                  widget.eventrequest.cancelReason == null
                      ? Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Event cancelled",
                      style: TextStyle(fontSize: 20, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                      : Container(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Event cancelled due to " +
                          widget.eventrequest.cancelReason,
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                if (widget.eventrequest.teamInviteStatus != 3)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (widget.eventrequest.serviceType == 'Premium')
                        RaisedButton(
                            color: KirthanStyles.colorPallete30,
                            child: Text('Make Payment'),
                            onPressed: () {}),
                      RaisedButton(
                          color: KirthanStyles.colorPallete10,
                          child: Text('Cancel Invite'),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            20.0)), //this right here
                                    child: Container(
                                      height: 200,
                                      child: Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Align(
                                              alignment: Alignment.center,
                                              child: Consumer<ThemeNotifier>(
                                                builder: (context, notifier,
                                                    child) =>
                                                    Text(
                                                        "Do you really want to cancel?",
                                                        style: TextStyle(
                                                            fontSize: notifier
                                                                .custFontSize)),
                                              ),
                                            ),
                                            Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: <Widget>[
                                                  RaisedButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                          context) {
                                                            return StatefulBuilder(
                                                                builder: (context,
                                                                    setState) {
                                                                  return Dialog(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius.circular(
                                                                            20.0)),
                                                                    //this right here
                                                                    child:
                                                                    Container(
                                                                      height: 500,
                                                                      child:
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            12.0),
                                                                        child:
                                                                        Column(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                          crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                          children: [
                                                                            new Container(
                                                                              child:
                                                                              new Column(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                                children: <Widget>[
                                                                                  Consumer<ThemeNotifier>(
                                                                                    builder: (context, notifier, child) => Text('Why do you want to cancel?', style: TextStyle(fontSize: notifier.custFontSize)),
                                                                                  ),
                                                                                  Column(
                                                                                    children: <Widget>[
                                                                                      RadioListTile(
                                                                                        value: 1,
                                                                                        groupValue: _groupValue,
                                                                                        onChanged: (value) {
                                                                                          setState(() {
                                                                                            // print(value);
                                                                                            widget.eventrequest.cancelReason = 'Health issues/injury';
                                                                                            // print('Health issues/injury');

                                                                                            _groupValue = value;
                                                                                          });
                                                                                        },
                                                                                        title: Consumer<ThemeNotifier>(
                                                                                          builder: (context, notifier, child) => Text('Health issues/injury', style: TextStyle(fontSize: notifier.custFontSize)),
                                                                                        ),
                                                                                      ),

                                                                                      RadioListTile(
                                                                                        value: 2,
                                                                                        groupValue: _groupValue,
                                                                                        onChanged: (value) {
                                                                                          setState(() {
                                                                                            // print(value);
                                                                                            widget.eventrequest.cancelReason = 'Emergency';
                                                                                            // print('Emergency');

                                                                                            _groupValue = value;
                                                                                          });
                                                                                        },
                                                                                        title: Consumer<ThemeNotifier>(
                                                                                          builder: (context, notifier, child) => Text('Emergency', style: TextStyle(fontSize: notifier.custFontSize)),
                                                                                        ),
                                                                                      ),
                                                                                      RadioListTile(
                                                                                        value: 3,
                                                                                        groupValue: _groupValue,
                                                                                        onChanged: (value) {
                                                                                          setState(() {
                                                                                            //  print(value);
                                                                                            widget.eventrequest.cancelReason = 'Important event';
                                                                                            // print('Important Event');

                                                                                            _groupValue = value;
                                                                                          });
                                                                                        },
                                                                                        title: Consumer<ThemeNotifier>(
                                                                                          builder: (context, notifier, child) => Text('Important event', style: TextStyle(fontSize: notifier.custFontSize)),
                                                                                        ),
                                                                                      ),
                                                                                      RadioListTile(
                                                                                        value: 4,
                                                                                        groupValue: _groupValue,
                                                                                        onChanged: (value) {
                                                                                          setState(() {
                                                                                            // print(value);
                                                                                            widget.eventrequest.cancelReason = 'Others';
                                                                                            // print('Others');

                                                                                            _groupValue = value;
                                                                                          });
                                                                                        },
                                                                                        title: Consumer<ThemeNotifier>(
                                                                                          builder: (context, notifier, child) => Text('Others', style: TextStyle(fontSize: notifier.custFontSize)),
                                                                                        ),
                                                                                      ),

                                                                                      //Text('$radioItem', style: TextStyle(fontSize: 23),)
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Row(
                                                                                mainAxisAlignment:
                                                                                MainAxisAlignment.spaceEvenly,
                                                                                children: <Widget>[
                                                                                  RaisedButton(
                                                                                    onPressed: () {
                                                                                      Map<String, dynamic> processrequestmap = new Map<String, dynamic>();
                                                                                      processrequestmap["id"] = widget.eventrequest?.id;
                                                                                      //widget.eventrequest?.isProcessed=false;
                                                                                      //widget.eventrequest?.approvalStatus="Cancelled";
                                                                                      widget.eventrequest?.teamInviteStatus = 3;
                                                                                      Map<String, dynamic> eventmap = widget.eventrequest.toJson();
                                                                                      eventPageVM.deleteEventRequest(eventmap);
                                                                                      //eventPageVM.deleteEventRequest(processrequestmap);
                                                                                      SnackBar mysnackbar = SnackBar(
                                                                                        content: Text("Event $delete "),
                                                                                        duration: new Duration(seconds: 4),
                                                                                        backgroundColor: Colors.red,
                                                                                      );
                                                                                      Navigator.push(
                                                                                        context,
                                                                                        MaterialPageRoute(builder: (context) => App()),
                                                                                      );
                                                                                    },
                                                                                    child: Consumer<ThemeNotifier>(
                                                                                      builder: (context, notifier, child) => Text(
                                                                                        "Send",
                                                                                        style: TextStyle(fontSize: notifier.custFontSize, color: Colors.white),
                                                                                      ),
                                                                                    ),
                                                                                    color: const Color(0xFF1BC0C5),
                                                                                  ),
                                                                                ]),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          });
                                                    },
                                                    child:
                                                    Consumer<ThemeNotifier>(
                                                      builder: (context,
                                                          notifier,
                                                          child) =>
                                                          Text(
                                                            "Yes",
                                                            style: TextStyle(
                                                                fontSize: notifier
                                                                    .custFontSize,
                                                                color:
                                                                Colors.white),
                                                          ),
                                                    ),
                                                    color:
                                                    const Color(0xFF1BC0C5),
                                                  ),
                                                  RaisedButton(
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child:
                                                    Consumer<ThemeNotifier>(
                                                      builder: (context,
                                                          notifier,
                                                          child) =>
                                                          Text(
                                                            "No",
                                                            style: TextStyle(
                                                                fontSize: notifier
                                                                    .custFontSize,
                                                                color:
                                                                Colors.white),
                                                          ),
                                                    ),
                                                    color:
                                                    const Color(0xFF1BC0C5),
                                                  ),
                                                ]),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
              ],
            )));
  }
}
