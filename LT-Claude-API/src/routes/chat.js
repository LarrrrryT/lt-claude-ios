import express from 'express';
import OpenAI from 'openai';

const router = express.Router();

// Initialize OpenAI client
const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY || process.env.ANTHROPIC_API_KEY
});

// Claude system prompt - simplified version of Friday
const SYSTEM_PROMPT = `You are Claude, an AI assistant created by Anthropic. You're helpful, harmless, and honest.

Current context:
- You're being accessed from a mobile iOS app
- Keep responses concise and mobile-friendly
- Use clear, readable formatting
- Be direct and helpful

Remember: You are Claude, not Friday (that's a different AI). Just be yourself - a helpful, thoughtful AI assistant.`;

// POST /api/chat
router.post('/', async (req, res) => {
  try {
    const { messages, max_tokens = 1024, temperature = 0.7 } = req.body;

    // Validate
    if (!messages || !Array.isArray(messages)) {
      return res.status(400).json({ error: 'messages array required' });
    }

    if (messages.length > 50) {
      return res.status(400).json({ error: 'Too many messages' });
    }

    // Build messages for API
    const apiMessages = [
      { role: 'system', content: SYSTEM_PROMPT },
      ...messages.map(m => ({
        role: m.role === 'user' ? 'user' : 'assistant',
        content: m.content
      }))
    ];

    // Try Claude first, fallback to GPT-4
    let response;
    const useAnthropic = process.env.ANTHROPIC_API_KEY;

    if (useAnthropic) {
      response = await openai.chat.completions.create({
        model: 'claude-sonnet-4-20250514',
        messages: apiMessages,
        max_tokens,
        temperature
      });
    } else {
      response = await openai.chat.completions.create({
        model: 'gpt-4o',
        messages: apiMessages,
        max_tokens,
        temperature
      });
    }

    const content = response.choices[0]?.message?.content || 'Sorry, I had trouble responding.';

    res.json({ content });

  } catch (error) {
    console.error('Chat error:', error);
    
    if (error.status === 401) {
      return res.status(401).json({ error: 'Invalid API key' });
    }
    
    res.status(500).json({ error: 'Failed to get response' });
  }
});

// POST /api/chat/voice - For voice transcription preprocessing
router.post('/voice', async (req, res) => {
  try {
    const { transcript } = req.body;
    
    if (!transcript) {
      return res.status(400).json({ error: 'transcript required' });
    }

    // Simple cleanup of voice transcript
    const cleaned = transcript
      .replace(/\s+/g, ' ')
      .trim();

    res.json({ cleaned });

  } catch (error) {
    console.error('Voice preprocess error:', error);
    res.status(500).json({ error: 'Failed to process voice input' });
  }
});

export default router;
