import 'package:flutter/foundation.dart';

enum MessageSender { user, bot }

enum ActionCardStatus { pending, confirmed, cancelled }

/// Segmento de texto enriquecido (negrita / normal).
@immutable
class TextSegment {
  const TextSegment(this.text, {this.bold = false});

  final String text;
  final bool bold;
}

@immutable
class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.sender,
    required this.timestamp,
    this.segments = const [],
    this.amountUsdc,
    this.amountLabel,
    this.action,
  });

  final String id;
  final MessageSender sender;
  final DateTime timestamp;
  final List<TextSegment> segments;
  final double? amountUsdc;
  final String? amountLabel;
  final ActionCardData? action;

  bool get hasAmountCard => amountUsdc != null;
  bool get hasActionCard => action != null;
  bool get isUser => sender == MessageSender.user;

  ChatMessage copyWith({
    List<TextSegment>? segments,
    double? amountUsdc,
    String? amountLabel,
    ActionCardData? action,
  }) {
    return ChatMessage(
      id: id,
      sender: sender,
      timestamp: timestamp,
      segments: segments ?? this.segments,
      amountUsdc: amountUsdc ?? this.amountUsdc,
      amountLabel: amountLabel ?? this.amountLabel,
      action: action ?? this.action,
    );
  }
}

@immutable
class ActionCardData {
  const ActionCardData({
    required this.amountUsdc,
    required this.recipient,
    required this.network,
    this.status = ActionCardStatus.pending,
    this.txHash,
  });

  final double amountUsdc;
  final String recipient;
  final String network;
  final ActionCardStatus status;
  final String? txHash;

  ActionCardData copyWith({
    ActionCardStatus? status,
    String? txHash,
  }) {
    return ActionCardData(
      amountUsdc: amountUsdc,
      recipient: recipient,
      network: network,
      status: status ?? this.status,
      txHash: txHash ?? this.txHash,
    );
  }
}
