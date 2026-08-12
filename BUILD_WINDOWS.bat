@echo off
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
  echo Flutter was not found in PATH.
  echo Install Flutter and Android Studio first, then reopen this folder.
  pause
  exit /b 1
)
if not exist android (
  echo Creating Android platform files...
  flutter create --platforms=android .
)
copy /Y build_support\android\AndroidManifest.xml android\app\src\main\AndroidManifest.xml >nul
echo Getting packages...
call flutter pub get
if errorlevel 1 goto :fail
echo Checking project...
call flutter analyze
if errorlevel 1 goto :fail
echo Building release APK...
call flutter build apk --release
if errorlevel 1 goto :fail
echo.
echo DONE
echo APK:
echo %CD%\build\app\outputs\flutter-apk\app-release.apk
pause
exit /b 0
:fail
echo.
echo Build failed. Copy the error text and send it to ChatGPT.
pause
exit /b 1
