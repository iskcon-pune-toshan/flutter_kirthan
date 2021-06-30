import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final EventPageViewModel eventPageVM =
EventPageViewModel(apiSvc: EventAPIService());
List<EventRequest> eventRequest;

class CalendarPage extends StatefulWidget {
  EventRequest eventrequest;

  CalendarPage({Key key, @required this.eventrequest}) : super(key: key);
  @override
  CalendarClass createState() => CalendarClass();
}
List<String> views = <String>[
  'Day',
  'Week',
  'Month',
];

class CalendarClass extends State<CalendarPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Container(
        child: FutureBuilder(
          future: getDataFromWeb(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data != null) {
              return SafeArea(
                child: Container(
                    child: SfCalendar(
                      view: CalendarView.month,
                      initialDisplayDate: DateTime.now(),
                      dataSource:_AppointmentDataSource(snapshot.data),
                      monthViewSettings: MonthViewSettings(showAgenda: true),
                      showDatePickerButton: true,
                    )),
              );
            } else {
              //TODO: solved the null print when shift to calender view
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Future<List<Meeting>> getDataFromWeb() async {
    final List<Meeting> appointmentData = [];
    eventRequest = await eventPageVM.getEventRequests("MyEvent");
    for(var eventName in eventRequest){
      var format = DateFormat("HH:mm");
      var one = format.parse(eventName.eventStartTime);
      var two = format.parse(eventName.eventEndTime);
      String duration;
    if(two.difference(one).toString().substring(0,2).contains(":"))
        duration= two.difference(one).toString().substring(0,1);
      else
        duration= two.difference(one).toString().substring(0,2);
      print(duration);
      Meeting meetingData = Meeting(
        eventName: eventName.eventTitle,
        from: DateTime(
            DateTime.parse(eventName.eventDate).year,
            DateTime.parse(eventName.eventDate).month,
            DateTime.parse(eventName.eventDate).add(new Duration(days: 1)).day,
            one.hour,
            one.minute),
        to: DateTime(
            DateTime.parse(eventName.eventDate).year,
            DateTime.parse(eventName.eventDate).month,
            DateTime.parse(eventName.eventDate)
                .add(new Duration(days: 1)).day,
            two.hour,two.minute),
        background: Colors.blue,
      );

      appointmentData.add(meetingData);
    }
    return appointmentData;
  }
}

class _AppointmentDataSource extends CalendarDataSource {
  _AppointmentDataSource(List<Meeting> source) {
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
      @required this.startTimeZone,
        @required this.endTimeZone,
      this.description = ''});

  final String eventName;
  final DateTime from;
  final DateTime to;
  final Color background;
  final bool isAllDay;
  final DateTime startTimeZone;
  final DateTime endTimeZone;
  final String description;
}
