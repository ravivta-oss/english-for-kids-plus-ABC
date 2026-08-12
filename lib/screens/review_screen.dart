import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../services/progress_store.dart';
import '../services/tts_service.dart';

/// A short, optional practice session pulled from the spaced-repetition
/// schedule — words the child has already learned, resurfacing exactly
/// when they're at risk of being forgotten. This is separate from the
/// main lesson path: it never blocks progression, it's just extra
/// reinforcement.
class ReviewScreen extends StatefulWidget {
  final LearnerProfile profile;
  const ReviewScreen({super.key, required this.profile});

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  static const int choicesPerQuestion = 4;

  late List<VocabWord> _dueWords;
  int step = 0;
  int correctCount = 0;

  final Set<String> _wrongChoiceIds = {};
  String? _correctChoiceId;
  bool _answeredCorrectly = false;

  List<VocabWord>? _cachedChoices;
  int? _cachedForStep;

  @override
  void initState() {
    super.initState();
    // Combine formally-due words (spaced-repetition schedule) with
    // chronically weak words (high miss ratio, regardless of whether
    // their box says they're "due" yet) — due words first, since those
    // are the most time-sensitive.
    final dueIds = ProgressStore.instance.dueWordIds(widget.profile.id, limit: 15);
    final weakIds = ProgressStore.instance.weakWordIds(widget.profile.id, limit: 8);
    final combinedIds = <String>{...dueIds, ...weakIds}.take(15).toList();
    _dueWords = combinedIds.map(AppData.word).toList();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_dueWords.isNotEmpty) {
        TtsService.instance.speakHebrew('בואו נתרגל מילים שכבר למדתם.');
      }
    });
  }

  List<VocabWord> _choices(VocabWord answer) {
    final pool = AppData.words
        .where((w) => w.category == answer.category && w.id != answer.id)
        .toList();
    pool.shuffle();
    final distractorCount = choicesPerQuestion - 1;
    final result = <VocabWord>[answer, ...pool.take(distractorCount)];
    if (result.length < choicesPerQuestion) {
      final extra = AppData.words.where((w) => !result.contains(w)).toList()..shuffle();
      result.addAll(extra.take(choicesPerQuestion - result.length));
    }
    result.shuffle();
    return result;
  }

  List<VocabWord> _choicesFor(VocabWord answer) {
    if (_cachedForStep == step && _cachedChoices != null) {
      return _cachedChoices!;
    }
    final choices = _choices(answer);
    _cachedChoices = choices;
    _cachedForStep = step;
    return choices;
  }

  Future<void> _answer(VocabWord choice, VocabWord answer) async {
    if (_answeredCorrectly) return;
    final ok = choice.id == answer.id;

    if (ok) {
      setState(() {
        _answeredCorrectly = true;
        _correctChoiceId = choice.id;
      });
      correctCount++;
      await ProgressStore.instance.recordReview(widget.profile.id, answer.id, true);
      await TtsService.instance.speakHebrew('מצוין!');
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      _next();
    } else {
      setState(() => _wrongChoiceIds.add(choice.id));
      // Any miss during review — even a later attempt — means this word
      // is still shaky, so it goes back to the start of the cycle. There
      // is no "pass" to game here since review sessions don't gate
      // anything; being honest about a wrong answer only helps the child.
      await ProgressStore.instance.recordReview(widget.profile.id, answer.id, false);
      await TtsService.instance.speakHebrew('כמעט. נסו שוב.');
      await TtsService.instance.speakEnglish(answer.english);
    }
  }

  void _next() {
    setState(() {
      step++;
      _wrongChoiceIds.clear();
      _correctChoiceId = null;
      _answeredCorrectly = false;
      _cachedChoices = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_dueWords.isEmpty) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('תרגול יומי')),
          body: const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Text(
                'אין כרגע מילים לתרגול. כל הכבוד! 🌟\nחזרו מחר לתרגול נוסף.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ),
      );
    }

    if (step >= _dueWords.length) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('תרגול יומי')),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('סיימתם את התרגול היומי! ⭐', style: TextStyle(fontSize: 22)),
                  const SizedBox(height: 8),
                  Text('$correctCount מתוך ${_dueWords.length} נכונות'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('חזרה למפה'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    final answer = _dueWords[step];
    final choices = _choicesFor(answer);
    final listening = step.isEven;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('תרגול יומי')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LinearProgressIndicator(value: (step + 1) / _dueWords.length),
                const SizedBox(height: 30),
                Text(
                  listening ? 'הקשיבו ובחרו' : 'קראו ובחרו את הפירוש',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                if (listening)
                  FilledButton.tonalIcon(
                    onPressed: () => TtsService.instance.speakEnglish(answer.english),
                    icon: const Icon(Icons.volume_up),
                    label: const Text('השמע'),
                  )
                else
                  Text(
                    answer.english,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 46, fontWeight: FontWeight.w800),
                  ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView(
                    children: choices.map((choice) {
                      final isWrong = _wrongChoiceIds.contains(choice.id);
                      final isCorrectPick = _correctChoiceId == choice.id;
                      final disabled = isWrong || _answeredCorrectly;

                      Color? bg;
                      Color? fg;
                      if (isCorrectPick) {
                        bg = Colors.green.shade600;
                        fg = Colors.white;
                      } else if (isWrong) {
                        bg = Colors.red.shade200;
                        fg = Colors.red.shade900;
                      }

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: bg,
                            foregroundColor: fg,
                          ),
                          onPressed: disabled ? null : () => _answer(choice, answer),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isWrong) ...[
                                const Icon(Icons.close, size: 18),
                                const SizedBox(width: 6),
                              ],
                              if (isCorrectPick) ...[
                                const Icon(Icons.check, size: 18),
                                const SizedBox(width: 6),
                              ],
                              Text(choice.hebrew, style: const TextStyle(fontSize: 21)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Text('שאלה ${step + 1} מתוך ${_dueWords.length}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
