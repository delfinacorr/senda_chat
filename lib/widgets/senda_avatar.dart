import 'package:flutter/material.dart';
import 'package:senda_chat/theme/app_theme.dart';

class SendaAvatar extends StatelessWidget {
  const SendaAvatar({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF134E4A),
            Color(0xFF0F766E),
            AppColors.mintSoft,
          ],
        ),
        border: Border.all(color: AppColors.mint.withValues(alpha: 0.45), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.mint.withValues(alpha: 0.18),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        'S',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
          fontSize: size * 0.42,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
