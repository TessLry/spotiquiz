import 'package:flutter/material.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/ui/widgets/search_album.dart';
import 'package:spotiquiz/ui/widgets/search_artist.dart';
import 'package:spotiquiz/ui/widgets/select_nb_question.dart';
import 'package:spotiquiz/utils/colors.dart';
import 'package:spotiquiz/ui/widgets/toogle_button.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedToggle = 'artist';
  int nbQuestion = 5;
  Artist? artist;
  Album? album;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SpotiQuiz'),
          backgroundColor: AppColors.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Text('Search for an artist or an album'),
            SelectNbQuestion(
              onToggle: (value) {
                setState(() {
                  nbQuestion = value;
                });
              },
            ),
            ToogleButton(
              onToggle: (value) {
                setState(() {
                  selectedToggle = value;
                });
              },
            ),
            Expanded(
              child: selectedToggle == 'artist'
                  ? SearchArtist(
                      onToggle: (value) {
                        artist = value;
                      },
                    )
                  : SearchAlbum(
                      onToggle: (value) {
                        album = value;
                      },
                    ),
            ),
          ],
        ));
  }
}
