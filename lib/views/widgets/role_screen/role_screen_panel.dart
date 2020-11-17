import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/rolescreen.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/view_models/role_screen_page_view_model.dart';
import 'package:flutter_kirthan/view_models/temple_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/role_screen/role_screen_list_item.dart';
import 'package:flutter_kirthan/views/widgets/temple/temple_list_item.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:flutter_kirthan/views/widgets/user_temple/user_temple_list_item.dart';
import 'package:scoped_model/scoped_model.dart';


class RoleScreensPanel extends StatelessWidget {
  String rolescreenType;
  final String screenName = "Role Screen";
  RoleScreensPanel({this.rolescreenType});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<RoleScreenViewPageModel>(
      //rebuildOnChange: true,
      builder: (context, child, model) {
        return FutureBuilder<List<RoleScreen>>(
          future: model.rolescreenrequests,
          builder: (_, AsyncSnapshot<List<RoleScreen>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var rolescreenRequests = snapshot.data;
                  return new Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          /*                        RaisedButton(
                            child: const Text("All Teams"),
                            onPressed: () {
                              print("All Teams");
                              model.setTeamRequests("AE");
                            },
                          ),
*/


                          /*                        Expanded(
                            child: RaisedButton(
                              child: const Text("Create a Team"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TeamWrite()));
                              },
                          ),
                          ),
*/
                        ],
                      ),
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                            rolescreenRequests == null ? 0 : rolescreenRequests.length,
                            itemBuilder: (_, int index) {
                              var teamrequest = rolescreenRequests[index];
                              return RoleScreenRequestsListItem(
                                  rolescreenrequest: teamrequest, roleScreenPageVM: model);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      await model.getRoleScreenMaping("All");
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
