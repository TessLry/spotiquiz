import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/bloc/track_cubit.dart';
import 'package:spotiquiz/router.dart';
import 'package:spotiquiz/utils/colors.dart';
import 'package:spotiquiz/utils/credentials.dart';

void main() {
  final TrackCubit trackCubit = TrackCubit();
  AppCredentials.fetchCredentials();

  runApp(
    BlocProvider<TrackCubit>(
      create: (_) => trackCubit,
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.homePage,
      routes: AppRouter.routes,
    );
  }
}
