import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SlideButton extends StatefulWidget {
  final int item;
  final Function callback;
  final Map<String, Map<String, dynamic>> playerMap;
  final String currentP;
  final int playerNumber;

  const SlideButton(
      {super.key,
      required this.item,
      required this.callback,
      required this.playerMap,
      required this.currentP,
      required this.playerNumber});

  @override
  State<SlideButton> createState() => _SlideButtonState();
}

class _SlideButtonState extends State<SlideButton> {
  double slideColorSpot = 0.9;
  Map<String, dynamic> blocked = {};
  bool isBlocked = false;

  void _getUnlocked() {
    var output;
    widget.playerMap.forEach((key, value) {
      blocked[key] = value['unlocked'];
    });
  }

  void _isBlocked() {
    var counter = 0;
    blocked.forEach((key, value) {
      if (value[widget.item] == 3) {
        counter++;
      }
      if (counter > 1) {
        setState(() {
          isBlocked = true;
        });
        return;
      }
    });
    return;
  }

  double _findLengthBarSize(player) {
    int val = blocked[player]?[widget.item] ?? 0;
    if (val == 0) {
      return 0;
    }

    if (val == 1) {
      return MediaQuery.of(context).size.width / 3;
    }
    if (val == 2) {
      return MediaQuery.of(context).size.width / 1.5;
    }
    if (val == 3) {
      return MediaQuery.of(context).size.width / 1.022;
    }

    return 0;
  }

  void _add() {
    if (!isBlocked) {
      setState(() {
        slideColorSpot -= 0.3;
      });
      HapticFeedback.lightImpact();
      widget.callback(val: widget.item, throwCount: 1);
    }
  }

  void _sub() {
    if (!isBlocked) {
      setState(() {
        slideColorSpot += 0.3;
      });
      HapticFeedback.lightImpact();

      widget.callback(val: widget.item * -1, throwCount: -1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getUnlocked();
    _isBlocked();

    return Stack(
        fit: StackFit.passthrough,
        alignment: AlignmentDirectional.topStart,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedContainer(
                    // Use the properties stored in the State class.
                    width: _findLengthBarSize('p1'),
                    height: widget.playerNumber == 2
                        ? MediaQuery.of(context).size.height / 30
                        : MediaQuery.of(context).size.height / 60,
                    decoration: BoxDecoration(
                      color: widget.playerMap['p1']!['color'],
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          topLeft: Radius.circular(4.0)),
                    ),
                    // Define how long the animation should take.
                    duration: const Duration(seconds: 1),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.fastOutSlowIn,
                  ),
                  AnimatedContainer(
                    // Use the properties stored in the State class.
                    width: _findLengthBarSize('p2'),
                    height: widget.playerNumber == 2
                        ? MediaQuery.of(context).size.height / 30
                        : MediaQuery.of(context).size.height / 60,
                    decoration: BoxDecoration(
                      color: widget.playerMap['p2']!['color'],
                      borderRadius: widget.playerNumber == 2
                          ? const BorderRadius.only(
                              bottomRight: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0))
                          : const BorderRadius.only(
                              bottomRight: Radius.circular(4.0),
                              bottomLeft: Radius.circular(4.0),
                            ),
                    ),
                    // Define how long the animation should take.
                    duration: const Duration(seconds: 1),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.fastOutSlowIn,
                  ),
                  AnimatedContainer(
                    // Use the properties stored in the State class.
                    width: _findLengthBarSize('p3'),
                    height: widget.playerNumber == 2
                        ? 0
                        : MediaQuery.of(context).size.height / 60,
                    decoration: BoxDecoration(
                      color: widget.playerMap['p3']!['color'],
                    ),
                    // Define how long the animation should take.
                    duration: const Duration(seconds: 1),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.fastOutSlowIn,
                  ),
                  AnimatedContainer(
                    // Use the properties stored in the State class.
                    width: _findLengthBarSize('p4'),
                    height: widget.playerNumber == 2
                        ? 0
                        : MediaQuery.of(context).size.height / 60,
                    decoration: BoxDecoration(
                      color: widget.playerMap['p4']!['color'],
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(4.0),
                          bottomLeft: Radius.circular(4.0)),
                    ),
                    // Define how long the animation should take.
                    duration: const Duration(seconds: 1),
                    // Provide an optional curve to make the animation feel smoother.
                    curve: Curves.fastOutSlowIn,
                  ),
                ],
              ),
            ],
          ),
          Dismissible(
            key: ObjectKey(widget.item),
            dismissThresholds: const {
              DismissDirection.startToEnd: 0.8,
              DismissDirection.endToStart: 0.4,
            },
            onDismissed: (direction) {
              switch (direction) {
                case DismissDirection.endToStart:
                  _add();
                  break;
                case DismissDirection.startToEnd:
                  _sub();
                  break;
                default:
              }
            },
            background: _DismissibleContainer(
              icon: isBlocked ? 'blocked!' : 'undone',
              backgroundColor: isBlocked
                  ? CupertinoColors.destructiveRed
                  : widget.playerMap[widget.currentP]!['color'],
              iconColor: Colors.green,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsetsDirectional.only(start: 20),
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.endToStart) {
                _add();
              }
              if (direction == DismissDirection.startToEnd) {
                _sub();
              }
              return null;
            },
            secondaryBackground: _DismissibleContainer(
              icon: isBlocked ? 'blocked!' : 'score!',
              backgroundColor: isBlocked
                  ? CupertinoColors.destructiveRed
                  : widget.playerMap[widget.currentP]!['color'],
              iconColor: Colors.yellow,
              alignment: Alignment.centerRight,
              padding: const EdgeInsetsDirectional.only(end: 20),
            ),
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 15,
              child: isBlocked
                  ? const CupertinoButton(
                      color: Color.fromARGB(196, 174, 174, 178),
                      disabledColor: Color.fromARGB(196, 110, 110, 112),
                      onPressed: null,
                      child: Text(' '),
                    )
                  : CupertinoButton(
                      color: Color.fromARGB(133, 196, 196, 202),
                      child: const Text(' '),
                      onPressed: () {
                        _add();
                      }),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 15,
            child: Center(
              child: Text(
                widget.item.toString(),
                style: TextStyle(
                    color: isBlocked
                        ? CupertinoColors.white
                        : const Color.fromARGB(255, 74, 73, 73),
                    fontSize: 30,
                    // decoration: isBlocked ? TextDecoration.lineThrough : null,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ]);
  }
}

class _DismissibleContainer extends StatelessWidget {
  const _DismissibleContainer({
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.alignment,
    required this.padding,
  });

  final String icon;
  final Color backgroundColor;
  final Color iconColor;
  final Alignment alignment;
  final EdgeInsetsDirectional padding;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      alignment: alignment,
      curve: standardEasing,
      color: backgroundColor,
      duration: kThemeAnimationDuration,
      padding: padding,
      child: Text(icon),
    );
  }
}
