import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotiquiz/models/score.dart';

class PreferencesRepository {
  Future<void> saveScore(List<Score> scores) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> listJson = [];
    for (final Score score in scores) {
      listJson.add(jsonEncode(score.toJson()));
    }
    prefs.setStringList('scores', listJson);
  }

  Future<List<Score>> loadScores() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> listJson = prefs.getStringList('scores') ?? [];
    final List<Score> scores = [];
    for (final String json in listJson) {
      scores.add(Score.fromJson(jsonDecode(json)));
    }

    return scores;
  }
}
