# Hermes Gateway on Render — Deployment Guide

Free-tier Telegram gateway on Render's infrastructure instead of this phone.
Once deployed: the phone can be off, Termux can be uninstalled, and you can
message from any device.

## What is already done (do not redo)

| File | Purpose |
|---|---|
| `render.yaml` | Render service definition (free worker, Singapore region) |
| `Dockerfile` | Container build — verified: `hermes-agent==0.19.0` installs cleanly on Python 3.13 |
| `SECRETS_TEMPLATE.md` | What to paste where |

## Your steps

### 1. Push the deploy folder to a GitHub repo

Create a repo (private is fine) containing exactly these three files:
```
render.yaml
Dockerfile
SECRETS_TEMPLATE.md   (optional, for reference)
```

### 2. Create the Render service

- Sign in at **render.com** with `mstreamagent@gmail.com`
- **New → Blueprint**
- Select your repo → **Apply**

Render reads `render.yaml` and creates a free `worker` service.

### 3. Add the secrets

Render shows 7 environment variables with no value (all `sync: false`).
On this phone, run:

```
python3 ~/.hermes/deploy/secrets.py --write
```

That writes `~/.hermes/deploy/SECRETS.env` (chmod 600). Paste each value into
the matching Render field. **Never paste secrets into Telegram chat.**

Then delete the file:
```
rm ~/.hermes/deploy/SECRETS.env
```

## 4. Stop the phone gateway

**Important:** only one process may poll the same Telegram bot token. While
both the phone and Render are running, messages will be duplicated or lost.

Once Render's logs show `Gateway started` / it connects successfully:
- Close Termux sessions running `hermes gateway`, or just force-stop Termux
  in Android app settings (the phone process will die on its own otherwise)

## Expected behaviour

| | |
|---|---|
| Free tier | No card, ~750 hrs/month |
| Idle | Sleeps after 15 min without messages |
| Wake | ~60s on the first message after sleeping |
| While chatting | Instant |
| Cost | $0 |

## Cost note

If the 60-second wake becomes annoying, Render's **Starter worker is $7/month**
and never sleeps. Start free; upgrade only if you feel it.

## Troubleshooting

**Bot replies to the old phone instance →** two pollers on one token. Stop the
phone gateway.

**Build fails on `pip install hermes-agent==0.19.0` →** check Render used
Python 3.13. The package requires `>=3.11,<3.14`; 3.14 will not resolve.

**Gateway starts but no replies →** check Render's log pane for Telegram auth
errors, and confirm `TELEGRAM_ALLOWED_USERS` matches your numeric user ID.