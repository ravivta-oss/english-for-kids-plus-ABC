import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../services/progress_store.dart';
import '../services/tts_service.dart';
import 'review_screen.dart';

enum _ExerciseKind { listeningChoice, readingChoice, phonicsBuild, sentenceBuild }

class LessonScreen extends StatefulWidget {
  final LearnerProfile profile;
  final Lesson lesson;
  const LessonScreen({super.key, required this.profile, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  static const int questionsPerLesson = 12;
  static const int choicesPerQuestion = 4;
  // The child must get this fraction of questions right on the FIRST
  // attempt (no wrong taps before it) to actually pass the lesson.
  // Getting there eventually via trial-and-error does NOT count — this is
  // what stops "just tap everything until it lets me through".
  static const double passingFirstTryRatio = 0.7;

  int step = 0;
  int correct = 0;
  int firstTryCorrectCount = 0;
  late List<VocabWord> focus;

  // The word asked at each question index. Normally just cycles through
  // `focus`, but a missed word gets RE-INSERTED here ~4 questions later
  // (Retrieval Retry) so it's tested again later in the same session
  // instead of only immediately — much stronger evidence of real
  // learning than an instant retry.
  List<VocabWord?> _questionPlan = [];

  // Function/connector words (is, a, am, are...) in this lesson that need
  // an explanation before the child is quizzed on them.
  late List<VocabWord> _introWords;
  int _introIndex = 0;
  bool _showingIntro = false;

  // ── Multiple-choice question state (listening / reading) ──────────
  final Set<String> _wrongChoiceIds = {};
  String? _correctChoiceId;
  bool _answeredCorrectly = false;
  bool _hadWrongAttemptThisQuestion = false;

  // ── Tile-build question state (phonics / sentence) ─────────────────
  List<String> _targetTokens = [];
  List<String> _bankTokens = [];
  List<String> _builtTokens = [];

  int get _requiredFirstTryCorrect =>
      (questionsPerLesson * passingFirstTryRatio).ceil();

  // Per-step cached data so it doesn't reshuffle on every rebuild.
  int? _cachedForStep;
  List<VocabWord>? _cachedChoices;
  _ExerciseKind? _cachedKind;
  VocabWord? _cachedFocusWord; // relevant word for mastery/review (may be null for sentence questions)

  @override
  void initState() {
    super.initState();
    _setUpFocusWords();
    _setUpIntroWords();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showingIntro) {
        _speakIntro();
      } else {
        _speakLessonStartMessage();
        _speakCurrentQuestionPrompt();
      }
    });
  }

  void _setUpFocusWords() {
    focus = widget.lesson.focusWordIds.map(AppData.word).toList();

    if (focus.isEmpty) {
      // Checkpoint / Boss / "summary" lessons carry no explicit word list —
      // they must review what was actually taught in THIS world, chosen
      // randomly, not just the first N words in the master list (which
      // would always be World 1's animal words regardless of which world
      // this lesson belongs to).
      final sameWorld = AppData.words
          .where((w) => w.world == widget.lesson.world)
          .toList()
        ..shuffle();

      if (sameWorld.length >= 5) {
        focus = sameWorld.take(8).toList();
      } else {
        // This world doesn't have enough words on its own (rare) — top up
        // with a review of the previous world so there's still a real quiz.
        final previousWorld = AppData.words
            .where((w) => w.world == widget.lesson.world - 1)
            .toList()
          ..shuffle();
        focus = [...sameWorld, ...previousWorld].take(8).toList();
      }
    } else {
      // Even explicit lesson word lists should not always quiz in the same
      // fixed order every time the child repeats a lesson.
      focus = [...focus]..shuffle();
    }

    _questionPlan = List.generate(questionsPerLesson, (i) => focus[i % focus.length]);
  }

  void _setUpIntroWords() {
    // Any function/connector word in this lesson (is, a, am, are...) gets
    // explained BEFORE the quiz starts, since these words don't have a
    // clean 1:1 Hebrew translation the way "dog" -> "כלב" does.
    final seen = <String>{};
    _introWords = focus
        .where((w) => w.explanation != null && seen.add(w.id))
        .toList();
    _showingIntro = _introWords.isNotEmpty;
  }

  void _speakLessonStartMessage() {
    TtsService.instance.speakHebrew(
      widget.lesson.boss
          ? 'זהו אתגר הבוס. קראו והקשיבו היטב.'
          : widget.lesson.checkpoint
              ? 'זהו שיעור חזרה. בואו נראה מה אנחנו זוכרים.'
              : 'מתחילים שיעור חדש. הקשיבו ובחרו את התשובה.',
    );
  }

  Future<void> _speakIntro() async {
    final word = _introWords[_introIndex];
    await TtsService.instance.speakHebrew(word.explanation!);
    await TtsService.instance.speakEnglish(word.english);
  }

  void _nextIntroWord() {
    if (_introIndex < _introWords.length - 1) {
      setState(() => _introIndex++);
      _speakIntro();
    } else {
      setState(() => _showingIntro = false);
      _speakLessonStartMessage();
      _speakCurrentQuestionPrompt();
    }
  }

  // ── Exercise-type selection ─────────────────────────────────────────

  List<_ExerciseKind> get _availableKinds => [
        _ExerciseKind.listeningChoice,
        _ExerciseKind.readingChoice,
        _ExerciseKind.phonicsBuild,
        if (widget.lesson.sentenceBank.isNotEmpty) _ExerciseKind.sentenceBuild,
      ];

  _ExerciseKind _kindForStep(int step) {
    final kinds = _availableKinds;
    return kinds[step % kinds.length];
  }

  void _ensureStepData() {
    if (_cachedForStep == step) return;

    final kind = _kindForStep(step);
    _cachedKind = kind;

    switch (kind) {
      case _ExerciseKind.listeningChoice:
      case _ExerciseKind.readingChoice:
        final answer = _questionPlan[step]!;
        _cachedFocusWord = answer;
        _cachedChoices = _buildMcChoices(answer);
        break;
      case _ExerciseKind.phonicsBuild:
        final answer = _questionPlan[step]!;
        _cachedFocusWord = answer;
        _setUpPhonicsTokens(answer);
        break;
      case _ExerciseKind.sentenceBuild:
        _cachedFocusWord = null; // not tied to a single vocabulary word
        _setUpSentenceTokens();
        break;
    }

    _cachedForStep = step;
    _wrongChoiceIds.clear();
    _correctChoiceId = null;
    _answeredCorrectly = false;
    _hadWrongAttemptThisQuestion = false;
  }

  List<VocabWord> _buildMcChoices(VocabWord answer) {
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

  void _setUpPhonicsTokens(VocabWord answer) {
    final target = answer.phonics.isNotEmpty
        ? List<String>.from(answer.phonics)
        : answer.english.toLowerCase().split('');

    // Add a couple of distractor letters/chunks so this is a real puzzle,
    // not just "tap everything in the bank".
    const letterPool = ['b', 'm', 'p', 'r', 's', 't', 'n', 'l'];
    final distractors = letterPool.where((l) => !target.contains(l)).toList()
      ..shuffle();

    _targetTokens = target;
    _bankTokens = [...target, ...distractors.take(2)]..shuffle();
    _builtTokens = [];
  }

  void _setUpSentenceTokens() {
    final sentences = widget.lesson.sentenceBank;
    final sentence = (sentences..shuffle()).first;
    final clean = sentence.replaceAll('.', '').replaceAll('?', '').trim();
    final target = clean.split(' ');

    // One distractor word drawn from this lesson's own focus vocabulary,
    // so it's plausible but still wrong.
    final distractorPool = focus
        .map((w) => w.english)
        .where((w) => !target.map((t) => t.toLowerCase()).contains(w.toLowerCase()))
        .toList()
      ..shuffle();

    _targetTokens = target;
    _bankTokens = [...target, if (distractorPool.isNotEmpty) distractorPool.first]..shuffle();
    _builtTokens = [];
    // Remember the raw sentence (with punctuation) for TTS playback.
    _currentSentenceDisplay = sentence;
  }

  String _currentSentenceDisplay = '';

  void _speakCurrentQuestionPrompt() {
    _ensureStepData();
    switch (_cachedKind!) {
      case _ExerciseKind.listeningChoice:
        TtsService.instance.speakEnglish(_cachedFocusWord!.english);
        break;
      case _ExerciseKind.readingChoice:
        break; // word is shown on screen, no need to speak it upfront
      case _ExerciseKind.phonicsBuild:
        TtsService.instance.speakEnglish(_cachedFocusWord!.english);
        break;
      case _ExerciseKind.sentenceBuild:
        TtsService.instance.speakEnglish(_currentSentenceDisplay);
        break;
    }
  }

  // ── Multiple-choice answer handling ─────────────────────────────────

  Future<void> _answerChoice(VocabWord choice, VocabWord answer) async {
    if (_answeredCorrectly) return;
    final ok = choice.id == answer.id;

    if (ok) {
      final wasFirstTry = !_hadWrongAttemptThisQuestion;
      setState(() {
        _answeredCorrectly = true;
        _correctChoiceId = choice.id;
      });
      await _onCorrect(answer, wasFirstTry, usedListening: _cachedKind == _ExerciseKind.listeningChoice);
    } else {
      final wasFirstAttempt = !_hadWrongAttemptThisQuestion;
      setState(() {
        _wrongChoiceIds.add(choice.id);
        _hadWrongAttemptThisQuestion = true;
      });
      await _onWrong(answer, wasFirstAttempt);
    }
  }

  // ── Tile-build answer handling (phonics + sentence) ─────────────────

  Future<void> _tapBankToken(int bankIndex) async {
    if (_answeredCorrectly) return;
    final token = _bankTokens[bankIndex];
    final expectedIndex = _builtTokens.length;
    final expected = _targetTokens[expectedIndex];

    if (token.toLowerCase() == expected.toLowerCase()) {
      setState(() {
        _builtTokens.add(token);
        _bankTokens.removeAt(bankIndex);
      });
      if (_builtTokens.length == _targetTokens.length) {
        final wasFirstTry = !_hadWrongAttemptThisQuestion;
        setState(() => _answeredCorrectly = true);
        final word = _cachedFocusWord;
        if (word != null) {
          await _onCorrect(word, wasFirstTry, usedListening: false, isPhonics: true);
        } else {
          // Sentence question — no single vocabulary word to attach
          // mastery/review to, but it still counts toward the lesson's
          // pass/fail score.
          correct++;
          if (wasFirstTry) firstTryCorrectCount++;
          await TtsService.instance.speakHebrew('מצוין!');
          if (!mounted) return;
          await Future.delayed(const Duration(milliseconds: 700));
          if (!mounted) return;
          _goToNextQuestion();
        }
      }
    } else {
      final wasFirstAttempt = !_hadWrongAttemptThisQuestion;
      setState(() => _hadWrongAttemptThisQuestion = true);
      final word = _cachedFocusWord;
      if (wasFirstAttempt && word != null) {
        await ProgressStore.instance.recordReview(widget.profile.id, word.id, false);
        _scheduleRetrievalRetry(word);
      }
      await TtsService.instance.speakHebrew('כמעט. נסו שוב.');
    }
  }

  void _clearBuild() {
    if (_answeredCorrectly) return;
    setState(() {
      _bankTokens = [..._bankTokens, ..._builtTokens]..shuffle();
      _builtTokens = [];
    });
  }

  /// Re-inserts a missed word a few questions further into this same
  /// lesson so it gets tested again later — not just via the immediate
  /// retry on the current question, which only proves short-term memory.
  void _scheduleRetrievalRetry(VocabWord word) {
    const delay = 4;
    final retryPos = step + delay;
    if (retryPos < questionsPerLesson &&
        _kindForStep(retryPos) != _ExerciseKind.sentenceBuild) {
      _questionPlan[retryPos] = word;
    }
  }

  // ── Shared correct/wrong handling ───────────────────────────────────

  Future<void> _onCorrect(
    VocabWord answer,
    bool wasFirstTry, {
    required bool usedListening,
    bool isPhonics = false,
  }) async {
    correct++;
    if (wasFirstTry) {
      firstTryCorrectCount++;
      final type = isPhonics
          ? MasteryType.recognition
          : usedListening
              ? MasteryType.listening
              : MasteryType.reading;
      // Only a clean first-attempt answer counts as real evidence of
      // mastery — bumping mastery on a guess-and-check answer would
      // falsely mark the word as "known".
      await ProgressStore.instance.bumpMastery(widget.profile.id, answer.id, type);
      await ProgressStore.instance.recordReview(widget.profile.id, answer.id, true);
    }
    await TtsService.instance.speakHebrew('מצוין!');
    if (!mounted) return;
    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    _goToNextQuestion();
  }

  Future<void> _onWrong(VocabWord answer, bool wasFirstAttempt) async {
    if (wasFirstAttempt) {
      await ProgressStore.instance.recordReview(widget.profile.id, answer.id, false);
      _scheduleRetrievalRetry(answer);
    }
    await TtsService.instance.speakHebrew('כמעט. נסו שוב.');
    await TtsService.instance.speakEnglish(answer.english);
  }

  void _goToNextQuestion() {
    setState(() {
      step++;
    });
    if (step >= questionsPerLesson) {
      _finishLesson();
    } else {
      _ensureStepData();
      _speakCurrentQuestionPrompt();
    }
  }

  Future<void> _finishLesson() async {
    final passed = firstTryCorrectCount >= _requiredFirstTryCorrect;
    if (passed) {
      await ProgressStore.instance.completeLesson(widget.profile.id, widget.lesson.id);
    }
    if (!mounted) return;
    if (passed) {
      _showPassedDialog();
    } else {
      _showTryAgainDialog();
    }
  }

  void _showPassedDialog() {
    final weakWords = ProgressStore.instance.weakWordIds(widget.profile.id, limit: 5);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('כל הכבוד! ⭐'),
        content: Text(
          'סיימתם את השיעור בהצלחה!\n'
          '$firstTryCorrectCount מתוך $questionsPerLesson נכונות בניסיון ראשון.'
          '${weakWords.isNotEmpty ? '\n\nיש כמה מילים שכדאי לחזק — רוצים סבב תרגול קצר?' : ''}',
        ),
        actions: [
          if (weakWords.isNotEmpty)
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                Navigator.pop(context); // leave lesson
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReviewScreen(profile: widget.profile),
                  ),
                );
              },
              child: const Text('תרגול בונוס למילים חלשות'),
            ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('המשך'),
          ),
        ],
      ),
    );
  }

  void _showTryAgainDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('כמעט שם! 💪'),
        content: Text(
          'כדי להמשיך לשיעור הבא, צריך לענות נכון בניסיון הראשון על '
          'לפחות $_requiredFirstTryCorrect מתוך $questionsPerLesson שאלות.\n\n'
          'הפעם הצלחתם ב-$firstTryCorrectCount מתוך $questionsPerLesson. '
          'בואו ננסה שוב עם שאלות חדשות!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // leave lesson without completing it
            },
            child: const Text('יציאה לעת אחרת'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _restartLesson();
            },
            child: const Text('נסו שוב'),
          ),
        ],
      ),
    );
  }

  void _restartLesson() {
    setState(() {
      step = 0;
      correct = 0;
      firstTryCorrectCount = 0;
      _introIndex = 0;
      _cachedForStep = null;
      _setUpFocusWords();
      _setUpIntroWords();
    });
    if (_showingIntro) {
      _speakIntro();
    } else {
      _speakLessonStartMessage();
      _speakCurrentQuestionPrompt();
    }
  }

  // ── UI ────────────────────────────────────────────────────────────

  Widget _buildIntro() {
    final word = _introWords[_introIndex];
    final isLast = _introIndex == _introWords.length - 1;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('שיעור ${widget.lesson.id}')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'רגע לפני שמתחילים...',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'מילה ${_introIndex + 1} מתוך ${_introWords.length}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade600),
                ),
                const SizedBox(height: 28),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Text(
                          word.english,
                          textDirection: TextDirection.ltr,
                          style: const TextStyle(fontSize: 52, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          word.explanation!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 19, height: 1.5),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.tonalIcon(
                          onPressed: _speakIntro,
                          icon: const Icon(Icons.volume_up),
                          label: const Text('השמע שוב'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _nextIntroWord,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    isLast ? 'הבנתי, בואו נתחיל! 🚀' : 'הבנתי, הלאה',
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMcQuestion() {
    final answer = _cachedFocusWord!;
    final choices = _cachedChoices!;
    final listening = _cachedKind == _ExerciseKind.listeningChoice;

    return Column(
      children: [
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
                  onPressed: disabled ? null : () => _answerChoice(choice, answer),
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
      ],
    );
  }

  Widget _buildTileQuestion() {
    final isPhonics = _cachedKind == _ExerciseKind.phonicsBuild;
    final title = isPhonics ? 'הרכיבו את המילה' : 'הרכיבו את המשפט';
    final promptWord = isPhonics ? _cachedFocusWord : null;

    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        if (isPhonics && promptWord != null)
          Text(promptWord.hebrew, style: const TextStyle(fontSize: 22)),
        FilledButton.tonalIcon(
          onPressed: () => isPhonics
              ? TtsService.instance.speakEnglish(promptWord!.english)
              : TtsService.instance.speakEnglish(_currentSentenceDisplay),
          icon: const Icon(Icons.volume_up),
          label: const Text('השמע'),
        ),
        const SizedBox(height: 20),
        // Build area — shows progress so far.
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 64),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: _builtTokens
                .map((t) => Chip(
                      label: Text(
                        t,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(fontSize: 20),
                      ),
                      backgroundColor: Colors.green.shade100,
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 12),
        if (_builtTokens.isNotEmpty && !_answeredCorrectly)
          TextButton.icon(
            onPressed: _clearBuild,
            icon: const Icon(Icons.refresh),
            label: const Text('נקה והתחל מחדש'),
          ),
        const SizedBox(height: 12),
        Expanded(
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(_bankTokens.length, (i) {
              return ActionChip(
                label: Text(
                  _bankTokens[i],
                  textDirection: TextDirection.ltr,
                  style: const TextStyle(fontSize: 20),
                ),
                onPressed: _answeredCorrectly ? null : () => _tapBankToken(i),
              );
            }),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_showingIntro) {
      return _buildIntro();
    }

    if (step >= questionsPerLesson) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    _ensureStepData();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('שיעור ${widget.lesson.id}')),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                LinearProgressIndicator(value: (step + 1) / questionsPerLesson),
                const SizedBox(height: 20),
                Expanded(
                  child: (_cachedKind == _ExerciseKind.listeningChoice ||
                          _cachedKind == _ExerciseKind.readingChoice)
                      ? _buildMcQuestion()
                      : _buildTileQuestion(),
                ),
                Text('שאלה ${step + 1} מתוך $questionsPerLesson'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
