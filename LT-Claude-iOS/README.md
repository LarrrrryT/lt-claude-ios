# LT Claude iOS App

A mobile iOS chat interface for Claude AI with walkie-talkie voice mode (coming soon).

## Features

- 💬 Real-time chat with Claude
- 🎙️ Voice input support (coming soon)
- 📱 Optimized for iPhone
- 🔄 Auto-reconnect
- 🔒 Local API key storage

## Setup

### Prerequisites

- macOS with Xcode 15+
- Homebrew
- Apple Developer Account ($99/year)

### iOS App Setup

```bash
# Navigate to project
cd LT-Claude-iOS

# Install dependencies
brew install xcodegen fastlane

# Generate Xcode project
xcodegen generate

# Open in Xcode
open LT-Claude-iOS.xcodeproj
```

### API Backend Setup (Railway)

```bash
# Navigate to API
cd LT-Claude-API

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your API keys
# - ANTHROPIC_API_KEY or OPENAI_API_KEY
```

### Deploy to Railway

1. Install Railway CLI: `npm i -g @railway/cli`
2. Login: `railway login`
3. Initialize: `railway init`
4. Set environment variables in Railway dashboard
5. Deploy: `railway up`

### Deploy to TestFlight

1. Set up Fastlane Match (for code signing):
   ```bash
   brew install fastlane
   fastlane match init
   ```

2. Configure secrets in GitHub:
   - `DEVELOPMENT_TEAM_ID` - Your Apple Team ID
   - `APPLE_ID` - Your Apple ID email
   - `APP_STORE_CONNECT_API_KEY` - App Store Connect API key (base64 encoded)

3. Push to main → GitHub Actions builds & deploys

## Environment Variables

### iOS App

Stored in UserDefaults on device:
- `claude_api_key` - Your Anthropic API key

### Backend API

```env
PORT=8080
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
ANTHROPIC_API_KEY=sk-ant-api-key...
OPENAI_API_KEY=sk-...
```

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   iOS App       │────▶│   Railway API   │────▶│   Claude API    │
│   (SwiftUI)     │     │   (Node.js)     │     │   (Anthropic)  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

## Future Features

- 🎤 Real-time walkie-talkie voice mode
- 🔔 Push notifications
- 📲 Apple Watch companion app
- 🏠 HomeKit integration

## License

MIT
