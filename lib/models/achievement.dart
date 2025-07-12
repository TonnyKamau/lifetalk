class Achievement {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final int requiredValue;
  final String rewardType;
  final int rewardValue;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final List<String> requirements;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    required this.requiredValue,
    required this.rewardType,
    required this.rewardValue,
    this.isUnlocked = false,
    this.unlockedAt,
    this.requirements = const [],
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      icon: json['icon'],
      category: json['category'],
      requiredValue: json['requiredValue'],
      rewardType: json['rewardType'],
      rewardValue: json['rewardValue'],
      isUnlocked: json['isUnlocked'] ?? false,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'])
          : null,
      requirements: List<String>.from(json['requirements'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'icon': icon,
      'category': category,
      'requiredValue': requiredValue,
      'rewardType': rewardType,
      'rewardValue': rewardValue,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'requirements': requirements,
    };
  }

  Achievement copyWith({
    String? id,
    String? title,
    String? description,
    String? icon,
    String? category,
    int? requiredValue,
    String? rewardType,
    int? rewardValue,
    bool? isUnlocked,
    DateTime? unlockedAt,
    List<String>? requirements,
  }) {
    return Achievement(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      category: category ?? this.category,
      requiredValue: requiredValue ?? this.requiredValue,
      rewardType: rewardType ?? this.rewardType,
      rewardValue: rewardValue ?? this.rewardValue,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      requirements: requirements ?? this.requirements,
    );
  }
}

class AchievementCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final List<Achievement> achievements;

  AchievementCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.achievements,
  });

  int get unlockedCount => achievements.where((a) => a.isUnlocked).length;
  int get totalCount => achievements.length;
  double get progress => totalCount > 0 ? unlockedCount / totalCount : 0.0;
}
