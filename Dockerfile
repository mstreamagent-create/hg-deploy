# Dockerfile for the Hermes Telegram gateway on Render (free tier).
#
# ── VERSION NOTE (checked 2026-10-04 against PyPI) ──────────────────────
# PyPI's newest hermes-agent is 0.19.0. The build installed on this phone is
# 0.20.6, which is NOT on PyPI yet. Pinning 0.20.6 makes `pip install` fail
# with "No matching distribution found", so this image pins the newest version
# that actually exists and is installable: 0.19.0.
#
# 0.19.0 declares requires_python >=3.11,<3.14 -> Python 3.13 is correct.
# It ships a py3-none-any wheel (9.9 MB) plus an sdist, so no build step is
# needed for the package itself. build-essential stays in the image because a
# few transitive dependencies still publish sdists only.
#
# ── WHY install from PyPI instead of copying the local tree ─────────────
# The Termux install is an aarch64 Android build with Android-specific
# constraints. Docker builds x86_64 Linux. Reusing the same Dockerfile as
# upstream would drag in Termux specifics. PyPI is the portable path.

FROM python:3.13-slim-bookworm

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    HOME=/app

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git ca-certificates curl build-essential && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# 0.19.0 = newest on PyPI. Bump deliberately, never float to latest.
RUN pip install "hermes-agent==0.19.0"

# Hermes keeps all state under ~/.hermes (skills, sessions, memory, logs).
RUN mkdir -p /app/.hermes

# Telegram long-polling is outbound only: no EXPOSE, no inbound port.
# Credentials arrive as environment variables injected by Render.
CMD ["hermes", "gateway"]