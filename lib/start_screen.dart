import 'package:flutter/cupertino.dart';
import 'game_view.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});
  static const routeName = '/';

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  void _onSelectPlayerNum(pn) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => InGameView(playerNumber: pn)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Cricket Scoreboard'),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('How many players?'),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CupertinoButton(
                    onPressed: () {
                      _onSelectPlayerNum(2);
                    },
                    child: const Text('2')),
                CupertinoButton(
                    onPressed: () {
                      _onSelectPlayerNum(3);
                    },
                    child: const Text('3')),
                CupertinoButton(
                    onPressed: () {
                      _onSelectPlayerNum(4);
                    },
                    child: const Text('4'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
