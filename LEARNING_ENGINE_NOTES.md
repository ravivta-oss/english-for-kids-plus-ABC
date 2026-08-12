# English Adventure — Learning Engine Notes

Current lesson policy:

1. Every world contains seven lessons.
2. Every lesson draws from the full vocabulary of that world; there are no one-word lessons.
3. Every lesson contains 12 questions.
4. Passing requires 9/12 correct on the first attempt.
5. A word answered correctly only after a wrong tap does not gain mastery for that question.
6. World 1 uses only its eight animal words.
7. From World 2 onward, 9 questions target the current world and 3 review weak words from prior worlds.
8. Review priority is based on the stored mastery score across listening, recognition, reading and usage.
9. Distractors never use vocabulary from future locked worlds.
10. Connector/function words can carry a Hebrew explanation shown before quizzing while still unfamiliar.

Planned next learning upgrades:
- Build-a-sentence questions.
- Phonics / build-the-word questions.
- Dedicated "Practice for me" screen using weak-word selection.
- Visible mastery progress for children/parents.

## v3 exercise variety
- Added four exercise modes: listening choice, reading choice, phonics/build-the-word, and build-a-sentence.
- World 1 intentionally uses listening + reading + phonics only, so children are not exposed to connector words before they are taught.
- Build-a-sentence begins in World 2 and uses sentence patterns made only from vocabulary already introduced by that point in the course.
- Correct phonics answers increase recognition mastery; correct sentence construction increases usage mastery.
- First-attempt pass gate remains 70% (9/12).


## Grammar / function-word explanations
Pronouns and grammar words that do not map cleanly 1:1 to Hebrew now include child-friendly Hebrew explanations and examples. The lesson introduces them before the quiz, and a 💡 'מה זה?' help button is available whenever such a word appears again.

## Personalized weak-word review / spaced repetition (V5)
- Worlds after World 1 reserve 4 of 12 questions for personalized review.
- Review priority combines low mastery, first-attempt mistakes, time since last exposure, and whether the word is due.
- A first-attempt miss resets the success streak and makes the word immediately eligible for review.
- Clean first-attempt successes schedule the next review after 1, 3, 7, 14, then 30 days.
- Review questions target the learner's weakest skill for that word (listening, reading, recognition/phonics, or usage/sentence building).
- All review history is stored separately per learner profile in SharedPreferences.

## Bonus reinforcement missions (V6)
- When a learner accumulates 10+ weak words, or 5+ weak words that are currently due, the current world shows a ⭐ Bonus Mission.
- The bonus is positive reinforcement, never a failure screen and never blocks the normal path.
- Its 12 questions come from the learner's personalized weak/due bank and target each word's weakest mastery skill.
- Completing the bonus updates the same spaced-repetition history; once the weak/due bank falls below the threshold, the bonus disappears automatically.

## V7 – retrieval retry, smarter bosses, mini-stories
- A first-attempt mistake can schedule the same word 4+ questions later in a different exercise type, so the learner retrieves it again instead of repeating the identical screen.
- Boss lessons now emphasize listening comprehension, sentence construction and (from World 3 onward) short reading-comprehension stories.
- Mini-stories use only vocabulary/structures appropriate to the learner's stage and ask a comprehension question after 2–3 short sentences.
- Retry remains part of normal mastery/spaced-repetition tracking.

## V8 – 24 worlds, 239 words, progressive reading
- Added Worlds 13–24 with exactly 120 new vocabulary items (10 per world).
- Total vocabulary is now 239 unique words.
- Grammar/connective words in later worlds include child-friendly Hebrew explanations.
- Reading comprehension now appears throughout the path from World 3, not only in Boss lessons.
- Reading frequency increases with level: one story slot in Worlds 3–6, two in 7–12, three in 13–18, and four in 19–24.
- Text length grows from 2 simple sentences to 7-sentence passages while reusing previously learned vocabulary and structures.
- Boss lessons continue to emphasize comprehension and sentence construction.
