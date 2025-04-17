// import 'package:flutter/material.dart';
// import 'package:todo_app_flutter/constants/color.dart';

// final ThemeData lightTheme = ThemeData(
//   brightness: Brightness.light,
//   primaryColor: const Color.fromARGB(255, 5, 20, 88),
//   scaffoldBackgroundColor: Colors.white,
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
//     bodyMedium: TextStyle(color: Colors.black54, fontSize: 14),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: const Color.fromARGB(255, 255, 65, 65),
//       foregroundColor: Colors.white,
//     ),
//   ),
// );

// final ThemeData darkTheme = ThemeData(
//   brightness: Brightness.dark,
//   primaryColor: gray,
//   scaffoldBackgroundColor: Colors.black,
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
//     bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
//   ),
//   elevatedButtonTheme: ElevatedButtonThemeData(
//     style: ElevatedButton.styleFrom(
//       backgroundColor: gray,
//       foregroundColor: Colors.white,
//     ),
//   ),
// );

// class ThemeInheritedWidget extends InheritedWidget {
//   final ThemeMode themeMode;
//   final Function toggleTheme;

//   const ThemeInheritedWidget({
//     super.key,
//     required this.themeMode,
//     required this.toggleTheme,
//     required super.child,
//   });

//   static ThemeInheritedWidget? of(BuildContext context) {
//     return context.dependOnInheritedWidgetOfExactType<ThemeInheritedWidget>();
//   }

//   @override
//   bool updateShouldNotify(covariant InheritedWidget oldWidget) {
//     return (oldWidget as ThemeInheritedWidget).themeMode != themeMode;
//   }
// }
