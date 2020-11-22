import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/screens.dart';
import 'package:flutter_kirthan/junk/main_page_view_model.dart';
import 'package:flutter_kirthan/view_models/screens_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/screens/screens_list_item.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:flutter_kirthan/views/pages/team/team_create.dart';
import 'package:flutter_kirthan/views/pages/teamuser/user_selection.dart';
import 'package:flutter_kirthan/views/pages/teamuser/teamuser_view.dart';

class ScreensPanel extends StatelessWidget {
  String screenType;
  final String screenName = "Screens";
  ScreensPanel({this.screenType});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ScreensPageViewModel>(
      //rebuildOnChange: true,
      builder: (context, child, model) {
        return FutureBuilder<List<Screens>>(
          future: model.screensrequests,
          builder: (_, AsyncSnapshot<List<Screens>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var templeRequests = snapshot.data;
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
                            templeRequests == null ? 0 : templeRequests.length,
                            itemBuilder: (_, int index) {
                              var teamrequest = templeRequests[index];
                              return ScreensRequestsListItem(
                                  screensrequest: teamrequest, screensPageVM: model);
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      await model.setScreens("All");
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