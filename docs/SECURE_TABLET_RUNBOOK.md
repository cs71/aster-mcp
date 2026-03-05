# Aster Secure Tablet Runbook (Chad)

## Goal
Use Aster on a dedicated tablet with high utility and reduced compromise risk.

## 1) Host-side hardening (required)

- Use hardened fork: `cs71/aster-mcp`
- Keep MCP/API bound to localhost only (`BIND_HOST=127.0.0.1`)
- Require API bearer token (`API_TOKEN`)
- Require device websocket token (`DEVICE_AUTH_TOKEN`)
- Keep token prefill disabled (`ALLOW_TOKEN_PREFILL=false`)
- Prefer Tailscale for remote access; avoid exposing LAN/public ports directly

### Start command
From `mcp/` directory:

```bash
npm run build
node dist/src/index.js
```

(Uses values from `mcp/.env`.)

## 2) Tablet install profile (minimum-risk first)

Install Aster only on a dedicated tablet (not personal phone).

### Enable now (required for core control)
- Accessibility Service (Aster)
- Ignore battery optimization for Aster
- Notification permission (optional but useful)

### Enable only when needed
- SMS (READ/SEND/RECEIVE)
- Phone calls
- Contacts
- Camera
- Files / All files access
- Location
- Overlay (SYSTEM_ALERT_WINDOW)

## 3) Runtime safety rules

- Keep tablet screen lock enabled
- Keep OS updated
- Do not log into sensitive personal apps on this tablet unless necessary
- Revoke permissions not actively needed
- If behavior looks odd, disconnect tablet and rotate both tokens immediately

## 4) Token rotation

When rotating:
1. Stop server
2. Regenerate `API_TOKEN` and `DEVICE_AUTH_TOKEN` in `mcp/.env`
3. Restart server
4. Reconnect tablet with new device token

## 5) Verification checklist

- `curl http://127.0.0.1:<api-port>/api/health` without auth returns `401`
- Same with bearer token returns `200`
- `/mcp` without auth returns `401`
- `/api/openclaw/prefill-token` returns `403` by default
- `ss -ltnp` shows listeners on `127.0.0.1` only

## 6) If you suspect compromise

- Stop Aster server immediately
- Uninstall Aster from tablet
- Rotate tokens
- Remove unneeded tablet permissions
- Review recent logs and connected-device history
