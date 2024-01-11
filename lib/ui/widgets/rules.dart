import 'package:flutter/material.dart';

class Rules extends StatelessWidget {
  const Rules({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Règles du jeu :'),
        SizedBox(width: 10),
        Text('1. Optez pour le mode "Artiste" ou "Album"'),
        SizedBox(width: 10),
        Text('2. Définissez le nombre de questions par partie'),
        SizedBox(width: 10),
        Text('3. Écoutez des extraits de 30 secondes'),
        SizedBox(width: 10),
        Text('4. Devinez le titre et gagnez des points !'),
      ],
    );
  }
}
