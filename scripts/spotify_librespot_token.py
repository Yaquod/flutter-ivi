#!/usr/bin/env python3
"""
Outputs a Spotify access token obtained via librespot (stored AP credentials).
This token has spclient RBAC access that PKCE tokens lack (e.g. Canvas API).

Prints just the token on stdout. Any errors go to stderr.
Exit code 0 on success, 1 on failure.
"""
import sys
import os

CREDS = os.path.expanduser("~/.cache/spotifyd/oauth/credentials.json")

if not os.path.exists(CREDS):
    print("no credentials", file=sys.stderr)
    sys.exit(1)

try:
    import logging
    # Silence librespot's verbose logging
    logging.disable(logging.CRITICAL)

    from librespot.core import Session

    session = Session.Builder() \
        .stored_file(CREDS) \
        .create()

    token = session.tokens().get_token(
        "user-read-playback-state",
        "user-read-currently-playing",
        "playlist-read-private",
    ).access_token

    print(token, end="")
    sys.exit(0)

except Exception as e:
    print(f"librespot error: {e}", file=sys.stderr)
    sys.exit(1)
