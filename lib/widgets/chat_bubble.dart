import 'package:flutter/material.dart';
import '../models/conversation.dart';
import '../utils/constants.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final bool isFromUser;

  const ChatBubble({
    super.key,
    required this.message,
    required this.isFromUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isFromUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: AppSizes.paddingS,
          left: AppSizes.paddingM,
          right: AppSizes.paddingM,
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: isFromUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingM,
                vertical: AppSizes.paddingS,
              ),
              decoration: BoxDecoration(
                color: isFromUser ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppSizes.radiusM),
                border: isFromUser
                    ? null
                    : Border.all(color: AppColors.textLight.withOpacity(0.2)),
                boxShadow: isFromUser
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                message.text,
                style: AppTextStyles.body1.copyWith(
                  color: isFromUser ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: AppSizes.paddingXS,
                left: AppSizes.paddingS,
                right: AppSizes.paddingS,
              ),
              child: Text(
                _formatTime(message.timestamp),
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
