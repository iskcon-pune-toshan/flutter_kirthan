


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
  static String url = "http://192.168.43.4:8080/";

  Future<Map<String, dynamic>> _getData() async {
    int userId = 4;
    _http.Response response = await _http.get(
        url + userId.toString() + "/notifications");
    var data = convert.jsonDecode(response.body);
    print(data);
    return data;
  }

  Future<bool> _respondToNotification(String id, bool response,BuildContext context) async {
    String tempUrl = url+"4/notifications/" + id;
    print(tempUrl);
    Map<String, Object> data = {"response": response ? 1 : 0, "userId": 4};
    var body = convert.jsonEncode(data);
    try {
      _http.Response resp = await _http
          .put(
          tempUrl, body: body, headers: {"Content-Type": "application/json"});
      (resp.statusCode == 200)
        ?  setState((){_getData();})
        : print("Following Error occured while updating notification response");
      Navigator.pop(context);
      return Future.value(true);
    }
    catch(Exception){
      print("Error Uploading data");
      return Future.value(false);
    }

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
                            _respondToNotification(data["id"], true,context)),
                    RaisedButton(
                        child: Text("Reject"),
                        onPressed: () =>
                            _respondToNotification(data["id"], false,context)),
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
                    _respondToNotification(
                        message["id"], true,context);
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
                  onPressed: () =>
                      _respondToNotification(
                        message["id"], false,context)
                  )
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
