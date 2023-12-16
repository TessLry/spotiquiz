import 'package:flutter/material.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotiquiz/utils/colors.dart';
import 'package:spotiquiz/utils/credentials.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  dynamic _artists;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SpotiQuiz'),
          backgroundColor: AppColors.primary,
        ),
        body: Container(
          child: ElevatedButton(
            onPressed: () async {
              // Initialisation de l'API Spotify
              await SpotifySdk.connectToSpotifyRemote(
                clientId: AppCredentials.spotifyId,
                redirectUrl: AppCredentials.spotifySecret,
              );

              // Exemple de lecture d'une piste
              await SpotifySdk.play(
                spotifyUri:
                    'spotify:track:4iV5W9uYEdYUVa79Axb7Rh', // Remplacez par l'URI de la piste que vous souhaitez lire
              );
            },
            child: Text('Lire une chanson sur Spotify'),
          ),
        ));
  }
}
