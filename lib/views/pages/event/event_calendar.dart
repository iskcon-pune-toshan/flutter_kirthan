import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_kirthan/view_models/event_page_view_model.dart';
import 'package:flutter_kirthan/services/event_service_impl.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: Row(
              children: [
                Text('Select a  Date'),
                SizedBox(
                  width: 10,
                ),
                Icon(
                  Icons.date_range,
                  color: Colors.white,
                ),
              ],
            ),
          )
        ],
      ),
      // drawer: MyDrawer(),
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
                    )),
              );
            } else {
              return Container(
                child: Center(
                  child: Text('Error'),
                ),
              );
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
      Meeting meetingData = Meeting(
          eventName: eventName.eventTitle,
          from: DateTime.parse(eventName.eventDate),

          to: DateTime.parse(eventName.eventDate).add(Duration(hours: int.parse(eventName.eventDuration))),
          background: Colors.blue,);
          //allDay: data['AllDay']);
      appointmentData.add(meetingData);
    }
    return appointmentData;
  }
  void _viewChanged(ViewChangedDetails viewChangedDetails) {
    SchedulerBinding.instance.addPostFrameCallback((duration) {
      _datePicked = viewChangedDetails
          .visibleDates[viewChangedDetails.visibleDates.length ~/ 2];
    });
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