import 'package:flutter/material.dart';
import 'package:senda_chat/models/chat_message.dart';
import 'package:senda_chat/theme/app_theme.dart';

class RichMessageText extends StatelessWidget {
  const RichMessageText({
    super.key,
    required this.segments,
    this.color = AppColors.textPrimary,
  });

  final List<TextSegment> segments;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          for (final segment in segments)
            TextSpan(
              text: segment.text,
              style: TextStyle(
                color: color,
                fontSize: 15,
                height: 1.35,
                fontWeight: segment.bold ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
        ],
      ),
    );
  }
}
