#!/bin/bash

# LT Claude iOS Setup Script
# Run this to initialize the project

set -e

echo "🚀 LT Claude iOS Setup"
echo "======================"

# Check for Homebrew
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Install from https://brew.sh"
    exit 1
fi

# Install dependencies
echo "📦 Installing dependencies..."
brew install xcodegen fastlane

# Generate Xcode project
echo "🔨 Generating Xcode project..."
xcodegen generate

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Open LT-Claude-iOS.xcodeproj in Xcode"
echo "2. Set your Development Team in Signing & Capabilities"
echo "3. Update ChatManager.swift with your API base URL"
echo "4. Build and run on simulator or device"
echo ""
echo "For TestFlight deployment, see README.md"
