class Score {
  final int score;
  final DateTime date;

  const Score(this.score, this.date);

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'date': date.toIso8601String(),
    };
  }

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      json['score'],
      DateTime.parse(json['date']),
    );
  }
}
