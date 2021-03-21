import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/views/widgets/user/user_list_item.dart';
import 'package:flutter_kirthan/views/pages/user/user_edit.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';

import './admin_view.dart';

class UserAdminView extends StatefulWidget {
  String status;
  UserAdminView({this.status});
  @override
  State<UserAdminView> createState() => _UserAdminView();
}

class _UserAdminView extends State<UserAdminView> {
  UserPageViewModel _userVM;

  void setStats() async {
    ScopedModel.of<Stats>(context).stats = await _userVM.getUserCount();
  }

  void initState() {
    super.initState();
    _userVM = UserPageViewModel(apiSvc: UserAPIService());
    setStats();
  }

  @override
  Widget build(BuildContext context) {
    return View(status: widget.status);
  }

  Widget EditView({var page, var actions, String status}) {
    return Scaffold(
      body: page,
      persistentFooterButtons: <Widget>[
        if (status.toLowerCase() == "new") actions
      ],
    );
  }

  Widget Actions(var callback, UserRequest data) {
    Map<String, dynamic> resultData = {
      "id": data.id,
      "usertype": "admin",
      "updatedby": "PlaceHolder"
    };
    return Row(
      children: [
        FlatButton(
            child: Text('Approve'),
            onPressed: () {
              resultData["approvalstatus"] = "approved";
              resultData["approvalcomments"] = "approved";
              callback(resultData);
            }),
        FlatButton(
          child: Text('Reject'),
          onPressed: () {
            resultData["approvalstatus"] = "rejected";
            resultData["approvalcomments"] = "rejected";
            callback(resultData);
          },
        ),
      ],
    );
  }

  Widget View({String status = "NEW"}) {
    return FutureBuilder(
        future: _userVM.getUserForApproval(status),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, itemCount) => Card(
                      child: Column(
                        children: [
                          FlatButton(
                            padding: EdgeInsets.all(0),
                            clipBehavior: Clip.none,
                            child: UserRequestsListItem(
                              userrequest: snapshot.data[itemCount],
                              userPageVM: _userVM,
                            ),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditView(
                                            status: snapshot
                                                .data[itemCount].approvalStatus,
                                            page: UserEdit(
                                              userrequest:
                                                  snapshot.data[itemCount],
                                            ),
                                            actions: Actions(
                                                _userVM.processUserRequest,
                                                snapshot.data[itemCount]),
                                          )));
                            },
                          ),
                          if (status == "NEW")
                            Actions(_userVM.processUserRequest,
                                snapshot.data[itemCount]),
                        ],
                      ),
                    ));
          }
          return Center(child: Text("No data found"));
        });
  }
}
