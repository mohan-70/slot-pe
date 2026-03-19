#!/bin/bash
# Firebase Hosting Deployment Script for Bookit
# This script builds and deploys your Flutter app to Firebase Hosting

echo "================================"
echo "Building Firebase Hosting Deploy"
echo "================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Step 1: Clean previous builds
echo -e "${YELLOW}Step 1: Cleaning previous builds...${NC}"
flutter clean
echo -e "${GREEN}✓ Cleaned${NC}"
echo ""

# Step 2: Get dependencies
echo -e "${YELLOW}Step 2: Getting dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

# Step 3: Build web
echo -e "${YELLOW}Step 3: Building web app (this may take 2-3 minutes)...${NC}"
flutter build web --release
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Web build failed${NC}"
    echo "Try running: flutter build web --web-renderer html"
    exit 1
fi
echo -e "${GREEN}✓ Web build complete${NC}"
echo ""

# Step 4: Deploy to Firebase
echo -e "${YELLOW}Step 4: Deploying to Firebase Hosting...${NC}"
firebase deploy --only hosting
if [ $? -ne 0 ]; then
    echo -e "${RED}✗ Deploy failed${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Deployment complete${NC}"
echo ""

# Step 5: Show hosting URL
PROJECT_ID=$(grep -o '"default": "[^"]*"' .firebaserc | cut -d'"' -f4)
echo -e "${GREEN}================================${NC}"
echo -e "${GREEN}✓ Deployment Successful!${NC}"
echo -e "${GREEN}================================${NC}"
echo ""
echo "Your app is now live at:"
echo "https://${PROJECT_ID}.web.app"
echo ""
echo "Firebase Console:"
echo "https://console.firebase.google.com/project/${PROJECT_ID}/hosting"
echo ""
