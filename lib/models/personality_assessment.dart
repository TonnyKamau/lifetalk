class PersonalityQuestion {
  final String id;
  final String question;
  final List<PersonalityOption> options;
  final String category;
  final int weight;

  PersonalityQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.category,
    this.weight = 1,
  });

  factory PersonalityQuestion.fromJson(Map<String, dynamic> json) {
    return PersonalityQuestion(
      id: json['id'],
      question: json['question'],
      options: (json['options'] as List)
          .map((option) => PersonalityOption.fromJson(option))
          .toList(),
      category: json['category'],
      weight: json['weight'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options.map((option) => option.toJson()).toList(),
      'category': category,
      'weight': weight,
    };
  }
}

class PersonalityOption {
  final String id;
  final String text;
  final Map<String, int> traitScores;
  final String? explanation;

  PersonalityOption({
    required this.id,
    required this.text,
    required this.traitScores,
    this.explanation,
  });

  factory PersonalityOption.fromJson(Map<String, dynamic> json) {
    return PersonalityOption(
      id: json['id'],
      text: json['text'],
      traitScores: Map<String, int>.from(json['traitScores']),
      explanation: json['explanation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'traitScores': traitScores,
      'explanation': explanation,
    };
  }
}

class PersonalityResult {
  final String userId;
  final Map<String, int> traitScores;
  final String primaryPersonalityType;
  final String secondaryPersonalityType;
  final Map<String, String> personalityTraits;
  final List<String> growthAreas;
  final List<String> strengths;
  final DateTime assessedAt;

  PersonalityResult({
    required this.userId,
    required this.traitScores,
    required this.primaryPersonalityType,
    required this.secondaryPersonalityType,
    required this.personalityTraits,
    required this.growthAreas,
    required this.strengths,
    required this.assessedAt,
  });

  factory PersonalityResult.fromJson(Map<String, dynamic> json) {
    return PersonalityResult(
      userId: json['userId'],
      traitScores: Map<String, int>.from(json['traitScores']),
      primaryPersonalityType: json['primaryPersonalityType'],
      secondaryPersonalityType: json['secondaryPersonalityType'],
      personalityTraits: Map<String, String>.from(json['personalityTraits']),
      growthAreas: List<String>.from(json['growthAreas']),
      strengths: List<String>.from(json['strengths']),
      assessedAt: DateTime.parse(json['assessedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'traitScores': traitScores,
      'primaryPersonalityType': primaryPersonalityType,
      'secondaryPersonalityType': secondaryPersonalityType,
      'personalityTraits': personalityTraits,
      'growthAreas': growthAreas,
      'strengths': strengths,
      'assessedAt': assessedAt.toIso8601String(),
    };
  }

  String getPersonalityDescription() {
    switch (primaryPersonalityType) {
      case 'Introvert':
        return 'You prefer thoughtful, one-on-one conversations and need time to process your thoughts.';
      case 'Extrovert':
        return 'You thrive in social situations and enjoy energizing group interactions.';
      case 'Analytical':
        return 'You value logic and facts, preferring structured, solution-focused conversations.';
      case 'Empathetic':
        return 'You naturally connect with others\' emotions and create supportive environments.';
      case 'Assertive':
        return 'You communicate directly and confidently, taking charge in challenging situations.';
      default:
        return 'You have a balanced approach to communication with unique strengths.';
    }
  }

  List<String> getRecommendedScenarios() {
    final recommendations = <String>[];

    if (growthAreas.contains('Confidence')) {
      recommendations.addAll(['public-speaking', 'assertive-communication']);
    }
    if (growthAreas.contains('Empathy')) {
      recommendations.addAll(['emotional-support', 'conflict-resolution']);
    }
    if (growthAreas.contains('Listening')) {
      recommendations.addAll(['active-listening', 'relationship-building']);
    }

    return recommendations.isNotEmpty
        ? recommendations
        : ['general-communication'];
  }
}
