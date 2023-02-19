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
  void fetchWeatherData(BuildContext context) {
    final appState = AppState.of(context);
    final api = appState.api;
    final updateAppState = appState.updateAppState;
    final updateCurrentPosition = appState.updateCurrentPosition;

    api
        .getWeather(
      latitude: appState.latitude,
      longitude: appState.longitude,
      dropCache: false,
    )
        .then((data) {
      updateAppState(
        locationData: data['location'],
        currentWeatherData: data['currentWeather'],
        futureWeatherData: data['futureWeather'],
        severeAlertsData: data['severeAlerts'],
      );
    });

    updateCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherData(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final container1Height = screenHeight * 0.15;
    final container2Height = screenHeight * 0.35;
    final container3Height = screenHeight * 0.285;
    final appState = AppState.of(context);

    Future<void> handleRefresh() async {
      fetchWeatherData(context);
    }

    return FutureBuilder(
      future: appState.updateCurrentPosition(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            appState.loading) {
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
