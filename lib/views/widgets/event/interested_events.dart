import 'package:flutter/material.dart';
//import 'package:flutter_kirthan/location/home.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/display_settings.dart';
import 'package:flutter_kirthan/views/pages/event/event_edit.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_kirthan/views/pages/event/event_location.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'event_list_item.dart';
import 'int_item.dart';

class Interested_events extends StatefulWidget {
  bool value;
  final EventRequest eventrequest;
  final EventPageViewModel eventPageVM;
  Interested_events({
    @required this.eventrequest,
    this.eventPageVM,
    bool value,
  });

  @override
  _Interested_eventsState createState() => _Interested_eventsState();
}

class _Interested_eventsState extends State<Interested_events> {
  _Interested_eventsState();

  bool get ind => false;

  get eventrequest => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Interested  Events"),
        ),
        body: Consumer<int_item>(
            builder: (context, int_item, child) => ListView.builder(
              itemCount: int_item.itemlist.length,
              itemBuilder: (context, index) {
                return Stack(
                    children:<Widget>[ Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      //color: Color(0xFFE3F2Fd),
                      child: Stack

                        (children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width - 8,
                          padding: EdgeInsets.all(9),
                          decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.all(
                                  new Radius.circular(10.0)),
                              gradient: new LinearGradient(
                                  //colors: [Colors.blue[100], Colors.blue],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                 // tileMode: TileMode.clamp
                              )),
                          child:Text(
                            '${int_item.itemlist[index]}',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),

                        ),

                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(Icons.cancel),
                            onPressed: (){
                              int_item.valitem(int_item.itemlist[index]);
                            },
                          ),
                        )
                      ]),
                    ),
                    ]);
              },
            )));
  }
}
