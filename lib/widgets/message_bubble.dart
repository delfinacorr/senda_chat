import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:senda_chat/models/chat_message.dart';
import 'package:senda_chat/theme/app_theme.dart';
import 'package:senda_chat/utils/formatters.dart';
import 'package:senda_chat/widgets/action_card.dart';
import 'package:senda_chat/widgets/amount_card.dart';
import 'package:senda_chat/widgets/rich_message_text.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    super.key,
    required this.message,
    required this.onConfirmAction,
    required this.onCancelAction,
  });

  final ChatMessage message;
  final VoidCallback onConfirmAction;
  final VoidCallback onCancelAction;

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final maxWidth = constraints.maxWidth * 0.82;
          final radius = BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          );

          return Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: ClipRRect(
                borderRadius: radius,
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: isUser ? 0 : 6,
                    sigmaY: isUser ? 0 : 6,
                  ),
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppColors.userBubble
                          : AppColors.botBubble.withValues(alpha: 0.88),
                      borderRadius: radius,
                      border: Border.all(
                        color: isUser
                            ? AppColors.mint.withValues(alpha: 0.18)
                            : AppColors.glassBorder,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (message.segments.isNotEmpty)
                          RichMessageText(segments: message.segments),
                        if (message.hasAmountCard) ...[
                          if (message.segments.isNotEmpty)
                            const SizedBox(height: 10),
                          AmountCard(
                            amountUsdc: message.amountUsdc!,
                            label: message.amountLabel ?? 'Monto',
                          ),
                        ],
                        if (message.hasActionCard) ...[
                          if (message.segments.isNotEmpty ||
                              message.hasAmountCard)
                            const SizedBox(height: 10),
                          ActionCard(
                            data: message.action!,
                            onConfirm: onConfirmAction,
                            onCancel: onCancelAction,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            formatClock(message.timestamp),
                            style: TextStyle(
                              color: AppColors.textSecondary
                                  .withValues(alpha: 0.9),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
