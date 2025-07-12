import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/constants.dart';
import '../models/user_progress.dart';
import 'daily_challenge_screen.dart';
import 'career_journey_screen.dart';
import 'practice_lab_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'conversation_screen.dart';
import '../models/scenario.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/game_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkPersonalityAssessment();
    _resumeLastConversationIfAny();
  }

  Future<void> _checkPersonalityAssessment() async {
    final prefs = await SharedPreferences.getInstance();
    final needsAssessment =
        !(prefs.getBool('personality_assessment_completed') ?? false);
    if (needsAssessment) {
      // Use pushReplacement to prevent back navigation
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/personality-assessment');
      });
    }
  }

  Future<void> _resumeLastConversationIfAny() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (!authProvider.isAuthenticated) return;
    final prefs = await SharedPreferences.getInstance();
    final needsAssessment =
        !(prefs.getBool('personality_assessment_completed') ?? false);
    if (needsAssessment) return;
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final loaded = await gameProvider.loadLastConversation(
      gameProvider.availableScenarios,
    );
    if (loaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/conversation');
      });
    }
  }

  final List<Widget> _screens = [
    const AuthenticatedHomeScreen(),
    const DailyChallengeScreen(),
    const CareerJourneyScreen(),
    const PracticeLabScreen(),
    const ProgressScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    // If not authenticated, only show the auth screen without bottom navigation
    if (!authProvider.isAuthenticated) {
      // Previously: return const HomeContent();
      // Now: Show nothing or a placeholder, since onboarding handles auth
      return const SizedBox.shrink();
    }

    // If authenticated, show the main app with bottom navigation
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textLight,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_fire_department),
            label: 'Daily',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.timeline), label: 'Career'),
          BottomNavigationBarItem(icon: Icon(Icons.science), label: 'Practice'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Progress',
          ),
        ],
      ),
    );
  }
}

class AuthenticatedHomeScreen extends StatelessWidget {
  const AuthenticatedHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.appName),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _buildHomeContent(context, progressProvider),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    ProgressProvider progressProvider,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeCard(context, progressProvider),
          const SizedBox(height: AppSizes.paddingL),
          _buildQuickActions(context),
          const SizedBox(height: AppSizes.paddingL),
          _buildRecentActivity(context),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(
    BuildContext context,
    ProgressProvider progressProvider,
  ) {
    final userProgress = progressProvider.userProgress;

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
              const CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white24,
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              const SizedBox(width: AppSizes.paddingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome back!',
                      style: AppTextStyles.heading3.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    if (userProgress != null)
                      Text(
                        'Level ${userProgress.totalLevel} • ${userProgress.currentStreak} day streak',
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (userProgress != null) ...[
            const SizedBox(height: AppSizes.paddingM),
            _buildSkillProgress(userProgress),
          ],
        ],
      ),
    );
  }

  Widget _buildSkillProgress(UserProgress userProgress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: AppTextStyles.body2.copyWith(
            color: Colors.white70,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSizes.paddingS),
        Row(
          children: [
            Expanded(
              child: _buildProgressItem(
                'Communication',
                userProgress.getSkillLevel('Empathy'),
                Icons.chat_bubble_outline,
              ),
            ),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: _buildProgressItem(
                'Leadership',
                userProgress.getSkillLevel('Confidence'),
                Icons.people_outline,
              ),
            ),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: _buildProgressItem(
                'Problem Solving',
                userProgress.getSkillLevel('Conflict Resolution'),
                Icons.lightbulb_outline,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressItem(String label, int level, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingS),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(AppSizes.radiusS),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: Colors.white70,
              fontSize: 10,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            'Lv.$level',
            style: AppTextStyles.caption.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Start Conversation',
                Icons.chat_bubble_outline,
                AppColors.primary,
                () {
                  // Create a default scenario for quick start
                  final defaultScenario = Scenario(
                    id: 'quick_start',
                    title: 'Quick Practice',
                    description: 'Practice your communication skills',
                    category: 'Communication',
                    difficulty: 'Beginner',
                    characterName: 'Alex',
                    characterAvatar: '👤',
                    initialMessage:
                        'Hi! I\'m Alex. Let\'s practice some conversation skills together. How are you doing today?',
                    skillRewards: {
                      'Empathy': 10,
                      'Listening': 10,
                      'Confidence': 5,
                    },
                    tags: ['practice', 'beginner'],
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          ConversationScreen(scenario: defaultScenario),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSizes.paddingM),
            Expanded(
              child: _buildActionCard(
                context,
                'Daily Challenge',
                Icons.local_fire_department,
                AppColors.secondary,
                () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DailyChallengeScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSizes.paddingL),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSizes.radiusL),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSizes.paddingS),
            Text(
              title,
              style: AppTextStyles.body2.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivity(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Activity', style: AppTextStyles.heading3),
        const SizedBox(height: AppSizes.paddingM),
        Container(
          padding: const EdgeInsets.all(AppSizes.paddingL),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(AppSizes.radiusL),
          ),
          child: Column(
            children: [
              _buildActivityItem(
                'Completed Communication Challenge',
                '2 hours ago',
                Icons.check_circle,
                Colors.green,
              ),
              const SizedBox(height: AppSizes.paddingM),
              _buildActivityItem(
                'Started Leadership Scenario',
                'Yesterday',
                Icons.play_circle,
                AppColors.primary,
              ),
              const SizedBox(height: AppSizes.paddingM),
              _buildActivityItem(
                'Earned 50 XP',
                '2 days ago',
                Icons.star,
                Colors.amber,
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
        const SizedBox(width: AppSizes.paddingS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.body2.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                time,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
