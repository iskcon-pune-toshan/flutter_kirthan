
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as _http;
import 'dart:convert' as convert;

/* The view for the notifications */

class NotificationView extends StatefulWidget {

  final String title = "Notifications";
  @override
  State<StatefulWidget> createState() {
    return new NotificationViewState();
  }

}

class NotificationViewState extends State<NotificationView> {
  Future<Map<String, dynamic>> _getData() async {
    int userId = 4;
    _http.Response response = await _http.get(
        "http://192.168.43.4:8080/" + userId.toString() + "/notifications");
    var data = convert.jsonDecode(response.body);
    print(data);
    return data;
  }

  Future<bool> _respondToNotification(String id, bool response) async {
    String url = "http://192.168.43.4:8080/4/notifications/" + id;
    print(url);
    Map<String, Object> data = {"response": response ? 1 : 0, "userId": 3};
    var body = convert.jsonEncode(data);
    _http.Response resp = await _http
        .put(url, body: body, headers: {"Content-Type": "application/json"});
    var respData = convert.jsonDecode(resp.body);
    print("Notification update request sent.  Response is :  " +
        resp.statusCode.toString() +
        respData.toString());
    return Future.value(resp.statusCode == 200);
  }

  Widget _showDetailedNotificationAsCard(Map<String, Object> data, bool addAction) {
    print(addAction);
    return Center(
        child: Card(
          //shadowColor: Colors.blueAccent,
          color: Colors.blue,
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.all(10),
                  child: Row(
                    children: <Widget>[Text("New Notification")],
                  )),
              Divider(),
              Container(
                margin: EdgeInsets.all(10),
                child:
                Row(children: [Text("Details " + data["message"].toString())]),
              ),
              Divider(),
              Container(
                margin: EdgeInsets.all(10),
                child: Row(children: [
                  Text("Notification for  " + data["type"].toString())
                ]),
              ),
              Divider(),
              addAction
                  ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton(
                        child: Text("Approve"),
                        onPressed: () =>
                            _respondToNotification(data["id"], true)),
                    RaisedButton(
                        child: Text("Reject"),
                        onPressed: () =>
                            _respondToNotification(data["id"], false)),
                  ])
                  : Row(),
              Divider(),
            ],
          ),
        ));
  }
  void _showNotificationAsDialog(BuildContext context , Map<String,dynamic> message){
    bool setAction = false;
    print(message);
    if (message["action"] == "WAIT") setAction = true;
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text("New Notifications"),
              content: Text(message["message"]),
              actions: <Widget>[
                setAction
                    ? FlatButton(
                  child: Text("Approve"), onPressed: () {
                   Future<bool> responseFromUpdate =  _respondToNotification(
                        message["id"], true);
                  responseFromUpdate.then((value) {
                    if (!value) Scaffold.of(context).showSnackBar(SnackBar(content: Text("Error Updating information")));
                    setState((){_getData();});
                    Navigator.pop(context);
                  })
                   .catchError((onError){
                     print("Following Error occured while updating notification respone"+onError.toString());
                     Scaffold.of(context).showSnackBar(SnackBar(content: Text("Error Updating information")));
                     Navigator.pop(context);
                   });
                  })
                    : FlatButton(
                  child: Text("View"),
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                NotificationView()));
                    },
                ),
                setAction
                    ? FlatButton(
                  child: Text("Reject"),
                  onPressed: () {
                    Future<bool> responseFromUpdate = _respondToNotification(
                        message["id"], false);
                    responseFromUpdate.then((value) {
                      if (!value) Scaffold.of(context).showSnackBar(SnackBar(content: Text("Error Updating information")));
                      setState((){_getData();});
                      Navigator.pop(context);
                    }).catchError((onError){
                      print("Following Error occured while updating notification respone"+onError.toString());
                      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Error Updating information")));
                      Navigator.pop(context);
                    });
                  })
                    : FlatButton(
                  child: Text("Discard"),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }


  Widget _buildNotification(Map<String, dynamic> data) {
    IconData icon;
    if (data["action"] == null) {
      icon = null;
    } else {
      String val = data["action"];
      val = val.toLowerCase();
      if (val == "rejected")
        icon = Icons.close;
      else if (val == "approved")
        icon = Icons.check;
      else
        icon = Icons.pause;
    }
    return Column(children: [
      ListTile(
          contentPadding: EdgeInsets.all(10),
          title: Text(data["message"]),
          subtitle: Text("CreatedBy " + data["creatorId"].toString()),
          trailing: icon == null ? null : Icon(icon),
          onTap: () {
            _showNotificationAsDialog(context, data);

          }),
      Divider(),
    ]);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      drawer: Drawer(
        child: Center(child: Text("Drawer placeholder")),
      ),
      body: FutureBuilder(
          future: _getData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var ListData = [];
              var dataNtf = snapshot.data["ntf"];
              var dataAppr = snapshot.data["ntf_appr"];
              if (dataNtf != null) {
                ListData.addAll(dataNtf);
              }
              if (dataAppr != null) {
                ListData.addAll(dataAppr);
              }
              return ListView.builder(
                  itemBuilder: (context, itemCount) =>
                      _buildNotification(ListData[itemCount]),
                  itemCount: ListData.length);
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(child: Text('Error loading notifications'));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
