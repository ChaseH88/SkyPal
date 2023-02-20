import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../classes/api.dart';

class AppState with ChangeNotifier {
  DateTime _currentDay;
  String _selectedDay;
  final API api;
  Position _currentPosition;
  bool _locationPermissionGranted;
  double _latitude;
  double _longitude;
  dynamic _locationData;
  dynamic _currentWeatherData;
  bool _loading = true;

  AppState({
    DateTime currentDay,
    String selectedDay,
    this.api,
    Position currentPosition,
    bool locationPermissionGranted,
    double latitude,
    double longitude,
    dynamic locationData,
    dynamic currentWeatherData,
  })  : _currentDay = currentDay ?? DateTime.now(),
        _selectedDay = selectedDay,
        _currentPosition = currentPosition,
        _locationPermissionGranted = locationPermissionGranted,
        _latitude = latitude,
        _longitude = longitude,
        _locationData = locationData,
        _currentWeatherData = currentWeatherData;

  static AppState of(BuildContext context) {
    return Provider.of<AppState>(context, listen: false);
  }

  DateTime get currentDay => _currentDay;
  String get selectedDay => _selectedDay;
  Position get currentPosition => _currentPosition;
  bool get locationPermissionGranted => _locationPermissionGranted;
  double get latitude => _latitude;
  double get longitude => _longitude;
  dynamic get locationData => _locationData;
  dynamic get currentWeatherData => _currentWeatherData;
  bool get loading => _loading;

  void updateSelectedDay(String newSelectedDay) {
    _selectedDay = newSelectedDay;
    notifyListeners();
  }

  Future<void> updateCurrentPosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _currentPosition = null;
        _locationPermissionGranted = false;
        return;
      }
    }
    _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = _currentPosition.latitude;
    _longitude = _currentPosition.longitude;
    _locationPermissionGranted = true;
    notifyListeners();
  }

  Future<void> updateAppState({
    dynamic locationData,
    dynamic currentWeatherData,
  }) async {
    _locationData = locationData;
    _currentWeatherData = currentWeatherData;
    _selectedDay = currentWeatherData.first['id'];
    _loading = false;
    notifyListeners();
  }

  // Factory constructor to create the AppState object.
  factory AppState.createState({
    DateTime currentDay,
    String selectedDay,
  }) {
    final api = API();

    return AppState(
      currentDay: currentDay,
      selectedDay: selectedDay,
      api: api,
    );
  }
}
