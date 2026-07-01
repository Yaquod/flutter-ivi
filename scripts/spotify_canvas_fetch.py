#!/usr/bin/env python3
"""
Fetches a Spotify Canvas URL using librespot's AP session token.
The librespot session has spclient RBAC access that PKCE tokens lack.

Usage: python3 spotify_canvas_fetch.py <track_uri>
Output: prints JSON: {"url": "...", "type": "VIDEO"} or {"url": null}

Credentials are read from ~/.cache/spotifyd/oauth/credentials.json
(written by spotifyd after first login).
"""

import sys
import json
import os
import base64
import struct
import time

CREDS_PATH = os.path.expanduser("~/.cache/spotifyd/oauth/credentials.json")

# ── Protobuf helpers ──────────────────────────────────────────────────────────

def varint(v):
    r = []
    while v >= 0x80:
        r.append((v & 0x7f) | 0x80)
        v >>= 7
    r.append(v)
    return bytes(r)

def encode_canvas_request(track_uri):
    uri = track_uri.encode()
    inner = b"\x0a" + varint(len(uri)) + uri          # EntityCanvaz.entity_uri
    return b"\x0a" + varint(len(inner)) + inner        # EntityCanvazRequest.tracks

def read_varint(data, i):
    result, shift = 0, 0
    while i < len(data):
        b = data[i]; i += 1
        result |= (b & 0x7f) << shift
        shift += 7
        if not (b & 0x80): break
    return result, i

def decode_canvaz(data):
    url, ctype = None, None
    i = 0
    while i < len(data):
        tag, i = read_varint(data, i)
        field, wire = tag >> 3, tag & 0x7
        if wire == 2:
            length, i = read_varint(data, i)
            val = data[i:i+length]; i += length
            if field == 2: url = val.decode("utf-8", errors="replace")
            elif field == 4: ctype = val.decode("utf-8", errors="replace")
        elif wire == 0:
            while i < len(data) and data[i] & 0x80: i += 1
            i += 1
        elif wire == 1: i += 8
        elif wire == 5: i += 4
        else: break
    return url, ctype

def decode_canvas_response(data):
    i = 0
    while i < len(data):
        tag, i = read_varint(data, i)
        field, wire = tag >> 3, tag & 0x7
        if wire == 2:
            length, i = read_varint(data, i)
            val = data[i:i+length]; i += length
            if field == 1:
                url, ctype = decode_canvaz(val)
                if url: return url, ctype
        elif wire == 0:
            while i < len(data) and data[i] & 0x80: i += 1
            i += 1
        elif wire == 1: i += 8
        elif wire == 5: i += 4
        else: break
    return None, None

# ── Main ──────────────────────────────────────────────────────────────────────

def main():
    if len(sys.argv) < 2:
        print(json.dumps({"error": "usage: spotify_canvas_fetch.py <track_uri>"}))
        sys.exit(1)

    track_uri = sys.argv[1]

    if not os.path.exists(CREDS_PATH):
        print(json.dumps({"error": f"no credentials at {CREDS_PATH}"}))
        sys.exit(1)

    with open(CREDS_PATH) as f:
        stored = json.load(f)

    # Convert spotifyd credential format to librespot-python format
    creds_file = "/tmp/librespot_creds.json"
    with open(creds_file, "w") as f:
        json.dump({
            "username": stored["username"],
            "credentials": stored["auth_data"],  # base64 blob
            "type": stored["auth_type"],
        }, f)

    try:
        from librespot.core import Session
        import requests

        session = Session.Builder() \
            .stored_file(creds_file) \
            .create()

        # Get a token with the scopes needed for spclient
        token = session.tokens().get_token(
            "playlist-read-private",
            "user-read-playback-state",
            "user-read-currently-playing",
        ).access_token

    except Exception as e:
        print(json.dumps({"error": f"librespot auth: {e}"}), file=sys.stderr)
        # Fall back to PKCE token from Flutter's storage
        flutter_storage = os.path.expanduser("~/.local/share/flutter_ivi/spotify_tokens.json")
        if os.path.exists(flutter_storage):
            with open(flutter_storage) as f:
                token = json.load(f).get("spotify_access_token")
        else:
            print(json.dumps({"url": None}))
            sys.exit(0)

    if not token:
        print(json.dumps({"url": None}))
        sys.exit(0)

    import urllib.request, urllib.error

    body = encode_canvas_request(track_uri)
    req = urllib.request.Request(
        "https://spclient.wg.spotify.com/canvaz-cache/v0/canvases",
        data=body,
        headers={
            "Authorization": f"Bearer {token}",
            "Content-Type": "application/x-protobuf",
            "Accept": "application/x-protobuf",
            "app-platform": "iOS",
            "Spotify-App-Version": "8.5.49.864",
            "User-Agent": "Spotify/8.5.49 iOS/14.3 (iPhone12,1)",
            "Accept-Language": "en",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req, timeout=8) as resp:
            data = resp.read()
            url, ctype = decode_canvas_response(data)
            print(json.dumps({"url": url, "type": ctype or "UNKNOWN"}))
    except urllib.error.HTTPError as e:
        body_text = e.read().decode("utf-8", errors="replace")
        print(json.dumps({"url": None, "status": e.code, "error": body_text}),
              file=sys.stderr)
        print(json.dumps({"url": None}))
    except Exception as e:
        print(json.dumps({"url": None, "error": str(e)}), file=sys.stderr)
        print(json.dumps({"url": None}))


if __name__ == "__main__":
    main()
