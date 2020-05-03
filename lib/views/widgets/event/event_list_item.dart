import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/interfaces/i_restapi_svcs.dart';
import 'package:flutter_kirthan/services/data_services.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';

class EventRequestsListItem extends StatelessWidget {
  final EventRequest eventrequest;
  final EventPageViewModel eventPageVM;
 // final UserRequest userrequests;
  //final IKirthanRestApi apiSvc = new RestAPIServices();

  EventRequestsListItem(
      {@required this.eventrequest, this.eventPageVM});

  @override
  Widget build(BuildContext context) {
    var title = Text(
      eventrequest?.eventTitle,
      style: TextStyle(
        color: KirthanStyles.titleColor,
        fontWeight: FontWeight.bold,
        fontSize: KirthanStyles.titleFontSize,
      ),
    );

    var subTitle = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Icon(
          Icons.movie,
          color: KirthanStyles.subTitleColor,
          size: KirthanStyles.subTitleFontSize,
        ),
        Container(
          margin: const EdgeInsets.only(left: 4.0),
          child: Text(
            eventrequest?.eventDescription,
            style: TextStyle(
              color: KirthanStyles.subTitleColor,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 65,
              child: RaisedButton(
                child: eventrequest.isProcessed
                    ? const Text("Processed")
                    : const Text("Not Processed"),
                onPressed: () {
                  Map<String, dynamic> processrequestmap =
                      new Map<String, dynamic>();
                  processrequestmap["id"] = eventrequest?.id;
                  processrequestmap["approvalstatus"] = "Approved";
                  processrequestmap["approvalcomments"] = "ApprovalComments";
                  processrequestmap["eventType"] = eventrequest?.eventType;
                  eventPageVM.processEventRequest(processrequestmap);
                  SnackBar mysnackbar = SnackBar(
                    content: Text("Event $process $successful "),
                    duration: new Duration(seconds: 4),
                    backgroundColor: Colors.green,
                  );
                  Scaffold.of(context).showSnackBar(mysnackbar);
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 55,
              child: RaisedButton(
                child: const Text("Delete"),
                onPressed: () {
                  Map<String, dynamic> processrequestmap =
                      new Map<String, dynamic>();
                  processrequestmap["id"] = eventrequest?.id;
                  eventPageVM.deleteEventRequest(processrequestmap);
                  SnackBar mysnackbar = SnackBar(
                    content: Text("Event $delete "),
                    duration: new Duration(seconds: 4),
                    backgroundColor: Colors.red,
                  );
                  Scaffold.of(context).showSnackBar(mysnackbar);
                },
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            SizedBox(
              height: 35,
              width: 55,
              child: RaisedButton(
                child: const Text("Edit"),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EditEvent(eventrequest: eventrequest)),
                  );
//updateEvent
                },
              ),
            ),
          ],
        ),
      ],
    );

    return Column(
      children: <Widget>[
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
          title: title,
          subtitle: subTitle,
        ),
        Divider(),
      ],
    );
  }
}
