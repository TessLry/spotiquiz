import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/bloc/score_cubit.dart';
import 'package:spotiquiz/bloc/track_cubit.dart';
import 'package:spotiquiz/models/album.dart';
import 'package:spotiquiz/models/artist.dart';
import 'package:spotiquiz/models/score.dart';
import 'package:spotiquiz/models/track.dart';
import 'package:spotiquiz/repositories/track_repository.dart';
import 'package:spotiquiz/ui/widgets/rules.dart';
import 'package:spotiquiz/ui/widgets/search_album.dart';
import 'package:spotiquiz/ui/widgets/search_artist.dart';
import 'package:spotiquiz/ui/widgets/select_nb_question.dart';
import 'package:spotiquiz/ui/widgets/toogle_button.dart';
import 'package:spotiquiz/utils/colors.dart';

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(text: 'Bienvenue sur '),
                TextSpan(
                  text: 'SpotiQuiz ',
                  style: TextStyle(color: AppColors.primary),
                ),
                TextSpan(text: '!'),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Rules(),
          const SizedBox(height: 30),
          ToogleButton(
            onToggle: (value) {
              setState(() {
                selectedToggle = value;
              });
            },
          ),
          const SizedBox(height: 30),
          SelectNbQuestion(
            onToggle: (value) {
              setState(() {
                nbQuestion = value;
              });
            },
          ),
          const SizedBox(height: 10),
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
          FloatingActionButton(
            onPressed: () {
              final TrackRepository trackRepository = TrackRepository();

              if (artist != null || album != null) {
                if (selectedToggle == 'artist') {
                  trackRepository
                      .getTracksByArtist(artist!, nbQuestion)
                      .then((List<Track> tracks) {
                    context.read<TrackCubit>().setTracks(tracks);

                    bool hasPreview = true;

                    for (final Track track in tracks) {
                      if (track.previewUrl == null) {
                        hasPreview = false;
                      }
                    }

                    if (!hasPreview) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Aucun extrait audio disponible'),
                        ),
                      );
                    } else {
                      BlocProvider.of<ScoreCubit>(context).addScore(Score(
                          0, DateTime.now(), artist!.name, artist!.image));

                      Navigator.pushNamed(context, '/game');
                    }
                  });
                } else {
                  trackRepository
                      .getTracksByAlbum(album!, nbQuestion)
                      .then((List<Track> tracks) {
                    context.read<TrackCubit>().setTracks(tracks);

                    bool hasPreview = true;

                    for (final Track track in tracks) {
                      if (track.previewUrl == null) {
                        hasPreview = false;
                      }
                    }

                    if (!hasPreview) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Aucun extrait audio disponible'),
                        ),
                      );
                    } else {
                      BlocProvider.of<ScoreCubit>(context).addScore(
                          Score(0, DateTime.now(), album!.name, album!.image));

                      Navigator.pushNamed(context, '/game');
                    }
                  });
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                        Text('Veuillez sélectionner un artiste ou un album'),
                  ),
                );
              }
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.play_arrow),
          )
        ],
      ),
    );
  }
}
