import 'package:flutter/material.dart';
import '../utils/constants.dart';

class FeedbackCard extends StatelessWidget {
  final Map<String, int> skillScores;
  final String feedback;
  final VoidCallback? onDismiss;

  const FeedbackCard({
    super.key,
    required this.skillScores,
    required this.feedback,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.all(AppSizes.paddingM),
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(AppSizes.radiusM),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.success,
                    size: 20,
                  ),
                  const SizedBox(width: AppSizes.paddingS),
                  Text(
                    'Feedback',
                    style: AppTextStyles.body1.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                  Spacer(),
                  if (onDismiss != null)
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.success,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: BoxConstraints(),
                      onPressed: onDismiss,
                      tooltip: 'Dismiss',
                    ),
                ],
              ),
              const SizedBox(height: AppSizes.paddingS),
              Text(feedback, style: AppTextStyles.body2),
              const SizedBox(height: AppSizes.paddingM),
              _buildSkillScores(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSkillScores() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Skill Scores:',
          style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSizes.paddingS),
        Wrap(
          spacing: AppSizes.paddingS,
          runSpacing: AppSizes.paddingXS,
          children: skillScores.entries.map((entry) {
            return Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
                vertical: AppSizes.paddingS,
              ),
              decoration: BoxDecoration(
                color: _getSkillColor(entry.value).withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppSizes.radiusS),
                border: Border.all(
                  color: _getSkillColor(entry.value).withOpacity(0.3),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getSkillIcon(entry.key),
                    size: 16,
                    color: _getSkillColor(entry.value),
                  ),
                  const SizedBox(width: AppSizes.paddingXS),
                  Text(
                    '${entry.key}: ${entry.value}/5',
                    style: TextStyle(
                      color: _getSkillColor(entry.value),
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Color _getSkillColor(int score) {
    if (score >= 4) {
      return AppColors.success;
    } else if (score >= 3) {
      return AppColors.warning;
    } else {
      return AppColors.error;
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
