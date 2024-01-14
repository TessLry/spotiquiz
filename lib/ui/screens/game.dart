import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:spotify_sdk/spotify_sdk.dart';
import 'package:spotiquiz/bloc/score_cubit.dart';
import 'package:spotiquiz/bloc/track_cubit.dart';
import 'package:spotiquiz/models/score.dart';
import 'package:spotiquiz/models/track.dart';
import 'package:spotiquiz/ui/widgets/animated_add_icon.dart';
import 'package:spotiquiz/ui/widgets/countdown.dart';
import 'package:spotiquiz/utils/colors.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  String _answer = "";
  int _timeLeft = 3;
  int _songPosition = 0;
  int _score = 0;
  List<Track> _autoCompleteTracks = [];
  Timer? _timer;
  bool _isSongAdded = false;
  AnimationController? _animationController;
  final TextEditingController _textFieldController = TextEditingController();

  AudioPlayer audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startCountDown();
    });
  }

  void _startCountDown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
          _animationController?.reset();
          _animationController?.forward();
        } else {
          timer.cancel();
          startGame();
        }
      });
    });
  }

  void startGame() {
    if (BlocProvider.of<TrackCubit>(context).state.isNotEmpty) {
      playMusic(BlocProvider.of<TrackCubit>(context).state[0].previewUrl);
      _answer = BlocProvider.of<TrackCubit>(context).state[0].name;
    }
  }

  Future<void> playMusic(previewUrl) async {
    await audioPlayer.play(UrlSource(previewUrl));

    audioPlayer.onPositionChanged.listen((Duration d) {
      setState(() {
        _songPosition = d.inSeconds;
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
        BlocProvider.of<ScoreCubit>(context).addScore(Score(
          _score,
          DateTime.now(),
        ));
        Navigator.of(context).pop();
      }
      audioPlayer.stop();
      _timeLeft = 3;
      _songPosition = 0;
      _isSongAdded = false;
      _startCountDown();
      _textFieldController.clear();
      _autoCompleteTracks = [];
      setState(() {});
    }
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    _timer?.cancel();
    _animationController?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SpotiQuiz',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 30,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              letterSpacing: 1.5,
            )),
        backgroundColor: AppColors.black,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Text(_score.toString(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                )),
          )
        ],
      ),
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
                        width: MediaQuery.of(context).size.width - 120,
                        height: MediaQuery.of(context).size.height * 0.4 - 80,
                        left: 60,
                        bottom: index * 4.0 + 40,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Card(
                              elevation: 8,
                              shadowColor: Colors.black54,
                              color: AppColors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: _timeLeft <= 0
                                  ? ScaleTransition(
                                      scale: _animationController!
                                          .drive(Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      )),
                                      child: Lottie.asset(
                                          'assets/music_playing.json'),
                                    )
                                  : Center(
                                      child: Coutdown(
                                      timeLeft: _timeLeft,
                                      animationController:
                                          _animationController!,
                                    ))),
                        ),
                      );
                    }).toList(),
                    Positioned(
                      left: 60,
                      right: 60,
                      bottom: 10,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ajouter à mes titres likés",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          AnimatedAddIcon(
                            isAdd: _isSongAdded,
                            onTap: () async {
                              if (_isSongAdded) {
                                return;
                              }
                              await SpotifySdk.addToLibrary(
                                  spotifyUri:
                                      'spotify:track:${BlocProvider.of<TrackCubit>(context).state[0].id}');

                              setState(() {
                                _isSongAdded = true;
                              });
                            },
                          )
                        ],
                      ),
                    ),
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
                              cursorColor: AppColors.primary,
                              controller: _textFieldController,
                              decoration: const InputDecoration(
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: AppColors.primary, width: 2.0),
                                  ),
                                  fillColor: AppColors.primary,
                                  prefixIcon: Icon(Icons.music_note),
                                  prefixIconColor: AppColors.primary,
                                  labelText: 'Réponse',
                                  labelStyle:
                                      TextStyle(color: AppColors.primary)),
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
