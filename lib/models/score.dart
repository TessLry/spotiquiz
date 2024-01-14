class Score {
  int score = 0;
  final DateTime date;
  final String name;
  final String? image;

  Score(this.score, this.date, this.name, this.image);

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'date': date.toIso8601String(),
      'name': name,
      'image': image,
    };
  }

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      json['score'],
      DateTime.parse(json['date']),
      json['name'],
      json['image'],
    );
  }
}
