import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String text;

  LoadingScreen({
    this.text = "Loading...",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(text),
          ],
        ),
      ),
    );
  }
}
