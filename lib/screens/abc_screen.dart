import 'package:flutter/material.dart';
import '../data/app_data.dart';
import '../models/models.dart';
import '../services/tts_service.dart';

/// A generic sound item — either a single letter ('a') or a blend
/// ('sh') — unified so the practice engine doesn't care which kind it
/// is quizzing on.
class _SoundItem {
  final String display;
  final String soundHint;
  final String example;
  const _SoundItem(this.display, this.soundHint, this.example);
}

List<_SoundItem> get _allSoundItems => [
      ...AppData.alphabet.map((l) => _SoundItem(l.letter, l.soundHint, l.exampleWord)),
      ...AppData.soundBlends.map((b) => _SoundItem(b.blend, b.soundHint, b.exampleWord)),
    ];

/// Standalone letter/sound-foundation track: learn the 26 letters plus
/// common sound blends (sh, ch, th, ck, wh, ph), practice matching
/// sound → letter (in general or focused on one specific sound), and
/// practice the reverse direction (a familiar Hebrew letter → its
/// closest English match). Deliberately disconnected from lesson/world
/// progression — a child can use this as much as they need, any time.
class AbcScreen extends StatefulWidget {
  const AbcScreen({super.key});

  @override
  State<AbcScreen> createState() => _AbcScreenState();
}

class _AbcScreenState extends State<AbcScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('אותיות וצלילים'),
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'לימוד'),
              Tab(text: 'תרגול'),
              Tab(text: 'מעברית'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: const [
            _LearnTab(),
            SoundPracticeRound(pool: null, focus: null),
            _HebrewMatchTab(),
          ],
        ),
      ),
    );
  }
}

class _LearnTab extends StatelessWidget {
  const _LearnTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('אותיות', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildGrid(context, AppData.alphabet.map((l) => _SoundItem(l.letter, l.soundHint, l.exampleWord)).toList()),
        const SizedBox(height: 24),
        const Text('צירופי צלילים מיוחדים', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _buildGrid(context, AppData.soundBlends.map((b) => _SoundItem(b.blend, b.soundHint, b.exampleWord)).toList()),
      ],
    );
  }

  Widget _buildGrid(BuildContext context, List<_SoundItem> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: items.length,
      itemBuilder: (context, i) {
        final item = items[i];
        return InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetail(context, item),
          child: Card(
            child: Center(
              child: Text(
                item.display,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showDetail(BuildContext context, _SoundItem item) {
    TtsService.instance.speakEnglish(item.display);
    showModalBottomSheet(
      context: context,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                item.display,
                textDirection: TextDirection.ltr,
                style: const TextStyle(fontSize: 64, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(item.soundHint, textAlign: TextAlign.center, style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () async {
                  await TtsService.instance.speakEnglish(item.display);
                  await Future.delayed(const Duration(milliseconds: 400));
                  await TtsService.instance.speakEnglish(item.example);
                },
                icon: const Icon(Icons.volume_up),
                label: Text('השמע: ${item.display} — ${item.example}'),
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () {
                  Navigator.pop(context); // close the sheet first
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: Scaffold(
                          appBar: AppBar(title: Text('תרגול: ${item.display}')),
                          body: SoundPracticeRound(pool: null, focus: item),
                        ),
                      ),
                    ),
                  );
                },
                child: const Text('תרגלו את הצליל הזה'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Generic sound-matching quiz: hears a sound, picks the matching
/// letter/blend from 4 options, retries on a wrong tap. If [focus] is
/// given, every question in the round targets that same sound (with
/// fresh random distractors each time) — useful for drilling one
/// specific letter a child is struggling with. Otherwise draws from the
/// full pool of letters + blends.
class SoundPracticeRound extends StatefulWidget {
  final List<_SoundItem>? pool;
  final _SoundItem? focus;
  const SoundPracticeRound({super.key, required this.pool, required this.focus});

  @override
  State<SoundPracticeRound> createState() => _SoundPracticeRoundState();
}

class _SoundPracticeRoundState extends State<SoundPracticeRound> {
  static const int roundLength = 10;
  static const int choicesPerQuestion = 4;

  late List<_SoundItem> _fullPool;
  late List<_SoundItem> _round;
  int _index = 0;
  int _correct = 0;
  final Set<String> _wrong = {};
  String? _correctPick;
  List<_SoundItem>? _cachedChoices;
  int? _cachedForIndex;

  @override
  void initState() {
    super.initState();
    _fullPool = widget.pool ?? _allSoundItems;
    _startRound();
  }

  void _startRound() {
    if (widget.focus != null) {
      _round = List.filled(roundLength, widget.focus!);
    } else {
      final shuffled = List.of(_fullPool)..shuffle();
      _round = shuffled.take(roundLength).toList();
    }
    setState(() {
      _index = 0;
      _correct = 0;
      _wrong.clear();
      _correctPick = null;
      _cachedChoices = null;
      _cachedForIndex = null;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakPrompt());
  }

  void _speakPrompt() {
    if (_index >= _round.length) return;
    TtsService.instance.speakEnglish(_round[_index].display);
  }

  List<_SoundItem> _choicesFor(_SoundItem answer) {
    if (_cachedForIndex == _index && _cachedChoices != null) return _cachedChoices!;
    final pool = _fullPool.where((s) => s.display != answer.display).toList()..shuffle();
    final choices = <_SoundItem>[answer, ...pool.take(choicesPerQuestion - 1)]..shuffle();
    _cachedChoices = choices;
    _cachedForIndex = _index;
    return choices;
  }

  Future<void> _select(_SoundItem choice, _SoundItem answer) async {
    if (_correctPick != null) return;
    if (choice.display == answer.display) {
      setState(() {
        _correctPick = choice.display;
        _correct++;
      });
      await TtsService.instance.speakHebrew('נכון!');
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        _index++;
        _wrong.clear();
        _correctPick = null;
        _cachedChoices = null;
      });
      if (_index < _round.length) _speakPrompt();
    } else {
      setState(() => _wrong.add(choice.display));
      await TtsService.instance.speakHebrew('נסו שוב.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_index >= _round.length) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('כל הכבוד! 🔤⭐', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text('$_correct מתוך ${_round.length} נכונות'),
              const SizedBox(height: 24),
              FilledButton(onPressed: _startRound, child: const Text('סבב נוסף')),
            ],
          ),
        ),
      );
    }

    final answer = _round[_index];
    final choices = _choicesFor(answer);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          LinearProgressIndicator(value: (_index + 1) / _round.length),
          const SizedBox(height: 24),
          Text(
            widget.focus != null ? 'מתרגלים: ${widget.focus!.display}' : 'איזה צליל שמעתם?',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          FilledButton.tonalIcon(
            onPressed: () => TtsService.instance.speakEnglish(answer.display),
            icon: const Icon(Icons.volume_up),
            label: const Text('השמע שוב'),
          ),
          const SizedBox(height: 28),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              childAspectRatio: 1.6,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: choices.map((choice) {
                final isWrong = _wrong.contains(choice.display);
                final isCorrectPick = _correctPick == choice.display;
                final disabled = isWrong || _correctPick != null;

                Color? bg;
                Color? fg;
                if (isCorrectPick) {
                  bg = Colors.green.shade600;
                  fg = Colors.white;
                } else if (isWrong) {
                  bg = Colors.red.shade200;
                  fg = Colors.red.shade900;
                }

                return FilledButton.tonal(
                  style: FilledButton.styleFrom(backgroundColor: bg, foregroundColor: fg),
                  onPressed: disabled ? null : () => _select(choice, answer),
                  child: Text(
                    choice.display,
                    textDirection: TextDirection.ltr,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800),
                  ),
                );
              }).toList(),
            ),
          ),
          Text('${_index + 1} מתוך ${_round.length}'),
        ],
      ),
    );
  }
}

/// Reverse-direction practice: shows a Hebrew letter the child already
/// knows, asks them to pick the closest-matching English letter/blend.
class _HebrewMatchTab extends StatefulWidget {
  const _HebrewMatchTab();

  @override
  State<_HebrewMatchTab> createState() => _HebrewMatchTabState();
}

class _HebrewMatchTabState extends State<_HebrewMatchTab> {
  static const int roundLength = 10;
  static const int choicesPerQuestion = 4;

  late List<HebrewSoundMatch> _round;
  int _index = 0;
  int _correct = 0;
  final Set<String> _wrong = {};
  String? _correctPick;
  List<HebrewSoundMatch>? _cachedChoices;
  int? _cachedForIndex;

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  void _startRound() {
    final shuffled = List.of(AppData.hebrewSoundMatches)..shuffle();
    setState(() {
      _round = shuffled.take(roundLength).toList();
      _index = 0;
      _correct = 0;
      _wrong.clear();
      _correctPick = null;
      _cachedChoices = null;
      _cachedForIndex = null;
    });
  }

  List<HebrewSoundMatch> _choicesFor(HebrewSoundMatch answer) {
    if (_cachedForIndex == _index && _cachedChoices != null) return _cachedChoices!;
    final pool = AppData.hebrewSoundMatches
        .where((m) => m.englishSound != answer.englishSound)
        .toList()
      ..shuffle();
    final choices = <HebrewSoundMatch>[answer, ...pool.take(choicesPerQuestion - 1)]..shuffle();
    _cachedChoices = choices;
    _cachedForIndex = _index;
    return choices;
  }

  Future<void> _select(HebrewSoundMatch choice, HebrewSoundMatch answer) async {
    if (_correctPick != null) return;
    if (choice.englishSound == answer.englishSound) {
      setState(() {
        _correctPick = choice.englishSound;
        _correct++;
      });
      await TtsService.instance.speakEnglish(answer.englishSound);
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 600));
      if (!mounted) return;
      setState(() {
        _index++;
        _wrong.clear();
        _correctPick = null;
        _cachedChoices = null;
      });
    } else {
      setState(() => _wrong.add(choice.englishSound));
      await TtsService.instance.speakHebrew('נסו שוב.');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_index >= _round.length) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('כל הכבוד! 🔤⭐', style: TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text('$_correct מתוך ${_round.length} נכונות'),
              const SizedBox(height: 24),
              FilledButton(onPressed: _startRound, child: const Text('סבב נוסף')),
            ],
          ),
        ),
      );
    }

    final answer = _round[_index];
    final choices = _choicesFor(answer);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(value: (_index + 1) / _round.length),
            const SizedBox(height: 20),
            const Text('איזו אות אנגלית נשמעת הכי דומה?', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Text(
              answer.hebrewLetter,
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.6,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: choices.map((choice) {
                  final isWrong = _wrong.contains(choice.englishSound);
                  final isCorrectPick = _correctPick == choice.englishSound;
                  final disabled = isWrong || _correctPick != null;

                  Color? bg;
                  Color? fg;
                  if (isCorrectPick) {
                    bg = Colors.green.shade600;
                    fg = Colors.white;
                  } else if (isWrong) {
                    bg = Colors.red.shade200;
                    fg = Colors.red.shade900;
                  }

                  return FilledButton.tonal(
                    style: FilledButton.styleFrom(backgroundColor: bg, foregroundColor: fg),
                    onPressed: disabled ? null : () => _select(choice, answer),
                    child: Text(
                      choice.englishSound,
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
                    ),
                  );
                }).toList(),
              ),
            ),
            Text('${_index + 1} מתוך ${_round.length}'),
          ],
        ),
      ),
    );
  }
}
