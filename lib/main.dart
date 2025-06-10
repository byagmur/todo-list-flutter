import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:todo_app_flutter/constants/theme.dart';
import 'package:todo_app_flutter/providers/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_flutter/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // flutterfire configure'den gelen dosya

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
          return MaterialApp.router(
            routerConfig: router_,

            // initialRoute: '/', // varsayılan route *yanlış kullanım. Hata verir
            // routes: {'/home': (context) => const HomePage()},
            themeMode: inheritedTheme.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              Locale('en', ''), // veya ['tr'] gibi Türkçe desteği
            ],
          );
        },
      ),
    );
  }
}
