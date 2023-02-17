import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import './appstate_widget.dart';

class OverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: true);

    return Container(
      child: Column(
        children: [
          Container(
            color: Colors.transparent,
            child: Text('68'),
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
