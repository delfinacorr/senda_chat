import 'package:flutter/foundation.dart';
import 'package:senda_chat/models/chat_message.dart';
import 'package:senda_chat/utils/formatters.dart';

class ChatController extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  int _idCounter = 0;

  List<ChatMessage> get messages => List.unmodifiable(_messages);

  String _nextId() => 'msg_${_idCounter++}';

  void loadSeedConversation() {
    _messages.clear();
    final now = DateTime.now();
    final base = DateTime(now.year, now.month, now.day, 14, 32);

    // Más reciente primero (índice 0) para ListView.builder(reverse: true).
    final seed = [
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.bot,
        timestamp: base,
        segments: parseRichText(
          'Hola, soy **Senda**, tu asistente de finanzas. '
          'Puedo consultar tu **saldo**, ayudarte a **enviar USDC** '
          'y operar en **Stellar Testnet**. ¿En qué te ayudo?',
        ),
      ),
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.user,
        timestamp: base.add(const Duration(minutes: 1)),
        segments: parseRichText('¿Cuál es mi saldo?'),
      ),
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.bot,
        timestamp: base.add(const Duration(minutes: 1, seconds: 8)),
        segments: parseRichText(
          'Este es tu saldo disponible en **Stellar Testnet**:',
        ),
        amountUsdc: 1284.50,
        amountLabel: 'Saldo disponible',
      ),
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.user,
        timestamp: base.add(const Duration(minutes: 3)),
        segments: parseRichText(
          'Quiero enviar **25 USDC** a **Ana Gómez**.',
        ),
      ),
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.bot,
        timestamp: base.add(const Duration(minutes: 3, seconds: 12)),
        segments: parseRichText(
          'Preparé el envío. Revisá los datos y confirmá para continuar:',
        ),
        action: const ActionCardData(
          amountUsdc: 25,
          recipient: 'Ana Gómez',
          network: 'Stellar Testnet',
        ),
      ),
    ];
    _messages.addAll(seed.reversed);
    notifyListeners();
  }

  void sendUserText(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return;

    final now = DateTime.now();
    _messages.insert(
      0,
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.user,
        timestamp: now,
        segments: parseRichText(text),
      ),
    );
    notifyListeners();
    _replyToUser(text, now);
  }

  void confirmAction(String messageId) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index < 0) return;
    final message = _messages[index];
    final action = message.action;
    if (action == null || action.status != ActionCardStatus.pending) return;

    final hash = shortStellarHash();
    _messages[index] = message.copyWith(
      action: action.copyWith(
        status: ActionCardStatus.confirmed,
        txHash: hash,
      ),
    );

    _messages.insert(
      0,
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        segments: parseRichText(
          'Listo. Envío de **${formatUsdc(action.amountUsdc)}** a '
          '**${action.recipient}** confirmado (simulado).\n'
          'Hash: **$hash**',
        ),
      ),
    );
    notifyListeners();
  }

  void cancelAction(String messageId) {
    final index = _messages.indexWhere((m) => m.id == messageId);
    if (index < 0) return;
    final message = _messages[index];
    final action = message.action;
    if (action == null || action.status != ActionCardStatus.pending) return;

    _messages[index] = message.copyWith(
      action: action.copyWith(status: ActionCardStatus.cancelled),
    );

    _messages.insert(
      0,
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.bot,
        timestamp: DateTime.now(),
        segments: parseRichText(
          'Envío cancelado. No se movió ningún USDC. '
          'Cuando quieras, pedime otro monto o destinatario.',
        ),
      ),
    );
    notifyListeners();
  }

  void _replyToUser(String text, DateTime userTime) {
    final lower = text.toLowerCase();
    final replyTime = userTime.add(const Duration(milliseconds: 80));

    if (_mentionsBalance(lower)) {
      _messages.insert(
        0,
        ChatMessage(
          id: _nextId(),
          sender: MessageSender.bot,
          timestamp: replyTime,
          segments: parseRichText(
            'Tu saldo actualizado en **Stellar Testnet**:',
          ),
          amountUsdc: 1284.50,
          amountLabel: 'Saldo disponible',
        ),
      );
      notifyListeners();
      return;
    }

    if (_mentionsTransfer(lower)) {
      final amount = _extractAmount(lower) ?? 10.0;
      final recipient = _extractRecipient(text) ?? 'contacto';
      _messages.insert(
        0,
        ChatMessage(
          id: _nextId(),
          sender: MessageSender.bot,
          timestamp: replyTime,
          segments: parseRichText(
            'Armé una transferencia simulada. Confirmá o cancelá:',
          ),
          action: ActionCardData(
            amountUsdc: amount,
            recipient: recipient,
            network: 'Stellar Testnet',
          ),
        ),
      );
      notifyListeners();
      return;
    }

    _messages.insert(
      0,
      ChatMessage(
        id: _nextId(),
        sender: MessageSender.bot,
        timestamp: replyTime,
        segments: parseRichText(
          'Puedo ayudarte a **consultar saldo** o **enviar USDC** '
          'en Stellar Testnet. Probá: “¿cuál es mi saldo?” o '
          '“enviar 10 USDC a Ana”.',
        ),
      ),
    );
    notifyListeners();
  }

  bool _mentionsBalance(String lower) =>
      lower.contains('saldo') ||
      lower.contains('balance') ||
      lower.contains('cuánto tengo') ||
      lower.contains('cuanto tengo');

  bool _mentionsTransfer(String lower) {
    final hasSend = lower.contains('enviar') ||
        lower.contains('manda') ||
        lower.contains('transfer') ||
        lower.contains('pago') ||
        lower.contains('pagar');
    final hasUsdc = lower.contains('usdc') || lower.contains('stellar');
    return hasSend || (hasUsdc && RegExp(r'\d').hasMatch(lower));
  }

  double? _extractAmount(String lower) {
    final match = RegExp(
      r'(\d+[.,]?\d*)\s*usdc|usdc\s*(\d+[.,]?\d*)|enviar\s+(\d+[.,]?\d*)',
    ).firstMatch(lower);
    if (match == null) return null;
    final raw = match.group(1) ?? match.group(2) ?? match.group(3);
    if (raw == null) return null;
    return double.tryParse(raw.replaceAll(',', '.'));
  }

  String? _extractRecipient(String text) {
    final patterns = [
      RegExp(r'a\s+\*{0,2}([A-Za-zÁÉÍÓÚáéíóúÑñ][\wÁÉÍÓÚáéíóúÑñ]*(?:\s+[A-Za-zÁÉÍÓÚáéíóúÑñ][\wÁÉÍÓÚáéíóúÑñ]*)?)\*{0,2}', caseSensitive: false),
      RegExp(r'para\s+\*{0,2}([A-Za-zÁÉÍÓÚáéíóúÑñ][\wÁÉÍÓÚáéíóúÑñ]*(?:\s+[A-Za-zÁÉÍÓÚáéíóúÑñ][\wÁÉÍÓÚáéíóúÑñ]*)?)\*{0,2}', caseSensitive: false),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(text);
      final name = match?.group(1)?.trim();
      if (name != null &&
          name.isNotEmpty &&
          !{'usdc', 'stellar', 'testnet'}.contains(name.toLowerCase())) {
        return name;
      }
    }
    return null;
  }
}
