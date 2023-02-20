import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import './appstate_widget.dart';

class DaysOfWeekWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);

    // Calculate the box width based on the screen size
    final mediaQueryData = MediaQuery.of(context);
    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;
    double boxWidth = screenWidth * 0.2;
    double boxHeight = screenHeight * 0.1;

    // will need to loop over appState.futureWeatherData and create a list of boxes
    // each box will have a date and a weather icon

    // Create a list of day name boxes
    List<Widget> dayWeatherBoxes = [];
    appState.currentWeatherData.forEach((day) {
      String dateTime =
          DateFormat('dd/MM').format(DateTime.parse(day['datetime']));
      dayWeatherBoxes.add(GestureDetector(
        key: ValueKey(day['id']),
        onTap: () {
          appState.updateSelectedDay(day['id']);
        },
        child: Container(
          width: boxWidth,
          height: boxHeight,
          child: Column(
            children: [Text(day['temperature']), Text(dateTime)],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color:
                  day['id'] == appState.selectedDay ? Colors.blue : Colors.grey,
              width: 2,
            ),
          ),
        ),
      ));
    });

    // Return a row of boxes, with the width and height scaled based on the screen size
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: dayWeatherBoxes,
      ),
    );
  }
}
