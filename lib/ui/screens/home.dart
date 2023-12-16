import 'package:flutter/material.dart';
import 'package:spotiquiz/utils/colors.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SpotiQuiz'),
          backgroundColor: AppColors.primary,
        ),
        body: const Center(
          child: Text(
            'Home',
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/game');
          },
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.play_arrow),
        ));
  }
}
