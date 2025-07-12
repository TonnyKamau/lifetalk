import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/scenario.dart';
import '../models/conversation.dart';
import '../models/personality_assessment.dart';
import '../models/achievement.dart';
import '../services/ai_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  final Uuid _uuid = Uuid();

  Scenario? _currentScenario;
  Conversation? _currentConversation;
  bool _isLoading = false;
  String? _error;
  List<Scenario> _availableScenarios = [];
  PersonalityResult? _personalityResult;
  List<Achievement> _achievements = [];
  Scenario? _dailyChallenge;
  bool _isDailyChallengeMode = false;
  final Map<String, List<Scenario>> _scenariosByCategory = {};
  final Map<String, List<Scenario>> _scenariosByCareerStage = {};

  Scenario? get currentScenario => _currentScenario;
  Conversation? get currentConversation => _currentConversation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<Scenario> get availableScenarios => _availableScenarios;
  AIService get aiService => _aiService;
  PersonalityResult? get personalityResult => _personalityResult;
  List<Achievement> get achievements => _achievements;
  Scenario? get dailyChallenge => _dailyChallenge;
  bool get isDailyChallengeMode => _isDailyChallengeMode;
  Map<String, List<Scenario>> get scenariosByCategory => _scenariosByCategory;
  Map<String, List<Scenario>> get scenariosByCareerStage =>
      _scenariosByCareerStage;

  GameProvider() {
    _loadScenarios();
    _loadAchievements();
    _loadDailyChallenge();
  }

  void _loadScenarios() {
    _availableScenarios = [
      // Basic scenarios
      Scenario(
        id: 'roommate-dishes',
        title: 'Roommate Won\'t Do the Dishes',
        description:
            'Your roommate keeps leaving dirty dishes in the sink. How do you address this respectfully?',
        category: 'Conflict Resolution',
        difficulty: 'Easy',
        characterName: 'Alex',
        characterAvatar: '👤',
        initialMessage:
            'Hey, can we talk about the mess in the kitchen? I\'ve noticed the dishes have been piling up lately.',
        skillRewards: {
          'Conflict Resolution': 50,
          'Empathy': 30,
          'Confidence': 20,
        },
        tags: ['roommate', 'dishes', 'conflict'],
        careerStage: 'High School',
        learningObjectives: [
          'Practice assertive communication',
          'Handle roommate conflicts',
        ],
        characterTraits: {
          'Communication Style': 'Direct but respectful',
          'Conflict Style': 'Problem-solver',
        },
      ),
      Scenario(
        id: 'first-date',
        title: 'Awkward First Date',
        description:
            'You\'re on a first date with someone who seems shy. Keep the conversation engaging and respectful.',
        category: 'Romantic Relationships',
        difficulty: 'Medium',
        characterName: 'Sasha',
        characterAvatar: '💕',
        initialMessage:
            'Hi! I\'m so glad we finally got to meet. I was a bit nervous about this, but you seem really nice.',
        skillRewards: {'Charisma': 50, 'Empathy': 40, 'Listening': 30},
        tags: ['dating', 'first-date', 'romance'],
        careerStage: 'University',
        learningObjectives: [
          'Build rapport',
          'Active listening',
          'Engaging conversation',
        ],
        characterTraits: {
          'Communication Style': 'Warm and curious',
          'Personality': 'Shy but interested',
        },
      ),
      Scenario(
        id: 'work-conflict',
        title: 'Workplace Disagreement',
        description:
            'A colleague disagrees with your approach on a project. Handle this professionally.',
        category: 'Workplace Situations',
        difficulty: 'Hard',
        characterName: 'Jordan',
        characterAvatar: '💼',
        initialMessage:
            'I understand your perspective, but I think we should consider a different approach to this project.',
        skillRewards: {
          'Conflict Resolution': 60,
          'Confidence': 40,
          'Charisma': 30,
        },
        tags: ['work', 'conflict', 'professional'],
        careerStage: 'Work',
        learningObjectives: [
          'Professional conflict resolution',
          'Assertive communication',
        ],
        characterTraits: {
          'Communication Style': 'Professional and analytical',
          'Conflict Style': 'Direct challenger',
        },
      ),
      // Career mode scenarios
      Scenario(
        id: 'high-school-presentation',
        title: 'Class Presentation',
        description:
            'You have to give a presentation in front of your class. Build confidence and engage your audience.',
        category: 'Public Speaking',
        difficulty: 'Medium',
        characterName: 'Class',
        characterAvatar: '🎓',
        initialMessage:
            'Alright, let\'s hear your presentation. We\'re all listening!',
        skillRewards: {'Public Speaking': 60, 'Confidence': 50, 'Charisma': 40},
        tags: ['presentation', 'public-speaking', 'confidence'],
        careerStage: 'High School',
        learningObjectives: [
          'Public speaking skills',
          'Audience engagement',
          'Confidence building',
        ],
        characterTraits: {
          'Communication Style': 'Supportive audience',
          'Energy': 'Attentive and encouraging',
        },
      ),
      Scenario(
        id: 'university-group-project',
        title: 'Group Project Conflict',
        description:
            'Your group members aren\'t pulling their weight. Address this diplomatically.',
        category: 'Leadership',
        difficulty: 'Hard',
        characterName: 'Team Members',
        characterAvatar: '👥',
        initialMessage:
            'We\'re falling behind on our project. What\'s the plan?',
        skillRewards: {
          'Leadership': 60,
          'Conflict Resolution': 50,
          'Assertiveness': 40,
        },
        tags: ['leadership', 'teamwork', 'conflict'],
        careerStage: 'University',
        learningObjectives: [
          'Team leadership',
          'Conflict resolution',
          'Motivating others',
        ],
        characterTraits: {
          'Communication Style': 'Group dynamics',
          'Conflict Style': 'Avoidant team members',
        },
      ),
      Scenario(
        id: 'job-interview',
        title: 'Job Interview',
        description:
            'You\'re in a job interview. Show confidence and answer questions effectively.',
        category: 'Workplace Situations',
        difficulty: 'Hard',
        characterName: 'Interviewer',
        characterAvatar: '💼',
        initialMessage:
            'Tell me about yourself and why you\'re interested in this position.',
        skillRewards: {'Confidence': 60, 'Charisma': 50, 'Public Speaking': 40},
        tags: ['interview', 'career', 'confidence'],
        careerStage: 'Work',
        learningObjectives: [
          'Interview skills',
          'Self-presentation',
          'Confidence',
        ],
        characterTraits: {
          'Communication Style': 'Professional interviewer',
          'Personality': 'Assessing candidate',
        },
      ),
    ];

    // Organize scenarios by category and career stage
    _organizeScenarios();
    notifyListeners();
  }

  void _organizeScenarios() {
    _scenariosByCategory.clear();
    _scenariosByCareerStage.clear();

    for (final scenario in _availableScenarios) {
      // By category
      if (!_scenariosByCategory.containsKey(scenario.category)) {
        _scenariosByCategory[scenario.category] = [];
      }
      _scenariosByCategory[scenario.category]!.add(scenario);

      // By career stage
      if (scenario.careerStage != null) {
        if (!_scenariosByCareerStage.containsKey(scenario.careerStage)) {
          _scenariosByCareerStage[scenario.careerStage!] = [];
        }
        _scenariosByCareerStage[scenario.careerStage!]!.add(scenario);
      }
    }
  }

  void _loadAchievements() {
    _achievements = [
      Achievement(
        id: 'first-conversation',
        title: 'First Steps',
        description: 'Complete your first conversation',
        icon: '🎯',
        category: 'Milestones',
        requiredValue: 1,
        rewardType: 'coins',
        rewardValue: 50,
      ),
      Achievement(
        id: 'empathy-master',
        title: 'Golden Listener',
        description: 'Score 5/5 on Empathy in 10 conversations',
        icon: '👂',
        category: 'Skills',
        requiredValue: 10,
        rewardType: 'badge',
        rewardValue: 100,
      ),
      Achievement(
        id: 'confidence-builder',
        title: 'Smooth Talker',
        description: 'Score 5/5 on Confidence in 5 conversations',
        icon: '💪',
        category: 'Skills',
        requiredValue: 5,
        rewardType: 'badge',
        rewardValue: 100,
      ),
      Achievement(
        id: 'streak-master',
        title: 'Dedicated Learner',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
        category: 'Consistency',
        requiredValue: 7,
        rewardType: 'coins',
        rewardValue: 200,
      ),
      Achievement(
        id: 'career-progressor',
        title: 'Life Journey',
        description: 'Complete scenarios from all career stages',
        icon: '🚀',
        category: 'Progress',
        requiredValue: 5,
        rewardType: 'title',
        rewardValue: 500,
      ),
    ];
  }

  void _loadDailyChallenge() {
    // Simple daily challenge selection - in production, this would be more sophisticated
    final today = DateTime.now().day;
    final challengeIndex = today % _availableScenarios.length;
    _dailyChallenge = _availableScenarios[challengeIndex];
  }

  // Save the current conversation and scenario to SharedPreferences
  Future<void> _saveLastConversation() async {
    if (_currentConversation == null || _currentScenario == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'last_conversation',
      jsonEncode(_currentConversation!.toJson()),
    );
    await prefs.setString('last_scenario_id', _currentScenario!.id);
  }

  // Load the last conversation and scenario from SharedPreferences
  Future<bool> loadLastConversation(List<Scenario> scenarios) async {
    final prefs = await SharedPreferences.getInstance();
    final convoJson = prefs.getString('last_conversation');
    final scenarioId = prefs.getString('last_scenario_id');
    if (convoJson != null && scenarioId != null) {
      try {
        final scenario = scenarios.firstWhere((s) => s.id == scenarioId);
        final conversation = Conversation.fromJson(jsonDecode(convoJson));
        _currentScenario = scenario;
        _currentConversation = conversation;
        notifyListeners();
        return true;
      } catch (e) {
        // If scenario not found or JSON error, clear saved state
        await clearLastConversation();
      }
    }
    return false;
  }

  // Clear the saved conversation
  Future<void> clearLastConversation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('last_conversation');
    await prefs.remove('last_scenario_id');
  }

  Future<void> startScenario(
    String scenarioId, {
    bool isDailyChallenge = false,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      _isDailyChallengeMode = isDailyChallenge;
      notifyListeners();

      final scenario = _availableScenarios.firstWhere(
        (s) => s.id == scenarioId,
        orElse: () => throw Exception('Scenario not found'),
      );

      _currentScenario = scenario;

      // Create new conversation
      _currentConversation = Conversation(
        id: _uuid.v4(),
        scenarioId: scenarioId,
        messages: [
          Message(
            id: _uuid.v4(),
            text: scenario.initialMessage,
            isFromUser: false,
            timestamp: DateTime.now(),
          ),
        ],
        startedAt: DateTime.now(),
        totalSkillScores: {
          'Empathy': 0,
          'Listening': 0,
          'Confidence': 0,
          'Charisma': 0,
          'Conflict Resolution': 0,
          'Assertiveness': 0,
          'Emotional Intelligence': 0,
          'Public Speaking': 0,
        },
      );
      await _saveLastConversation();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(String text) async {
    if (_currentConversation == null || _currentScenario == null) return;

    try {
      _isLoading = true;
      notifyListeners();

      // Add user message
      final userMessage = Message(
        id: _uuid.v4(),
        text: text,
        isFromUser: true,
        timestamp: DateTime.now(),
      );

      final updatedMessages = [..._currentConversation!.messages, userMessage];

      _currentConversation = _currentConversation!.copyWith(
        messages: updatedMessages,
      );

      // Get AI response with personality adaptation and timeout
      final aiResponse = await _aiService
          .getResponse(
            scenario: _currentScenario!,
            conversation: _currentConversation!,
            userMessage: text,
            personalityResult: _personalityResult,
          )
          .timeout(
            const Duration(seconds: 20),
            onTimeout: () {
              throw Exception('AI response timed out. Please try again.');
            },
          );

      // Add AI message
      final aiMessage = Message(
        id: _uuid.v4(),
        text: aiResponse.response,
        isFromUser: false,
        timestamp: DateTime.now(),
        skillScores: aiResponse.skillScores,
        feedback: aiResponse.feedback,
      );

      final finalMessages = [...updatedMessages, aiMessage];

      _currentConversation = _currentConversation!.copyWith(
        messages: finalMessages,
      );
      await _saveLastConversation();
    } catch (e) {
      _error = e.toString();
      print('Error in sendMessage: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> assessPersonality(List<Map<String, String>> answers) async {
    try {
      _isLoading = true;
      notifyListeners();

      _personalityResult = await _aiService.assessPersonality(
        userId: 'current_user', // In production, get from auth
        answers: answers,
      );
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Scenario> getScenariosForCategory(String category) {
    return _scenariosByCategory[category] ?? [];
  }

  List<Scenario> getScenariosForCareerStage(String stage) {
    return _scenariosByCareerStage[stage] ?? [];
  }

  List<Scenario> getRecommendedScenarios() {
    if (_personalityResult == null) {
      return _availableScenarios.take(5).toList();
    }

    final recommendations = _personalityResult!.getRecommendedScenarios();
    return _availableScenarios
        .where((s) => recommendations.contains(s.id))
        .toList();
  }

  void endConversation() {
    if (_currentConversation != null) {
      _currentConversation = _currentConversation!.copyWith(
        completedAt: DateTime.now(),
        isCompleted: true,
      );
    }
    clearLastConversation();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void resetGame() {
    _currentScenario = null;
    _currentConversation = null;
    _error = null;
    _isDailyChallengeMode = false;
    notifyListeners();
  }

  void setPersonalityResult(PersonalityResult result) {
    _personalityResult = result;
    notifyListeners();
  }
}
