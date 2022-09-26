// ignore: depend_on_referenced_packages
import 'package:hive/hive.dart';

part 'profile_score.g.dart';

@HiveType(typeId: 1)
class ProfileScore {
  ProfileScore({required this.time, required this.score});
  @HiveField(0)
  final DateTime time;

  @HiveField(1)
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
