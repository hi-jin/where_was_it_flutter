import 'package:flutter/material.dart';

class ColorStyle {
  Color darkPrimary;
  Color primary;
  Color lightPrimary;
  Color accent;

  ColorStyle({
    required this.darkPrimary,
    required this.primary,
    required this.lightPrimary,
    required this.accent,
  });

  static get teal => ColorStyle(
    darkPrimary: Colors.teal.shade700,
    primary: Colors.teal,
    lightPrimary: Colors.teal.shade50,
    accent: Colors.teal.shade700,
  );

  static get purple => ColorStyle(
    darkPrimary: const Color(0xff8a39e1),
    primary: const Color(0xff9c51e0),
    lightPrimary: const Color(0xffe1bee7),
    accent: const Color(0xffecc488),
  );
}