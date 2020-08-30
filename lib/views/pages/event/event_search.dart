import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
class Search extends StatefulWidget {
  EventRequest eventrequest ;

  Search({Key key,this.eventrequest}) : super(key: key);

  @override
  SearchClass createState() => SearchClass();

}

class SearchClass extends State<Search> {
  final myController = TextEditingController();
  int _index;
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body:
      Card(
        elevation: 5,
        child: TextField(
          controller: myController,
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
          onSubmitted: (_) => {

          },
        ),

      ),

    );
  }

}

