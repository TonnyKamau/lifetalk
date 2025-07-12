import 'package:flutter/material.dart';
import '../utils/constants.dart';

class CareerJourneyScreen extends StatelessWidget {
  const CareerJourneyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Journey'),
        backgroundColor: AppColors.secondary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressOverview(),
            const SizedBox(height: AppSizes.paddingL),
            _buildLifeStages(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingL),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.secondary, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(AppSizes.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline, color: Colors.white, size: 32),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Journey',
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Level 3 • 2 stages completed',
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
          _buildProgressBar(0.4), // 40% progress
        ],
      ),
    );
  }

  Widget _buildProgressBar(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Progress',
              style: AppTextStyles.body2.copyWith(color: Colors.white70),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.body2.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingS),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.white24,
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ],
    );
  }

  Widget _buildLifeStages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Life Stages', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        _buildStageCard(
          'School Life',
          'High school and college scenarios',
          Icons.school,
          AppColors.success,
          true,
          0.8,
        ),
        const SizedBox(height: AppSizes.paddingM),
        _buildStageCard(
          'Dating & Relationships',
          'Romantic and social scenarios',
          Icons.favorite,
          AppColors.error,
          true,
          0.6,
        ),
        const SizedBox(height: AppSizes.paddingM),
        _buildStageCard(
          'Workplace',
          'Professional communication scenarios',
          Icons.work,
          AppColors.primary,
          false,
          0.0,
        ),
        const SizedBox(height: AppSizes.paddingM),
        _buildStageCard(
          'Family Life',
          'Family dynamics and parenting',
          Icons.family_restroom,
          AppColors.secondary,
          false,
          0.0,
        ),
      ],
    );
  }

  Widget _buildStageCard(
    String title,
    String description,
    IconData icon,
    Color color,
    bool isUnlocked,
    double progress,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: isUnlocked ? AppColors.surface : AppColors.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(
          color: isUnlocked
              ? color.withOpacity(0.3)
              : AppColors.textLight.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSizes.paddingM),
            decoration: BoxDecoration(
              color: isUnlocked
                  ? color.withOpacity(0.1)
                  : AppColors.textLight.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusM),
            ),
            child: Icon(
              icon,
              color: isUnlocked ? color : AppColors.textLight,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSizes.paddingM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isUnlocked
                        ? AppColors.textPrimary
                        : AppColors.textLight,
                  ),
                ),
                Text(
                  description,
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (isUnlocked) ...[
                  const SizedBox(height: AppSizes.paddingS),
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: color.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ],
              ],
            ),
          ),
          Icon(
            isUnlocked ? Icons.arrow_forward_ios : Icons.lock,
            color: isUnlocked ? color : AppColors.textLight,
            size: 20,
          ),
        ],
      ),
    );
  }
}
