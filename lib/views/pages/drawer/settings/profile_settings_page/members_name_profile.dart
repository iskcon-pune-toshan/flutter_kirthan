import 'package:flutter/material.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';

class members_profile extends StatefulWidget {
  @override
  _members_profileState createState() => _members_profileState();
}

class _members_profileState extends State<members_profile> {
  int counter = 3;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit members"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
              child: Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => Column(
              children: [
                Text("Members",
                    style: TextStyle(
                        fontSize: notifier.custFontSize,
                        fontWeight: FontWeight.bold)),
                addmember(counter),
                Divider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    RaisedButton.icon(
                      label: Text('Add'),
                      icon: const Icon(Icons.add_circle),
                      color: Colors.green,
                      onPressed: () {
                        //addmember();
                        setState(() {
                          counter++;
                        });
                      },
                    ),
                    RaisedButton(
                      child: Text('Get Approved'),
                      //color: Colors.redAccent,
                      //padding: const EdgeInsets.fromLTRB100.0, 0.0, 50.0, 0.0),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          )),
        ),
      ),
    );
  }

  //print("Entered");
  Widget addmember(int counter) {
    var i = 1;
    return Card(
      child: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Column(
          children: [
            for (int i = 1; i <= counter; i++)
              Container(
                //color: Colors.black26,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.green),
                          ),
                          icon: Icon(Icons.people_outline, color: Colors.grey),
                          labelText: "Member " + i.toString(),
                          hintText: "Please enter the name of the member",
                          labelStyle: TextStyle(
                            fontSize: notifier.custFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          hintStyle: TextStyle(
                            color: Colors.grey,
                          )),
                    ),
                    Divider()
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
