

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/MapsBloc.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/MapsEvent.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_kirthan/views/pages/event/home_page_map/bloc.dart';


class MapOption extends StatelessWidget {
  final MapType mapType;
  MapOption({@required this.mapType});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: BlocProvider.of<MapsBloc>(context),
      builder: (context, state) {
        return Container(
          child: Positioned(
            top: 150,
            right: 5,
            child: Card(
              child: RaisedButton(
                onPressed: () {
                  BlocProvider.of<MapsBloc>(context)
                      .add(MapTypeButtonPressed(currentMapType: mapType));
                },
                color: Colors.black54,
                child: new Text('Check',style: TextStyle(color:Colors.white),),
              )
              /*IconButton(
                icon: Icon(
                  Icons.check,
                  color: Colors.grey[700],
                ),
                onPressed: () {
                  BlocProvider.of<MapsBloc>(context)
                      .add(MapTypeButtonPressed(currentMapType: mapType));
                },
              ),*/
            ),
          ),
        );
      },
    );
  }
}