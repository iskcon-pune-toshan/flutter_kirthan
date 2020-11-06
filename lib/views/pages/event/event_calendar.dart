import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_kirthan/models/event.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/cupertino.dart';

class Calendar extends StatefulWidget {
  EventRequest eventrequest ;

  Calendar({Key key, @required this.eventrequest}) : super(key: key);

  @override
  CalendarClass createState() => CalendarClass();

}
List<String> views = <String>[
  'Day',
  'Week',
  'Month',
];
class CalendarClass extends State<Calendar>
{
  CalendarView _calendarView;
  DateTime _datePicked;
  DateTime _calendarDate;
  @override
  void initState() {
    // TODO: implement initState
    _calendarView = CalendarView.week;
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
            child: Icon(
              Icons.date_range,
              color: Colors.white,
            ),
          )
        ],
        leading: PopupMenuButton<String>(
          icon: Icon(Icons.calendar_today),
          itemBuilder: (BuildContext context) => views.map((String choice) {
            return PopupMenuItem<String>(
              value: choice,
              child: Text(choice),
            );
          }).toList(),
          onSelected: (String value) {
            setState(() {
              if (value == 'Day') {
                _calendarView = CalendarView.day;
              } else if (value == 'Week') {
                _calendarView = CalendarView.week;
              }  else if (value == 'Month') {
                _calendarView = CalendarView.month;
              }
            });
          },
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: SfCalendar(
              initialDisplayDate: _calendarDate,
              view: _calendarView,
              onViewChanged: _viewChanged,
              dataSource: _getCalendarDataSource(),
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
}

