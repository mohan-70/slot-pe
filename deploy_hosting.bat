@echo off
REM Firebase Hosting Deployment Script for Bookit (Windows)
REM This script builds and deploys your Flutter app to Firebase Hosting

echo ================================
echo Building Firebase Hosting Deploy
echo ================================
echo.

REM Step 1: Clean previous builds
echo Step 1: Cleaning previous builds...
call flutter clean
echo Build artifacts cleaned
echo.

REM Step 2: Get dependencies
echo Step 2: Getting dependencies...
call flutter pub get
echo Dependencies installed
echo.

REM Step 3: Build web
echo Step 3: Building web app (this may take 2-3 minutes)...
call flutter build web --release
if errorlevel 1 (
    echo Web build failed
    echo Try running: flutter build web --web-renderer html
    pause
    exit /b 1
)
echo Web build complete
echo.

REM Step 4: Deploy to Firebase
echo Step 4: Deploying to Firebase Hosting...
call firebase deploy --only hosting
if errorlevel 1 (
    echo Deploy failed
    pause
    exit /b 1
)
echo Deployment complete
echo.

REM Step 5: Show hosting URL
echo ================================
echo Deployment Successful!
echo ================================
echo.
echo Your app is now live at:
echo https://slot-pe.web.app
echo.
echo Firebase Console:
echo https://console.firebase.google.com/project/slot-pe/hosting
echo.
pause
