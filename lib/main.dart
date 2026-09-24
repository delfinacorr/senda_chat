import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:senda_chat/screens/chat_screen.dart';
import 'package:senda_chat/state/chat_controller.dart';
import 'package:senda_chat/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const SendaChatApp());
}

class SendaChatApp extends StatelessWidget {
  const SendaChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatController()..loadSeedConversation(),
      child: MaterialApp(
        title: 'Senda Chat',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        home: const ChatScreen(),
      ),
    );
  }
}
