#!/usr/bin/env bash
# kodi-rpc.sh — JSON-RPC calls for Kodi 21 (Omega)
#
# Kodi setup (Settings > Services > Control):
#   - Enable "Allow remote control via HTTP"
#   - Enable "Allow remote control from applications on other systems"
#   - Default port: 8080
#   - Set KODI_USER / KODI_PASS below if you enabled authentication

KODI_HOST="${KODI_HOST:-192.168.0.209}"
KODI_PORT="${KODI_PORT:-8080}"
KODI_USER="${KODI_USER:-kodi}"
KODI_PASS="${KODI_PASS:-kodi}"
KODI_URL="http://$KODI_HOST:$KODI_PORT/jsonrpc"

# Build auth flag only if credentials are set
_auth_flag() {
    if [[ -n $KODI_USER && -n $KODI_PASS ]]; then
        echo "-u $KODI_USER:$KODI_PASS"
    fi
}

# Base request function
kodi_request() {
    curl -s \
        $(_auth_flag) \
        -H "Content-Type: application/json" \
        -d "$1" \
        "$KODI_URL" | jq .
}

# --- Ping / version check ---
kodi_ping() {
    kodi_request '{
        "jsonrpc": "2.0",
        "method": "JSONRPC.Version",
        "id": 1
    }'
}

# --- Open a URL for playback ---
kodi_open() {
    local url="$1"
    kodi_request "{
        \"jsonrpc\": \"2.0\",
        \"method\": \"Player.Open\",
        \"params\": {
            \"item\": { \"file\": \"$url\" }
        },
        \"id\": 1
    }"
}

# --- Playback controls ---
kodi_play_pause() {
    kodi_request '{
        "jsonrpc": "2.0",
        "method": "Player.PlayPause",
        "params": { "playerid": 1 },
        "id": 1
    }'
}

kodi_stop() {
    kodi_request '{
        "jsonrpc": "2.0",
        "method": "Player.Stop",
        "params": { "playerid": 1 },
        "id": 1
    }'
}

# --- Volume ---
kodi_vol() {
    local level="$1"  # 0-100
    kodi_request "{
        \"jsonrpc\": \"2.0\",
        \"method\": \"Application.SetVolume\",
        \"params\": { \"volume\": $level },
        \"id\": 1
    }"
}

# --- Get currently playing item ---
kodi_now_playing() {
    kodi_request '{
        "jsonrpc": "2.0",
        "method": "Player.GetItem",
        "params": {
            "playerid": 1,
            "properties": ["title", "file", "runtime"]
        },
        "id": 1
    }'
}

# --- Dispatch ---
case "$1" in
    ping)         kodi_ping ;;
    open)         kodi_open "$2" ;;
    play|pause)   kodi_play_pause ;;
    stop)         kodi_stop ;;
    vol)          kodi_vol "$2" ;;
    now)          kodi_now_playing ;;
    *)
        echo "Usage: $0 {ping|open <url>|play|stop|vol <0-100>|now}"
        echo ""
        echo "Environment variables:"
        echo "  KODI_HOST  — Kodi device IP    (default: 192.168.0.201)"
        echo "  KODI_PORT  — Kodi port          (default: 8080)"
        echo "  KODI_USER  — HTTP auth username (optional)"
        echo "  KODI_PASS  — HTTP auth password (optional)"
        exit 1
        ;;
esac
