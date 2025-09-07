import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ColorScheme get colorApp => Theme.of(this).colorScheme;
}
