/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/authenticate_service.dart';
import 'package:flutter_kirthan/services/base_service.dart';
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:table_calendar/table_calendar.dart';



class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> with BaseAPIService{
  CalendarController _controller;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  List<String> event;
  List<String> date;
  Future getevent() async{
    String requestBody = '';
    requestBody = '{"approvalStatus" : "Approved"}';
    print(requestBody);
    String token = AutheticationAPIService().sessionJWTToken;
    print("search service");
    var response = await client1.put('$baseUrl/api/event/geteventtitle',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }, body: requestBody);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);
      //print(eventrequestsData);
      List<String> events = eventrequestsData.map((event) => event.toString()).toList();
      event=events;
      print(event);

      //print(event);
//print(eventrequests);
    } else {
      throw Exception('Failed to get data');
    }
  }
  getdates() async {
    String requestBody = '';
    requestBody = '{"id" : "1"}';

    //print(requestBody);

    String token = AutheticationAPIService().sessionJWTToken;

    var response = await client1.put('$baseUrl/api/event/geteventdates',
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        }, body: requestBody);
    print(response.statusCode);
    if (response.statusCode == 200) {
      List<dynamic> eventrequestsData = json.decode(response.body);
      print(eventrequestsData);
      List<EventRequest> eventrequests = eventrequestsData
          .map((eventrequestsData) => EventRequest.fromJson(eventrequestsData))
          .toList();
      List<String> events = eventrequests.map((event) => event.toString())
          .toList();
      date=events;
      print(events);
      print("before return");
    }
  }

  @override
  void initState() {
    getevent();
    getdates();
   // _events={date:event};
    super.initState();
    _controller = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Calendar'),
      ),
      drawer: MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TableCalendar(
              events:_events,
              initialCalendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                  todayColor: Colors.blue,
                  selectedColor: Theme.of(context).primaryColor,
                  todayStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22.0,
                      color: Colors.black)
              ),
              headerStyle: HeaderStyle(
                centerHeaderTitle: true,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(22.0),
                ),
                formatButtonTextStyle: TextStyle(color: Colors.orange),
                formatButtonShowsNext: false,
              ),
              startingDayOfWeek: StartingDayOfWeek.monday,
onDaySelected: (date, events, holidays) {
                print(date.toUtc());
              },

              builders: CalendarBuilders(
                selectedDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.black),
                    )),
                todayDayBuilder: (context, date, events) => Container(
                    margin: const EdgeInsets.all(5.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(color: Colors.white),
                    )),
              ),
              calendarController: _controller,
            )
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter_kirthan/views/pages/drawer/settings/drawer.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';

class CalendarPage extends StatefulWidget {
  EventRequest eventrequest ;

  CalendarPage({Key key, @required this.eventrequest}) : super(key: key);

  @override
  CalendarClass createState() => CalendarClass();

}
List<String> views = <String>[
  'Day',
  'Week',
  'Month',
];
class CalendarClass extends State<CalendarPage>
{
  CalendarView _calendarView;
  DateTime _datePicked;
  DateTime _calendarDate;

  @override
  void initState() {
    _calendarView = CalendarView.month;
    _datePicked = DateTime.now();
    _calendarDate = DateTime.now();
    super.initState();
  }
  List<Meeting> getMeetingDetails() {
    final List<Meeting> meetingCollection = <Meeting>[];
    //eventNameCollection = <String>[];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Calendar",
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              showDatePicker(
                  context: context,
                  initialDate: _datePicked,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100))
                  .then((DateTime date) {
                if (date != null && date != _calendarDate)
                  setState(() {
                    _calendarDate = date;
                  });
              });
            },
            child: Icon(
              Icons.date_range,
              color: Colors.white,
            ),
          )
        ],

      ),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SfCalendar(
              showDatePickerButton: true,
              initialDisplayDate: _calendarDate,
              view: CalendarView.month,
              onViewChanged: _viewChanged,
              dataSource: _getCalendarDataSource(),
              monthViewSettings: MonthViewSettings(showAgenda: true),
            ),
          ),
        ],
      ),
    );

  }
  void _viewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      _datePicked = viewChangedDetails
          .visibleDates[viewChangedDetails.visibleDates.length ~/ 2];
    });
  }
  _AppointmentDataSource _getCalendarDataSource() {
    List<Appointment> appointments = <Appointment>[];
    appointments.add(Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours:2)),
      subject: 'Janmasthami',
      color: Colors.blue,
      isAllDay: true,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 11, 1, 10),
      endTime: DateTime(2020,11,1,10).add(Duration(hours:2)),
      subject: 'Navaratri',
      color: Colors.red,
      isAllDay: true,
    ));
    appointments.add(Appointment(
      startTime: DateTime(2020, 11, 4, 10),
      endTime: DateTime(2020,11,4,10).add(Duration(hours:2)),
      subject: 'Rama Navami',
      color: Colors.deepPurple,
      isAllDay: false,
    ));

    return _AppointmentDataSource(appointments);
  }




}
class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Appointment> source) {
    appointments = source;
  }
  @override
  bool isAllDay(int index) => appointments[index].isAllDay;

  @override
  String getSubject(int index) => appointments[index].eventName;

  @override
  String getStartTimeZone(int index) => appointments[index].startTimeZone;

  @override
  String getNotes(int index) => appointments[index].description;

  @override
  String getEndTimeZone(int index) => appointments[index].endTimeZone;

  @override
  Color getColor(int index) => appointments[index].background;

  @override
  DateTime getStartTime(int index) => appointments[index].from;

  @override
  DateTime getEndTime(int index) => appointments[index].to;

}
class Meeting {
  Meeting(
      {@required this.from,
        @required this.to,
        this.background = Colors.green,
        this.isAllDay = false,
        this.eventName = '',
        this.startTimeZone = '',
        this.endTimeZone = '',
        this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final String startTimeZone;
  final String endTimeZone;
  final String description;
}
