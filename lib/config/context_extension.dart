import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  ThemeData get colorApp => Theme.of(this);
}
