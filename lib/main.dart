import 'package:flutter/material.dart';
import 'package:spotiquiz/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SpotiQuiz',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0x1DB954)),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: AppRouter.homePage,
      routes: AppRouter.routes,
    );
  }
}
