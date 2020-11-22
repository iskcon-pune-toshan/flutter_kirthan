import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/junk/main_page_view_model.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/services/signin_service.dart';
import 'package:flutter_kirthan/views/widgets/event/eventsearch_panel.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/MapsBloc.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/Widget.dart';
import 'package:flutter_kirthan/views/pages/eventuser/eventuser_view.dart';
import 'package:flutter_kirthan/views/pages/teamuser/teamuser_view.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/views/widgets/event/event_list_item.dart';
import 'package:flutter_kirthan/views/widgets/event/event_panel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
class EventSearchView extends StatefulWidget {
  final String title = " Search Events";
  final String screenName = SCR_EVENT;
  EventRequest eventrequest;
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<EventSearchView> with SingleTickerProviderStateMixin {

  List<String> eventlist = List<String>();
  List<String> tempList = List<String>();
  bool isLoading = false;

  List<String> eventTime = ["Today", "Tomorrow", "This Week", "This Month"];

  String _selectedValue;
  int _index;
  SharedPreferences prefs;
  List<String> access;
  Map<String, bool> accessTypes = new Map<String, bool>();
  //List<String> userdetails;
  String photoUrl;
  String name;

  void loadPref() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      access = prefs.getStringList(widget.screenName);
      access.forEach((f) {
        List<String> access = f.split(":");
        accessTypes[access.elementAt(0)] =
        access.elementAt(1).toLowerCase() == "true" ? true : false;
      });
      eventPageVM.accessTypes = accessTypes;
      //userdetails = prefs.getStringList("LoginDetails");
      SignInService().firebaseAuth.currentUser().then((onValue) {
        photoUrl = onValue.photoUrl;
        name = onValue.displayName;
        print(name);
        print(photoUrl);
      });
      //print(userdetails.length);
    });
  }

  Future loadData() async {
    await eventPageVM.setEventRequests("All");
  }

  @override
  void initState() {
    super.initState();
    _index = 0;
    loadData();
    loadPref();
    _fetchevent();
    //print("in Event");
    //print(SignInService().firebaseAuth.currentUser().then((onValue) => print(onValue.displayName)));
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        title: Text("Search"),

    ),

body:Container(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _searchBar(),
              //_widget(),
              Expanded(
                flex: 1,
                child: _widget(),
              )
            ],
          ),
        ),
          /*new EventsPanel(
            eventType: "All",
          ),*/


      );

  }

  Widget _searchBar(){
    return Container(
      padding: EdgeInsets.only(bottom: 16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search Event",
          prefixIcon: Icon(Icons.search),
        ),
        onChanged: (text){
          _filterList(text);
        },
      ),
    );
  }

  Widget _mainData(){
    return Center(
      child: isLoading?
      CircularProgressIndicator():
      ListView.builder(
          itemCount: eventlist.length,
          itemBuilder: (context,index){
            return ListTile(
                title: Text(eventlist[index],)
            );
          }),
    );
  }
  Widget _widget(){
    return  ScopedModel<EventPageViewModel>(
    model: eventPageVM,
    child: EventSearchPanel(
    eventType: "All",
    ),
    );
  }

  _filterList(String text) {
    if(text.isNotEmpty){
      setState(() {
        eventlist = tempList;
      });
    }
    else{
      final List<String> filteredevents = List<String>();
      tempList.map((EventRequest){
        if(EventRequest.contains(text.toString().toUpperCase())){
          filteredevents.add(EventRequest);
        }
      }).toList();
      setState(() {
        eventlist.clear();
        eventlist.addAll(filteredevents);
      });
    }

  }

/* _fetchevent() async {
    String requestBody = '';

    setState(() {
      isLoading = true;
    });
    tempList = List<String>();
    final response = await _client.put('$_baseUrl/geteventrequests',
        headers: {"Content-Type": "application/json"}, body: requestBody);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);

      List<EventRequest> eventrequests = eventrequestsData.map((
          eventrequestsData) => EventRequest.fromMap(eventrequestsData))
          .toList();
       jsonResponse['message'].forEach((event){
        tempList.add(event.toString().toUpperCase());
      });

      return eventrequests;
    }
    else
      throw Exception("Failed to load Events.");


    setState(() {
      eventlist = tempList;
      isLoading = false;
    });
  }*/


  _fetchevent() async{
    setState(() {
      isLoading = true;
    });
    tempList = List<String>();
    final response = await http.get('');
    if(response.statusCode == 200){

    }
    else{
      throw Exception("Failed to load Events.");
    }
    setState(() {
      eventlist = tempList;
      isLoading = false;
    });
  }

}
