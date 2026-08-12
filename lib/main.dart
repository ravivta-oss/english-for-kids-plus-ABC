import 'package:flutter/material.dart';
import 'data/app_data.dart';
import 'screens/profile_screen.dart';
import 'services/progress_store.dart';
import 'services/tts_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ProgressStore.instance.init();
  runApp(const EnglishAdventureApp());
}

class EnglishAdventureApp extends StatelessWidget {
  const EnglishAdventureApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'English Adventure',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFFF7FBFF),
        cardTheme: const CardThemeData(
          elevation: 1,
          margin: EdgeInsets.symmetric(vertical: 6),
        ),
      ),
      home: ProfileScreen(
        profiles: AppData.profiles,
        onSpeakHebrew: TtsService.instance.speakHebrew,
      ),
    );
  }
}
