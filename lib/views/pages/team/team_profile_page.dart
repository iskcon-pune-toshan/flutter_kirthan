import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/commonlookuptable.dart';
import 'package:flutter_kirthan/models/team.dart';
import 'package:flutter_kirthan/models/teamuser.dart';
import 'package:flutter_kirthan/models/user.dart';
import 'package:flutter_kirthan/services/common_lookup_table_service_impl.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/services/team_user_service_impl.dart';
import 'package:flutter_kirthan/services/user_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/common_lookup_table_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';
import 'package:flutter_kirthan/view_models/team_user_page_view_model.dart';
import 'package:flutter_kirthan/view_models/user_page_view_model.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/theme/theme_manager.dart';
import 'package:provider/provider.dart';

final UserPageViewModel userPageVM =
    UserPageViewModel(apiSvc: UserAPIService());
final TeamPageViewModel teamPageVM =
    TeamPageViewModel(apiSvc: TeamAPIService());
final TeamUserPageViewModel teamUserPageVM =
    TeamUserPageViewModel(apiSvc: TeamUserAPIService());
final CommonLookupTablePageViewModel commonLookupTablePageVM =
    CommonLookupTablePageViewModel(apiSvc: CommonLookupTableAPIService());

class TeamProfilePage extends StatefulWidget {
  String teamTitle;
  String teamLeadId;
  TeamProfilePage({this.teamTitle, this.teamLeadId});
  @override
  _TeamProfilePageState createState() =>
      _TeamProfilePageState(teamTitle, teamLeadId);
}

class _TeamProfilePageState extends State<TeamProfilePage> {
  String teamTitle;
  String teamLeadId;
  _TeamProfilePageState(this.teamTitle, this.teamLeadId);

  String type;
  String experience;
  String Email;
  int Phone;
  String username;
  int id;
  String Title;
  Future<List<TeamRequest>> Teams;
  List<TeamRequest> teamList = new List<TeamRequest>();
  Future<List<UserRequest>> Users;
  List<UserRequest> userList = new List<UserRequest>();
  Future<List<TeamUser>> TeamUsers;
  List<TeamUser> teamusersList = new List<TeamUser>();
  @override
  void initState() {
    Teams = teamPageVM.getTeamRequests("Approved");
    Users = userPageVM.getUserRequests("Approved");
    super.initState();
  }

  Widget phone(String email) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => FutureBuilder<List<UserRequest>>(
          future: Users,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              userList = snapshot.data;
              for (var user in userList) {
                if (user.email == email) {
                  Phone = user.phoneNumber;
                  return Text(
                    ': ' + Phone.toString(),
                    style: TextStyle(
                        fontSize: notifier.custFontSize,
                        color: notifier.darkTheme?Colors.grey[400]:Colors.grey[700]),
                  );
                }
              }
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Widget un(String email) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => FutureBuilder<List<UserRequest>>(
          future: Users,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              userList = snapshot.data;
              for (var user in userList) {
                if (user.email == email) {
                  username = user.fullName;

                  return Text(
                    username,
                    style: TextStyle(
                        fontSize: notifier.custFontSize,
                        color: notifier.darkTheme?Colors.grey[300]:Colors.grey[700]),
                  );
                }
              }
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Widget teamMembers(int id) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child) => FutureBuilder<List<TeamUser>>(
          future: teamUserPageVM.getTeamUserMappings(id.toString()),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              teamusersList = snapshot.data;
              List<TeamUser> listofteamusers =
                  teamusersList.where((user) => user.teamId == id).toList();
              List<String> memberList =
                  listofteamusers.map((e) => e.userName).toSet().toList();
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: memberList.length,
                  itemBuilder: (context, index) {
                    return Row(
                      children: [
                        SizedBox(
                          width: 100,
                        ),
                        Text(
                          (index + 1).toString() + ". " + memberList[index],
                          style: TextStyle(
                              fontSize: notifier.custFontSize,
                              color: notifier.darkTheme?Colors.grey[400]:Colors.grey[700]),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              return Text('Error');
            }
            return CircularProgressIndicator();
          }),
    );
  }

  Widget teamCategory(TeamRequest data) {
    return Consumer<ThemeNotifier>(
      builder:(context, notifier, child)=> FutureBuilder(
          future: commonLookupTablePageVM
              .getCommonLookupTable("lookupType:Event-type-Category"),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              List<CommonLookupTable> cltList = snapshot.data;
              List<CommonLookupTable> currCategory = cltList
                  .where((element) => element.id == data.category)
                  .toList();

              for (var i in currCategory) {
                type = i.description;
              }
              return Row(
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Type: ',
                        style: TextStyle(
                            fontSize: notifier.custFontSize,
                            fontWeight: FontWeight.bold,
                            color: notifier.darkTheme?Colors.grey[300]:Colors.grey[700]),
                      )),
                  Text(
                    type != null ? type : "New",
                    style: TextStyle(fontSize: notifier.custFontSize, color: notifier.darkTheme?Colors.grey[400]:Colors.grey[600]),
                  )
                ],
              );
            } else {
              return Container();
            }
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, notifier, child)=>
     Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
            title: Text(
              'Team Details',
              style: TextStyle(color: KirthanStyles.colorPallete60),
            ),
            backgroundColor: KirthanStyles.colorPallete30,
          ),
          body: Consumer<ThemeNotifier>(
            builder: (context, notifier, child) => FutureBuilder(
                future: Teams,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    teamList = snapshot.data;
                    for (var team in snapshot.data) {
                      if (team.teamTitle == this.teamTitle) {
                        // teamTitle = team.teamTitle;
                        experience = team.experience;
                        Email = team.teamLeadId;
                        id = team.id;
                        return Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            FractionallySizedBox(
                              alignment: Alignment.topCenter,
                              heightFactor: 0.2,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: KirthanStyles.colorPallete30,
                                ),
                              ),
                            ),
                            FractionallySizedBox(
                              alignment: Alignment.bottomCenter,
                              heightFactor: 0.95,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20)),
                                  color:notifier.darkTheme? Colors.grey[800]:Colors.white,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.account_circle,
                                            size: 100,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Container(width: MediaQuery.of(context).size.width*0.5,
                                            margin: EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                  'Team',
                                                  style: TextStyle(
                                                      fontSize: 19 +
                                                          notifier.custFontSize,
                                                      fontWeight: FontWeight.w800,
                                                      color: notifier.darkTheme?Colors.grey[100]:Colors.grey[900]),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Divider(thickness: 2,),
                                                Text(
                                                  teamTitle,
                                                  style: TextStyle(
                                                      fontSize: 6 +
                                                          notifier.custFontSize,
                                                      fontWeight: FontWeight.bold,
                                                      color: notifier.darkTheme?Colors.grey[200]:Colors.grey[800]),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Divider(thickness:2),
                                                un(Email),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Divider(
                                        thickness: 2,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Container(
                                        alignment: Alignment.centerLeft,
                                        child: Column(
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.info_outline_rounded,
                                                  color: KirthanStyles
                                                      .colorPallete30,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Description",
                                                  style: TextStyle(
                                                      fontSize: 4 +
                                                          notifier.custFontSize,
                                                      fontWeight: FontWeight.w500,
                                                      color: notifier.darkTheme?Colors.grey[300]:Colors.grey[700]),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            teamCategory(team),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Team Members: ',
                                                  style: TextStyle(
                                                      fontSize:
                                                          notifier.custFontSize,
                                                      fontWeight: FontWeight.bold,
                                                      color: notifier.darkTheme?Colors.grey[300]:Colors.grey[700]),
                                                )),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Container(child: teamMembers(id)),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: Text(
                                                      'Experience: ',
                                                      style: TextStyle(
                                                          fontSize: notifier
                                                              .custFontSize,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                          notifier.darkTheme?Colors.grey[300]:Colors.grey[700]),
                                                    )),
                                                Text(
                                                  experience,
                                                  style: TextStyle(
                                                      fontSize:
                                                          notifier.custFontSize,
                                                      color: notifier.darkTheme?Colors.grey[400]:Colors.grey[600]),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Divider(
                                              thickness: 2,
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.contact_mail_outlined,
                                                    color: KirthanStyles
                                                        .colorPallete30,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Text(
                                                    'Contact Details:',
                                                    style: TextStyle(
                                                        fontSize: 2 +
                                                            notifier.custFontSize,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: notifier.darkTheme?Colors.grey[300]:Colors.grey[700]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.call,
                                                  size: 30,
                                                  color: notifier.darkTheme?Colors.grey[300]:Colors.grey[700],
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                phone(Email),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.mail,
                                                    size: 30,
                                                    color: notifier.darkTheme?Colors.grey[300]:Colors.grey[700]),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  ': ' + Email,
                                                  style: TextStyle(
                                                      fontSize:
                                                          notifier.custFontSize,
                                                      color: notifier.darkTheme?Colors.grey[400]:Colors.grey[700]),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Divider(
                                                  thickness: 3,
                                                ),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    }
                  }
                  return Center(
                    child: Text('Team Request not accepted'),
                  );
                }),
          )),
    );
  }
}
