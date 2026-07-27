#!/usr/bin/env bash
#
# build.sh — render a discovery-recap working folder to a single-page PDF.
#
# Usage:
#   bash build.sh "<outputs>/discovery-recaps/2026-07-27-acme-onepager"
#
# The folder must contain index.html and styles.css (written in Step 5).
# The PDF lands in the same folder as "<folder-name>.pdf".
#
# What it does:
#   1. Starts a local HTTP server on a free port (so relative CSS loads)
#   2. Renders the page to PDF with a headless Chrome/Chromium/Edge browser
#   3. Stops the server, leaving only the PDF behind — no deploy, no hosting
#
# Cross-platform: detects a browser binary across macOS, Linux, and WSL
# rather than hardcoding a path (the brittlest part of the original build).

set -euo pipefail

# ---------- args ----------
WORKDIR="${1:-}"
if [[ -z "$WORKDIR" ]]; then
  echo "ERROR: pass the working folder as the first argument." >&2
  echo "  bash build.sh \"<outputs>/discovery-recaps/{date}-{slug}-onepager\"" >&2
  exit 1
fi
if [[ ! -f "$WORKDIR/index.html" ]]; then
  echo "ERROR: $WORKDIR/index.html not found. Did Step 5 write the folder?" >&2
  exit 1
fi

# Normalize to an absolute path.
WORKDIR="$(cd "$WORKDIR" && pwd)"
SLUG="$(basename "$WORKDIR")"
OUT_PDF="$WORKDIR/$SLUG.pdf"

# ---------- find a browser ----------
find_browser() {
  # 1) explicit override
  if [[ -n "${CHROME_BIN:-}" && -x "${CHROME_BIN}" ]]; then
    echo "$CHROME_BIN"; return 0
  fi
  # 2) anything already on PATH
  local c
  for c in google-chrome google-chrome-stable chromium chromium-browser \
           microsoft-edge microsoft-edge-stable chrome; do
    if command -v "$c" >/dev/null 2>&1; then command -v "$c"; return 0; fi
  done
  # 3) common absolute locations (macOS, Linux, Playwright cache, WSL)
  local p
  for p in \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Microsoft Edge.app/Contents/MacOS/Microsoft Edge" \
    "/opt/pw-browsers/chromium" \
    "/opt/google/chrome/chrome" \
    "/usr/bin/google-chrome" "/usr/bin/chromium" "/usr/bin/chromium-browser" \
    "/snap/bin/chromium" \
    "/mnt/c/Program Files/Google/Chrome/Application/chrome.exe" \
    "/mnt/c/Program Files (x86)/Microsoft/Edge/Application/msedge.exe"; do
    if [[ -x "$p" ]]; then echo "$p"; return 0; fi
  done
  return 1
}

BROWSER="$(find_browser || true)"
if [[ -z "$BROWSER" ]]; then
  echo "ERROR: no Chrome/Chromium/Edge browser found." >&2
  echo "  Install one, or set CHROME_BIN=/path/to/chrome and re-run." >&2
  exit 1
fi

# ---------- python for the local server ----------
PYTHON="$(command -v python3 || command -v python || true)"
if [[ -z "$PYTHON" ]]; then
  echo "ERROR: Python 3 is required to serve the render. Install python3 and re-run." >&2
  exit 1
fi

# ---------- pick a free port ----------
PORT="$("$PYTHON" -c 'import socket;s=socket.socket();s.bind(("127.0.0.1",0));print(s.getsockname()[1]);s.close()')"

# ---------- start server ----------
"$PYTHON" -m http.server "$PORT" --bind 127.0.0.1 --directory "$WORKDIR" >/dev/null 2>&1 &
SERVER_PID=$!
cleanup() { kill "$SERVER_PID" >/dev/null 2>&1 || true; }
trap cleanup EXIT

# Wait for the server to accept connections (up to ~5s).
for _ in $(seq 1 50); do
  if "$PYTHON" -c "import socket,sys; s=socket.socket(); s.settimeout(0.2)
try:
    s.connect(('127.0.0.1', $PORT)); s.close()
except Exception:
    sys.exit(1)" 2>/dev/null; then
    break
  fi
  sleep 0.1
done

# ---------- render ----------
PROFILE="$(mktemp -d)"
trap 'cleanup; rm -rf "$PROFILE"' EXIT

"$BROWSER" \
  --headless=new \
  --disable-gpu \
  --no-sandbox \
  --no-pdf-header-footer \
  --user-data-dir="$PROFILE" \
  --print-to-pdf="$OUT_PDF" \
  --print-to-pdf-no-header \
  "http://127.0.0.1:$PORT/index.html" >/dev/null 2>&1 || {
    # Older Chrome builds reject --headless=new; retry with legacy flag.
    "$BROWSER" \
      --headless \
      --disable-gpu \
      --no-sandbox \
      --user-data-dir="$PROFILE" \
      --print-to-pdf="$OUT_PDF" \
      --print-to-pdf-no-header \
      "http://127.0.0.1:$PORT/index.html" >/dev/null 2>&1
  }

if [[ ! -f "$OUT_PDF" ]]; then
  echo "ERROR: render finished but no PDF was produced at $OUT_PDF." >&2
  exit 1
fi

echo "Built: $OUT_PDF"
