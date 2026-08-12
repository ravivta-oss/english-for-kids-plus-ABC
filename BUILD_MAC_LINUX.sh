#!/usr/bin/env bash
set -e
if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter was not found in PATH. Install Flutter and Android Studio first."
  exit 1
fi
if [ ! -d android ]; then
  flutter create --platforms=android .
fi
cp build_support/android/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
flutter pub get
flutter analyze
flutter build apk --release
echo "DONE: $(pwd)/build/app/outputs/flutter-apk/app-release.apk"
