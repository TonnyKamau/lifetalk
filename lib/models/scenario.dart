class Scenario {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String characterName;
  final String characterAvatar;
  final String initialMessage;
  final Map<String, int> skillRewards;
  final List<String> tags;
  final bool isUnlocked;
  final int requiredLevel;
  final String? creatorId; // For community scenarios
  final double rating; // Community rating
  final int playCount; // How many times played
  final String? personalityType; // For personality adaptation
  final String? careerStage; // For career mode
  final int estimatedDuration; // In minutes
  final List<String> learningObjectives; // What skills this scenario teaches
  final Map<String, String> characterTraits; // Character personality traits

  Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.characterName,
    required this.characterAvatar,
    required this.initialMessage,
    required this.skillRewards,
    required this.tags,
    this.isUnlocked = true,
    this.requiredLevel = 1,
    this.creatorId,
    this.rating = 0.0,
    this.playCount = 0,
    this.personalityType,
    this.careerStage,
    this.estimatedDuration = 5,
    this.learningObjectives = const [],
    this.characterTraits = const {},
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      difficulty: json['difficulty'],
      characterName: json['characterName'],
      characterAvatar: json['characterAvatar'],
      initialMessage: json['initialMessage'],
      skillRewards: Map<String, int>.from(json['skillRewards']),
      tags: List<String>.from(json['tags']),
      isUnlocked: json['isUnlocked'] ?? true,
      requiredLevel: json['requiredLevel'] ?? 1,
      creatorId: json['creatorId'],
      rating: json['rating']?.toDouble() ?? 0.0,
      playCount: json['playCount'] ?? 0,
      personalityType: json['personalityType'],
      careerStage: json['careerStage'],
      estimatedDuration: json['estimatedDuration'] ?? 5,
      learningObjectives: List<String>.from(json['learningObjectives'] ?? []),
      characterTraits: Map<String, String>.from(json['characterTraits'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'characterName': characterName,
      'characterAvatar': characterAvatar,
      'initialMessage': initialMessage,
      'skillRewards': skillRewards,
      'tags': tags,
      'isUnlocked': isUnlocked,
      'requiredLevel': requiredLevel,
      'creatorId': creatorId,
      'rating': rating,
      'playCount': playCount,
      'personalityType': personalityType,
      'careerStage': careerStage,
      'estimatedDuration': estimatedDuration,
      'learningObjectives': learningObjectives,
      'characterTraits': characterTraits,
    };
  }

  Scenario copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? difficulty,
    String? characterName,
    String? characterAvatar,
    String? initialMessage,
    Map<String, int>? skillRewards,
    List<String>? tags,
    bool? isUnlocked,
    int? requiredLevel,
    String? creatorId,
    double? rating,
    int? playCount,
    String? personalityType,
    String? careerStage,
    int? estimatedDuration,
    List<String>? learningObjectives,
    Map<String, String>? characterTraits,
  }) {
    return Scenario(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
      characterName: characterName ?? this.characterName,
      characterAvatar: characterAvatar ?? this.characterAvatar,
      initialMessage: initialMessage ?? this.initialMessage,
      skillRewards: skillRewards ?? this.skillRewards,
      tags: tags ?? this.tags,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      requiredLevel: requiredLevel ?? this.requiredLevel,
      creatorId: creatorId ?? this.creatorId,
      rating: rating ?? this.rating,
      playCount: playCount ?? this.playCount,
      personalityType: personalityType ?? this.personalityType,
      careerStage: careerStage ?? this.careerStage,
      estimatedDuration: estimatedDuration ?? this.estimatedDuration,
      learningObjectives: learningObjectives ?? this.learningObjectives,
      characterTraits: characterTraits ?? this.characterTraits,
    );
  }

  bool get isCommunityScenario => creatorId != null;
  bool get isPremium => difficulty == 'Hard' || category == 'Premium';
}
