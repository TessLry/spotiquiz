import 'package:spotiquiz/ui/screens/game.dart';
import 'package:spotiquiz/ui/screens/home.dart';

class AppRouter {
  static const String homePage = '/home';
  static const String gamePage = '/game';

  static final routes = {
    homePage: (context) => const Home(),
    gamePage: (context) => const Game(),
  };
}
