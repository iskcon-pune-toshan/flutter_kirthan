import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';

class description_profile extends StatefulWidget {
  @override
  _description_profileState createState() => _description_profileState();
}

class _description_profileState extends State<description_profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Description'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                bottom: 20.0, top: 20.0, left: 10.0, right: 10.0),
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              maxLines: null,
              style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
              decoration: InputDecoration(
                labelText: 'Description',
                hintText: 'Please enter the description',
                prefixIcon: Icon(Icons.description),
                hintStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                labelStyle: TextStyle(fontSize: 22),
                focusedBorder: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                ),
                border: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    //color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                bottom: 20.0, top: 20.0, left: 10.0, right: 10.0),
            child: TextFormField(
              style: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
              decoration: InputDecoration(
                labelText: 'Type',
                hintText: 'Please enter the type',
                prefixIcon: Icon(Icons.trip_origin),
                hintStyle: TextStyle(fontSize: MyPrefSettingsApp.custFontSize),
                labelStyle: TextStyle(fontSize: 22),
                focusedBorder: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(color: Colors.indigo, width: 1.5),
                ),
                border: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    //color: Colors.blue,
                    width: 1.5,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  //borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          Row(
            children: [
              Divider(
                thickness: 100.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.lightGreen,
                    child: Text('Submit'),
                    onPressed: () {},
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue, width: 2)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: SizedBox(
                  width: 150,
                  height: 50,
                  child: RaisedButton(
                    color: Colors.redAccent,
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                        side: BorderSide(color: Colors.blue, width: 2)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration buildInputDecoration(IconData icons,String hinttext,String labeltext) {
  return InputDecoration(
    labelText: labeltext,
    hintText: hinttext,

    prefixIcon: Icon(icons),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
          color: Colors.green,
          width: 1.5
      ),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25.0),
      borderSide: BorderSide(
        color: Colors.blue,
        width: 1.5,
      ),
    ),
  );
}