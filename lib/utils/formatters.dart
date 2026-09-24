import 'package:senda_chat/models/chat_message.dart';

String formatUsdc(double amount) {
  final fixed = amount.toStringAsFixed(2);
  final parts = fixed.split('.');
  final whole = _groupThousands(parts[0]);
  return '$whole,${parts[1]} USDC';
}

String _groupThousands(String digits) {
  final negative = digits.startsWith('-');
  final raw = negative ? digits.substring(1) : digits;
  final buffer = StringBuffer();
  var count = 0;
  for (var i = raw.length - 1; i >= 0; i--) {
    buffer.write(raw[i]);
    count++;
    if (count % 3 == 0 && i != 0) {
      buffer.write('.');
    }
  }
  final grouped = buffer.toString().split('').reversed.join();
  return negative ? '-$grouped' : grouped;
}

String formatClock(DateTime time) {
  final h = time.hour.toString().padLeft(2, '0');
  final m = time.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String formatDayLabel(DateTime day) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final target = DateTime(day.year, day.month, day.day);
  final diff = today.difference(target).inDays;
  if (diff == 0) return 'Hoy';
  if (diff == 1) return 'Ayer';
  final d = day.day.toString().padLeft(2, '0');
  final m = day.month.toString().padLeft(2, '0');
  return '$d/$m/${day.year}';
}

/// Parser liviano: **negrita** → [TextSegment].
List<TextSegment> parseRichText(String input) {
  final segments = <TextSegment>[];
  final pattern = RegExp(r'\*\*(.+?)\*\*');
  var cursor = 0;
  for (final match in pattern.allMatches(input)) {
    if (match.start > cursor) {
      segments.add(TextSegment(input.substring(cursor, match.start)));
    }
    segments.add(TextSegment(match.group(1)!, bold: true));
    cursor = match.end;
  }
  if (cursor < input.length) {
    segments.add(TextSegment(input.substring(cursor)));
  }
  if (segments.isEmpty) {
    segments.add(TextSegment(input));
  }
  return segments;
}

String shortStellarHash() {
  const alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ234567';
  final now = DateTime.now().microsecondsSinceEpoch;
  final buffer = StringBuffer('G');
  var seed = now;
  for (var i = 0; i < 8; i++) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    buffer.write(alphabet[seed % alphabet.length]);
  }
  buffer.write('…');
  seed = (seed * 1103515245 + 12345) & 0x7fffffff;
  for (var i = 0; i < 4; i++) {
    seed = (seed * 1103515245 + 12345) & 0x7fffffff;
    buffer.write(alphabet[seed % alphabet.length]);
  }
  return buffer.toString();
}
