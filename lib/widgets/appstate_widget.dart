import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../classes/api.dart';

class AppState with ChangeNotifier {
  DateTime _currentDay;
  List<DateTime> _next14Days;
  DateTime _selectedDay;
  final API api;

  AppState({
    DateTime currentDay,
    List<DateTime> next14Days,
    DateTime selectedDay,
    this.api,
  })  : _currentDay = currentDay ?? DateTime.now(),
        _next14Days = next14Days ??
            List.generate(
              14,
              (i) => DateTime.now().add(Duration(days: i)),
            ),
        _selectedDay = selectedDay ?? DateTime.now();

  static AppState of(BuildContext context) {
    return Provider.of<AppState>(context, listen: false);
  }

  DateTime get currentDay => _currentDay;

  List<DateTime> get next14Days => _next14Days;

  DateTime get selectedDay => _selectedDay;

  void updateSelectedDay(DateTime newSelectedDay) {
    _selectedDay = newSelectedDay;
    notifyListeners();
  }

  // Factory constructor to create the AppState object.
  factory AppState.createState({
    DateTime currentDay,
    List<DateTime> next14Days,
    DateTime selectedDay,
  }) {
    final api = API();

    return AppState(
      currentDay: currentDay,
      next14Days: next14Days,
      selectedDay: selectedDay,
      api: api,
    );
  }
}
