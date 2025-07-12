import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../utils/constants.dart';
import '../models/user_progress.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress'),
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<ProgressProvider>(
        builder: (context, progressProvider, child) {
          final userProgress = progressProvider.userProgress;

          if (userProgress == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOverviewCard(userProgress),
                const SizedBox(height: AppSizes.paddingL),
                _buildSkillProgress(userProgress),
                const SizedBox(height: AppSizes.paddingL),
                _buildAchievements(userProgress),
                const SizedBox(height: AppSizes.paddingL),
                _buildRecentActivity(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildOverviewCard(UserProgress userProgress) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Colors.white, size: 32),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Progress',
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Level ${userProgress.totalLevel} • ${userProgress.totalExperience} XP',
                      style: AppTextStyles.body2.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Scenarios',
                  '${userProgress.completedScenarios.length}',
                  Icons.check_circle,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: _buildStatCard(
                  'Streak',
                  '${userProgress.currentStreak} days',
                  Icons.local_fire_department,
                ),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: _buildStatCard(
                  'Achievements',
                  '${userProgress.achievements.length}',
                  Icons.emoji_events,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 24),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            title,
            style: AppTextStyles.caption.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgress(UserProgress userProgress) {
    final skills = [
      'Empathy',
      'Listening',
      'Confidence',
      'Charisma',
      'Conflict Resolution',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skill Levels', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        ...skills.map((skill) => _buildSkillCard(userProgress, skill)),
      ],
    );
  }

  Widget _buildSkillCard(UserProgress userProgress, String skill) {
    final level = userProgress.getSkillLevel(skill);
    final experience = userProgress.getSkillExperience(skill);
    final progress = userProgress.getSkillProgress(skill);
    final expForNextLevel = level * 100;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getSkillIcon(skill),
                color: _getSkillColor(skill),
                size: 24,
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      skill,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Level $level • $experience/$expForNextLevel XP',
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
                  color: _getSkillColor(skill).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSizes.radiusS),
                ),
                child: Text(
                  'Level $level',
                  style: TextStyle(
                    color: _getSkillColor(skill),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.paddingS),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: _getSkillColor(skill).withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_getSkillColor(skill)),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievements(UserProgress userProgress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Achievements', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        if (userProgress.achievements.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingL),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
              border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 48,
                  color: AppColors.textLight,
                ),
                const SizedBox(height: AppSizes.paddingM),
                Text(
                  'No achievements yet',
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  'Complete scenarios to earn achievements!',
                  style: AppTextStyles.body2,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          )
        else
          ...userProgress.achievements.map(
            (achievement) => _buildAchievementCard(achievement),
          ),
      ],
    );
  }

  Widget _buildAchievementCard(String achievement) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingS),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingS),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.2),
              borderRadius: BorderRadius.circular(AppSizes.radiusS),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: AppColors.accent,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Text(
              achievement,
              style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Completed "Roommate Dishes" scenario',
                '2 hours ago',
                Icons.check_circle,
                AppColors.success,
              ),
              const Divider(),
              _buildActivityItem(
                'Earned 50 XP in Conflict Resolution',
                'Yesterday',
                Icons.trending_up,
                AppColors.primary,
              ),
              const Divider(),
              _buildActivityItem(
                'Started 7-day streak',
                '3 days ago',
                Icons.local_fire_department,
                AppColors.warning,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(
    String title,
    String time,
    IconData icon,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: AppSizes.paddingM),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.body1),
              Text(time, style: AppTextStyles.caption),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSkillColor(String skill) {
    switch (skill.toLowerCase()) {
      case 'empathy':
        return AppColors.error;
      case 'listening':
        return AppColors.primary;
      case 'confidence':
        return AppColors.warning;
      case 'charisma':
        return AppColors.secondary;
      case 'conflict resolution':
        return AppColors.success;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData _getSkillIcon(String skill) {
    switch (skill.toLowerCase()) {
      case 'empathy':
        return Icons.favorite;
      case 'listening':
        return Icons.hearing;
      case 'confidence':
        return Icons.psychology;
      case 'charisma':
        return Icons.star;
      case 'conflict resolution':
        return Icons.handshake;
      default:
        return Icons.psychology;
    }
  }
}
