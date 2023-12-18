import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:spotiquiz/bloc/track_cubit.dart';
import 'package:spotiquiz/models/track.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  String _answer = "";
  int timeLeft = 5;
  final TextEditingController _textFieldController = TextEditingController();

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playMusic(previewUrl) async {
    await audioPlayer.play(UrlSource(previewUrl));
  }

  void _startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          startGame();
        }
      });
    });
  }

  void handleSubmit(value) {
    if (value == _answer) {
      audioPlayer
          .getCurrentPosition()
          .then((value) => print(value)); //To calculate score
      BlocProvider.of<TrackCubit>(context).removeTrack();
      if (BlocProvider.of<TrackCubit>(context).state.isEmpty) {
        Navigator.of(context).pop();
      }
      audioPlayer.stop();
      timeLeft = 5;
      _startCountDown();
      _textFieldController.clear();
      setState(() {});
    }
  }

  void startGame() {
    if (BlocProvider.of<TrackCubit>(context).state.isNotEmpty) {
      playMusic(BlocProvider.of<TrackCubit>(context).state[0].previewUrl);
      _answer = BlocProvider.of<TrackCubit>(context).state[0].name;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCountDown();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: BlocBuilder<TrackCubit, List<Track>>(
          builder: (context, tracks) {
            return Column(children: [
              Expanded(
                flex: 4,
                child: Center(
                    child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    ...tracks.map((track) {
                      int index = tracks.indexOf(track);
                      return Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        bottom: index * 4.0,
                        child: Card(
                            elevation: 8,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            margin: const EdgeInsets.only(
                                top: 40, left: 60, right: 60, bottom: 40),
                            child: timeLeft <= 0
                                ? Lottie.asset("assets/music_playing.json")
                                : Center(
                                    child: Text(
                                      timeLeft.toString(),
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                      );
                    }).toList(),
                  ],
                )),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: TextField(
                            controller: _textFieldController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Réponse',
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            //not rounded
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                          ),
                          onPressed: () {
                            handleSubmit(_textFieldController.text);
                          },
                          child: const Text(
                            'Suivant',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]);
          },
        ),
      ),
    );
  }
}
