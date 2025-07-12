class Message {
  final String id;
  final String text;
  final bool isFromUser;
  final DateTime timestamp;
  final Map<String, int>? skillScores;
  final String? feedback;

  Message({
    required this.id,
    required this.text,
    required this.isFromUser,
    required this.timestamp,
    this.skillScores,
    this.feedback,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      text: json['text'],
      isFromUser: json['isFromUser'],
      timestamp: DateTime.parse(json['timestamp']),
      skillScores: json['skillScores'] != null
          ? Map<String, int>.from(json['skillScores'])
          : null,
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isFromUser': isFromUser,
      'timestamp': timestamp.toIso8601String(),
      'skillScores': skillScores,
      'feedback': feedback,
    };
  }
}

class Conversation {
  final String id;
  final String scenarioId;
  final List<Message> messages;
  final DateTime startedAt;
  final DateTime? completedAt;
  final Map<String, int> totalSkillScores;
  final bool isCompleted;

  Conversation({
    required this.id,
    required this.scenarioId,
    required this.messages,
    required this.startedAt,
    this.completedAt,
    required this.totalSkillScores,
    this.isCompleted = false,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'],
      scenarioId: json['scenarioId'],
      messages: (json['messages'] as List)
          .map((msg) => Message.fromJson(msg))
          .toList(),
      startedAt: DateTime.parse(json['startedAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      totalSkillScores: Map<String, int>.from(json['totalSkillScores']),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'scenarioId': scenarioId,
      'messages': messages.map((msg) => msg.toJson()).toList(),
      'startedAt': startedAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'totalSkillScores': totalSkillScores,
      'isCompleted': isCompleted,
    };
  }

  Conversation copyWith({
    String? id,
    String? scenarioId,
    List<Message>? messages,
    DateTime? startedAt,
    DateTime? completedAt,
    Map<String, int>? totalSkillScores,
    bool? isCompleted,
  }) {
    return Conversation(
      id: id ?? this.id,
      scenarioId: scenarioId ?? this.scenarioId,
      messages: messages ?? this.messages,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      totalSkillScores: totalSkillScores ?? this.totalSkillScores,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
