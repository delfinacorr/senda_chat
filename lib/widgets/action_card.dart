import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:senda_chat/models/chat_message.dart';
import 'package:senda_chat/theme/app_theme.dart';
import 'package:senda_chat/utils/formatters.dart';

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.data,
    required this.onConfirm,
    required this.onCancel,
  });

  final ActionCardData data;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final pending = data.status == ActionCardStatus.pending;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.58),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppColors.mint, size: 18),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Confirmar envío',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  _StatusChip(status: data.status),
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(label: 'Monto', value: formatUsdc(data.amountUsdc)),
              const SizedBox(height: 6),
              _InfoRow(label: 'Destinatario', value: data.recipient),
              const SizedBox(height: 6),
              _InfoRow(label: 'Red', value: data.network),
              if (data.txHash != null) ...[
                const SizedBox(height: 6),
                _InfoRow(label: 'Hash', value: data.txHash!),
              ],
              if (pending) ...[
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.divider),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: onConfirm,
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.mintSoft,
                          foregroundColor: const Color(0xFF042F2E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text('Confirmar'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 96,
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              fontFeatures: [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final ActionCardStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ActionCardStatus.pending => ('Pendiente', AppColors.warning),
      ActionCardStatus.confirmed => ('Confirmado', AppColors.success),
      ActionCardStatus.cancelled => ('Cancelado', AppColors.danger),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
