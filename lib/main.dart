import 'package:flutter/material.dart';
import 'package:todo_app_flutter/presentation/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        // ThemeData.dark() üzerinden kopyalama yapıyoruz
        textTheme: TextTheme(
          bodySmall: TextStyle(fontFamily: 'Poppins'),
          bodyLarge: TextStyle(fontFamily: 'Poppins'),
          bodyMedium: TextStyle(fontFamily: 'Poppins'),
        ),
        appBarTheme: const AppBarTheme(
          /*
         title: const Text(
           'my playground',
           textAlign: TextAlign.center,
           style: TextStyle
             (

             //fontStyle: FontStyle.italic,
           ),
         ),
         */
          shadowColor: Colors.white,
          backgroundColor: Colors.black,

          //automaticallyImplyLeading: false, //sol üstteki butonu kaldırır (geri butonu)
        ),
      ),
      home: const HomePage(),
    );
  }
}
