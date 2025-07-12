import '../models/scenario.dart';
import '../models/conversation.dart';
import '../models/personality_assessment.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AIResponse {
  final String response;
  final Map<String, int> skillScores;
  final String feedback;
  final String? coachingTip;
  final Map<String, double> detailedScores;
  final String? suggestedImprovement;

  AIResponse({
    required this.response,
    required this.skillScores,
    required this.feedback,
    this.coachingTip,
    this.detailedScores = const {},
    this.suggestedImprovement,
  });
}

class AIService {
  late final GenerativeModel _model;

  AIService() {
    final apiKey = dotenv.env['GEMINI_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_KEY not found in .env');
    }
    _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
  }

  Future<AIResponse> getResponse({
    required Scenario scenario,
    required Conversation conversation,
    required String userMessage,
    PersonalityResult? personalityResult,
  }) async {
    final prompt = _buildPrompt(
      scenario,
      conversation,
      userMessage,
      personalityResult,
    );
    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    final aiText =
        response.text?.trim() ?? "I'm not sure how to respond to that.";

    final skillScores = await _analyzeUserMessage(
      userMessage,
      scenario,
      personalityResult,
    );
    final feedback = await _generateFeedback(
      userMessage,
      skillScores,
      scenario,
    );
    final coachingTip = await _generateCoachingTip(skillScores, scenario);
    final suggestedImprovement = await _suggestImprovement(
      userMessage,
      skillScores,
      scenario,
    );

    return AIResponse(
      response: aiText,
      skillScores: skillScores,
      feedback: feedback,
      coachingTip: coachingTip,
      suggestedImprovement: suggestedImprovement,
    );
  }

  Future<String> askCoach({
    required Scenario scenario,
    required Conversation conversation,
    required String userQuestion,
    PersonalityResult? personalityResult,
  }) async {
    final lastUserMsg = conversation.messages.lastWhere(
      (m) => m.isFromUser,
      orElse: () => Message(
        id: 'none',
        text: '',
        isFromUser: true,
        timestamp: DateTime.now(),
      ),
    );

    final prompt =
        '''
You are LifeTalk Mentor, a social skills coach with expertise in psychology and communication.

Scenario: ${scenario.title}
Description: ${scenario.description}
User's last message: "${lastUserMsg.text}"
User's question: "$userQuestion"
${personalityResult != null ? 'User\'s personality: ${personalityResult.primaryPersonalityType}' : ''}

Provide:
1. Psychology-backed analysis of their communication
2. Specific, actionable improvement suggestions
3. Alternative phrases they could use
4. A brief role-play exercise to practice
5. Encouragement that builds confidence

Keep your response under 200 words, warm and supportive.
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text?.trim() ??
        "I'm here to help! Try asking your question again.";
  }

  Future<PersonalityResult> assessPersonality({
    required String userId,
    required List<Map<String, String>> answers,
  }) async {
    final prompt =
        '''
Analyze these personality assessment answers and provide a detailed personality profile:

Answers: $answers

Provide a JSON response with:
{
  "traitScores": {"Introversion": 0-100, "Extroversion": 0-100, "Analytical": 0-100, "Empathetic": 0-100, "Assertive": 0-100},
  "primaryPersonalityType": "one of the traits",
  "secondaryPersonalityType": "second strongest trait",
  "personalityTraits": {"Communication Style": "description", "Conflict Style": "description", "Growth Areas": "description"},
  "growthAreas": ["list of areas to improve"],
  "strengths": ["list of communication strengths"]
}
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    final responseText = response.text?.trim() ?? '{}';

    // Parse the JSON response and create PersonalityResult
    // This is a simplified version - in production you'd want proper JSON parsing
    return PersonalityResult(
      userId: userId,
      traitScores: {
        'Introversion': 50,
        'Extroversion': 50,
        'Analytical': 60,
        'Empathetic': 70,
        'Assertive': 40,
      },
      primaryPersonalityType: 'Empathetic',
      secondaryPersonalityType: 'Analytical',
      personalityTraits: {
        'Communication Style': 'Supportive and understanding',
        'Conflict Style': 'Collaborative problem-solver',
        'Growth Areas': 'Building confidence in assertive situations',
      },
      growthAreas: ['Confidence', 'Public Speaking'],
      strengths: ['Active Listening', 'Empathy', 'Conflict Resolution'],
      assessedAt: DateTime.now(),
    );
  }

  String _buildPrompt(
    Scenario scenario,
    Conversation conversation,
    String userMessage,
    PersonalityResult? personalityResult,
  ) {
    final history = conversation.messages
        .map((m) => (m.isFromUser ? 'User: ' : 'AI: ') + m.text)
        .join('\n');

    final personalityContext = personalityResult != null
        ? '''
User's Personality: ${personalityResult.primaryPersonalityType}
Communication Style: ${personalityResult.personalityTraits['Communication Style'] ?? 'Balanced'}
Growth Areas: ${personalityResult.growthAreas.join(', ')}
'''
        : '';

    return '''
You are roleplaying as "${scenario.characterName}" in the following scenario:
Title: ${scenario.title}
Description: ${scenario.description}
Category: ${scenario.category}
Difficulty: ${scenario.difficulty}
Character Personality: ${scenario.characterTraits.isNotEmpty ? scenario.characterTraits.toString() : 'Friendly, supportive, and engaging'}

$personalityContext

Conversation so far:
$history
User: $userMessage

AI: (Respond naturally as the character. Keep the conversation flowing, ask open-ended questions, and encourage the user to continue. Never end the chat abruptly. Your goal is to help the user practice social skills and keep the dialogue going.)
''';
  }

  Future<Map<String, int>> _analyzeUserMessage(
    String message,
    Scenario scenario,
    PersonalityResult? personalityResult,
  ) async {
    final prompt =
        '''
Analyze this user message for social communication skills:

Message: "$message"
Scenario: ${scenario.title}
Category: ${scenario.category}
${personalityResult != null ? 'User\'s growth areas: ${personalityResult.growthAreas.join(', ')}' : ''}

Rate each skill from 1-5 (1=poor, 5=excellent):
- Empathy: How well they understand and respond to emotions
- Listening: How well they acknowledge and build on the conversation
- Confidence: How assertive and self-assured they appear
- Charisma: How engaging and likable their communication is
- Conflict Resolution: How well they handle disagreements
- Assertiveness: How clearly they express their needs
- Emotional Intelligence: How well they manage emotions

Respond with only a JSON object like: {"Empathy": 3, "Listening": 4, ...}
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    final responseText = response.text?.trim() ?? '{}';

    // Parse JSON response - simplified for now
    return {
      'Empathy': _calculateEmpathyScore(message),
      'Listening': _calculateListeningScore(message),
      'Confidence': _calculateConfidenceScore(message),
      'Charisma': _calculateCharismaScore(message),
      'Conflict Resolution': _calculateConflictScore(message),
      'Assertiveness': _calculateAssertivenessScore(message),
      'Emotional Intelligence': _calculateEmotionalIntelligenceScore(message),
    };
  }

  Future<String> _generateFeedback(
    String message,
    Map<String, int> scores,
    Scenario scenario,
  ) async {
    final prompt =
        '''
Generate constructive feedback for this user message:

Message: "$message"
Scores: $scores
Scenario: ${scenario.title}

Provide:
1. One specific positive observation
2. One specific area for improvement
3. One actionable suggestion

Keep it encouraging and under 100 words.
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text?.trim() ??
        'Great effort! Keep practicing to improve your skills.';
  }

  Future<String?> _generateCoachingTip(
    Map<String, int> scores,
    Scenario scenario,
  ) async {
    final lowestScore = scores.entries.reduce(
      (a, b) => a.value < b.value ? a : b,
    );

    final prompt =
        '''
Provide a quick coaching tip for improving ${lowestScore.key} in ${scenario.category} scenarios.

Current score: ${lowestScore.value}/5
Scenario: ${scenario.title}

Give one specific, actionable tip under 50 words.
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text?.trim();
  }

  Future<String?> _suggestImprovement(
    String message,
    Map<String, int> scores,
    Scenario scenario,
  ) async {
    final prompt =
        '''
Suggest an improved version of this user message:

Original: "$message"
Scores: $scores
Scenario: ${scenario.title}

Provide a better version that would score higher, keeping the same intent but improving the communication.
''';

    final content = [Content.text(prompt)];
    final response = await _model.generateContent(content);
    return response.text?.trim();
  }

  // Enhanced scoring methods
  int _calculateEmpathyScore(String message) {
    final empatheticWords = [
      'understand',
      'feel',
      'sorry',
      'apologize',
      'care',
      'concern',
      'must be',
      'sounds like',
      'I imagine',
      'that must be',
    ];
    int score = 2;

    for (final word in empatheticWords) {
      if (message.toLowerCase().contains(word)) {
        score += 1;
      }
    }

    return score.clamp(1, 5);
  }

  int _calculateConflictScore(String message) {
    final conflictWords = [
      'compromise',
      'solution',
      'together',
      'work',
      'resolve',
      'let\'s',
      'we can',
      'find a way',
      'meet in the middle',
    ];
    int score = 2;

    for (final word in conflictWords) {
      if (message.toLowerCase().contains(word)) {
        score += 1;
      }
    }

    return score.clamp(1, 5);
  }

  int _calculateConfidenceScore(String message) {
    final confidentWords = [
      'think',
      'believe',
      'suggest',
      'propose',
      'recommend',
      'I can',
      'I will',
      'definitely',
      'certainly',
    ];
    int score = 2;

    for (final word in confidentWords) {
      if (message.toLowerCase().contains(word)) {
        score += 1;
      }
    }

    return score.clamp(1, 5);
  }

  int _calculateCharismaScore(String message) {
    final charismaticWords = [
      'great',
      'amazing',
      'wonderful',
      'excellent',
      'fantastic',
      'love',
      'excited',
      'thrilled',
      'brilliant',
    ];
    int score = 2;

    for (final word in charismaticWords) {
      if (message.toLowerCase().contains(word)) {
        score += 1;
      }
    }

    return score.clamp(1, 5);
  }

  int _calculateListeningScore(String message) {
    final listeningWords = ['you', 'your', 'what', 'how', 'why', 'tell me'];
    int score = 2;

    for (final word in listeningWords) {
      if (message.toLowerCase().contains(word)) {
        score += 1;
      }
    }

    return score.clamp(1, 5);
  }

  int _calculateAssertivenessScore(String message) {
    final assertiveWords = [
      'I need',
      'I want',
      'I prefer',
      'I think',
      'I believe',
      'clearly',
      'directly',
      'honestly',
      'frankly',
    ];
    int score = 2;

    for (final word in assertiveWords) {
      if (message.toLowerCase().contains(word)) {
        score += 1;
      }
    }

    return score.clamp(1, 5);
  }

  int _calculateEmotionalIntelligenceScore(String message) {
    final eiWords = [
      'emotion',
      'feeling',
      'mood',
      'upset',
      'happy',
      'sad',
      'frustrated',
      'excited',
      'worried',
      'relieved',
    ];
    int score = 2;

    for (final word in eiWords) {
      if (message.toLowerCase().contains(word)) {
        score += 1;
      }
    }

    return score.clamp(1, 5);
  }
}
