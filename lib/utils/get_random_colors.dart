import 'dart:ui';

import 'package:flutter/material.dart';

Color getRandomColor(String text) {
  final colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
  ];
  return colors[text.hashCode % colors.length];
}

Color getRandomLetterColor(String text) {
  final colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.indigo,
  ];
  // Pick a color consistently based on the text
  return colors[text.hashCode % colors.length];
}