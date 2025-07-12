import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color secondary = Color(0xFF8B5CF6);
  static const Color accent = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1F2937);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight = Color(0xFF9CA3AF);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle body1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
  );

  static const TextStyle body2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textLight,
  );
}

class AppSizes {
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;

  static const double radiusS = 8.0;
  static const double radiusM = 12.0;
  static const double radiusL = 16.0;
  static const double radiusXL = 24.0;

  static const double iconSizeS = 16.0;
  static const double iconSizeM = 24.0;
  static const double iconSizeL = 32.0;
  static const double iconSizeXL = 48.0;
}

class AppStrings {
  static const String appName = 'LifeTalk';
  static const String appTagline =
      'Improve your social skills through AI-powered conversations';

  // Navigation
  static const String dailyChallenge = 'Daily Challenge';
  static const String careerJourney = 'Career Journey';
  static const String practiceLab = 'Practice Lab';
  static const String progress = 'Progress';
  static const String settings = 'Settings';

  // Game Modes
  static const String modeDaily = 'Daily Challenge';
  static const String modeCareer = 'Career Mode';
  static const String modePractice = 'Practice Mode';
  static const String modeReflection = 'Reflection Mode';

  // Skills
  static const String skillEmpathy = 'Empathy';
  static const String skillListening = 'Listening';
  static const String skillConfidence = 'Confidence';
  static const String skillCharisma = 'Charisma';
  static const String skillConflictResolution = 'Conflict Resolution';

  // Categories
  static const String categoryRomantic = 'Romantic Relationships';
  static const String categoryFriendships = 'Friendships';
  static const String categoryFamily = 'Family Dynamics';
  static const String categoryWorkplace = 'Workplace Situations';
  static const String categoryConflict = 'Conflict Resolution';
  static const String categoryConfidence = 'Confidence Building';
  static const String categoryEmotional = 'Emotional Support';
}
