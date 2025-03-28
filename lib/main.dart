import 'package:flutter/material.dart';
import 'package:todo_app_flutter/presentation/widgets/loader.dart';
import 'package:todo_app_flutter/presentation/widgets/login.dart';
import 'theme/theme.dart';
import 'package:todo_app_flutter/providers/todo_provider.dart';
import 'package:todo_app_flutter/presentation/screens/home.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/data/models/todo.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => TodoProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  // This widget is the root of your application.

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeInheritedWidget(
      themeMode: _themeMode,
      
      toggleTheme: _toggleTheme,
      child: Builder(
        builder: (context) {
          final inheritedTheme = ThemeInheritedWidget.of(context)!;
          return MaterialApp(
            // initialRoute: '/', // varsayılan route
            
            routes: {'/home': (context) => const HomePage()},

            themeMode: inheritedTheme.themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),

            home: const HomePage(),
          );
          //title: 'Flutter Demo',

          //  theme: ThemeData.dark().copyWith(
          //         // ThemeData.dark() üzerinden kopyalama yapıyoruz
          //         textTheme: TextTheme(
          //           bodySmall: TextStyle(fontFamily: 'Poppins'),
          //           bodyLarge: TextStyle(fontFamily: 'Poppins'),
          //           bodyMedium: TextStyle(fontFamily: 'Poppins'),
          //         ),
          //         appBarTheme: const AppBarTheme(
          //           /*
          //          title: const Text(
          //            'my playground',
          //            textAlign: TextAlign.center,
          //            style: TextStyle
          //              (

          //              //fontStyle: FontStyle.italic,
          //            ),
          //          ),
          //          */
          //           shadowColor: Colors.white,
          //           backgroundColor: Colors.black,

          //           //automaticallyImplyLeading: false, //sol üstteki butonu kaldırır (geri butonu)
          //         ),
          //       ),

          // home: const HomePage(),
        },
      ),
    );
  }
}
