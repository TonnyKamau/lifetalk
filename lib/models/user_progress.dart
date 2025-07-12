class UserProgress {
  final String userId;
  final Map<String, int> skillLevels;
  final Map<String, int> skillExperience;
  final int totalLevel;
  final int totalExperience;
  final List<String> completedScenarios;
  final List<String> achievements;
  final int currentStreak;
  final DateTime lastPlayedDate;
  final Map<String, int> categoryProgress;
  final String? personalityType;
  final Map<String, String> personalityTraits;
  final String currentCareerStage;
  final Map<String, int> careerStageProgress;
  final int coins;
  final List<String> unlockedFeatures;
  final Map<String, DateTime> dailyChallenges;
  final List<String> savedConversations;
  final Map<String, double> skillGrowthRate;
  final List<String> favoriteScenarios;
  final Map<String, int> scenarioAttempts;

  UserProgress({
    required this.userId,
    required this.skillLevels,
    required this.skillExperience,
    required this.totalLevel,
    required this.totalExperience,
    required this.completedScenarios,
    required this.achievements,
    required this.currentStreak,
    required this.lastPlayedDate,
    required this.categoryProgress,
    this.personalityType,
    this.personalityTraits = const {},
    this.currentCareerStage = 'High School',
    this.careerStageProgress = const {},
    this.coins = 100,
    this.unlockedFeatures = const [],
    this.dailyChallenges = const {},
    this.savedConversations = const [],
    this.skillGrowthRate = const {},
    this.favoriteScenarios = const [],
    this.scenarioAttempts = const {},
  });

  factory UserProgress.initial(String userId) {
    return UserProgress(
      userId: userId,
      skillLevels: {
        'Empathy': 1,
        'Listening': 1,
        'Confidence': 1,
        'Charisma': 1,
        'Conflict Resolution': 1,
        'Assertiveness': 1,
        'Emotional Intelligence': 1,
        'Public Speaking': 1,
      },
      skillExperience: {
        'Empathy': 0,
        'Listening': 0,
        'Confidence': 0,
        'Charisma': 0,
        'Conflict Resolution': 0,
        'Assertiveness': 0,
        'Emotional Intelligence': 0,
        'Public Speaking': 0,
      },
      totalLevel: 1,
      totalExperience: 0,
      completedScenarios: [],
      achievements: [],
      currentStreak: 0,
      lastPlayedDate: DateTime.now(),
      categoryProgress: {
        'Romantic Relationships': 0,
        'Friendships': 0,
        'Family Dynamics': 0,
        'Workplace Situations': 0,
        'Conflict Resolution': 0,
        'Confidence Building': 0,
        'Emotional Support': 0,
        'Public Speaking': 0,
        'Leadership': 0,
      },
      careerStageProgress: {
        'High School': 0,
        'University': 0,
        'Work': 0,
        'Relationship': 0,
        'Leadership': 0,
      },
    );
  }

  factory UserProgress.fromJson(Map<String, dynamic> json) {
    return UserProgress(
      userId: json['userId'],
      skillLevels: Map<String, int>.from(json['skillLevels']),
      skillExperience: Map<String, int>.from(json['skillExperience']),
      totalLevel: json['totalLevel'],
      totalExperience: json['totalExperience'],
      completedScenarios: List<String>.from(json['completedScenarios']),
      achievements: List<String>.from(json['achievements']),
      currentStreak: json['currentStreak'],
      lastPlayedDate: DateTime.parse(json['lastPlayedDate']),
      categoryProgress: Map<String, int>.from(json['categoryProgress']),
      personalityType: json['personalityType'],
      personalityTraits: Map<String, String>.from(
        json['personalityTraits'] ?? {},
      ),
      currentCareerStage: json['currentCareerStage'] ?? 'High School',
      careerStageProgress: Map<String, int>.from(
        json['careerStageProgress'] ?? {},
      ),
      coins: json['coins'] ?? 100,
      unlockedFeatures: List<String>.from(json['unlockedFeatures'] ?? []),
      dailyChallenges: Map<String, DateTime>.from(
        (json['dailyChallenges'] ?? {}).map(
          (key, value) => MapEntry(key, DateTime.parse(value)),
        ),
      ),
      savedConversations: List<String>.from(json['savedConversations'] ?? []),
      skillGrowthRate: Map<String, double>.from(json['skillGrowthRate'] ?? {}),
      favoriteScenarios: List<String>.from(json['favoriteScenarios'] ?? []),
      scenarioAttempts: Map<String, int>.from(json['scenarioAttempts'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'skillLevels': skillLevels,
      'skillExperience': skillExperience,
      'totalLevel': totalLevel,
      'totalExperience': totalExperience,
      'completedScenarios': completedScenarios,
      'achievements': achievements,
      'currentStreak': currentStreak,
      'lastPlayedDate': lastPlayedDate.toIso8601String(),
      'categoryProgress': categoryProgress,
      'personalityType': personalityType,
      'personalityTraits': personalityTraits,
      'currentCareerStage': currentCareerStage,
      'careerStageProgress': careerStageProgress,
      'coins': coins,
      'unlockedFeatures': unlockedFeatures,
      'dailyChallenges': dailyChallenges.map(
        (key, value) => MapEntry(key, value.toIso8601String()),
      ),
      'savedConversations': savedConversations,
      'skillGrowthRate': skillGrowthRate,
      'favoriteScenarios': favoriteScenarios,
      'scenarioAttempts': scenarioAttempts,
    };
  }

  UserProgress copyWith({
    String? userId,
    Map<String, int>? skillLevels,
    Map<String, int>? skillExperience,
    int? totalLevel,
    int? totalExperience,
    List<String>? completedScenarios,
    List<String>? achievements,
    int? currentStreak,
    DateTime? lastPlayedDate,
    Map<String, int>? categoryProgress,
    String? personalityType,
    Map<String, String>? personalityTraits,
    String? currentCareerStage,
    Map<String, int>? careerStageProgress,
    int? coins,
    List<String>? unlockedFeatures,
    Map<String, DateTime>? dailyChallenges,
    List<String>? savedConversations,
    Map<String, double>? skillGrowthRate,
    List<String>? favoriteScenarios,
    Map<String, int>? scenarioAttempts,
  }) {
    return UserProgress(
      userId: userId ?? this.userId,
      skillLevels: skillLevels ?? this.skillLevels,
      skillExperience: skillExperience ?? this.skillExperience,
      totalLevel: totalLevel ?? this.totalLevel,
      totalExperience: totalExperience ?? this.totalExperience,
      completedScenarios: completedScenarios ?? this.completedScenarios,
      achievements: achievements ?? this.achievements,
      currentStreak: currentStreak ?? this.currentStreak,
      lastPlayedDate: lastPlayedDate ?? this.lastPlayedDate,
      categoryProgress: categoryProgress ?? this.categoryProgress,
      personalityType: personalityType ?? this.personalityType,
      personalityTraits: personalityTraits ?? this.personalityTraits,
      currentCareerStage: currentCareerStage ?? this.currentCareerStage,
      careerStageProgress: careerStageProgress ?? this.careerStageProgress,
      coins: coins ?? this.coins,
      unlockedFeatures: unlockedFeatures ?? this.unlockedFeatures,
      dailyChallenges: dailyChallenges ?? this.dailyChallenges,
      savedConversations: savedConversations ?? this.savedConversations,
      skillGrowthRate: skillGrowthRate ?? this.skillGrowthRate,
      favoriteScenarios: favoriteScenarios ?? this.favoriteScenarios,
      scenarioAttempts: scenarioAttempts ?? this.scenarioAttempts,
    );
  }

  int getSkillLevel(String skill) {
    return skillLevels[skill] ?? 1;
  }

  int getSkillExperience(String skill) {
    return skillExperience[skill] ?? 0;
  }

  double getSkillProgress(String skill) {
    int currentExp = getSkillExperience(skill);
    int currentLevel = getSkillLevel(skill);
    int expForNextLevel = currentLevel * 100;
    return currentExp / expForNextLevel;
  }

  bool get hasCompletedDailyChallenge {
    final today = DateTime.now().toIso8601String().split('T')[0];
    return dailyChallenges.containsKey(today);
  }

  bool get canPlayDailyChallenge => !hasCompletedDailyChallenge;

  int getCareerStageProgress(String stage) {
    return careerStageProgress[stage] ?? 0;
  }

  bool get isPremiumUser => unlockedFeatures.contains('premium');

  List<String> getWeakestSkills() {
    final sortedSkills = skillLevels.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return sortedSkills.take(3).map((e) => e.key).toList();
  }

  List<String> getStrongestSkills() {
    final sortedSkills = skillLevels.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedSkills.take(3).map((e) => e.key).toList();
  }
}
