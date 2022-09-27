import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_u/src/features/auth/data/auth_repository.dart';
import 'package:quiz_u/src/features/profile/domain/profile_score.dart';
import 'package:quiz_u/src/utils/in_memory_store.dart';

class ProfileRepository {
  ProfileRepository(this._authRepository);

  /// This user is used to fetch his own data
  /// Usually the repository depends on the client to communicate
  /// with the backend which uses the recieved token to identify the user
  /// However, this data repository needs another mean to identify the user
  /// that's why we need the logged in user info to save it with a unique key
  final AuthRepository _authRepository;

  final _userScores = InMemoryStore<List<ProfileScore>>([]);

  Future<void> fetchUserScores() async {
    if (_authRepository.currentUser == null) {
      throw 'No logged in user to show data';
    }

    try {
      final box = await Hive.openBox<String>('users_scores');
      final String results =
          box.get(_authRepository.currentUser!.mobile) ?? '[]';
      final List resultsJson = jsonDecode(results);
      if (resultsJson.isEmpty) {
        _userScores.value = resultsJson.cast<ProfileScore>();
        return;
      }
      _userScores.value = jsonDecode(results)
          .map<ProfileScore>((scoreItem) => ProfileScore.fromJson(scoreItem))
          .toList()
          .cast<ProfileScore>();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveUserScore(int newScore) async {
    if (_authRepository.currentUser == null) {
      throw 'No logged in user to write any data';
    }

    final box = await Hive.openBox<String>('users_scores');
    final newUserScores = _userScores.value;
    newUserScores.add(ProfileScore(time: DateTime.now(), score: newScore));
    // convert newUserScores to JSON
    final newUserScoresJson = jsonEncode(newUserScores);
    // save score in box,
    box.put(_authRepository.currentUser!.mobile, newUserScoresJson);
    // update [_userScores as well]
    _userScores.value = newUserScores;
  }
}

final profileRepositoryProvider =
    Provider.autoDispose<ProfileRepository>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ProfileRepository(authRepository)..fetchUserScores();
});

final profileScroesStreamProvider =
    StreamProvider.autoDispose<List<ProfileScore>>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return profileRepository._userScores.stream;
});
