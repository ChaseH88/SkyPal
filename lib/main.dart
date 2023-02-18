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
    return FutureBuilder(
      future: dotenv.load(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<AppState>(
            create: (context) => AppState.createState(),
            child: MaterialApp(
              home: WeatherWidget(),
            ),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}

class WeatherWidget extends StatefulWidget {
  @override
  _WeatherWidgetState createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  @override
  void initState() {
    super.initState();
    final appState = AppState.of(context);
    final updateCurrentPosition = appState.updateCurrentPosition;
    updateCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final container1Height = screenHeight * 0.15;
    final container2Height = screenHeight * 0.35;
    final container3Height = screenHeight * 0.285;
    final appState = AppState.of(context);
    final api = appState.api;

    Future<void> handleRefresh() async {
      final data = await api.getWeather(
          latitude: appState.latitude,
          longitude: appState.longitude,
          dropCache: false);
      print('========================');
      print(data);
    }

    return FutureBuilder(
      future: appState.updateCurrentPosition(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
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
      },
    );
  }
}
