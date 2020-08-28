import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter/cupertino.dart';

class Search extends StatefulWidget {
  EventRequest eventrequest ;

  Search({Key key, @required this.eventrequest}) : super(key: key);

  @override
  SearchClass createState() => SearchClass();

}

class SearchClass extends State<Search>
{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(

   body:
              Card(
                elevation: 5,
                  child: TextField(
                    //onSubmitted: ,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        labelText: 'Search Event',
                        prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
                ),
                filled: true,
                      ),
                  ),
                 ),

        );

  }


  }

