import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/junk/main_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/user/user_panel.dart';
import 'package:flutter_kirthan/views/widgets/event/event_panel.dart';
import 'package:flutter_kirthan/views/widgets/team/team_panel.dart';
import 'package:flutter_kirthan/common/constants.dart';

import 'package:scoped_model/scoped_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MyMainPage extends StatefulWidget {
  final MyMainPageViewModel viewModel;
  final UserLogin userLogin;
  final UserAccess userAccess;
  String screenName;

  MyMainPage({Key key, @required this.viewModel, @required this.userLogin, @required this.userAccess}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MyMainPage> with SingleTickerProviderStateMixin {
  TabController tabController;

  Future loadData() async {
    await widget.viewModel.setUserRequests("All");
    await widget.viewModel.setEventRequests("All");
    await widget.viewModel.setTeamRequests("All");
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
    loadData();
    //print(widget.userLogin.username);
    //print(widget.userAccess.role);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Request Approvals',
          style: TextStyle(
            fontFamily: 'Distant Galaxy',
          ),
        ),
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 2.0,
          tabs: <Widget>[
            Tab(icon: Icon(FontAwesomeIcons.users),
              child: const Text("Users"),),
            Tab(icon: Icon(FontAwesomeIcons.globeAmericas),
              child: const Text("Events"),),
            Tab(icon: Icon(FontAwesomeIcons.teamspeak),
              child: const Text("Teams"),),
          ],
        ),
      ),
      body: ScopedModel<MyMainPageViewModel>(
        model: widget.viewModel,
        child: TabBarView(
          controller: tabController,
          children: <Widget>[
            //          UsersPanel(userType: "SuperAdmin",),
            UsersPanel(userType: "All",),
            EventsPanel(eventType: "All",),
            TeamsPanel(teamType: "All",),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    tabController?.dispose();
    super.dispose();
  }
}