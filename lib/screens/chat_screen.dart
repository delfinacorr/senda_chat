import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senda_chat/state/chat_controller.dart';
import 'package:senda_chat/theme/app_theme.dart';
import 'package:senda_chat/utils/formatters.dart';
import 'package:senda_chat/widgets/chat_input_bar.dart';
import 'package:senda_chat/widgets/message_bubble.dart';
import 'package:senda_chat/widgets/senda_avatar.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 560;
        const phone = _PhoneFrame(
          child: _ChatBody(),
        );
        if (!wide) {
          return const Scaffold(
            body: SafeArea(bottom: false, child: _ChatBody()),
          );
        }
        return Scaffold(
          backgroundColor: const Color(0xFF070B14),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420, maxHeight: 860),
              child: phone,
            ),
          ),
        );
      },
    );
  }
}

class _PhoneFrame extends StatelessWidget {
  const _PhoneFrame({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.glassBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.45),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}

class _ChatBody extends StatelessWidget {
  const _ChatBody();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ChatController>();
    final messages = controller.messages;

    return Column(
      children: [
        const _ChatHeader(),
        Expanded(
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0B1220),
                  Color(0xFF0E1628),
                  Color(0xFF0B1220),
                ],
              ),
            ),
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.only(top: 8, bottom: 12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final older = index + 1 < messages.length
                    ? messages[index + 1]
                    : null;
                final showDay = older == null ||
                    !_sameDay(message.timestamp, older.timestamp);

                return Column(
                  children: [
                    if (showDay) _DaySeparator(date: message.timestamp),
                    MessageBubble(
                      message: message,
                      onConfirmAction: () =>
                          controller.confirmAction(message.id),
                      onCancelAction: () =>
                          controller.cancelAction(message.id),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        ChatInputBar(onSend: controller.sendUserText),
      ],
    );
  }

  bool _sameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.75),
            border: const Border(
              bottom: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
                color: AppColors.textSecondary,
                visualDensity: VisualDensity.compact,
              ),
              const SendaAvatar(size: 42),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Senda',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.verified_rounded,
                          size: 16,
                          color: AppColors.mint,
                        ),
                      ],
                    ),
                    SizedBox(height: 2),
                    Text(
                      'en línea',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.mint.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: AppColors.mint.withValues(alpha: 0.35),
                  ),
                ),
                child: const Text(
                  'Stellar Testnet',
                  style: TextStyle(
                    color: AppColors.mint,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DaySeparator extends StatelessWidget {
  const _DaySeparator({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.divider),
          ),
          child: Text(
            formatDayLabel(date),
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
