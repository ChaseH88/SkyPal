import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './appstate_widget.dart';

class DetailsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);
    final currentWeatherData = appState.currentWeatherData;
    final selectedDay = appState.selectedDay;
    final selectedDayData = currentWeatherData.firstWhere(
      (day) => day['id'] == selectedDay,
      orElse: () => null,
    );

    Map<String, dynamic> page1 = {
      'Precepitation': selectedDayData['precipitation'],
      'High': selectedDayData['high_temp'],
      'Low': selectedDayData['low_temp'],
      'Wind Speed': selectedDayData['wind_speed'],
      'Wind Gust': selectedDayData['max_wind_speed_gust'],
      'Wind Direction': selectedDayData['wind_direction'],
    };

    Map<String, dynamic> page2 = {
      'Cloud Cover': selectedDayData['cloud_cover'],
      'Dew Point': selectedDayData['dew_point'],
      'UV Index': selectedDayData['uv_index'],
      'Feels Like': selectedDayData['feels_like'],
      'Sunrise': selectedDayData['sunrise'],
      'Sunset': selectedDayData['sunset'],
    };

    Container buildContainer(String key, String val) {
      return Container(
        height: 10,
        color: Colors.transparent,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                key,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              Text(
                val,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return PageView(
      children: [
        PageView(
          children: [
            GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              children: page1.entries.map((e) {
                return buildContainer(e.key, e.value.toString());
              }).toList(),
            ),
            GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              physics: NeverScrollableScrollPhysics(),
              children: page2.entries.map((e) {
                return buildContainer(e.key, e.value.toString());
              }).toList(),
            )
          ],
        ),
      ],
    );
  }
}
