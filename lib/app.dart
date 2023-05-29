import 'package:dart_cricket_score/start_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CupertinoCricketApp extends StatelessWidget {
  const CupertinoCricketApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return const CupertinoApp(
      theme: CupertinoThemeData(brightness: Brightness.light),
      home: StartScreen(),
    );
  }
}
