import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kirthan/junk/main_page_view_model.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter/cupertino.dart';
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
/*
final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
class Search extends StatefulWidget {
  EventRequest eventrequest ;
  final MyMainPageViewModel viewModel;
  Search({Key key,this.eventrequest,this.viewModel}) : super(key: key);

  @override
  SearchClass createState() => SearchClass();

}

class SearchClass extends State<Search> {
  final myController = TextEditingController();
EventRequest eventrequest;
  final EventPageViewModel eventPageVM;
  String eventType;
  SearchClass({@required this.eventrequest, this.eventPageVM});

  @override
  Widget build(BuildContext context) {
    return Scaffold (
        body: Stack(
        children:<Widget>[
        Card(
        elevation: 5,
        child: TextField(
        controller: myController,
        //onSubmitted: ,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
        labelText: 'Search Event',
        prefixIcon: Icon(
        Icons.search,
        color: Colors.black,
    ),
    filled: true,

    ),
    onSubmitted: (_) => {
    EventsPanel(),

    },
    ),

    ),
        ScopedModelDescendant<EventPageViewModel>(
      builder: (context, child, model) {
        return FutureBuilder<List<EventRequest>>(
          future: model.eventrequests,
          builder: (_, AsyncSnapshot<List<EventRequest>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var eventRequests = snapshot.data;
                  return new Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[




                      Expanded(
                        child: Scrollbar(
                          controller: ScrollController(
                            initialScrollOffset: 2,
                            keepScrollOffset: false,
                          ),
                          child: Center(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: eventRequests == null
                                  ? 0
                                  : eventRequests.length,
                              itemBuilder: (_, int index) {
                                var eventrequest = eventRequests[index];
                                return EventRequestsListItem(
                                  eventrequest: eventrequest,
                                  eventPageVM: model,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      //await model.setSuperAdminUserRequests("SuperAdmin");
                      //await model.setUserRequests("All");
                      await model.setEventRequests("All");
                    },
                  );
                }
            }
          },
        );
      },
    ),
    ScopedModelDescendant<EventPageViewModel>(
      child:Scaffold(
      body: Stack(
      children:<Widget>[
      Card(
        elevation: 5,
        child: TextField(
          controller: myController,
          //onSubmitted: ,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            labelText: 'Search Event',
            prefixIcon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            filled: true,

          ),
          onSubmitted: (_) => {
            EventsPanel(),

          },
        ),

      ),

      ]),),
    )]),);
  }
  */
/*TabController tabController;
  search() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '',
          style: TextStyle(
            fontFamily: '',
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 2.0,
          tabs: <Widget>[

            Tab(icon: Icon(FontAwesomeIcons.globeAmericas),
              child: const Text("Events"),),

          ],
        ),
      ),
      body: ScopedModel<MyMainPageViewModel>(
        model: widget.viewModel,
        child: TabBarView(
          controller: tabController,
          children: <Widget>[
            //          UsersPanel(userType: "SuperAdmin",),

            EventsPanel(eventType: "All",),

          ],
        ),
      ),
    );*//*

  }









*/


class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {

  List<String> eventlist = List<String>();
  List<String> tempList = List<String>();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchevent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(

        title: Text("Search"),

    ),
    body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _searchBar(),
              Expanded(
                flex: 1,
                child: _mainData(),
              )
            ],
          ),
        )
    ),
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
  final _baseUrl = 'http://192.168.1.8:8080'; //Manju
  //final _baseUrl = 'http://192.168.1.7:8080'; // Janice
  http.Client _client = http.Client();
/*
 _fetchevent() async {
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