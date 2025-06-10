import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:todo_app_flutter/presentation/screens/home_screen.dart';
import 'package:todo_app_flutter/presentation/screens/login_screen.dart';
import 'package:todo_app_flutter/presentation/screens/register_screen.dart';
import 'package:todo_app_flutter/presentation/screens/sheet_learn_screen.dart';

final GoRouter router_ = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/sheet_learn', builder: (context, state) => const SheetLearn()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
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