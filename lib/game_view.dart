import 'package:dart_cricket_score/multipliers.dart';
import 'package:dart_cricket_score/player.dart';
import 'package:dart_cricket_score/score_display.dart';
import 'package:flutter/cupertino.dart';
import 'slide_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class InGameView extends StatefulWidget {
  static const routeName = '/inGame';
  final int playerNumber;

  const InGameView({super.key, required this.playerNumber});

  @override
  State<InGameView> createState() => _InGameViewState();
}

class _InGameViewState extends State<InGameView> {
  List<int> points = [25, 20, 19, 18, 17, 16, 15, 0];
  List<String> staticPlayers = [];
  List<String> players = [];
  int round = 0;
  String currentP = '';
  String firstPlayer = '';
  num playerScore = 0;
  int throws = 0;
  int selectedMultiplier = 1;

  Map<String, Player> playerMap = {
    'p1': Player(color: CupertinoColors.systemIndigo),
    'p2': Player(color: CupertinoColors.systemTeal),
    'p3': Player(color: CupertinoColors.systemOrange),
    'p4': Player(color: CupertinoColors.systemGreen),
  };

  void _setSelectedMultiplier(num) {
    setState(() {
      selectedMultiplier = num;
    });
  }

  @override
  void initState() {
    if (widget.playerNumber == 2) {
      setState(() {
        staticPlayers = ['p1', 'p2'];
        players = ['p1', 'p2'];
      });
    }
    if (widget.playerNumber == 3) {
      setState(() {
        staticPlayers = ['p1', 'p2', 'p3'];
        players = ['p1', 'p2', 'p3'];
      });
    }
    if (widget.playerNumber == 4) {
      setState(() {
        staticPlayers = ['p1', 'p2', 'p3', 'p4'];
        players = ['p1', 'p2', 'p3', 'p4'];
      });
    }

    setState(() {
      currentP = players.removeAt(0);
      firstPlayer = currentP;
    });

    super.initState();
  }

  void _sumPlayerScoresPerRound() {
    setState(() {
      playerMap[currentP]!.score += playerMap[currentP]
          ?.history[round]
          .fold(0, (previous, current) => previous + current);
    });
  }

  void _moveToNextPlayer() {
    _sumPlayerScoresPerRound();

    players.add(currentP);

    setState(() {
      throws = 0;
      playerScore = 0;
      currentP = players.removeAt(0);

      if (currentP == firstPlayer) {
        round += 1;
      }
    });
  }

  void _addHistoryArrayIfNotPresent() {
    List? cob = playerMap[currentP]?.history;
    int? currentLen = cob?.length;
    if (currentLen! <= round) {
      playerMap[currentP]?.history.add([]);
    }
  }

  void _updatePlayerScore({
    required int val,
    required int throwCount,
  }) {
    _addHistoryArrayIfNotPresent();

    // if positive
    if (val > 0) {
      // check if unlocked
      if (playerMap[currentP]?.unlocked[val] < 3) {
        // if it isn't, burn a turn and increase count for that val
        playerMap[currentP]?.unlocked[val] += 1;
        setState(() {
          throws += throwCount;
        });
        // check if it's the third throw...
        if (throws == 3) {
          // if it is, move to next player...
          Future.delayed(const Duration(milliseconds: 500), () {
            _moveToNextPlayer();
          });
          return;
        }
      } else {
        // the val is unlocked... add points and burn turn
        playerMap[currentP]?.history[round]?.add(val * selectedMultiplier);

        setState(() {
          throws += throwCount;
          playerScore += (val * selectedMultiplier);
        });
      }
    } else if (val < 0) {
      // handle negative swipe here
      int posVal = val.abs();
      if (playerMap[currentP]?.unlocked[posVal] > 0 &&
          playerMap[currentP]?.unlocked[posVal] < 3) {
        playerMap[currentP]?.unlocked[posVal] -= 1;
      }
      List? c = playerMap[currentP]?.history[round];
      int? cl = c?.length;
      if (cl! > 0) {
        playerMap[currentP]?.history[round]?.removeLast();
      }

      setState(() {
        if (throws > 0) {
          throws += throwCount;
        }
        if (playerScore > 0) {
          playerScore += (val * selectedMultiplier);
        }
      });
    } else {
      // if zero burn turn
      setState(() {
        throws += throwCount;
      });
    }

    if (throws == 3) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _moveToNextPlayer();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                transitionDuration: Duration.zero,
                pageBuilder: (_, __, ___) => InGameView(
                  playerNumber: widget.playerNumber,
                ),
              ),
            );
          },
          child: Container(
            color: const Color.fromARGB(12, 239, 239, 244),
            height: 50,
            width: 50,
            child: const Icon(
              CupertinoIcons.refresh,
              color: CupertinoColors.activeBlue,
            ),
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
              color: const Color.fromARGB(12, 239, 239, 244),
              height: 50,
              width: 50,
              child: const Icon(CupertinoIcons.left_chevron)),
        ),
        middle: Text(
          'Round ${round + 1}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      child: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width / 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: staticPlayers.map(
                    (e) {
                      return ScoreDisplay(
                          e: e,
                          playerMap: playerMap,
                          throws: throws,
                          currentP: currentP,
                          playerScore: playerScore,
                          playerNumber: widget.playerNumber);
                    },
                  ).toList(),
                ),
                Multipliers(
                    callback: _setSelectedMultiplier,
                    playerMap: playerMap,
                    currentP: currentP,
                    selectedMultiplier: selectedMultiplier,
                    playerScore: playerScore),
                ...points.map(
                  (e) {
                    return Container(
                      margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 88,
                        bottom: MediaQuery.of(context).size.height / 88,
                      ),
                      width: double.infinity,
                      child: SlideButton(
                          item: e,
                          callback: _updatePlayerScore,
                          playerMap: playerMap,
                          currentP: currentP,
                          playerNumber: widget.playerNumber),
                    );
                  },
                ).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
