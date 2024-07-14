import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ColorNotifier extends StateNotifier<Color> {
  ColorNotifier() : super(Colors.green);

  void update(Color newColor) {
    state = newColor;
  }

  List<Color> _colors() {
    List<Color> colors = [];
    double hueStep = 360 / 18;

    for (int i = 0; i < 18; i++) {
      double hue = (i * hueStep) % 360;
      colors.add(HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor());
    }

    return colors;
  }

  List<Color> get colors => _colors();
}

final colorProvider = StateNotifierProvider<ColorNotifier, Color>((ref) {
  return ColorNotifier();
});
