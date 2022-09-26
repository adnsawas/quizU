class LeaderboardResult {
  final String name;
  final int? score;

  LeaderboardResult({required this.name, this.score});

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'name': name,
      'score': score,
    };
  }

  factory LeaderboardResult.fromJson(Map<String, dynamic> map) {
    return LeaderboardResult(
      name: map['name'] as String,
      score: map['score'] != null ? map['score'] as int : null,
    );
  }
}
