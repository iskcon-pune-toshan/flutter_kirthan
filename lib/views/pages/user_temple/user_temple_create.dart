import 'package:flutter/material.dart';
import 'package:flutter_kirthan/common/constants.dart';
import 'package:flutter_kirthan/models/temple.dart';
import 'package:flutter_kirthan/models/usertemple.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/services/user_temple_service_impl.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_temple_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

final UserTemplePageViewModel userTemplePageVM =
UserTemplePageViewModel(apiSvc: UserTempleAPIService());

final UserPageViewModel userPageVM =
UserPageViewModel(apiSvc: UserAPIService());


class UserTempleCreate extends StatefulWidget {
  UserTempleCreate({this.selectedUsers}) : super();
  List<UserTemple> selectedUsers;

  final String screenName = SCR_USER_TEMPLE;
  final String title = "User Temple Mapping";


  @override
  _UserTempleCreateState createState() =>
      _UserTempleCreateState(selectedUsers: selectedUsers);
}

class _UserTempleCreateState extends State<UserTempleCreate> {
  final _formKey = GlobalKey<FormState>();
  List<UserTemple> selectedUsers;
  //final IKirthanRestApi apiSvc = new RestAPIServices();
  _UserTempleCreateState({this.selectedUsers});
  UserTemple userTemple = new UserTemple();
  Future<List<UserRequest>> users;

  /*List<UserRequest> _users = [
    UserRequest(id: 1, roleId: 1),
    UserRequest(id: 2, roleId: 2),
    UserRequest(id: 3, roleId: 3),
    UserRequest(id: 4,roleId: 4),
  ];*/
  UserRequest _selectedUser;

  @override
  void initState() {
    users = userPageVM.getUserRequests("SA");
    super.initState();
    //_selectedTeam =  null;
  }

  FutureBuilder getTeamWidget() {
    return FutureBuilder<List<UserRequest>>(
        future: users,
        builder:
            (BuildContext context, AsyncSnapshot<List<UserRequest>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Center(child: const CircularProgressIndicator());
            case ConnectionState.done:
              if (snapshot.hasData) {
                return Container(
                  //width: 20.0,
                  //height: 10.0,
                  child: Center(
                    child: DropdownButtonFormField<UserRequest>(
                      value: _selectedUser,
                      icon: const Icon(Icons.supervisor_account),
                      hint: Text('Select User'),
                      items: snapshot.data
                          .map((user) =>
                          DropdownMenuItem<UserRequest>(
                            value: user,
                            child: Text(user.userName),
                          ))
                          .toList(),
                      onChanged: (input) {
                        setState(() {
                          _selectedUser = input;
                        });
                      },
                    ),
                  ),
                );
              } else {
                return Container(
                  width: 20.0,
                  height: 10.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
          }
        });
  }
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    //print(selectedUsers.length);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: <Widget>[
          getTeamWidget(),
          ListView.builder(
              shrinkWrap: true,
              itemCount: selectedUsers == null ? 0 : selectedUsers.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(selectedUsers[index].templeName),
                  subtitle: Text(selectedUsers[index].templeId.toString()),
                );
              }),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('SELECTED ${selectedUsers.length}'),
                  onPressed: () {
                    List<UserTemple> listofUserTemples = new List<UserTemple>();
                    for (var user in selectedUsers) {

                      UserTemple userTemple = new UserTemple();
                      userTemple.templeId = user.templeId;
                      userTemple.userId = _selectedUser.id;
                      userTemple.roleId = user.roleId;
                      userTemple.userName = _selectedUser.userName;
                      userTemple.templeName = user.templeName;


                      listofUserTemples.add(userTemple);
                      SnackBar mysnackbar = SnackBar (
                        content: Text("User-Temple registered $successful "),
                        duration: new Duration(seconds: 4),
                        backgroundColor: Colors.green,
                      );
                      // Scaffold.of(context).showSnackBar(mysnackbar);
                      _scaffoldKey.currentState.showSnackBar(mysnackbar);
                    }
                    print(listofUserTemples);
                    userTemplePageVM.submitNewUserTempleMapping(listofUserTemples);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: OutlineButton(
                  child: Text('DELETE SELECTED'),
                  onPressed: null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
