import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/bloc/track_cubit.dart';
import 'package:spotiquiz/models/track.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  var _answer = "";

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playMusic(previewUrl) async {
    await audioPlayer.play(UrlSource(previewUrl));
  }

  void handleChange(value) {
    if (value == _answer) {
      print("Correct");
      BlocProvider.of<TrackCubit>(context).removeTrack();
      audioPlayer.stop();
      setState(() {});
    } else {
      print("Incorrect");
    }
  }

  void startGame() {
    if (BlocProvider.of<TrackCubit>(context).state.length > 0) {
      print("CA COMMENCE");
      playMusic(BlocProvider.of<TrackCubit>(context).state[0].previewUrl);
      _answer = BlocProvider.of<TrackCubit>(context).state[0].name;
    } else {
      print("FINI");
    }
  }

  @override
  Widget build(BuildContext context) {
    startGame();
    return Scaffold(
        appBar: AppBar(
          title: const Text("SpotiQuiz"),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: BlocBuilder<TrackCubit, List<Track>>(
            builder: (context, tracks) {
              return Card(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {
                        handleChange(value);
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Réponse',
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}
