import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:senda_chat/screens/chat_screen.dart';
import 'package:senda_chat/state/chat_controller.dart';
import 'package:senda_chat/theme/app_theme.dart';

void main() {
  testWidgets('ChatScreen muestra Senda y la tarjeta de acción pendiente',
      (tester) async {
    final controller = ChatController()..loadSeedConversation();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: controller,
        child: MaterialApp(
          theme: AppTheme.dark,
          home: const ChatScreen(),
        ),
      ),
    );

    expect(find.text('Senda'), findsOneWidget);
    expect(find.text('en línea'), findsOneWidget);
    expect(find.text('Stellar Testnet'), findsWidgets);
    expect(find.text('Confirmar'), findsOneWidget);
    expect(find.text('Cancelar'), findsOneWidget);
  });
}
