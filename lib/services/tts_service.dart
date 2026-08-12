import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._();
  static final instance = TtsService._();
  final FlutterTts _tts = FlutterTts();

  Future<void> speakEnglish(String text) async {
    await _tts.stop();
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.38);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> speakHebrew(String text) async {
    await _tts.stop();
    await _tts.setLanguage('he-IL');
    await _tts.setSpeechRate(0.43);
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> stop() => _tts.stop();
}
