# LT Claude - Mobile AI Companion

An iOS app + backend API for chatting with Claude AI, with walkie-talkie voice mode (coming soon).

## Quick Start

### 1. Backend (Railway)

```bash
cd LT-Claude-API
npm install
cp .env.example .env
# Edit .env with your ANTHROPIC_API_KEY
railway up
```

### 2. iOS App

```bash
cd LT-Claude-iOS
./setup.sh
open LT-Claude-iOS.xcodeproj
```

## Project Structure

```
lt-claude/
├── LT-Claude-iOS/          # iOS SwiftUI app
│   ├── Sources/             # App code
│   ├── Resources/           # Assets, Info.plist
│   ├── fastlane/            # TestFlight deployment
│   └── .github/workflows/   # CI/CD
│
└── LT-Claude-API/           # Node.js backend
    ├── src/
    │   ├── index.js         # Express server
    │   └── routes/chat.js   # Claude API integration
    └── railway.json         # Railway config
```

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `GET /health` | GET | Health check |
| `POST /api/chat` | POST | Send message to Claude |
| `POST /api/chat/voice` | POST | Preprocess voice transcript |

## Environment Variables

### Backend (.env)

```env
PORT=8080
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
ALLOWED_ORIGINS=http://localhost:3000,http://localhost:8080
```

### iOS

Stored in UserDefaults:
- `claude_api_key` - Your Anthropic API key (optional, can use backend)

## Deployment

### Railway

```bash
cd LT-Claude-API
railway init
railway up
```

### TestFlight

1. Set GitHub secrets:
   - `DEVELOPMENT_TEAM_ID`
   - `APPLE_ID`
   - `APP_STORE_CONNECT_API_KEY`

2. Push to `main` branch

3. GitHub Actions builds & deploys automatically

## Future Features

- 🎤 Real-time walkie-talkie voice mode
- 🔔 Push notifications
- 📲 Apple Watch companion
- 🏠 HomeKit integration

## License

MIT
