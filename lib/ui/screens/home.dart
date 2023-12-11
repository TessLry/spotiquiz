import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpotiQuiz'),
        backgroundColor: Color.fromARGB(255, 30, 215, 96),
      ),
      body: Center(
        child: Text(
          'Home',
        ),
      ),
    );
  }
}
