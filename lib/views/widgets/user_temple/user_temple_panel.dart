import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/temple/temple_list_item.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:flutter_kirthan/views/widgets/user_temple/user_temple_list_item.dart';
import 'package:scoped_model/scoped_model.dart';


class UserTemplesPanel extends StatelessWidget {
  String usertempleType;
  final String screenName = "User Temple";
  UserTemplesPanel({this.usertempleType});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserTemplePageViewModel>(
      //rebuildOnChange: true,
      builder: (context, child, model) {
        return FutureBuilder<List<UserTemple>>(
          future: model.userTemples,
          builder: (_, AsyncSnapshot<List<UserTemple>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var usertempleRequests = snapshot.data;
                  return new Column(
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[

                        ],
                      ),
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                            usertempleRequests == null ? 0 : usertempleRequests.length,
                            itemBuilder: (_, int index) {
                              var usertemplerequest = usertempleRequests[index];
                              return UserTempleRequestsListItem(
                                  usertemplerequest: usertemplerequest, userTemplePageVM: model);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      await model.getUserTempleMapping("");
                    },
                  );
                }
            }
          },
        );
      },
    );
  }
}
