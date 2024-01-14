import 'package:flutter/material.dart';
import 'package:spotiquiz/ui/navigations/navigation_tab_bar.dart';
import 'package:spotiquiz/ui/screens/login_page.dart';
import 'package:spotiquiz/ui/screens/game.dart';

class AppRouter {
  static const String loginPage = '/login';
  static const String homePage = '/home';
  static const String gamePage = '/game';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) {
        switch (settings.name) {
          case loginPage:
            return const LoginPage();
          case homePage:
            return const NavigationTabBar();
          case gamePage:
            return const Game();
          default:
            return const LoginPage();
        }
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
