import 'package:flutter/material.dart';

// Widgets
import 'package:weather_app/widgets/app_bar_widget.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherWidget(),
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final container1Height = screenHeight * 0.25; // 25% of screen height
    final container2Height = screenHeight * 0.35; // 35% of screen height
    final container3Height = screenHeight * 0.285; // 40% of screen height

    return Scaffold(
      appBar: AppBarWidget(title: 'This is a test'),
      backgroundColor: Colors.lightBlue,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
              color: Colors.transparent,
              height: container1Height,
              child: Text('Widget 1')),
          Container(
              color: Colors.transparent,
              height: container2Height,
              child: Text('Widget 2')),
          Container(
              color: Colors.transparent,
              constraints: BoxConstraints(
                minHeight: container3Height,
                maxHeight: screenHeight - container1Height - container2Height,
              ),
              child: Text('Widget 3')),
        ],
      ),
    );
  }
}
