import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/widgets/user/user_list_item.dart';
import 'package:flutter_kirthan/views/widgets/no_internet_connection.dart';
import 'package:scoped_model/scoped_model.dart';

class UsersPanel extends StatelessWidget {
  final String userType;

  final String title = "Register User";
  final String screenName = "Register User";

  UsersPanel({this.userType});
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<UserPageViewModel>(
      //rebuildOnChange: true,
      builder: (context, child, model) {
        return FutureBuilder<List<UserRequest>>(
          future: model.userrequests,
          builder: (_, AsyncSnapshot<List<UserRequest>> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Center(child: const CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasData) {
                  var userRequests = snapshot.data;
                  return new Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    //mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 3,
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.grey[400],
                            highlightColor: KirthanStyles.colorPallete30,
                            child: const Text("Super Admin"),
                            onPressed: () {
                              print("Super Admin");
                              model.setUserRequests("SA");
                              print(model.setUserRequests("SA"));
                            },
                          ),
                          RaisedButton(
                            color: Colors.grey[400],
                            highlightColor: KirthanStyles.colorPallete30,
                            child: const Text("Admin"),
                            onPressed: () {
                              print("Admin");
                              model.setUserRequests("A");
                            },
                          ),
                          RaisedButton(
                            color: Colors.grey[400],
                            highlightColor: KirthanStyles.colorPallete30,
                            child: const Text("Users"),
                            onPressed: () {
                              print("Users");
                              model.setUserRequests("U");
                            },
                          ),
                          /*Expanded(
                            child: RaisedButton(
                              child: const Text("Create an User Request"),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserWrite()));
                              },
                            ),
                          ),*/
                        ],
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Expanded(
                        child: Scrollbar(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                userRequests == null ? 0 : userRequests.length,
                            itemBuilder: (_, int index) {
                              var userrequest = userRequests[index];
                              return UserRequestsListItem(
                                userrequest: userrequest,
                                userPageVM: model,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return NoInternetConnection(
                    action: () async {
                      //await model.setSuperAdminUserRequests("SuperAdmin");
                      await model.setUserRequests("All");
                      //await model.setUserdetails();
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
