import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import './appstate_widget.dart';

class OverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final currentWeatherData = appState.currentWeatherData;
    final selectedDay = appState.selectedDay;
    final selectedDayData = currentWeatherData.firstWhere(
      (day) => day['id'] == selectedDay,
      orElse: () => null,
    );

    return Container(
      child: Column(
        children: [
          Container(
            child: Text(
              selectedDayData['temperature'],
              style: TextStyle(
                fontSize: 50,
                color: Colors.white,
              ),
            ),
            margin: EdgeInsets.only(bottom: 20),
          ),
          Container(
            child: Text(
              selectedDayData['weather_description'],
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
          ),
          Container(
            child: Text(appState.locationData['displayCityState'],
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                )),
          ),
        ],
      ),
    );
  }
}
