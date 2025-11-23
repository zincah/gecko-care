// lib/features/voice/voice_service.dart
import 'package:speech_to_text/speech_to_text.dart' as stt;

class VoiceService {
  final _stt = stt.SpeechToText();
  Future<bool> init() => _stt.initialize();
  Future<void> start({
    required void Function(String text) onText,
  }) async {
    await _stt.listen(
      localeId: 'ko_KR',
      onResult: (res) {
        if (res.finalResult) onText(res.recognizedWords);
      },
    );
  }
  Future<void> stop() => _stt.stop();
}
