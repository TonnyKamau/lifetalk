import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../models/scenario.dart';
import 'conversation_screen.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenge'),
        backgroundColor: AppColors.accent,
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.availableScenarios.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          // For now, use the first scenario as daily challenge
          final dailyScenario = gameProvider.availableScenarios.first;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStreakCard(context),
                const SizedBox(height: AppSizes.paddingL),
                _buildDailyScenario(context, dailyScenario),
                const SizedBox(height: AppSizes.paddingL),
                _buildPreviousChallenges(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStreakCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.accent, AppColors.warning],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.local_fire_department,
            color: Colors.white,
            size: 32,
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Streak',
                  style: AppTextStyles.body2.copyWith(color: Colors.white70),
                ),
                Text(
                  '7 days', // This would come from user progress
                  style: AppTextStyles.heading2.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.paddingM,
              vertical: AppSizes.paddingS,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: const Text('🔥', style: TextStyle(fontSize: 20)),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyScenario(BuildContext context, Scenario scenario) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
        border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textLight.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                scenario.characterAvatar,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scenario.title, style: AppTextStyles.heading3),
                    Text(
                      'with ${scenario.characterName}',
                      style: AppTextStyles.body2,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.paddingM,
                  vertical: AppSizes.paddingS,
                ),
                decoration: BoxDecoration(
                  color: _getDifficultyColor(
                    scenario.difficulty,
                  ).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: Text(
                  scenario.difficulty,
                  style: TextStyle(
                    color: _getDifficultyColor(scenario.difficulty),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          Text(scenario.description, style: AppTextStyles.body1),
          const SizedBox(height: AppSizes.paddingM),
          _buildSkillRewards(scenario.skillRewards),
          const SizedBox(height: AppSizes.paddingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _startScenario(context, scenario),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSizes.paddingL,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusM),
                ),
              ),
              child: const Text(
                'Start Challenge',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRewards(Map<String, int> skillRewards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skill Rewards:',
          style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.paddingS),
        Wrap(
          spacing: AppSizes.paddingS,
          children: skillRewards.entries.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
                vertical: AppSizes.paddingS,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
              ),
              child: Text(
                '${entry.key} +${entry.value}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPreviousChallenges(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Previous Challenges', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSizes.paddingS),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Roommate Dishes Challenge',
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text('Completed yesterday', style: AppTextStyles.body2),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textLight,
                size: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return AppColors.success;
      case 'medium':
        return AppColors.warning;
      case 'hard':
        return AppColors.error;
      default:
        return AppColors.textSecondary;
    }
  }

  void _startScenario(BuildContext context, Scenario scenario) {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.startScenario(scenario.id).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ConversationScreen(scenario: scenario),
        ),
      );
    });
  }
}
