import 'package:flutter/cupertino.dart';
import 'slide_button.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class InGameView extends StatefulWidget {
  static const routeName = '/inGame';
  int playerNumber = 0;

  InGameView({super.key, required this.playerNumber});

  @override
  State<InGameView> createState() => _InGameViewState();
}

class _InGameViewState extends State<InGameView> {
  List<int> points = [25, 20, 19, 18, 17, 16, 15, 0];
  List<String> staticPlayers = ['p1', 'p2', 'p3'];

  List<String> players = ['p1', 'p2', 'p3'];
  int round = 0;
  String currentP = '';
  String firstPlayer = '';
  int playerScore = 0;
  int throws = 0;

  Map<String, Map<String, dynamic>> playerMap = {
    'p1': {
      'history': [],
      'score': 0,
      'unlocked': {25: 0, 20: 0, 19: 0, 18: 0, 17: 0, 16: 0, 15: 0},
      'color': CupertinoColors.systemIndigo,
    },
    'p2': {
      'history': [],
      'score': 0,
      'unlocked': {25: 0, 20: 0, 19: 0, 18: 0, 17: 0, 16: 0, 15: 0},
      'color': CupertinoColors.systemTeal,
    },
    'p3': {
      'history': [],
      'score': 0,
      'unlocked': {25: 0, 20: 0, 19: 0, 18: 0, 17: 0, 16: 0, 15: 0},
      'color': CupertinoColors.systemOrange,
    },
    'p4': {
      'history': [],
      'score': 0,
      'unlocked': {25: 0, 20: 0, 19: 0, 18: 0, 17: 0, 16: 0, 15: 0},
      'color': CupertinoColors.systemGreen,
    },
  };

  int selectedMultiplier = 1;

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
    List<dynamic> tmp1 = playerMap[currentP]!['history'];

    List<dynamic> tmp2 = playerMap[currentP]!['history'][round];
    print('tmp - $tmp1, tmp2 - $tmp2');
    print('${round}');

    print(
        '${playerMap[currentP]!['history'][round].fold(0, (previous, current) => previous + current)}');
    print('currentP - ${currentP}');

    setState(() {
      playerMap[currentP]!['score'] += playerMap[currentP]?['history']?[round]
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
    List? cob = playerMap[currentP]?['history'];
    int? currlen = cob?.length;
    if (currlen! <= round) {
      playerMap[currentP]?['history']?.add([]);
    }
  }

  void _updatePlayerScore({
    required int val,
    required int throwCount,
  }) {
    _addHistoryArrayIfNotPresent();

    // handle these cases
    // val is negative, val is zero, val is positive
    // if val is neg, if throws is greater than zero, reduce throw by 1
    //
    // if positive
    if (val > 0) {
      // check if unlocked
      if (playerMap[currentP]?['unlocked']?[val] < 3) {
        // if it isn't, burn a turn and increase count for that val
        playerMap[currentP]?['unlocked']![val] += 1;
        setState(() {
          throws += throwCount;
        });
        // check if it's the third throw...
        if (throws == 3) {
          // playerMap[currentP]?['history']?[round]?.add(val);

          // if it is, move to next player...
          _moveToNextPlayer();

          return;
        }
      } else {
        // the val is unlocked... add points and burn turn
        playerMap[currentP]?['history']?[round]?.add(val * selectedMultiplier);

        setState(() {
          throws += throwCount;
          playerScore += (val * selectedMultiplier);
        });
      }
    } else if (val < 0) {
      // handle negative swipe here

      int posVal = val.abs();
      if (playerMap[currentP]?['unlocked']?[posVal] > 0 &&
          playerMap[currentP]?['unlocked']?[posVal] < 3) {
        playerMap[currentP]?['unlocked']![posVal] -= 1;
      }
      List? c = playerMap[currentP]?['history'][round];
      int? cl = c?.length;
      if (cl! > 0) {
        playerMap[currentP]?['history']?[round]?.removeLast();
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
      Future.delayed(const Duration(milliseconds: 1000), () {
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
            color: Color.fromARGB(12, 239, 239, 244),
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
            debugPrint('Back button tapped');
          },
          child: Container(
              color: Color.fromARGB(12, 239, 239, 244),
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
            // constraints: kIsWeb ? const BoxConstraints(maxWidth: 375) : null,
            margin: EdgeInsets.all(MediaQuery.of(context).size.width / 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: staticPlayers.map(
                    (e) {
                      return Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            // color: e == currentP
                            //     ? playerMap[currentP]!['color'].withOpacity(0.2)
                            //     : null,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8.0)),
                            border: e == currentP
                                ? Border.all(
                                    width: 3,
                                    color: playerMap[currentP]!['color'])
                                : null),
                        child: AnimatedContainer(
                          alignment: Alignment.center,
                          transformAlignment: AlignmentDirectional.center,
                          width: widget.playerNumber == 2
                              ? e == currentP
                                  ? MediaQuery.of(context).size.width / 2
                                  : MediaQuery.of(context).size.width / 4
                              : widget.playerNumber == 3
                                  ? e == currentP
                                      ? MediaQuery.of(context).size.width / 3
                                      : MediaQuery.of(context).size.width / 4
                                  : e == currentP
                                      ? MediaQuery.of(context).size.width / 4
                                      : MediaQuery.of(context).size.width / 6.5,
                          height: MediaQuery.of(context).size.height / 16,
                          curve: Curves.fastOutSlowIn,
                          duration: const Duration(seconds: 1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text(
                                      e,
                                      style: e == currentP
                                          ? TextStyle(
                                              color:
                                                  playerMap[currentP]!['color'],
                                              fontWeight: FontWeight.bold)
                                          : TextStyle(
                                              color: playerMap[e]!['color'],
                                              fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  FittedBox(
                                    fit: BoxFit.contain,
                                    child: e == currentP
                                        ? Text(
                                            '${playerMap[e]?['score'] + playerScore}',
                                            style: e == currentP
                                                ? const TextStyle(
                                                    // color: playerMap[currentP]!['color'],

                                                    fontWeight: FontWeight.bold)
                                                : const TextStyle(
                                                    fontWeight: FontWeight.bold
                                                    // color: playerMap[e]!['color'],
                                                    ),
                                          )
                                        : Text(
                                            '${playerMap[e]?['score']}',
                                            style: e == currentP
                                                ? const TextStyle(
                                                    // color: playerMap[currentP]!['color'],

                                                    fontWeight: FontWeight.bold)
                                                : const TextStyle(
                                                    fontWeight: FontWeight.bold
                                                    // color: playerMap[e]!['color'],
                                                    ),
                                          ),
                                  ),
                                ],
                              ),
                              e == currentP
                                  ? FittedBox(
                                      fit: BoxFit.contain,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              throws < 1
                                                  ? Icon(
                                                      CupertinoIcons.circle,
                                                      color: playerMap[e]![
                                                          'color'],
                                                      semanticLabel:
                                                          'Text to announce in accessibility modes',
                                                    )
                                                  : Icon(
                                                      CupertinoIcons
                                                          .circle_fill,
                                                      color: playerMap[e]![
                                                          'color'],
                                                      semanticLabel:
                                                          'Text to announce in accessibility modes',
                                                    ),
                                              throws < 2
                                                  ? Icon(
                                                      CupertinoIcons.circle,
                                                      color: playerMap[e]![
                                                          'color'],
                                                      semanticLabel:
                                                          'Text to announce in accessibility modes',
                                                    )
                                                  : Icon(
                                                      CupertinoIcons
                                                          .circle_fill,
                                                      color: playerMap[e]![
                                                          'color'],
                                                      semanticLabel:
                                                          'Text to announce in accessibility modes',
                                                    ),
                                              throws < 3
                                                  ? Icon(
                                                      CupertinoIcons.circle,
                                                      color: playerMap[e]![
                                                          'color'],
                                                      semanticLabel:
                                                          'Text to announce in accessibility modes',
                                                    )
                                                  : Icon(
                                                      CupertinoIcons
                                                          .circle_fill,
                                                      color: playerMap[e]![
                                                          'color'],
                                                      semanticLabel:
                                                          'Text to announce in accessibility modes',
                                                    ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  : Text(''),
                            ],
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                // )

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _setSelectedMultiplier(1);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: selectedMultiplier == 1
                              ? playerMap[currentP]!['color']
                              : null,
                          border: Border.all(
                              width: 1, color: playerMap[currentP]!['color']),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: SizedBox(
                          width: 70,
                          height: MediaQuery.of(context).size.height / 25,
                          child: Center(
                            child: Text('1x',
                                style: TextStyle(
                                    // color: playerMap[currentP]!['color'],
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _setSelectedMultiplier(2);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: selectedMultiplier == 2
                              ? playerMap[currentP]!['color']
                              : null,
                          border: Border.all(
                              width: 1, color: playerMap[currentP]!['color']),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: SizedBox(
                          width: 70,
                          height: MediaQuery.of(context).size.height / 25,
                          child: Center(
                            child: Text('2x',
                                style: TextStyle(
                                    // color: playerMap[currentP]!['color'],

                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _setSelectedMultiplier(3);
                      },
                      child: Container(
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: selectedMultiplier == 3
                              ? playerMap[currentP]!['color']
                              : null,
                          border: Border.all(
                              width: 1, color: playerMap[currentP]!['color']),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8.0)),
                        ),
                        child: SizedBox(
                          width: 70,
                          height: MediaQuery.of(context).size.height / 25,
                          child: Center(
                            child: Text('3x',
                                style: TextStyle(
                                    // color: playerMap[currentP]!['color'],
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

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
