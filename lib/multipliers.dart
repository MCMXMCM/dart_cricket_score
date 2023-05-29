import 'package:dart_cricket_score/player.dart';
import 'package:flutter/cupertino.dart';
import 'game_view.dart';

class Multipliers extends StatefulWidget {
  final Function callback;
  final Map<String, Player> playerMap;
  final String currentP;
  final int selectedMultiplier;
  final num playerScore;

  const Multipliers(
      {super.key,
      required this.callback,
      required this.playerMap,
      required this.currentP,
      required this.selectedMultiplier,
      required this.playerScore});

  @override
  State<Multipliers> createState() => _MultipliersState();
}

class _MultipliersState extends State<Multipliers> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            widget.callback(1);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: widget.selectedMultiplier == 1
                  ? widget.playerMap[widget.currentP]?.color
                  : null,
              border: Border.all(
                  width: 1, color: widget.playerMap[widget.currentP]!.color),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: SizedBox(
              width: 70,
              height: MediaQuery.of(context).size.height / 25,
              child: const Center(
                child: Text('1x',
                    style: TextStyle(
                        // color: widget.playerMap[widget.currentP]!['color'],
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.callback(2);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: widget.selectedMultiplier == 2
                  ? widget.playerMap[widget.currentP]?.color
                  : null,
              border: Border.all(
                  width: 1, color: widget.playerMap[widget.currentP]!.color),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: SizedBox(
              width: 70,
              height: MediaQuery.of(context).size.height / 25,
              child: const Center(
                child:
                    Text('2x', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            widget.callback(3);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: widget.selectedMultiplier == 3
                  ? widget.playerMap[widget.currentP]?.color
                  : null,
              border: Border.all(
                  width: 1, color: widget.playerMap[widget.currentP]!.color),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            ),
            child: SizedBox(
              width: 70,
              height: MediaQuery.of(context).size.height / 25,
              child: const Center(
                child: Text('3x',
                    style: TextStyle(
                        // color: widget.playerMap[widget.currentP]!['color'],
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
