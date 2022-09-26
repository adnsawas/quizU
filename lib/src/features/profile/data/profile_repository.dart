import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quiz_u/src/features/auth/data/auth_repository.dart';
import 'package:quiz_u/src/features/auth/domain/logged_user.dart';
import 'package:quiz_u/src/features/profile/domain/profile_score.dart';
import 'package:quiz_u/src/utils/in_memory_store.dart';

class ProfileRepository {
  ProfileRepository(this._user);

  /// This user is used to fetch his own data
  /// Usually the repository depends on the client to communicate
  /// with the backend which uses the recieved token to identify the user
  /// However, this data repository needs another mean to identify the user
  /// that's why we need the logged in user info to save it with a unique key
  final LoggedUser? _user;

  final _userScores = InMemoryStore<List<ProfileScore>>([]);

  Future<void> fetchUserScores() async {
    if (_user == null) throw 'No logged in user to show data';

    try {
      final box = await Hive.openBox<List<ProfileScore>>('users_scores');
      final List<ProfileScore> results =
          box.get(_user!.mobile) ?? <ProfileScore>[];
      _userScores.value = results;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> saveUserScore(int newScore) async {
    if (_user == null) throw 'No logged in user to write any data';

    final box = await Hive.openBox<List<ProfileScore>>('users_scores');
    final newUserScores = _userScores.value;
    newUserScores.add(ProfileScore(time: DateTime.now(), score: newScore));
    // save score in box,
    box.put(_user!.mobile, newUserScores);
    // update [_userScores as well]
    _userScores.value = newUserScores;
  }
}

final profileRepositoryProvider =
    Provider.autoDispose<ProfileRepository>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return ProfileRepository(authRepository.currentUser)..fetchUserScores();
});

final profileScroesStreamProvider =
    StreamProvider.autoDispose<List<ProfileScore>>((ref) {
  final profileRepository = ref.watch(profileRepositoryProvider);
  return profileRepository._userScores.stream;
});
