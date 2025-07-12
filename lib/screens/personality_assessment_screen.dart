import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/personality_assessment.dart';
import '../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalityAssessmentScreen extends StatefulWidget {
  const PersonalityAssessmentScreen({super.key});

  @override
  State<PersonalityAssessmentScreen> createState() =>
      _PersonalityAssessmentScreenState();
}

class _PersonalityAssessmentScreenState
    extends State<PersonalityAssessmentScreen> {
  int _currentQuestionIndex = 0;
  final List<Map<String, String>> _answers = [];
  bool _isLoading = false;

  final List<PersonalityQuestion> _questions = [
    PersonalityQuestion(
      id: 'social-energy',
      question: 'How do you typically feel after social gatherings?',
      category: 'Social Energy',
      options: [
        PersonalityOption(
          id: 'energized',
          text: 'Energized and excited to connect more',
          traitScores: {'Extroversion': 80, 'Charisma': 70},
        ),
        PersonalityOption(
          id: 'tired',
          text: 'Tired but satisfied with good conversations',
          traitScores: {'Introversion': 60, 'Empathy': 70},
        ),
        PersonalityOption(
          id: 'mixed',
          text: 'It depends on the people and situation',
          traitScores: {'Analytical': 60, 'Emotional Intelligence': 70},
        ),
      ],
    ),
    PersonalityQuestion(
      id: 'conflict-style',
      question: 'When there\'s a disagreement, you usually:',
      category: 'Conflict Resolution',
      options: [
        PersonalityOption(
          id: 'direct',
          text: 'Address it directly and find a solution',
          traitScores: {'Assertiveness': 80, 'Confidence': 70},
        ),
        PersonalityOption(
          id: 'collaborative',
          text: 'Listen to all sides and find common ground',
          traitScores: {'Empathy': 80, 'Conflict Resolution': 70},
        ),
        PersonalityOption(
          id: 'avoid',
          text: 'Prefer to let things cool down first',
          traitScores: {'Emotional Intelligence': 70, 'Listening': 60},
        ),
      ],
    ),
    PersonalityQuestion(
      id: 'communication-preference',
      question: 'In conversations, you prefer to:',
      category: 'Communication Style',
      options: [
        PersonalityOption(
          id: 'lead',
          text: 'Take the lead and guide the conversation',
          traitScores: {'Charisma': 80, 'Confidence': 70},
        ),
        PersonalityOption(
          id: 'listen',
          text: 'Listen actively and ask thoughtful questions',
          traitScores: {'Listening': 80, 'Empathy': 70},
        ),
        PersonalityOption(
          id: 'balance',
          text: 'Find a natural balance between talking and listening',
          traitScores: {'Emotional Intelligence': 70, 'Analytical': 60},
        ),
      ],
    ),
    PersonalityQuestion(
      id: 'stress-response',
      question: 'When you\'re stressed or nervous, you:',
      category: 'Emotional Management',
      options: [
        PersonalityOption(
          id: 'talk',
          text: 'Talk it out with someone you trust',
          traitScores: {'Extroversion': 70, 'Emotional Intelligence': 70},
        ),
        PersonalityOption(
          id: 'reflect',
          text: 'Take time alone to process your thoughts',
          traitScores: {'Introversion': 70, 'Analytical': 70},
        ),
        PersonalityOption(
          id: 'action',
          text: 'Focus on solving the problem directly',
          traitScores: {'Assertiveness': 70, 'Confidence': 70},
        ),
      ],
    ),
    PersonalityQuestion(
      id: 'feedback-style',
      question: 'When giving feedback to others, you:',
      category: 'Communication Style',
      options: [
        PersonalityOption(
          id: 'constructive',
          text: 'Focus on specific improvements and solutions',
          traitScores: {'Analytical': 80, 'Assertiveness': 70},
        ),
        PersonalityOption(
          id: 'supportive',
          text: 'Start with positives and offer gentle suggestions',
          traitScores: {'Empathy': 80, 'Listening': 70},
        ),
        PersonalityOption(
          id: 'direct',
          text: 'Be honest and straightforward about issues',
          traitScores: {'Confidence': 80, 'Charisma': 70},
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Personality Assessment'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.primary),
                  SizedBox(height: 16),
                  Text('Analyzing your personality...'),
                ],
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Progress indicator
                  LinearProgressIndicator(
                    value: (_currentQuestionIndex + 1) / _questions.length,
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Question ${_currentQuestionIndex + 1} of ${_questions.length}',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 32),

                  // Question
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _questions[_currentQuestionIndex].question,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Options
                        Expanded(
                          child: ListView.builder(
                            itemCount: _questions[_currentQuestionIndex]
                                .options
                                .length,
                            itemBuilder: (context, index) {
                              final option = _questions[_currentQuestionIndex]
                                  .options[index];
                              return Card(
                                margin: const EdgeInsets.only(bottom: 16),
                                elevation: 2,
                                child: InkWell(
                                  onTap: () => _selectOption(option),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            option.text,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios,
                                          color: AppColors.primary,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _selectOption(PersonalityOption option) {
    _answers.add({
      'questionId': _questions[_currentQuestionIndex].id,
      'optionId': option.id,
      'answer': option.text,
    });

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      _completeAssessment();
    }
  }

  Future<void> _completeAssessment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final gameProvider = Provider.of<GameProvider>(context, listen: false);
      await gameProvider.assessPersonality(_answers);

      // Mark assessment as completed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('personality_assessment_completed', true);

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing assessment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
