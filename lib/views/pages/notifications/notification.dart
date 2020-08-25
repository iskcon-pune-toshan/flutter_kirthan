import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kirthan/services/notification_service.dart';


/* The view for the notifications */

class NotificationView extends StatefulWidget {
  final String title = "Notifications";
  @override
  State<StatefulWidget> createState() {
    return new NotificationViewState();
  }
}

class NotificationViewState extends State<NotificationView> {
  NotificationManager _nm = new NotificationManager();

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
            _nm.showNotification(context, data,(){setState(() {
              _nm.getData();
            });});
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
          future: _nm.getData(),
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
