import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quiz_u/src/common_widgets/animated_list_item.dart';
import 'package:quiz_u/src/common_widgets/async_value_widget.dart';
import 'package:quiz_u/src/common_widgets/empty_results_widget.dart';
import 'package:quiz_u/src/features/leaderboard/data/leaderboard_repository.dart';
import 'package:quiz_u/src/features/leaderboard/domain/leaderboard_result.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leaderboardResults = ref.watch(leaderboardResultsProvider);
    return AsyncValueWidget<List<LeaderboardResult>>(
      value: leaderboardResults,
      refresh: () => ref.refresh(leaderboardResultsProvider.future),
      builder: (context, data) {
        return data.isEmpty
            ? const EmptyResultsWidget()
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Card(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('🏆', style: TextStyle(fontSize: 75)),
                            Text('Leaderboard',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.secondaryColor)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          color: AppColors.primaryColor,
                          onRefresh: () =>
                              ref.refresh(leaderboardResultsProvider.future),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              final leaderboardResult = data[index];
                              return AnimatedListItem(
                                child: ListTile(
                                  title: Text(
                                    leaderboardResult.name,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  leading: CircleAvatar(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      child: Text('${index + 1}')),
                                  trailing: Text(
                                      leaderboardResult.score == null
                                          ? 'N/A'
                                          : leaderboardResult.score.toString(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              );
                            },
                            itemCount: data.length,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
      },
    );
  }
}
