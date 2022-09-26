import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/features/leaderboard/domain/leaderboard_result.dart';
import 'package:quiz_u/src/utils/api_end_points.dart';
import 'package:quiz_u/src/utils/app_http_client.dart';

class LeaderboardRepository {
  final AppHttpClient client;
  LeaderboardRepository(this.client);

  Future<List<LeaderboardResult>> fetchLeaderboard() async {
    try {
      final response = await client.get(Uri.parse(Endpoints.topScores));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final topScores = jsonResponse
            .map<LeaderboardResult>((leaderboardResult) =>
                LeaderboardResult.fromJson(leaderboardResult))
            .toList();
        return topScores;
      } else {
        throw 'Could not fetch top scores';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}

final leaderboardRepositoryProvider = Provider<LeaderboardRepository>((ref) {
  final client = ref.watch(appHttpClientProvider);
  return LeaderboardRepository(client);
});

final leaderboardResultsProvider =
    FutureProvider.autoDispose<List<LeaderboardResult>>(
  (ref) async {
    final leaderboardRepository = ref.watch(leaderboardRepositoryProvider);
    return leaderboardRepository.fetchLeaderboard();
  },
  cacheTime: const Duration(seconds: 10),
);
