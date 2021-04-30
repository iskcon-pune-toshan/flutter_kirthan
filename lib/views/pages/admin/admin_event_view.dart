import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/event/event_list_item.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import './admin_view.dart';

class EventAdminView extends StatefulWidget {
  String status;
  EventAdminView({this.status});
  @override
  _EventAdminViewState createState() => _EventAdminViewState();
}

class _EventAdminViewState extends State<EventAdminView> {
  EventPageViewModel _eventVM;

  void setStats() async {
    ScopedModel.of<Stats>(context).stats = await _eventVM.getEventCount();
  }

  void initState() {
    super.initState();
    _eventVM = EventPageViewModel(apiSvc: EventAPIService());
    setStats();
  }

  @override
  Widget build(BuildContext context) {
    return View(status: widget.status);
  }

  Widget EditView({var page, var actions, String status}) {
    return Scaffold(
      body: page,
      persistentFooterButtons: <Widget>[
        if (status.toLowerCase() == "NEW") actions
      ],
    );
  }

  Widget Actions(var callback, var data) {
    Map<String, dynamic> resultData = {
      "id": data.id,
      "usertype": "admin",
      "updatedby": "PlaceHolder"
    };
    if (data.approvalStatus == "NEW")
      return Row(children: [
        FlatButton(
            child: Text('Approve'),
            onPressed: () {
              resultData["approvalStatus"] = "Approved";
              resultData["approvalComments"] = "Approved";
              callback(resultData);
              print(resultData);
            }),
        FlatButton(
          child: Text('Reject'),
          onPressed: () {
            resultData["approvalStatus"] = "Rejected";
            resultData["approvalComments"] = "Rejected";
            callback(resultData);
          },
        ),
      ]);
  }

  Widget View({String status}) {
    print(status);
    return FutureBuilder(
        future: _eventVM.getData(status),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, itemCount) => Card(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15.0,
                    ),
                    FlatButton(
                        padding: EdgeInsets.all(0),
                        clipBehavior: Clip.none,
                        //shows the list of events in adminPanel
                        child: EventRequestsListItem(
                          eventrequest: snapshot.data[itemCount],
                          eventPageVM: _eventVM,
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditView(
                                      status: snapshot.data[itemCount].status
                                          .toString(),
                                      page: EditEvent(
                                          eventrequest:
                                          snapshot.data[itemCount]),
                                      actions: Actions(
                                          _eventVM.processEventRequest,
                                          snapshot.data[itemCount]))));
                        }),
                    if (status == "NEW")
                      Actions(_eventVM.processEventRequest,
                          snapshot.data[itemCount])
                  ],
                ),
              ),
            );
          }
          return Center(child: Text("No data found"));
        });
  }
}
