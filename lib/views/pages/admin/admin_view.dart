import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';

import 'package:flutter_kirthan/views/pages/admin/admin_event_view.dart';
import 'package:flutter_kirthan/views/pages/admin/admin_team_view.dart';
import 'package:flutter_kirthan/views/pages/admin/admin_user_view.dart';
import 'package:scoped_model/scoped_model.dart';

class Stats extends Model {
  int _acceptedCount = 0;

  int _waitingCount = 0;

  int _rejectedCount = 0;

  int get accepted => _acceptedCount;

  int get waiting => _waitingCount;

  int get rejected => _rejectedCount;

  set stats(List<int> data) {
    _acceptedCount = data[0];
    _waitingCount = data[2];
    _rejectedCount = data[1];
    notifyListeners();
  }

  set accepted(int count) {
    _acceptedCount = count;
    notifyListeners();
  }

  set waiting(int count) {
    _waitingCount = count;
    notifyListeners();
  }

  set rejected(int count) {
    _rejectedCount = count;
    notifyListeners();
  }
}

class AdminView extends StatefulWidget {
  AdminView();

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  int _currentIndex = 0;
  var _body;
  Stats _displayStat;

  void initState() {
    super.initState();
    _body = EventAdminView();
    _displayStat = new Stats();
  }

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return ScopedModel<Stats>(
        model: _displayStat,
        child: ScopedModelDescendant<Stats>(
            builder: (context, child, model) => Scaffold(
                  appBar: AppBar(
                    title: Text('Admin panel'),
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(50),
                      child: Container(
                          color: KirthanStyles.colorPallete30,
                          height: 50.0,
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                    padding: EdgeInsets.only(top: 5),
                                    child: FlatButton(
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            model.accepted.toString(),
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Text(
                                            'Accepted',
                                            style:
                                                TextStyle(color: Colors.white),
                                          )
                                        ],
                                      ),
                                      onPressed: () {
                                        if (_currentIndex == 0)
                                          setState(() {
                                            _body = EventAdminView(status: "2");
                                          });
                                        else if (_currentIndex == 1) {
                                          setState(() {
                                            _body = TeamAdminView(
                                                status: "Approved");
                                          });
                                        } else if (_currentIndex == 2) {
                                          setState(() {
                                            _body = UserAdminView(
                                                status: "Approved");
                                          });
                                        }
                                      },
                                    )),
                                VerticalDivider(
                                  color: Colors.white,
                                ),
                                FlatButton(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        model.rejected.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('Rejected',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  onPressed: () {
                                    if (_currentIndex == 0)
                                      setState(() {
                                        _body = EventAdminView(status: "4");
                                      });
                                    else if (_currentIndex == 1) {
                                      setState(() {
                                        _body =
                                            TeamAdminView(status: "Rejected");
                                      });
                                    } else if (_currentIndex == 2) {
                                      setState(() {
                                        _body =
                                            UserAdminView(status: "Rejected");
                                      });
                                    }
                                  },
                                ),
                                VerticalDivider(
                                  color: Colors.white,
                                ),
                                FlatButton(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        model.waiting.toString(),
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Text('Waiting',
                                          style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  onPressed: () {
                                    if (_currentIndex == 0)
                                      setState(() {
                                        _body = EventAdminView(
                                          status: "1",
                                        );
                                      });
                                    else if (_currentIndex == 1) {
                                      setState(() {
                                        _body = TeamAdminView(
                                          status: "Waiting",
                                        );
                                      });
                                    } else if (_currentIndex == 2) {
                                      setState(() {
                                        _body = UserAdminView(
                                          status: "Waiting",
                                        );
                                      });
                                    }
                                  },
                                ),
                              ])),
                    ),
                  ),
                  body: _body,
                  bottomNavigationBar: BottomNavigationBar(
                    onTap: (int index) {
                      if (index == 0) {
                        setState(() {
                          _body = EventAdminView(status: "2");
                          _currentIndex = index;
                        });
                      }
                      if (index == 1) {
                        setState(() {
                          _body = TeamAdminView(status: "Approved");
                          _selectedIndex = index;
                          _currentIndex = index;
                        });
                      }
                      if (index == 2) {
                        setState(() {
                          _body = UserAdminView(status: "Approved");
                          _selectedIndex = index;
                          _currentIndex = index;
                        });
                      }
                    },
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                        icon: Icon(Icons.event),
                        title: Text(
                          'Events',
                        ),
                      ),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.group), title: Text('Teams')),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.person), title: Text('User')),
                    ],
                    currentIndex: _selectedIndex,
                    selectedItemColor: KirthanStyles.colorPallete10,
                  ),
                )));
  }
}
