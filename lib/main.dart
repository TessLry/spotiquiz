import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/bloc/score_cubit.dart';
import 'package:spotiquiz/bloc/track_cubit.dart';
import 'package:spotiquiz/repositories/preferences_repository.dart';
import 'package:spotiquiz/router.dart';
import 'package:spotiquiz/ui/navigations/navigation_tab_bar.dart';
import 'package:spotiquiz/utils/colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final TrackCubit trackCubit = TrackCubit();
  final ScoreCubit scoreCubit = ScoreCubit(PreferencesRepository());

  scoreCubit.loadScores();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<TrackCubit>(create: (_) => trackCubit),
        BlocProvider<ScoreCubit>(create: (_) => scoreCubit),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotiQuiz',
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        scaffoldBackgroundColor: AppColors.black,
        brightness: Brightness.dark,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      debugShowCheckedModeBanner: false,
      home: const NavigationTabBar(),
      routes: AppRouter.routes,
    );
  }
}
