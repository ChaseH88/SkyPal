import "package:flutter/material.dart";
import 'package:intl/intl.dart';

class DaysOfWeekWidget extends StatelessWidget {
  final DateTime currentDate = DateTime.now();
  final List<DateTime> next14Days = [];

  @override
  Widget build(BuildContext context) {
    // Add the next 14 days to the list
    for (int i = 0; i < 14; i++) {
      DateTime day = currentDate.add(Duration(days: i));
      next14Days.add(day);
    }

    // Return a row of boxes, with the width and height scaled based on the screen size
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final mediaQueryData = MediaQuery.of(context);
        final screenWidth = mediaQueryData.size.width;
        final screenHeight = mediaQueryData.size.height;
        double boxWidth = screenWidth * 0.2;
        double boxHeight = screenHeight * 0.15; // adjust as needed
        List<Widget> dayBoxes = [];
        for (DateTime day in next14Days) {
          String dayName = DateFormat('EEEE').format(day);
          dayBoxes.add(Container(
            width: boxWidth,
            height: boxHeight,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(
                child: Text(dayName),
              ),
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black,
                width: 1,
              ),
            ),
          ));
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: dayBoxes,
          ),
        );
      },
    );
  }
}
