import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import './appstate_widget.dart';

class DaysOfWeekWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = AppState.from(context);

    // Calculate the box width based on the screen size
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;
    double boxWidth = screenWidth * 0.2;
    double boxHeight = screenHeight * 0.1;

    // Create a list of day name boxes
    List<Widget> dayBoxes = [];
    for (DateTime date in appState.next14Days) {
      dayBoxes.add(GestureDetector(
        onTap: () {
          if (appState.handleUpdateSelectedDay != null) {
            appState.handleUpdateSelectedDay(date);
          }
        },
        child: Container(
          width: boxWidth,
          height: boxHeight,
          child: Center(
            child: Text(DateFormat('EEEE, MMM d').format(date)),
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: date == appState.selectedDay ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
        ),
      ));
    }

    // Return a row of boxes, with the width and height scaled based on the screen size
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dayBoxes,
      ),
    );
  }
}
