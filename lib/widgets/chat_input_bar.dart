import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:senda_chat/theme/app_theme.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({super.key, required this.onSend});

  final ValueChanged<String> onSend;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _submit() {
    final text = _controller.text;
    if (text.trim().isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  void _showSimSnack(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            10,
            10,
            10,
            10 + MediaQuery.paddingOf(context).bottom,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.72),
            border: const Border(
              top: BorderSide(color: AppColors.glassBorder),
            ),
          ),
          child: Row(
            children: [
              _RoundIconButton(
                icon: Icons.image_outlined,
                tooltip: 'Adjuntar imagen',
                onTap: () => _showSimSnack(
                  'Simulación: adjuntar imagen no está disponible en este demo.',
                ),
              ),
              const SizedBox(width: 4),
              _RoundIconButton(
                icon: Icons.attach_file_rounded,
                tooltip: 'Adjuntar archivo',
                onTap: () => _showSimSnack(
                  'Simulación: adjuntar archivo no está disponible en este demo.',
                ),
              ),
              const SizedBox(width: 6),
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _submit(),
                  style: const TextStyle(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Escribí un mensaje…',
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Material(
                color: AppColors.mintSoft,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: _submit,
                  child: const SizedBox(
                    width: 46,
                    height: 46,
                    child: Icon(
                      Icons.send_rounded,
                      color: Color(0xFF042F2E),
                      size: 22,
                    ),
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

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: AppColors.textSecondary, size: 22),
        ),
      ),
    );
  }
}
