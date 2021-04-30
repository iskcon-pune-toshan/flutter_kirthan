import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/pages/team/team_profile_page.dart';
class RequestCode extends StatefulWidget {
  @override
  _RequestCodeState createState() => _RequestCodeState();
}

String validateMobile(String value) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (value.length == 0) {
    return 'Please enter mobile number';
  } else if (!regExp.hasMatch(value)) {
    return 'Please enter valid mobile number';
  }
  return null;
}

class _RequestCodeState extends State<RequestCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dummy Screen"),
      ),
      body : SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(margin: const EdgeInsets.only(top: 50)),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 100, 0, 0),
              child: Card(
                child: Container(
                  padding: new EdgeInsets.all(10),
                  child: Text("Enter Code",
                    style: TextStyle(
                        fontSize: 40,
                        color: Colors.grey
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.fromLTRB(30,0,30,0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: FlatButton(
                child: Text(
                  'Continue without Code',
                  style: TextStyle(color: Colors.grey, fontSize: 20,decoration: TextDecoration.underline,decorationStyle: TextDecorationStyle.solid),
                  textAlign: TextAlign.left,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              TeamWrite())
                  );
                },
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,

              child: Container(
                margin: EdgeInsets.fromLTRB(0, 140, 40, 50),
                child: FlatButton(
                    color: Colors.green,
                    child: Text('Next',style: TextStyle(fontSize: 18),),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TeamProfilePage())
                      );
                    }
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

