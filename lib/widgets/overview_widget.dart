import "package:flutter/material.dart";

class OverviewWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
