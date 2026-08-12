import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class ProgressStore {
  ProgressStore._();
  static final instance = ProgressStore._();
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String _lessonKey(String profileId) => 'completed_lessons_$profileId';
  String _masteryKey(String profileId) => 'mastery_$profileId';
  String _reviewKey(String profileId) => 'review_$profileId';
  String _storyKey(String profileId) => 'completed_stories_$profileId';

  Set<int> completedLessons(String profileId) {
    final raw = _prefs.getStringList(_lessonKey(profileId)) ?? [];
    return raw.map(int.parse).toSet();
  }

  bool isLessonCompleted(String profileId, int lessonId) =>
      completedLessons(profileId).contains(lessonId);

  Future<void> completeLesson(String profileId, int lessonId) async {
    final values = completedLessons(profileId)..add(lessonId);
    await _prefs.setStringList(
      _lessonKey(profileId),
      values.map((e) => e.toString()).toList()..sort(),
    );
  }

  // ── Mini-story completion ──────────────────────────────────────────
  //
  // A world's mini-story (if it has one) must be read and its
  // comprehension question(s) answered correctly before the NEXT world
  // unlocks — same spirit as the lesson pass-gate, applied to reading.
  Set<int> completedStories(String profileId) {
    final raw = _prefs.getStringList(_storyKey(profileId)) ?? [];
    return raw.map(int.parse).toSet();
  }

  bool isStoryCompleted(String profileId, int world) =>
      completedStories(profileId).contains(world);

  Future<void> completeStory(String profileId, int world) async {
    final values = completedStories(profileId)..add(world);
    await _prefs.setStringList(
      _storyKey(profileId),
      values.map((e) => e.toString()).toList()..sort(),
    );
  }

  Map<String, dynamic> _mastery(String profileId) {
    final raw = _prefs.getString(_masteryKey(profileId));
    return raw == null ? <String, dynamic>{} : jsonDecode(raw);
  }

  int mastery(String profileId, String wordId, MasteryType type) {
    final all = _mastery(profileId);
    final word = (all[wordId] as Map?)?.cast<String, dynamic>() ?? {};
    return (word[type.name] as num?)?.toInt() ?? 0;
  }

  Future<void> bumpMastery(
    String profileId,
    String wordId,
    MasteryType type, {
    int delta = 1,
  }) async {
    final all = _mastery(profileId);
    final word = (all[wordId] as Map?)?.cast<String, dynamic>() ?? {};
    final current = (word[type.name] as num?)?.toInt() ?? 0;
    word[type.name] = (current + delta).clamp(0, 3);
    word['lastSeen'] = DateTime.now().toIso8601String();
    all[wordId] = word;
    await _prefs.setString(_masteryKey(profileId), jsonEncode(all));
  }

  // ── Spaced repetition (Leitner system) with a weak-word priority ───
  //
  // Each learned word sits in a "box" (0-5). A correct review pushes it
  // up a box and pushes its next-due date further into the future; a
  // wrong review drops it straight back to box 0 (due again tomorrow).
  // Alongside that, every review attempt is tallied so we can identify
  // "chronically weak" words — ones that get missed disproportionately
  // often — regardless of whether they happen to be due right now.
  static const List<int> _intervalDays = [1, 2, 4, 7, 14, 30];

  Map<String, dynamic> _reviews(String profileId) {
    final raw = _prefs.getString(_reviewKey(profileId));
    return raw == null ? <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
  }

  Future<void> _saveReviews(String profileId, Map<String, dynamic> reviews) async {
    await _prefs.setString(_reviewKey(profileId), jsonEncode(reviews));
  }

  /// Call this whenever a word is answered — correctly or not — on the
  /// first attempt of a question, to schedule when it should come back
  /// for review and to update its long-term weak/strong tally.
  Future<void> recordReview(String profileId, String wordId, bool correct) async {
    final reviews = _reviews(profileId);
    final entry = (reviews[wordId] as Map?)?.cast<String, dynamic>() ??
        {'box': 0, 'attempts': 0, 'misses': 0};
    var box = (entry['box'] as num?)?.toInt() ?? 0;
    final attempts = ((entry['attempts'] as num?)?.toInt() ?? 0) + 1;
    final misses = ((entry['misses'] as num?)?.toInt() ?? 0) + (correct ? 0 : 1);

    box = correct ? (box + 1).clamp(0, _intervalDays.length - 1) : 0;

    final next = DateTime.now().add(Duration(days: _intervalDays[box]));
    reviews[wordId] = {
      'box': box,
      'next': next.toIso8601String(),
      'attempts': attempts,
      'misses': misses,
    };
    await _saveReviews(profileId, reviews);
  }

  /// Word ids due for review right now, ordered by priority rather than
  /// just how overdue they are: among due words, weaker words (lower
  /// box, higher miss ratio) come first, since those are the ones most
  /// at risk of being forgotten.
  List<String> dueWordIds(String profileId, {int limit = 15}) {
    final reviews = _reviews(profileId);
    final now = DateTime.now();
    final due = <MapEntry<String, Map<String, dynamic>>>[];

    reviews.forEach((wordId, value) {
      final map = (value as Map).cast<String, dynamic>();
      final next = DateTime.tryParse(map['next'] as String? ?? '');
      if (next != null && !next.isAfter(now)) {
        due.add(MapEntry(wordId, map));
      }
    });

    due.sort((a, b) {
      final boxA = (a.value['box'] as num?)?.toInt() ?? 0;
      final boxB = (b.value['box'] as num?)?.toInt() ?? 0;
      if (boxA != boxB) return boxA.compareTo(boxB); // weaker box first
      final missRatioA = _missRatio(a.value);
      final missRatioB = _missRatio(b.value);
      return missRatioB.compareTo(missRatioA); // higher miss ratio first
    });

    return due.take(limit).map((e) => e.key).toList();
  }

  double _missRatio(Map<String, dynamic> entry) {
    final attempts = (entry['attempts'] as num?)?.toInt() ?? 0;
    final misses = (entry['misses'] as num?)?.toInt() ?? 0;
    if (attempts == 0) return 0;
    return misses / attempts;
  }

  int dueCount(String profileId) => dueWordIds(profileId, limit: 100000).length;

  /// Chronically weak words — a high miss ratio across enough attempts to
  /// be meaningful — regardless of whether they're formally "due" today.
  /// This powers the automatic bonus-practice suggestion after a lesson.
  List<String> weakWordIds(String profileId, {int limit = 8, int minAttempts = 2}) {
    final reviews = _reviews(profileId);
    final candidates = <MapEntry<String, double>>[];

    reviews.forEach((wordId, value) {
      final map = (value as Map).cast<String, dynamic>();
      final attempts = (map['attempts'] as num?)?.toInt() ?? 0;
      if (attempts < minAttempts) return;
      final ratio = _missRatio(map);
      if (ratio > 0) {
        candidates.add(MapEntry(wordId, ratio));
      }
    });

    candidates.sort((a, b) => b.value.compareTo(a.value));
    return candidates.take(limit).map((e) => e.key).toList();
  }

  Future<void> resetProfile(String profileId) async {
    await _prefs.remove(_lessonKey(profileId));
    await _prefs.remove(_masteryKey(profileId));
    await _prefs.remove(_reviewKey(profileId));
    await _prefs.remove(_storyKey(profileId));
  }
}
