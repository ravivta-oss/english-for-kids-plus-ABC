import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../services/progress_store.dart';
import '../services/tts_service.dart';

enum _Phase { reading, questions, bonusReview, completed }

/// A short reading activity: the child listens to / reads a mini-story
/// built entirely from vocabulary they've already learned, then answers
/// comprehension question(s) in Hebrew.
///
/// Passing is stricter than it looks: the child CAN always finish
/// answering (wrong taps just disable that option, same retry-friendly
/// style as lessons), but the next world only unlocks if EVERY question
/// was answered correctly on the FIRST attempt in the same round — a
/// "clean" round. Any wrong tap anywhere in the round routes the child
/// into a short bonus review of that world's weak words, then loops
/// back to a fresh attempt at the story question(s). This repeats until
/// they get a clean round, so guessing can never unlock progress.
class StoryScreen extends StatefulWidget {
  final LearnerProfile profile;
  final Story story;
  const StoryScreen({super.key, required this.profile, required this.story});

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  static const int bonusChoicesPerQuestion = 4;
  static const int maxBonusWords = 6;

  _Phase _phase = _Phase.reading;

  // ── Story question state ────────────────────────────────────────────
  int _questionIndex = 0;
  final Set<int> _wrongIndices = {};
  int? _correctSelectedIndex;
  bool _roundHadAnyMiss = false;

  // ── Bonus review state ───────────────────────────────────────────────
  List<VocabWord> _bonusWords = [];
  int _bonusIndex = 0;
  final Set<String> _bonusWrongIds = {};
  bool _bonusAnsweredCorrectly = false;
  List<VocabWord>? _bonusCachedChoices;
  int? _bonusCachedForIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TtsService.instance.speakHebrew('בואו נקרא סיפור קצר.');
    });
  }

  Future<void> _playStory() async {
    for (final sentence in widget.story.sentences) {
      await TtsService.instance.speakEnglish(sentence);
      await Future.delayed(const Duration(milliseconds: 350));
    }
  }

  void _startQuestions() {
    setState(() {
      _phase = _Phase.questions;
      _questionIndex = 0;
      _wrongIndices.clear();
      _correctSelectedIndex = null;
      _roundHadAnyMiss = false;
    });
    if (widget.story.questions.isNotEmpty) {
      TtsService.instance.speakHebrew(widget.story.questions.first.question);
    } else {
      _markComplete();
    }
  }

  Future<void> _selectAnswer(int index) async {
    if (_correctSelectedIndex != null) return;
    final q = widget.story.questions[_questionIndex];

    if (index == q.correctIndex) {
      setState(() => _correctSelectedIndex = index);
      await TtsService.instance.speakHebrew('נכון!');
    } else {
      setState(() {
        _wrongIndices.add(index);
        _roundHadAnyMiss = true; // this round no longer counts as "clean"
      });
      await TtsService.instance.speakHebrew('כמעט. נסו שוב.');
      // Question stays open — the child can try again among the
      // remaining (non-disabled) options. They will always eventually
      // be able to finish this question; what changes is whether the
      // ROUND counts as clean for unlocking the next world.
    }
  }

  void _nextQuestion() {
    final isLast = _questionIndex >= widget.story.questions.length - 1;
    if (isLast) {
      if (_roundHadAnyMiss) {
        _startBonusReview();
      } else {
        _markComplete();
      }
      return;
    }
    setState(() {
      _questionIndex++;
      _wrongIndices.clear();
      _correctSelectedIndex = null;
    });
    TtsService.instance.speakHebrew(widget.story.questions[_questionIndex].question);
  }

  Future<void> _markComplete() async {
    await ProgressStore.instance.completeStory(widget.profile.id, widget.story.world);
    if (!mounted) return;
    setState(() => _phase = _Phase.completed);
  }

  // ── Bonus review: practice this world's weak words, then loop back ──

  List<VocabWord> _pickBonusWords() {
    final worldWords = AppData.words.where((w) => w.world == widget.story.world).toList();
    final weakIds = ProgressStore.instance.weakWordIds(widget.profile.id, limit: 50).toSet();
    var picks = worldWords.where((w) => weakIds.contains(w.id)).toList();
    if (picks.isEmpty) picks = List.of(worldWords); // fallback: review the whole world
    picks.shuffle();
    return picks.take(maxBonusWords).toList();
  }

  void _startBonusReview() {
    final words = _pickBonusWords();
    if (words.isEmpty) {
      // Nothing to review (shouldn't normally happen) — just loop back.
      _resetQuestionRound();
      return;
    }
    setState(() {
      _phase = _Phase.bonusReview;
      _bonusWords = words;
      _bonusIndex = 0;
      _bonusWrongIds.clear();
      _bonusAnsweredCorrectly = false;
      _bonusCachedChoices = null;
      _bonusCachedForIndex = null;
    });
    TtsService.instance.speakHebrew('בואו נתרגל כמה מילים לפני שנחזור לסיפור.');
  }

  List<VocabWord> _bonusChoicesFor(VocabWord answer) {
    if (_bonusCachedForIndex == _bonusIndex && _bonusCachedChoices != null) {
      return _bonusCachedChoices!;
    }
    final pool = AppData.words
        .where((w) => w.category == answer.category && w.id != answer.id)
        .toList()
      ..shuffle();
    final result = <VocabWord>[answer, ...pool.take(bonusChoicesPerQuestion - 1)];
    if (result.length < bonusChoicesPerQuestion) {
      final extra = AppData.words.where((w) => !result.contains(w)).toList()..shuffle();
      result.addAll(extra.take(bonusChoicesPerQuestion - result.length));
    }
    result.shuffle();
    _bonusCachedChoices = result;
    _bonusCachedForIndex = _bonusIndex;
    return result;
  }

  Future<void> _selectBonusAnswer(VocabWord choice, VocabWord answer) async {
    if (_bonusAnsweredCorrectly) return;
    if (choice.id == answer.id) {
      setState(() => _bonusAnsweredCorrectly = true);
      await TtsService.instance.speakHebrew('נכון!');
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (_bonusIndex >= _bonusWords.length - 1) {
        _finishBonusReview();
      } else {
        setState(() {
          _bonusIndex++;
          _bonusWrongIds.clear();
          _bonusAnsweredCorrectly = false;
          _bonusCachedChoices = null;
        });
      }
    } else {
      setState(() => _bonusWrongIds.add(choice.id));
      await TtsService.instance.speakHebrew('כמעט, נסו שוב.');
    }
  }

  void _finishBonusReview() {
    TtsService.instance.speakHebrew('מעולה! עכשיו בואו ננסה שוב את שאלת הסיפור.');
    _resetQuestionRound();
  }

  void _resetQuestionRound() {
    setState(() {
      _phase = _Phase.questions;
      _questionIndex = 0;
      _wrongIndices.clear();
      _correctSelectedIndex = null;
      _roundHadAnyMiss = false;
    });
    if (widget.story.questions.isNotEmpty) {
      TtsService.instance.speakHebrew(widget.story.questions.first.question);
    }
  }

  // ── UI ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text(widget.story.title)),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: switch (_phase) {
              _Phase.reading => _buildReading(),
              _Phase.questions => _buildQuestions(),
              _Phase.bonusReview => _buildBonusReview(),
              _Phase.completed => _buildCompleted(),
            },
          ),
        ),
      ),
    );
  }

  Widget _buildReading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'קראו את הסיפור',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: widget.story.sentences
                        .map((s) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text(
                                s,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 28, height: 1.6),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.tonalIcon(
          onPressed: _playStory,
          icon: const Icon(Icons.volume_up),
          label: const Text('השמע את הסיפור'),
        ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: _startQuestions,
          style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
          child: Text(
            widget.story.questions.isEmpty ? 'סיום' : 'הבנתי, בואו נענה על שאלות',
          ),
        ),
      ],
    );
  }

  Widget _buildQuestions() {
    final q = widget.story.questions[_questionIndex];
    final answered = _correctSelectedIndex != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton.icon(
          onPressed: () => setState(() => _phase = _Phase.reading),
          icon: const Icon(Icons.menu_book_outlined, size: 18),
          label: const Text('קראו את הסיפור שוב'),
        ),
        Text(
          'שאלה ${_questionIndex + 1} מתוך ${widget.story.questions.length}',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 16),
        Text(
          q.question,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: List.generate(q.options.length, (i) {
              final isWrong = _wrongIndices.contains(i);
              final isCorrectPick = _correctSelectedIndex == i;
              final disabled = isWrong || answered;

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
                  onPressed: disabled ? null : () => _selectAnswer(i),
                  child: Text(q.options[i], style: const TextStyle(fontSize: 20)),
                ),
              );
            }),
          ),
        ),
        if (answered)
          FilledButton(
            onPressed: _nextQuestion,
            style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
            child: Text(
              _questionIndex >= widget.story.questions.length - 1 ? 'סיום' : 'הבא',
            ),
          ),
      ],
    );
  }

  Widget _buildBonusReview() {
    final word = _bonusWords[_bonusIndex];
    final choices = _bonusChoicesFor(word);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'תרגול קצר לפני שחוזרים לסיפור',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'מילה ${_bonusIndex + 1} מתוך ${_bonusWords.length}',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 20),
        FilledButton.tonalIcon(
          onPressed: () => TtsService.instance.speakEnglish(word.english),
          icon: const Icon(Icons.volume_up),
          label: Text(word.english, style: const TextStyle(fontSize: 20)),
        ),
        const SizedBox(height: 24),
        Expanded(
          child: ListView(
            children: choices.map((choice) {
              final isWrong = _bonusWrongIds.contains(choice.id);
              final isCorrectPick = _bonusAnsweredCorrectly && choice.id == word.id;
              final disabled = isWrong || _bonusAnsweredCorrectly;

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
                  onPressed: disabled ? null : () => _selectBonusAnswer(choice, word),
                  child: Text(choice.hebrew, style: const TextStyle(fontSize: 21)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCompleted() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('כל הכבוד! 📖⭐', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 8),
          const Text('העולם הבא נפתח!'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('חזרה'),
          ),
        ],
      ),
    );
  }
}
