# Render Secrets — what to paste where

All 7 values come from this phone. Generate the real ones with:

```
python3 ~/.hermes/deploy/secrets.py --write
```

That writes `~/.hermes/deploy/SECRETS.env` (chmod 600). Copy from there into
Render's dashboard, then delete the file.

**Never paste these into Telegram chat.** That is how the Gmail password and
the Gemini key leaked earlier.

| Render env var | What it is |
|---|---|
| `TELEGRAM_BOT_TOKEN` | Bot token from @BotFather — required |
| `TELEGRAM_ALLOWED_USERS` | Your numeric Telegram user ID — restricts who can command the bot |
| `TELEGRAM_HOME_CHANNEL` | Home channel ID for proactive messages |
| `GEMINI_API_KEY` | Google AI Studio — fallback provider 1 |
| `GROQ_API_KEY` | Groq — fallback provider 2 |
| `NVIDIA_API_KEY` | NVIDIA NIM — fallback provider 3 |
| `EXA_API_KEY` | Exa — web research / search |

Plus, already given defaults in `render.yaml` (no action needed):
- `HERMES_MAX_TURNS=400`
- `PYTHONUNBUFFERED=1`

## If the Render gateway forgets everything on restart

Free-tier workers have an ephemeral filesystem. Conversations and skills will
reset. To persist them, add a disk and point `HOME` at it — Render Starter
plan ($7/mo) supports persistent disks; the free plan does not.

For most chat use that is fine: Telegram keeps the message history, the agent
rebuilds context each time.

## Version note

The container installs `hermes-agent==0.19.0` from PyPI — the newest published
version as of 2026-10-04. The build running on the phone is 0.20.6, which is
not yet on PyPI. If 0.20.6 is published before you deploy, update the pin in
`Dockerfile`.