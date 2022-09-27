import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quiz_u/src/common_widgets/animated_list_item.dart';
import 'package:quiz_u/src/common_widgets/async_value_widget.dart';
import 'package:quiz_u/src/common_widgets/empty_results_widget.dart';
import 'package:quiz_u/src/features/auth/data/auth_repository.dart';
import 'package:quiz_u/src/features/auth/presentation/logout_button/logout_button.dart';
import 'package:quiz_u/src/features/profile/data/profile_repository.dart';
import 'package:quiz_u/src/features/profile/domain/profile_score.dart';
import 'package:quiz_u/src/theme/app_colors.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfile = ref.watch(authRepositoryProvider).currentUser!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Logout Button
          Row(
            children: [
              const Expanded(child: SizedBox.shrink()),
              // Profile Info,
              Expanded(
                child: Text('Profile',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.secondaryColor)),
              ),
              const Expanded(
                  child: Align(
                      alignment: Alignment.centerRight, child: LogoutButton())),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: AppColors.secondaryColor, width: 2),
                shape: BoxShape.circle,
                color: AppColors.smallItemsBackgroundColor),
            child: const Text('👨🏻‍💻', style: TextStyle(fontSize: 70)),
          ),
          Text(userProfile.name!, style: Theme.of(context).textTheme.headline5),
          const SizedBox(height: 8),
          Text(userProfile.mobile,
              style: Theme.of(context).textTheme.headline5),
          const SizedBox(height: 24),
          const Divider(),
          // Scores Info Header
          const SizedBox(height: 12),
          Text('My Scores',
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor)),
          // User Scores Details
          Builder(
            builder: (context) {
              final userScores = ref.watch(profileScroesStreamProvider);
              return AsyncValueWidget<List<ProfileScore>>(
                value: userScores,
                refresh: ref.read(profileRepositoryProvider).fetchUserScores,
                builder: (context, scores) {
                  return Expanded(
                      child: scores.isEmpty
                          ? const Center(child: EmptyResultsWidget())
                          : RefreshIndicator(
                              onRefresh: ref
                                  .read(profileRepositoryProvider)
                                  .fetchUserScores,
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  final score = scores[index];
                                  return AnimatedListItem(
                                    child: ListTile(
                                      title: Text(
                                        DateFormat('MMM d, yyyy - h:mm a')
                                            .format(score.time),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6,
                                      ),
                                      trailing: Text(score.score.toString(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline6),
                                    ),
                                  );
                                },
                                itemCount: scores.length,
                              ),
                            ));
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
