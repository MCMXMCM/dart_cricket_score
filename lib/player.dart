import 'package:flutter/cupertino.dart';

class Player {
  final List<dynamic> history = [];
  late num score = 0;
  final Map unlocked = {25: 0, 20: 0, 19: 0, 18: 0, 17: 0, 16: 0, 15: 0};
  final Color color;

  Player({required this.color});
}
