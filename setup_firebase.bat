@echo off
REM Firebase Setup Script for Bookit (Windows)
REM Run: setup_firebase.bat

echo ================================
echo Firebase Setup for Bookit
echo ================================
echo.

REM Check if firebase CLI is installed
firebase --version >nul 2>&1
if errorlevel 1 (
    echo Firebase CLI is not installed
    echo Install it with: npm install -g firebase-tools
    exit /b 1
)

echo Firebase CLI found
echo.

REM Step 1: Login
echo Step 1: Login to Firebase
echo Running: firebase login
call firebase login
echo.

REM Step 2: Initialize project
echo Step 2: Initialize Firebase Project
echo Running: firebase init
call firebase init
echo.

REM Step 3: Deploy rules
echo Step 3: Deploy Firestore Security Rules
set /p deploy="Deploy Firestore rules now? (y/n): "
if /i "%deploy%"=="y" (
    call firebase deploy --only firestore:rules,firestore:indexes,storage
    echo Rules deployed successfully
) else (
    echo Skipping rule deployment
)
echo.

REM Step 4: Download configuration files
echo Step 4: Download Configuration Files
echo.
echo For Android:
echo   1. Go to: https://console.firebase.google.com
echo   2. Select your project
echo   3. Click Android app settings
echo   4. Download 'google-services.json'
echo   5. Place in: android\app\google-services.json
echo.
echo For iOS:
echo   1. Go to: https://console.firebase.google.com
echo   2. Select your project
echo   3. Click iOS app settings
echo   4. Download 'GoogleService-Info.plist'
echo   5. Place in: ios\Runner\GoogleService-Info.plist
echo.

pause

REM Step 5: Verify setup
echo Step 5: Verify Setup
echo.

if exist "android\app\google-services.json" (
    echo Found: android\app\google-services.json
) else (
    echo Missing: android\app\google-services.json
)

if exist "ios\Runner\GoogleService-Info.plist" (
    echo Found: ios\Runner\GoogleService-Info.plist
) else (
    echo Missing: ios\Runner\GoogleService-Info.plist
)

if exist "firestore.rules" (
    echo Found: firestore.rules
) else (
    echo Missing: firestore.rules
)

echo.
echo ================================
echo Firebase setup complete!
echo ================================
echo.
echo Next steps:
echo 1. Update lib/firebase_options.dart with your API keys
echo 2. Run: flutter pub get
echo 3. Test the app: flutter run
echo.
echo For detailed instructions, see: FIREBASE_SETUP.md
echo.
pause
