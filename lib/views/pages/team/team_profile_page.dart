import 'package:flutter/material.dart';
import 'package:flutter_kirthan/services/team_service_impl.dart';
import 'package:flutter_kirthan/utils/kirthan_styles.dart';
import 'package:flutter_kirthan/view_models/team_page_view_model.dart';



class TeamProfilePage extends StatefulWidget {
  @override
  _TeamProfilePageState createState() => _TeamProfilePageState();
}

class _TeamProfilePageState extends State<TeamProfilePage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: KirthanStyles.colorPallete60),
        title: Text(
          'Team Profile',
          style: TextStyle(color: KirthanStyles.colorPallete60),
        ),
        backgroundColor: KirthanStyles.colorPallete30,
      ),
      body:SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20,10,20,10),
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.account_circle,size: 200,),
                  Container(
                    margin: EdgeInsets.fromLTRB(20, 60, 10, 10),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Team',style: TextStyle(fontSize: 30),),
                        SizedBox(height: 10,),
                        Text('TeamName:',style: TextStyle(fontSize: 18),),
                        SizedBox(height: 5,),
                        Text(''),
                        SizedBox(height: 10,),
                        Text('UserName:',style: TextStyle(fontSize: 18),),
                        SizedBox(height: 5,),
                        Text(''),

                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: 20,),
              Column(

                  children:<Widget>[
                    Align(alignment:Alignment.centerLeft,child: Text('Description:',style: TextStyle(fontSize: 25),)),
                    SizedBox(height: 20,),
                    Align(alignment:Alignment.centerLeft,child: Text('Type:',style: TextStyle(fontSize: 18),)),
                    SizedBox(height: 10,),
                    Align(alignment:Alignment.centerLeft,child: Text('Team Members:',style: TextStyle(fontSize: 18),)),
                    Container(
                      height: 50,
                      width: 200,
                    ),
                    SizedBox(height: 10,),
                    Align(alignment:Alignment.centerLeft,child: Text('Experience:',style: TextStyle(fontSize: 18),)),
                    SizedBox(height: 20,),

                  ]
              ),
              Row(
                children: <Widget> [
                  Icon(Icons.call,size: 30,),
                  SizedBox(width: 10,),
                  Text('8983460253',style: TextStyle(fontSize: 16),),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                children: <Widget> [
                  Icon(Icons.mail,size: 30,),
                  SizedBox(width: 10,),
                  Text('karan.gaikwad512@gmail.com',style: TextStyle(fontSize: 16),),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
