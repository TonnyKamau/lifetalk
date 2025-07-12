import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/conversation.dart';
import '../utils/constants.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/feedback_card.dart';
import 'dart:async';

class EnhancedConversationScreen extends StatefulWidget {
  final String scenarioId;
  final bool isDailyChallenge;

  const EnhancedConversationScreen({
    super.key,
    required this.scenarioId,
    this.isDailyChallenge = false,
  });

  @override
  State<EnhancedConversationScreen> createState() =>
      _EnhancedConversationScreenState();
}

class _EnhancedConversationScreenState
    extends State<EnhancedConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFeedback = false;
  Message? _lastUserMessage;
  Map<String, int>? _lastSkillScores;
  Timer? _feedbackTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startScenario();
    });
  }

  Future<void> _startScenario() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.startScenario(
      widget.scenarioId,
      isDailyChallenge: widget.isDailyChallenge,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Consumer<GameProvider>(
          builder: (context, gameProvider, child) {
            final scenario = gameProvider.currentScenario;
            return Text(scenario?.title ?? 'Conversation');
          },
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (widget.isDailyChallenge)
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Daily Challenge',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (gameProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${gameProvider.error}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _startScenario(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final conversation = gameProvider.currentConversation;
          final scenario = gameProvider.currentScenario;

          if (conversation == null || scenario == null) {
            return const Center(child: Text('No conversation available'));
          }

          return Column(
            children: [
              // Scenario info card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          scenario.characterAvatar,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                scenario.characterName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                scenario.category,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getDifficultyColor(scenario.difficulty),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            scenario.difficulty,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      scenario.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              // Feedback card (if showing)
              if (_showFeedback &&
                  _lastUserMessage != null &&
                  _lastSkillScores != null)
                Stack(
                  children: [
                    FeedbackCard(
                      skillScores: _lastSkillScores!,
                      feedback:
                          _lastUserMessage!.feedback ?? 'Great communication!',
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.grey),
                        onPressed: _dismissFeedback,
                        tooltip: 'Dismiss',
                      ),
                    ),
                  ],
                ),

              // Messages
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: conversation.messages.length,
                        itemBuilder: (context, index) {
                          final message = conversation.messages[index];
                          return ChatBubble(
                            message: message,
                            isFromUser: message.isFromUser,
                          );
                        },
                      ),
                    ),
                    // Typing indicator
                    if (gameProvider.isLoading &&
                        conversation.messages.isNotEmpty &&
                        conversation.messages.last.isFromUser)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            const CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 12),
                            const Text('AI is typing...'),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Input area
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: _sendMessage,
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      mini: true,
                      child: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Consumer<GameProvider>(
        builder: (context, gameProvider, child) {
          if (gameProvider.currentConversation?.messages.length == 1) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () => _askCoach(),
            backgroundColor: AppColors.secondary,
            foregroundColor: Colors.white,
            icon: const Icon(Icons.psychology),
            label: const Text('Ask Coach'),
          );
        },
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showMessageFeedback(Message message) {
    setState(() {
      _lastUserMessage = message;
      _lastSkillScores = message.skillScores;
      _showFeedback = true;
    });
    _feedbackTimer?.cancel();
    _feedbackTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showFeedback = false;
        });
      }
    });
  }

  void _dismissFeedback() {
    _feedbackTimer?.cancel();
    setState(() {
      _showFeedback = false;
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    await gameProvider.sendMessage(text);

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _askCoach() async {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final conversation = gameProvider.currentConversation;
    final scenario = gameProvider.currentScenario;

    if (conversation == null || scenario == null) return;

    // Show dialog to ask coach
    final question = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask LifeTalk Coach'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('What would you like to ask the coach?'),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                hintText: 'e.g., How can I improve my response?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              // Get the question from the text field
              Navigator.pop(context, 'How can I improve my communication?');
            },
            child: const Text('Ask'),
          ),
        ],
      ),
    );

    if (question != null && question.isNotEmpty) {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final response = await gameProvider.aiService.askCoach(
          scenario: scenario,
          conversation: conversation,
          userQuestion: question,
          personalityResult: gameProvider.personalityResult,
        );

        Navigator.pop(context); // Remove loading

        // Show coach response
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('LifeTalk Coach'),
            content: SingleChildScrollView(child: Text(response)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      } catch (e) {
        Navigator.pop(context); // Remove loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _feedbackTimer?.cancel();
    super.dispose();
  }
}
