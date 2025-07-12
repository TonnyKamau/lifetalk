import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';
import '../models/scenario.dart';
import 'conversation_screen.dart';

class PracticeLabScreen extends StatelessWidget {
  const PracticeLabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Practice Lab'),
        backgroundColor: AppColors.success,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkillCategories(),
            const SizedBox(height: AppSizes.paddingL),
            _buildAvailableScenarios(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillCategories() {
    final categories = [
      {'name': 'Empathy', 'icon': Icons.favorite, 'color': AppColors.error},
      {'name': 'Listening', 'icon': Icons.hearing, 'color': AppColors.primary},
      {
        'name': 'Confidence',
        'icon': Icons.psychology,
        'color': AppColors.warning,
      },
      {'name': 'Charisma', 'icon': Icons.star, 'color': AppColors.secondary},
      {
        'name': 'Conflict Resolution',
        'icon': Icons.handshake,
        'color': AppColors.success,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Practice Skills', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppSizes.paddingM,
            mainAxisSpacing: AppSizes.paddingM,
            childAspectRatio: 1.2,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildSkillCard(
              category['name'] as String,
              category['icon'] as IconData,
              category['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildSkillCard(String skill, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: AppSizes.paddingS),
          Text(
            skill,
            style: AppTextStyles.body1.copyWith(
              fontWeight: FontWeight.w600,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSizes.paddingXS),
          Text(
            'Level 3', // This would come from user progress
            style: AppTextStyles.caption.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableScenarios(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Available Scenarios', style: AppTextStyles.heading3),
            const SizedBox(height: AppSizes.paddingM),
            ...gameProvider.availableScenarios.map(
              (scenario) => _buildScenarioCard(context, scenario),
            ),
          ],
        );
      },
    );
  }

  Widget _buildScenarioCard(BuildContext context, Scenario scenario) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textLight.withOpacity(0.1),
            blurRadius: 4,
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
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      scenario.title,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(scenario.category, style: AppTextStyles.body2),
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
          const SizedBox(height: AppSizes.paddingS),
          Text(scenario.description, style: AppTextStyles.body2),
          const SizedBox(height: AppSizes.paddingM),
          Row(
            children: [
              Expanded(child: _buildSkillRewards(scenario.skillRewards)),
              ElevatedButton(
                onPressed: () => _startScenario(context, scenario),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.paddingL,
                    vertical: AppSizes.paddingS,
                  ),
                ),
                child: const Text('Practice'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSkillRewards(Map<String, int> skillRewards) {
    return Wrap(
      spacing: AppSizes.paddingS,
      children: skillRewards.entries.map((entry) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSizes.paddingS,
            vertical: AppSizes.paddingXS,
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
              fontSize: 10,
            ),
          ),
        );
      }).toList(),
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
