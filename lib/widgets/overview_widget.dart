import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import './appstate_widget.dart';

class OverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);

    print("Testing: $appState.currentWeatherData");

    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Text(
                appState.currentWeatherData['temperature'] ?? 'Loading...'),
          ),
          Container(
            color: Colors.transparent,
            child: Text('Clear'),
          ),
        ],
      ),
    );
  }
}
