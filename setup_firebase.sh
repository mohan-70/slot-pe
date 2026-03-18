#!/bin/bash
# Firebase Setup Script for Bookit
# This script helps initialize Firebase with your project credentials
# Run: bash setup_firebase.sh

set -e

echo "================================"
echo "Firebase Setup for Bookit"
echo "================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null
then
    echo -e "${RED}Firebase CLI is not installed${NC}"
    echo "Install it with: npm install -g firebase-tools"
    exit 1
fi

echo -e "${GREEN}✓ Firebase CLI found${NC}"
echo ""

# Step 1: Login
echo -e "${YELLOW}Step 1: Login to Firebase${NC}"
echo "Running: firebase login"
firebase login
echo ""

# Step 2: Initialize project
echo -e "${YELLOW}Step 2: Initialize Firebase Project${NC}"
echo "Running: firebase init"
firebase init
echo ""

# Step 3: Get Project ID
PROJECT_ID=$(grep -o '"default": "[^"]*"' .firebaserc | cut -d'"' -f4)
echo -e "${GREEN}✓ Project ID: $PROJECT_ID${NC}"
echo ""

# Step 4: Deploy rules
echo -e "${YELLOW}Step 3: Deploy Firestore Security Rules${NC}"
read -p "Deploy Firestore rules now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
    firebase deploy --only firestore:rules,firestore:indexes,storage
    echo -e "${GREEN}✓ Rules deployed successfully${NC}"
else
    echo "Skipping rule deployment"
fi
echo ""

# Step 4: Download configuration files
echo -e "${YELLOW}Step 4: Download Configuration Files${NC}"
echo "Go to: https://console.firebase.google.com/project/$PROJECT_ID/settings/serviceaccounts"
echo ""
echo "For Android:"
echo "  1. Click 'Android' app"
echo "  2. Download 'google-services.json'"
echo "  3. Place in: android/app/google-services.json"
echo ""
echo "For iOS:"
echo "  1. Click 'iOS' app"
echo "  2. Download 'GoogleService-Info.plist'"
echo "  3. Place in: ios/Runner/GoogleService-Info.plist"
echo ""

read -p "Press enter once files are downloaded..."
echo ""

# Step 5: Verify setup
echo -e "${YELLOW}Step 5: Verify Setup${NC}"

ANDROID_CONFIG="android/app/google-services.json"
if [ -f "$ANDROID_CONFIG" ]; then
    echo -e "${GREEN}✓ Found: $ANDROID_CONFIG${NC}"
else
    echo -e "${RED}✗ Missing: $ANDROID_CONFIG${NC}"
fi

IOS_CONFIG="ios/Runner/GoogleService-Info.plist"
if [ -f "$IOS_CONFIG" ]; then
    echo -e "${GREEN}✓ Found: $IOS_CONFIG${NC}"
else
    echo -e "${RED}✗ Missing: $IOS_CONFIG${NC}"
fi

FIRESTORE_RULES="firestore.rules"
if [ -f "$FIRESTORE_RULES" ]; then
    echo -e "${GREEN}✓ Found: $FIRESTORE_RULES${NC}"
else
    echo -e "${RED}✗ Missing: $FIRESTORE_RULES${NC}"
fi

echo ""
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}Firebase setup complete!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Next steps:"
echo "1. Update lib/firebase_options.dart with your API keys"
echo "2. Run: flutter pub get"
echo "3. Test the app: flutter run"
echo ""
echo "For detailed instructions, see: FIREBASE_SETUP.md"
