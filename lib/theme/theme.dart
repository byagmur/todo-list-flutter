import 'package:flutter/material.dart';

class ThemeInheritedWidget extends InheritedWidget {
  final ThemeMode themeMode;
  final Function toggleTheme;

  const ThemeInheritedWidget({
    Key? key,
    required this.themeMode,
    required this.toggleTheme,
    required Widget child,
  }) : super(key: key, child: child);

  static ThemeInheritedWidget? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeInheritedWidget>();
  }

  @override 
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return (oldWidget as ThemeInheritedWidget).themeMode != themeMode;
  }
}
