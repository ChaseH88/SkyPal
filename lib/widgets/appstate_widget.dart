import 'package:flutter/material.dart';

class AppState extends InheritedModel<String> {
  final DateTime _currentDay;
  final List<DateTime> _next14Days;
  final DateTime _selectedDay;
  final void Function(DateTime newSelectedDay) _updateSelectedDay;

  AppState({
    Key key,
    DateTime currentDay,
    List<DateTime> next14Days,
    DateTime selectedDay,
    final void Function(DateTime newSelectedDay) updateSelectedDay,
    Widget child,
  })  : _currentDay = currentDay ?? DateTime.now(),
        _next14Days = next14Days ??
            List.generate(
              14,
              (i) => DateTime.now().add(Duration(days: i)),
            ),
        _selectedDay = selectedDay ?? DateTime.now(),
        _updateSelectedDay = updateSelectedDay,
        super(key: key, child: child);

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return _currentDay != oldWidget._currentDay ||
        _next14Days != oldWidget._next14Days ||
        _selectedDay != oldWidget._selectedDay;
  }

  @override
  bool updateShouldNotifyDependent(
      AppState oldWidget, Set<String> dependencies) {
    final bool currentDayChanged = _currentDay != oldWidget._currentDay;
    final bool next14DaysChanged = _next14Days != oldWidget._next14Days;
    final bool selectedDayChanged = _selectedDay != oldWidget._selectedDay;

    return dependencies.contains('currentDay') && currentDayChanged ||
        dependencies.contains('next14Days') && next14DaysChanged ||
        dependencies.contains('selectedDay') && selectedDayChanged;
  }

  static AppState of(BuildContext context, String aspect) {
    return InheritedModel.inheritFrom<AppState>(context, aspect: aspect);
  }

  static AppState from(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>();
  }

  DateTime get currentDay => _currentDay;

  List<DateTime> get next14Days => _next14Days;

  DateTime get selectedDay => _selectedDay;

  void handleUpdateSelectedDay(DateTime newSelectedDay) {
    _updateSelectedDay(newSelectedDay);
  }
}
