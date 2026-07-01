// Spotify OAuth relay for Waymo IVI
//
// Deploy with Wrangler:
//   cd cloudflare
//   npm i -g wrangler
//   wrangler kv:namespace create SESSIONS
//   # paste the returned id into wrangler.toml [[kv_namespaces]]
//   wrangler deploy
//
// Then register  https://<worker-domain>/callback  in the Spotify Developer
// Dashboard as a redirect URI, and set SPOTIFY_RELAY_URL in the IVI's .env.

const KV_TTL_SEC = 300; // codes expire after 5 minutes

// ── Spotify-branded response pages ───────────────────────────────────────────

const SUCCESS_HTML = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <title>Spotify Connected</title>
  <style>
    body{margin:0;background:#191414;color:#fff;font-family:-apple-system,
         Helvetica Neue,sans-serif;display:flex;align-items:center;
         justify-content:center;min-height:100vh;text-align:center}
    .check{width:80px;height:80px;background:#1DB954;border-radius:50%;
           display:flex;align-items:center;justify-content:center;
           margin:0 auto 24px;font-size:40px}
    h2{margin:0 0 12px;font-size:26px}
    p{color:#b3b3b3;font-size:16px;margin:0}
  </style>
</head>
<body>
  <div>
    <div class="check">✓</div>
    <h2>Connected to Spotify!</h2>
    <p>You can return to the vehicle screen.</p>
  </div>
  <script>setTimeout(()=>window.close(),2000)</script>
</body>
</html>`;

const errorHtml = (msg) => `<!DOCTYPE html>
<html lang="en">
<head><meta charset="utf-8"><title>Login Failed</title>
<style>body{margin:0;background:#191414;color:#fff;font-family:sans-serif;
     display:flex;align-items:center;justify-content:center;
     min-height:100vh;text-align:center}
h2{color:#e33}</style></head>
<body><div><h2>Login failed</h2><p style="color:#b3b3b3">${msg}</p></div></body>
</html>`;

// ── Main handler ──────────────────────────────────────────────────────────────

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    // CORS pre-flight (IVI polls from a different origin)
    if (request.method === 'OPTIONS') {
      return new Response(null, {
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, OPTIONS',
        },
      });
    }

    // /auth?session=UUID&client_id=…&challenge=…&scope=…
    // QR code on the IVI points here; worker redirects phone to Spotify.
    if (url.pathname === '/auth') {
      const session   = url.searchParams.get('session')   ?? '';
      const clientId  = url.searchParams.get('client_id') ?? '';
      const challenge = url.searchParams.get('challenge') ?? '';
      const scope     = url.searchParams.get('scope')     ?? '';

      if (!session || !clientId || !challenge) {
        return new Response('Bad request', { status: 400 });
      }

      const redirectUri = `https://${url.hostname}/callback`;
      const spotify = new URL('https://accounts.spotify.com/authorize');
      spotify.searchParams.set('client_id',             clientId);
      spotify.searchParams.set('response_type',         'code');
      spotify.searchParams.set('redirect_uri',          redirectUri);
      spotify.searchParams.set('code_challenge_method', 'S256');
      spotify.searchParams.set('code_challenge',        challenge);
      spotify.searchParams.set('scope',                 scope);
      spotify.searchParams.set('state',                 session);

      return Response.redirect(spotify.toString(), 302);
    }

    // /callback?code=…&state=UUID  ← Spotify redirects phone here after login
    if (url.pathname === '/callback') {
      const code    = url.searchParams.get('code');
      const session = url.searchParams.get('state');
      const error   = url.searchParams.get('error');

      if (code && session) {
        await env.SESSIONS.put(session, code, { expirationTtl: KV_TTL_SEC });
        return new Response(SUCCESS_HTML, {
          headers: { 'content-type': 'text/html; charset=utf-8' },
        });
      }

      const msg = error === 'access_denied'
        ? 'You denied access. Try again from the vehicle screen.'
        : `Unexpected error: ${error ?? 'unknown'}`;
      return new Response(errorHtml(msg), {
        status: 400,
        headers: { 'content-type': 'text/html; charset=utf-8' },
      });
    }

    // /poll?session=UUID  ← IVI polls every 2 s for the authorization code
    if (url.pathname === '/poll') {
      const session = url.searchParams.get('session') ?? '';
      const code    = session ? await env.SESSIONS.get(session) : null;
      const json    = code ? { code } : { waiting: true };

      if (code) {
        // Consume the code so it can only be exchanged once
        await env.SESSIONS.delete(session);
      }

      return new Response(JSON.stringify(json), {
        headers: {
          'content-type': 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
      });
    }

    return new Response('Not found', { status: 404 });
  },
};
