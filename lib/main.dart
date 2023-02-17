import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Widgets
import 'package:weather_app/widgets/appstate_widget.dart';
import 'package:weather_app/widgets/app_bar_widget.dart';
import 'package:weather_app/widgets/daysofweek_widget.dart';
import 'package:weather_app/widgets/overview_widget.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (context) => AppState(),
      child: MaterialApp(
        home: WeatherWidget(),
      ),
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
    final container1Height = screenHeight * 0.15;
    final container2Height = screenHeight * 0.35;
    final container3Height = screenHeight * 0.285;

    Future<void> handleRefresh() async {
      print('refreshing');
    }

    return Scaffold(
      appBar: AppBarWidget(title: 'This is a test'),
      backgroundColor: Colors.lightBlue,
      body: RefreshIndicator(
        onRefresh: handleRefresh,
        child: ListView(
          children: [
            Container(
              height: container1Height,
              child: OverviewWidget(),
            ),
            Container(
              height: container2Height,
              child: DaysOfWeekWidget(),
            ),
            Container(
              height: container3Height,
              child: Text('Container 3'),
            ),
          ],
        ),
      ),
    );
  }
}
