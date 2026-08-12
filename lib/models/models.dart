enum MasteryType { listening, recognition, reading, usage }

class LearnerProfile {
  final String id;
  final String name;
  final String emoji;
  const LearnerProfile(this.id, this.name, this.emoji);
}

class VocabWord {
  final String id;
  final String english;
  final String hebrew;
  final String category;
  final int world;
  final List<String> examples;
  final List<String> phonics;
  // For function/connector words (is, a, am, are...) that have no clean
  // 1:1 Hebrew translation. When set, the lesson shows this explanation
  // BEFORE quizzing the child on the word.
  final String? explanation;

  const VocabWord({
    required this.id,
    required this.english,
    required this.hebrew,
    required this.category,
    required this.world,
    this.examples = const [],
    this.phonics = const [],
    this.explanation,
  });
}

class Lesson {
  final int id;
  final int world;
  final int indexInWorld;
  final String title;
  final List<String> focusWordIds;
  final bool checkpoint;
  final bool boss;
  // Full example sentences (using only vocabulary taught up to this
  // lesson) used by the "Build a Sentence" exercise type. When empty,
  // that exercise type is simply skipped for this lesson.
  final List<String> sentenceBank;

  const Lesson({
    required this.id,
    required this.world,
    required this.indexInWorld,
    required this.title,
    this.focusWordIds = const [],
    this.checkpoint = false,
    this.boss = false,
    this.sentenceBank = const [],
  });
}

class World {
  final int id;
  final String title;
  final String emoji;
  final String goal;
  const World(this.id, this.title, this.emoji, this.goal);
}

/// A single lowercase letter with a Hebrew hint about the sound it makes
/// and an example word, used by the standalone ABC practice track. This
/// is intentionally separate from VocabWord/Lesson — it never affects
/// word mastery, lesson pass/fail, or world unlocking. It's pure letter
/// foundation practice, for kids who need it before the word exercises
/// (especially "Build the Word") make sense.
class AlphabetLetter {
  final String letter; // always lowercase — that's how words appear in-app
  final String soundHint; // Hebrew description of the sound
  final String exampleWord;
  const AlphabetLetter({
    required this.letter,
    required this.soundHint,
    required this.exampleWord,
  });
}

/// A multi-letter English sound (sh, ck, th...) that doesn't map to a
/// single alphabet letter but is common enough in early reading to teach
/// directly alongside the 26 letters.
class SoundBlend {
  final String blend; // e.g. 'sh'
  final String soundHint;
  final String exampleWord;
  const SoundBlend({
    required this.blend,
    required this.soundHint,
    required this.exampleWord,
  });
}

/// Reverse-direction practice: starting from a Hebrew letter the child
/// already knows, find the closest-matching English letter or sound
/// blend. This is a practical bridge for beginners, not a precise
/// linguistic equivalence.
class HebrewSoundMatch {
  final String hebrewLetter;
  final String englishSound; // a single letter or a blend like 'sh'
  final String exampleWord;
  const HebrewSoundMatch({
    required this.hebrewLetter,
    required this.englishSound,
    required this.exampleWord,
  });
}

/// A single Hebrew comprehension question about a story, with 3 Hebrew
/// answer options.
class ComprehensionQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  const ComprehensionQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

/// A very short mini-story (2-3 English sentences) that only uses
/// vocabulary already taught up to [world], followed by comprehension
/// questions in Hebrew. This is a bonus reading activity — it never
/// blocks lesson/world progression the way passing a lesson does.
class Story {
  final int world;
  final String title;
  final List<String> sentences;
  final List<ComprehensionQuestion> questions;
  const Story({
    required this.world,
    required this.title,
    required this.sentences,
    required this.questions,
  });
}
