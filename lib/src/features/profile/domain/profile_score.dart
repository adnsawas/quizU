class ProfileScore {
  ProfileScore({required this.time, required this.score});
  final DateTime time;

  final int score;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'time': time.millisecondsSinceEpoch,
      'score': score,
    };
  }

  factory ProfileScore.fromJson(Map<String, dynamic> map) {
    return ProfileScore(
      time: DateTime.fromMillisecondsSinceEpoch(map['time'] as int),
      score: map['score'] as int,
    );
  }
}
