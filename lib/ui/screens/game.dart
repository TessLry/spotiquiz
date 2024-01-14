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
import 'package:spotiquiz/ui/widgets/game/animated_add_icon.dart';
import 'package:spotiquiz/ui/widgets/game/autocomplete_answer_input.dart';
import 'package:spotiquiz/ui/widgets/game/countdown.dart';
import 'package:spotiquiz/utils/colors.dart';

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  late Track _currentTrack;
  String _answer = "";
  String _gamePhase = "countdown";
  int _timeLeft = 3;
  int _songPosition = 0;
  int _currentScore = 0;
  int _score = 0;
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
      _currentTrack = BlocProvider.of<TrackCubit>(context).state[0];
    });
  }

  void _startCountDown() {
    setState(() {
      _gamePhase = "countdown";
    });
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
    setState(() {
      _gamePhase = "playing";
    });

    if (BlocProvider.of<TrackCubit>(context).state.isNotEmpty) {
      playMusic(_currentTrack.previewUrl);
      _answer = _currentTrack.name;
    }
  }

  Future<void> playMusic(previewUrl) async {
    await audioPlayer.play(UrlSource(previewUrl));

    audioPlayer.onPositionChanged.listen((Duration d) {
      setState(() {
        _songPosition = d.inSeconds;
      });
    });

    audioPlayer.onPlayerComplete.listen((event) {
      setState(() {
        _textFieldController.clear();
        _timeLeft = 3;
        _songPosition = 0;
        _currentScore = 0;
        _gamePhase = "finished";
      });
    });
  }

  bool handleSubmit(value) {
    if (value == _answer) {
      int duration = 30;
      _currentScore = 0;
      audioPlayer.getCurrentPosition().then((value) {
        _currentScore = (duration - (value?.inSeconds ?? 0)) * 100;
        setState(() {
          _score += _currentScore;
        });
      });
      _textFieldController.clear();
      audioPlayer.stop();
      _timeLeft = 3;
      _songPosition = 0;
      setState(() {
        _gamePhase = "finished";
      });

      return true;
    }

    return false;
  }

  void handleNextSong() async {
    await BlocProvider.of<TrackCubit>(context).removeTrack();
    if (!context.mounted) return;

    if (BlocProvider.of<TrackCubit>(context).state.isEmpty) {
      await BlocProvider.of<ScoreCubit>(context).updateLastScore(_score);

      if (!context.mounted) return;
      Navigator.of(context).pop();
      return;
    }

    _currentTrack = BlocProvider.of<TrackCubit>(context).state[0];
    _isSongAdded = false;
    _startCountDown();
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
                                child: (() {
                                  if (_gamePhase == "countdown") {
                                    return Center(
                                      child: Countdown(
                                        timeLeft: _timeLeft,
                                        animationController:
                                            _animationController!,
                                      ),
                                    );
                                  } else if (_gamePhase == "playing") {
                                    return ScaleTransition(
                                      scale: _animationController!
                                          .drive(Tween<double>(
                                        begin: 0.0,
                                        end: 1.0,
                                      )),
                                      child: Lottie.asset(
                                          'assets/music_playing.json'),
                                    );
                                  } else if (_gamePhase == "finished") {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Image.network(
                                                _currentTrack.album.image!,
                                                fit: BoxFit.cover,
                                                width: 40,
                                                height: 40),
                                            const SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    _currentTrack.name,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${_currentTrack.artist.name} \u2022  ${_currentTrack.album.name}",
                                                    softWrap: false,
                                                    overflow: TextOverflow.fade,
                                                    style: const TextStyle(
                                                      color: AppColors.white,
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              "Ajouter à mes titres likés",
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontStyle: FontStyle.italic,
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
                                                        'spotify:track:${_currentTrack.id}');

                                                setState(() {
                                                  _isSongAdded = true;
                                                });
                                              },
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              _currentScore == 0
                                                  ? "Dommage..."
                                                  : "Bravo !",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 10),
                                            Text(
                                              "+ $_currentScore pts",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 20),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20, right: 20),
                                          child: ElevatedButton(
                                            onPressed: handleNextSong,
                                            style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10),
                                              backgroundColor: Colors.green,
                                              foregroundColor: Colors.black,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            ),
                                            child: const Text("Suivant"),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return const Text(
                                        "Une erreur est survenue");
                                  }
                                })(),
                              )));
                    }).toList(),
                  ],
                )),
              ),
              Expanded(
                  flex: 6,
                  child: AutocompleteAnswerInput(
                      textFieldController: _textFieldController,
                      trackList: tracks,
                      handleSubmit: handleSubmit))
            ]);
          },
        ),
      ),
    );
  }
}
