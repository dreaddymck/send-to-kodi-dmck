#!/usr/bin/env bash

#TODO: Create web application support
#TODO: option in application to change IPTV playlist
#TODO: Android arm yt-dlp encoding not working properly

# SCRIPTNAME=$(basename "$0")
SEND_TO_KODI_TMP=$(dirname $(mktemp -u))
SEND_TO_KODI_PWD=$(pwd)
SEND_TO_KODI_DIR="$(dirname "$(readlink -f "$0")")"
SEND_TO_KODI_HISTORY=$HOME/.config/send_to_kodi/.send_to_kodi_history
source "$SEND_TO_KODI_DIR/lib/maintenance"
source "$SEND_TO_KODI_DIR/lib/requirements"
source "$SEND_TO_KODI_DIR/lib/config"
source "$SEND_TO_KODI_DIR/lib/logo"
source "$SEND_TO_KODI_DIR/lib/banner"
source "$SEND_TO_KODI_DIR/lib/about"
source "$SEND_TO_KODI_DIR/lib/server"
source "$SEND_TO_KODI_DIR/lib/dlrz/ytdl-dlrz"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_channels"
source "$SEND_TO_KODI_DIR/lib/iptv/iptv_main"
source "$SEND_TO_KODI_DIR/lib/kodi/kodi_requests"
source "$SEND_TO_KODI_DIR/lib/main"
source "$SEND_TO_KODI_DIR/lib/start"

HISTFILE=$SEND_TO_KODI_HISTORY
HISTCONTROL=ignoreboth
shopt -s histappend

if [ ! -d "$DOWNLOAD_DIR" ]; then
    echo "Invalid download directory, update DOWNLOAD_DIR in $SEND_TO_KODI_CONF."
fi

# Load ytdl environment,
# Bypass $REMOTE check
# Default to tmp directory
if [[ "$INPUT" =~ ^(dlrz|dl|rz)$ ]]; then
    unset INPUT
    cd "$SEND_TO_KODI_TMP" && ytdl_dlrz
    exit
fi

[[ $REMOTE ]] || error "Remote address NOT specified, see --help"
send_to_kodi_banner
main
