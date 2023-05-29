import 'package:dart_cricket_score/player.dart';
import 'package:flutter/cupertino.dart';
import 'game_view.dart';

class ScoreDisplay extends StatefulWidget {
  final int throws;
  final Map<String, Player> playerMap;
  final String currentP;
  final String e;
  final int playerNumber;
  final num playerScore;

  const ScoreDisplay(
      {super.key,
      required this.e,
      required this.playerMap,
      required this.currentP,
      required this.throws,
      required this.playerNumber,
      required this.playerScore});

  @override
  State<ScoreDisplay> createState() => _ScoreDisplayState();
}

class _ScoreDisplayState extends State<ScoreDisplay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          border: widget.e == widget.currentP
              ? Border.all(width: 3, color: widget.playerMap[widget.e]!.color)
              : null),
      child: AnimatedContainer(
        alignment: Alignment.center,
        transformAlignment: AlignmentDirectional.center,
        width: widget.playerNumber == 2
            ? widget.e == widget.currentP
                ? MediaQuery.of(context).size.width / 2
                : MediaQuery.of(context).size.width / 4
            : widget.playerNumber == 3
                ? widget.e == widget.currentP
                    ? MediaQuery.of(context).size.width / 3
                    : MediaQuery.of(context).size.width / 4
                : widget.e == widget.currentP
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
                    widget.e,
                    style: widget.e == widget.currentP
                        ? TextStyle(
                            color: widget.playerMap[widget.currentP]!.color,
                            fontWeight: FontWeight.bold)
                        : TextStyle(
                            color: widget.playerMap[widget.e]!.color,
                            fontWeight: FontWeight.bold),
                  ),
                ),
                FittedBox(
                  fit: BoxFit.contain,
                  child: widget.e == widget.currentP
                      ? Text(
                          '${widget.playerMap[widget.e]!.score + widget.playerScore}',
                          style: widget.e == widget.currentP
                              ? const TextStyle(
                                  // color: widget.playerMap[currentP]!['color'],

                                  fontWeight: FontWeight.bold)
                              : const TextStyle(fontWeight: FontWeight.bold
                                  // color: widget.playerMap[widget.e]!['color'],
                                  ),
                        )
                      : Text(
                          '${widget.playerMap[widget.e]?.score}',
                          style: widget.e == widget.currentP
                              ? const TextStyle(
                                  // color: widget.playerMap[currentP]!['color'],

                                  fontWeight: FontWeight.bold)
                              : const TextStyle(fontWeight: FontWeight.bold
                                  // color: widget.playerMap[widget.e]!['color'],
                                  ),
                        ),
                ),
              ],
            ),
            widget.e == widget.currentP
                ? FittedBox(
                    fit: BoxFit.contain,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            widget.throws < 1
                                ? Icon(
                                    CupertinoIcons.circle,
                                    color: widget.playerMap[widget.e]?.color,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  )
                                : Icon(
                                    CupertinoIcons.circle_fill,
                                    color: widget.playerMap[widget.e]?.color,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                            widget.throws < 2
                                ? Icon(
                                    CupertinoIcons.circle,
                                    color: widget.playerMap[widget.e]?.color,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  )
                                : Icon(
                                    CupertinoIcons.circle_fill,
                                    color: widget.playerMap[widget.e]?.color,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  ),
                            widget.throws < 3
                                ? Icon(
                                    CupertinoIcons.circle,
                                    color: widget.playerMap[widget.e]?.color,
                                    semanticLabel:
                                        'Text to announce in accessibility modes',
                                  )
                                : Icon(
                                    CupertinoIcons.circle_fill,
                                    color: widget.playerMap[widget.e]?.color,
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
  }
}
