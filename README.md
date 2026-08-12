# English Adventure — V1 starter

Flutter starter project for the English-learning app specified in the V1 document.

Implemented in this first code drop:
- 4 independent profiles: ילד 1, ילד 2, אבא, אמא
- Local progress persistence with SharedPreferences
- 12-world learning map
- 84 lesson definitions
- First playable lesson flow
- English/Hebrew Text-to-Speech only (no recorded audio)
- Word mastery model: listening / recognition / reading / usage
- Parent dashboard
- Reset profile for QA testing
- Core vocabulary data model and starter vocabulary bank

## Run

1. Install Flutter.
2. From this folder run:
   flutter pub get
   flutter run

Android is the primary V1 target. The project source is platform-neutral; if Android/iOS folders are not present, run:
   flutter create .
before `flutter pub get`.

## Next implementation milestone

Expand the generic lesson engine from the current listen/choose + reading exercises to:
- Picture → Word
- Build Word
- Phonics Blend
- Build Sentence
- Listen & Understand
- Quick Challenge
- adaptive review scheduling

No recorded audio is required. `flutter_tts` switches locale between Hebrew and English.
