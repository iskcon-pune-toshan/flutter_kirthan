import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/teamuser/teamuser_create.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());

class UserSelection extends StatefulWidget {
  UserSelection({Key key}) : super(key: key);

  final String title = "User Selection";
  final String screenName = SCR_TEAM_USER;

  @override
  _UserSelectionState createState() => _UserSelectionState();
}

class _UserSelectionState extends State<UserSelection> {
  final _formKey = GlobalKey<FormState>();

  //final IKirthanRestApi apiSvc = new RestAPIServices();
  Future<List<UserRequest>> users;
  List<UserRequest> selectedUsers;
  bool sort;

  @override
  void initState() {
    sort = false;
    selectedUsers = [];
    users = userPageVM.getUserRequests("All");
    super.initState();
  }

  onSelectedRow(bool selected, UserRequest user) async {
    setState(() {
      if (selected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    });
  }

  /*deleteSelected() async {
    setState(() {
      if (selectedUsers.isNotEmpty) {
        List<UserRequest> temp = [];
        temp.addAll(selectedUsers);
        for (UserRequest user in temp) {
          users.remove(user);
          selectedUsers.remove(user);
        }
      }
    });
  }*/

  SingleChildScrollView dataBody() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<List<UserRequest>>(
          future: users,
          builder: (BuildContext context,
              AsyncSnapshot<List<UserRequest>> snapshot) {
            if (snapshot.hasData) {
              return DataTable(
                sortAscending: sort,
                sortColumnIndex: 0,
                columns: [
                  DataColumn(
                      label: Text("FirstName"),
                      numeric: false,
                      onSort: (columnIndex, ascending) {
                        setState(() {
                          sort = !sort;
                          if (ascending) {
                            snapshot.data.sort(
                                    (a, b) => a.fullName.compareTo(b.fullName));
                          } else {
                            snapshot.data.sort(
                                    (a, b) => b.fullName.compareTo(a.fullName));
                          }
                        });
                        //onSortColum(columnIndex, ascending);
                      }),
                  DataColumn(
                    label: Text("LastName"),
                    numeric: false,
                  ),
                  DataColumn(
                    label: Text("UserName"),
                    numeric: false,
                  ),
                ],
                rows: snapshot.data
                    .map(
                      (user) =>
                      DataRow(
                          selected: selectedUsers.contains(user),
                          onSelectChanged: (b) {
                            onSelectedRow(b, user);
                          },
                          cells: [
                            DataCell(
                              Text(user.fullName),
                              onTap: () {
                                print('Selected ${user.fullName}');
                              },
                            ),
                            DataCell(
                              Text(user.fullName),
                            ),
                            DataCell(
                              Text(user.fullName),
                            ),
                          ]),
                )
                    .toList(),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print("Hello: 1");
    //print(users);
    //print("Hello: 2");
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          Expanded(
            child: dataBody(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: RaisedButton(
                  color: KirthanStyles.colorPallete30,
                  //child: Text('SELECTED ${selectedUsers.length}'),
                  child: Text("Next"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                TeamUserCreate(selectedUsers: selectedUsers)));
                  },
                ),
              ),
              /*Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('DELETE SELECTED'),
                  onPressed: selectedUsers.isEmpty
                      ? null
                      : () {
                          //deleteSelected();
                        },
                ),
              ),*/
            ],
          ),
        ],
      ),
    );
  }
}