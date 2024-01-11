import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotiquiz/bloc/track_cubit.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/models/track.dart';
import 'package:spotiquiz/repositories/track_repository.dart';
import 'package:spotiquiz/ui/widgets/search_album.dart';
import 'package:spotiquiz/ui/widgets/search_artist.dart';
import 'package:spotiquiz/ui/widgets/select_nb_question.dart';
import 'package:spotiquiz/ui/widgets/toogle_button.dart';
import 'package:spotiquiz/utils/credentials.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
                onPressed: () async {
                  await SpotifySdk.connectToSpotifyRemote(
                      clientId: AppCredentials.spotifyId,
                      redirectUrl: AppCredentials.redirectUrl);
                },
                icon: const Icon(Icons.connect_without_contact_rounded)),
            IconButton(
                onPressed: () async {
                  String token = await SpotifySdk.getAccessToken(
                      clientId: AppCredentials.spotifyId,
                      redirectUrl: AppCredentials.redirectUrl,
                      scope:
                          "app-remote-control,user-modify-playback-state,playlist-read-private");

                  setState(() {
                    AppCredentials.accessToken = token;
                    print("token" + AppCredentials.accessToken);
                  });
                },
                icon: const Icon(Icons.token_outlined)),
          ],
        ),
        const Text('Search for an artist or an album'),
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
        ElevatedButton(
            onPressed: () {
              print("TETE");
              final TrackRepository trackRepository = TrackRepository();

              trackRepository
                  .getTracksByArtist(artist!, nbQuestion)
                  .then((List<Track> tracks) {
                context.read<TrackCubit>().setTracks(tracks);

                Navigator.pushNamed(context, '/game');
              });
            },
            child: Text("TEST"))
      ],
    );
  }
}
