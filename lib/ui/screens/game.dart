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
  int _timeLeft = 5;
  int _score = 0;
  List<Track> _autoCompleteTracks = [];
  final TextEditingController _textFieldController = TextEditingController();

  AudioPlayer audioPlayer = AudioPlayer();

  Future<void> playMusic(previewUrl) async {
    await audioPlayer.play(UrlSource(previewUrl));
  }

  void _startCountDown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          timer.cancel();
          startGame();
        }
      });
    });
  }

  void handleSubmit(value) {
    if (value == _answer) {
      int duration = 30;
      int currentScore = 0;
      audioPlayer.getCurrentPosition().then((value) {
        currentScore = (duration - (value?.inSeconds ?? 0)) * 100;
        setState(() {
          _score += currentScore;
        });
      });

      BlocProvider.of<TrackCubit>(context).removeTrack();
      if (BlocProvider.of<TrackCubit>(context).state.isEmpty) {
        Navigator.of(context).pop();
      }
      audioPlayer.stop();
      _timeLeft = 5;
      _startCountDown();
      _textFieldController.clear();
      _autoCompleteTracks = [];
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
                            child: _timeLeft <= 0
                                ? Lottie.asset("assets/music_playing.json")
                                : Center(
                                    child: Text(
                                      _timeLeft.toString(),
                                      style: const TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )),
                      );
                    }).toList(),
                    Positioned(
                        right: 10,
                        top: 10,
                        child: Text(_score.toString(),
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ))),
                  ],
                )),
              ),
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 0, left: 40, right: 40),
                      child: Row(
                        children: [
                          Flexible(
                            child: TextField(
                              controller: _textFieldController,
                              decoration: const InputDecoration(
                                prefixIcon: Icon(Icons.music_note),
                                prefixIconColor: Colors.grey,
                                labelText: 'Réponse',
                              ),
                              onChanged: (value) {
                                setState(() {
                                  if (value.isEmpty) {
                                    _autoCompleteTracks = [];
                                    return;
                                  }
                                  _autoCompleteTracks = tracks
                                      .where((track) => track.name
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                        child: ListView.builder(
                            itemCount: _autoCompleteTracks.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_autoCompleteTracks[index].name),
                                onTap: () {
                                  handleSubmit(_autoCompleteTracks[index].name);
                                },
                              );
                            }))
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
