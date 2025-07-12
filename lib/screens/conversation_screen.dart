import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/constants.dart';
import '../models/scenario.dart';
import '../models/conversation.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/feedback_card.dart';
import 'dart:async';

class ConversationScreen extends StatefulWidget {
  final Scenario scenario;

  const ConversationScreen({super.key, required this.scenario});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showFeedback = false;
  Message? _lastUserMessage;
  Timer? _feedbackTimer;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(widget.scenario.characterAvatar),
            const SizedBox(width: AppSizes.paddingS),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.scenario.characterName,
                    style: const TextStyle(fontSize: 16),
                  ),
                  Text(
                    widget.scenario.title,
                    style: const TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => _showEndDialog(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<GameProvider>(
              builder: (context, gameProvider, child) {
                final conversation = gameProvider.currentConversation;

                if (conversation == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(AppSizes.paddingM),
                  itemCount:
                      conversation.messages.length + (_showFeedback ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == conversation.messages.length &&
                        _showFeedback) {
                      return _buildFeedbackCard();
                    }

                    final message = conversation.messages[index];
                    return ChatBubble(
                      message: message,
                      isFromUser: message.isFromUser,
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildFeedbackCard() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        final conversation = gameProvider.currentConversation;
        if (conversation == null || conversation.messages.isEmpty) {
          return const SizedBox.shrink();
        }

        final lastMessage = conversation.messages.last;
        if (lastMessage.skillScores == null) {
          return const SizedBox.shrink();
        }

        return FeedbackCard(
          skillScores: lastMessage.skillScores!,
          feedback: lastMessage.feedback ?? 'Good response!',
          onDismiss: () {
            _feedbackTimer?.cancel();
            setState(() {
              _showFeedback = false;
            });
          },
        );
      },
    );
  }

  Widget _buildMessageInput() {
    return Consumer<GameProvider>(
      builder: (context, gameProvider, child) {
        return Container(
          padding: const EdgeInsets.all(AppSizes.paddingM),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              top: BorderSide(color: AppColors.textLight.withOpacity(0.2)),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Type your message...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppSizes.radiusL),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.paddingM,
                      vertical: AppSizes.paddingS,
                    ),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: AppSizes.paddingS),
              Consumer<GameProvider>(
                builder: (context, gameProvider, child) {
                  return IconButton(
                    onPressed: gameProvider.isLoading ? null : _sendMessage,
                    icon: gameProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(AppSizes.paddingM),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    gameProvider.sendMessage(message).then((_) {
      _messageController.clear();
      _scrollToBottom();
      _feedbackTimer?.cancel();
      setState(() {
        _showFeedback = true;
      });
      _feedbackTimer = Timer(const Duration(seconds: 10), () {
        if (mounted) {
          setState(() {
            _showFeedback = false;
          });
        }
      });
    });
  }

  void _scrollToBottom() {
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

  void _showEndDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Conversation'),
        content: const Text('Are you sure you want to end this conversation?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _endConversation();
            },
            child: const Text('End'),
          ),
        ],
      ),
    );
  }

  void _endConversation() {
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(
      context,
      listen: false,
    );

    gameProvider.endConversation();

    // Save conversation and update progress
    if (gameProvider.currentConversation != null) {
      progressProvider.saveConversation(gameProvider.currentConversation!);

      // Calculate total skill scores
      final totalScores = <String, int>{};
      for (final message in gameProvider.currentConversation!.messages) {
        if (message.skillScores != null) {
          for (final entry in message.skillScores!.entries) {
            totalScores[entry.key] =
                (totalScores[entry.key] ?? 0) + entry.value;
          }
        }
      }

      progressProvider.completeScenario(widget.scenario.id, totalScores);
    }

    // Show AI Coach Mode dialog after scenario ends
    Future.delayed(const Duration(milliseconds: 300), () {
      _showCoachDialog(context);
    });
  }

  void _showCoachDialog(BuildContext context) {
    final aiService = Provider.of<GameProvider>(
      context,
      listen: false,
    ).aiService;
    final gameProvider = Provider.of<GameProvider>(context, listen: false);
    final conversation = gameProvider.currentConversation;
    final scenario = widget.scenario;
    final TextEditingController questionController = TextEditingController();
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        String? aiResponse;
        bool isLoading = false;
        return StatefulBuilder(
          builder: (context, setState) {
            // Add a listener to update the button state as the user types
            void textListener() => setState(() {});
            questionController.removeListener(textListener); // avoid duplicates
            questionController.addListener(textListener);

            // Clean up listener when dialog is closed
            void cleanup() => questionController.removeListener(textListener);

            return WillPopScope(
              onWillPop: () async {
                cleanup();
                return true;
              },
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSizes.radiusL),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                    maxWidth: MediaQuery.of(context).size.width * 0.9,
                  ),
                  padding: const EdgeInsets.all(AppSizes.paddingL),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.psychology,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          Expanded(
                            child: Text(
                              'Ask the LifeTalk Mentor',
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              cleanup();
                              Navigator.pop(context);
                            },
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: questionController,
                                decoration: InputDecoration(
                                  hintText:
                                      'E.g. What could I have done better?',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusM,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.background,
                                ),
                                maxLines: 3,
                              ),
                              const SizedBox(height: AppSizes.paddingM),
                              if (isLoading)
                                const Center(
                                  child: Column(
                                    children: [
                                      CircularProgressIndicator(),
                                      SizedBox(height: AppSizes.paddingS),
                                      Text('Mentor is thinking...'),
                                    ],
                                  ),
                                )
                              else if (aiResponse != null)
                                Container(
                                  padding: const EdgeInsets.all(
                                    AppSizes.paddingM,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(
                                      AppSizes.radiusM,
                                    ),
                                    border: Border.all(
                                      color: AppColors.success.withOpacity(0.3),
                                    ),
                                  ),
                                  child: Text(
                                    aiResponse!,
                                    style: AppTextStyles.body2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSizes.paddingM),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              cleanup();
                              Navigator.pop(context);
                            },
                            child: const Text('Close'),
                          ),
                          const SizedBox(width: AppSizes.paddingS),
                          ElevatedButton(
                            onPressed:
                                isLoading ||
                                    questionController.text.trim().isEmpty
                                ? null
                                : () async {
                                    setState(() => isLoading = true);
                                    try {
                                      final response = await aiService.askCoach(
                                        scenario: scenario,
                                        conversation: conversation!,
                                        userQuestion: questionController.text
                                            .trim(),
                                      );
                                      setState(() {
                                        aiResponse = response;
                                        isLoading = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        aiResponse =
                                            'Sorry, I encountered an error. Please try again.';
                                        isLoading = false;
                                      });
                                    }
                                  },
                            child: const Text('Ask Mentor'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
