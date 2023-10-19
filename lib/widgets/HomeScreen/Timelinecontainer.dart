import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';

class Timelinecontainer extends StatefulWidget {
  void Function(DateTime rdate) changedate;
  final bool islight;

  Timelinecontainer(
      {super.key, required this.changedate, required this.islight});

  @override
  State<Timelinecontainer> createState() => _TimelinecontainerState();
}

class _TimelinecontainerState extends State<Timelinecontainer> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: EasyDateTimeLine(
          onDateChange: (rdate) {
            widget.changedate(rdate);
          },
          headerProps: EasyHeaderProps(
            monthStyle: TextStyle(
              color: widget.islight ? Colors.black : Colors.white,
            ),
            selectedDateStyle: TextStyle(
                color: widget.islight ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16),
            monthPickerType: MonthPickerType.switcher,
            selectedDateFormat: SelectedDateFormat.fullDateDMonthAsStrY,
          ),
          timeLineProps: EasyTimeLineProps(
              vPadding: 5, hPadding: 15, separatorPadding: 12),
          dayProps: EasyDayProps(
              todayStyle: DayStyle(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          width: 2,
                          color:
                              widget.islight ? Colors.black : Colors.white))),
              inactiveDayNumStyle: TextStyle(
                  color: widget.islight ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              inactiveDayStrStyle: TextStyle(
                  color: widget.islight ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
              inactiveMothStrStyle: TextStyle(
                  color: widget.islight ? Colors.black : Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
              inactiveDayDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: widget.islight ? Colors.black : Colors.white)),
              activeDayNumStyle: TextStyle(
                  color: widget.islight ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              activeMothStrStyle: TextStyle(
                  color: widget.islight ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
              activeDayStrStyle: TextStyle(
                  color: widget.islight ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 12),
              activeDayDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      begin: Alignment.bottomRight,
                      end: Alignment.topLeft,
                      colors: widget.islight
                          ? [Colors.black, Colors.black]
                          : [
                              Colors.white, Colors.white

                              // Color.fromRGBO(54, 0, 51, 1),
                              // Color.fromRGBO(11, 135, 147, 1)
                              // Color.fromRGBO(0, 0, 0, 1),
                              // Color.fromRGBO(146, 60, 181, 1),
                            ])),
              width: 80,
              height: 100,
              dayStructure: DayStructure.dayStrDayNumMonth),
          initialDate: DateTime.now()),
    );
  }
}
