import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotiquiz/models/score.dart';
import 'package:spotiquiz/repositories/preferences_repository.dart';

class ScoreCubit extends Cubit<List<Score>> {
  final PreferencesRepository preferencesRepository;

  ScoreCubit(this.preferencesRepository) : super([]);

  Future<void> loadScores() async {
    final List<Score> scores = await preferencesRepository.loadScores();

    emit(scores);
  }

  Future<void> addScore(Score scores) async {
    emit([...state, scores]);

    preferencesRepository.saveScore(state);
  }
}
