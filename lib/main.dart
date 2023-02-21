import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Widgets
import 'package:weather_app/widgets/appstate_widget.dart';
import 'package:weather_app/widgets/app_bar_widget.dart';
import 'package:weather_app/widgets/daysofweek_widget.dart';
import 'package:weather_app/widgets/overview_widget.dart';
import 'package:weather_app/widgets/details_widget.dart';
import 'package:weather_app/widgets/loading_widget.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 1), () => dotenv.load()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider<AppState>(
            create: (context) => AppState.createState(),
            child: MaterialApp(
              home: WeatherWidget(),
            ),
          );
        } else {
          return MaterialApp(
              home: LoadingScreen(
            text: 'Starting App...',
          ));
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
  Future<void> _initializeAppState(BuildContext context) async {
    try {
      final appState = AppState.of(context);
      appState.updateCurrentPosition().then((value) => null);
      fetchWeatherData(context).then((value) => null);
    } catch (e) {
      print("Error initializing app state: $e");
    }
  }

  Future<void> fetchWeatherData(BuildContext context) async {
    final appState = AppState.of(context);
    final api = appState.api;
    final updateAppState = appState.updateAppState;
    api
        .getWeather(
      latitude: appState.latitude,
      longitude: appState.longitude,
    )
        .then((data) {
      updateAppState(
        locationData: data['location'],
        currentWeatherData: data['weatherData'],
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeAppState(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final container1Height = screenHeight * 0.2;
    final container2Height = screenHeight * 0.3;
    final container3Height = screenHeight * 0.5;
    final appState = AppState.of(context);

    Future<void> handleRefresh() async {
      fetchWeatherData(context);
    }

    return FutureBuilder(
      future: appState.updateCurrentPosition(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            appState.loading) {
          return LoadingScreen(
            text: snapshot.connectionState == ConnectionState.waiting
                ? 'Getting your location...'
                : 'Loading weather data...',
          );
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
                    child: DetailsWidget(),
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
