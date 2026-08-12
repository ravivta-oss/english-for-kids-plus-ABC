# English Adventure — Build Ready

This package contains the Flutter source and the companion build files for producing an Android APK.

## What is included
- 4 independent profiles
- 12 worlds / 84 core lesson slots
- local progress storage
- per-word mastery model
- Hebrew + English TTS only; no recorded audio assets
- parent QA dashboard and profile reset
- lesson map, checkpoints and bosses
- Android TTS manifest overlay
- one-click-ish build scripts for Windows and macOS/Linux

## First build on Windows
1. Install Flutter SDK.
2. Install Android Studio and, inside it, Android SDK + Android SDK Command-line Tools.
3. Open a new Command Prompt and run: `flutter doctor`
4. Accept Android licenses if requested: `flutter doctor --android-licenses`
5. Unzip this package.
6. Double-click `BUILD_WINDOWS.bat`.
7. When it finishes, the APK is:
   `build\app\outputs\flutter-apk\app-release.apk`

## First build on macOS/Linux
1. Install Flutter and Android Studio/SDK.
2. Run `flutter doctor` and resolve Android items.
3. In this folder run:
   `./BUILD_MAC_LINUX.sh`
4. APK output:
   `build/app/outputs/flutter-apk/app-release.apk`

## Important
This environment could not run Flutter itself, so the package is prepared for build but has not been compiled here. The build script intentionally runs `flutter analyze` before producing the APK. If it stops, copy the complete terminal error back into ChatGPT and the source can be corrected.

## Android TTS
The build script copies `build_support/android/AndroidManifest.xml` after `flutter create .`. This adds the Android 11+ TTS service query required by the TTS plugin.

## Release signing
`flutter build apk --release` can create a locally installable release APK using the standard generated Android project setup. For Google Play publishing later, create and configure your own upload keystore.
