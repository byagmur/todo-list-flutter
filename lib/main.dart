import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_flutter/presentation/screens/login_screen.dart';
import 'package:todo_app_flutter/constants/theme.dart';
import 'package:todo_app_flutter/providers/todo_provider.dart';
import 'package:todo_app_flutter/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

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

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/home',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: HomePage(),
            transitionsBuilder: (
              context,
              animation,
              secondaryAnimation,
              child,
            ) {
              // Change the opacity of the screen using a Curve based on the the animation's
              // value
              // return SlideTransition(
              //   position: animation.drive(
              //     Tween<Offset>(
              //       begin: const Offset(0.0, 1.0),
              //       end: const Offset(0.0, 0.0),
              //     ).chain(CurveTween(curve: Curves.easeInOut)),
              //   ),
              //   child: child,
              // );

              return FadeTransition(
                opacity: CurveTween(
                  curve: Curves.easeInOutCirc,
                ).animate(animation),
                child: child,
              );
            },
          );
        },
      ),
    ],
  );

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
            routerConfig: _router,

            // initialRoute: '/', // varsayılan route *yanlış kullanım. Hata verir
            // routes: {'/home': (context) => const HomePage()},
            themeMode: inheritedTheme.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
          );
        },
      ),
    );
  }
}
