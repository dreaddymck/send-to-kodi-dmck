# Send to Kodi DMCK

Github projects forked and merged into this abomination.

* https://github.com/allejok96/send-to-kodi
* https://github.com/shahin8r/iptv

Provides the following services

* Send compatible yt-dlp/youtube-dl streams to Kodi.
* Send compatible local media to Kodi.
* Download/Resize mp4 to local or ssh storage
* MPEG-DASH (high quality video) support - (__Work In Progress__)
* IPTV m3u playlist interface, send iptv to kodi (__Work In Progress__)

*Note: Kodi add-ons may be required for proprietory media streams.*

## Installation

1. In Kodi, enable *System > Servicies > Web server > Allow remote control via HTTP*.
2. Install on your Kodi box:

   * `InputStream.Adaptive` to enable MPEG-DASH support.
   * *Kodi add-ons* for proprietory media support.

3. Install to your Linux environment:

   * `yt-dlp`           to add support for hundreds of video sites.
   * `jq`               JSON Processing
   * `ffmpeg`           media manipulation
   * `fzf`              required for iptv interface - https://github.com/junegunn/fzf
   * `python-twisted`   to enable local file sharing and MPEG-DASH support (optional). Environment variables: TWISTED_PATH - Path to python-twisted webserver
   * `PhantomJS`        Scriptable Headless Browser (optional)

4. Edit config file $HOME/.config/send_to_kodi/config to customize default settings:

   ```bash
   #!/usr/bin/env bash
   VERBOSE=0 # display debug activities 0/1
   DOWNLOAD_DIR=.~/
   KODI_YOUTUBE=0
   SEND_RAW=0
   REMOTE="kodibox:8080"
   LOGIN="username:password"
   HOST_NAME="$(hostname -i )"
   SHARE_PORT=8080
   USER_AGENT="Mozilla/5.0 (Android 14; Mobile; rv:68.0) Gecko/68.0 Firefox/128.0"
   VCODEC="h264"
   RESOLUTION_JSON='[
      {"res":"360", "value" : ["twitch.tv","youtube.com"]}
   ]' # resolution height priority per domain.
   VOLUME_AMP_STEPS=5 #volume amplification steps up/down default 5
   LISTFORMATS=0
   MODE="default" #values: default/stream

   #For DLRZ (download/resize to local/ssh storage)
   REMOTE_SSH=""
   REMOTE_PATH=""
   LIMIT_RATE="2000K"
   UPDATECMD="yt-dlp -U"
   ```

5. Run it from the command line:

   ```bash
   ./send-to-kodi.sh -r kodibox:8080 -u user:pass https://vimeo.com/174312494
   ```

6. Edit `send-to-kodi.desktop` add your credentials then copy it to your user folder (optional):

   ```bash
   chmod 600 send-to-kodi.desktop
   mkdir -p ~/.local/bin ~/.local/share/applications
   cp send-to-kodi.sh ~/.local/bin/send-to-kodi
   cp send-to-kodi.desktop ~/.local/share/applications/
   ```

7. Options:

   ```text
   -d DIRECTORY           Temporary download directory for high quality streaming
   -l PORT                Local port number used for file sharing (default 8080)
   -r HOST:PORT           Kodi remote address
   -u USERNAME:PASSWORD   Kodi login credentials
   -x                     Do not try to resolve URL, just send it
   -y                     Use Kodi's youtube addon instead of youtube-dl

   -v                     display git version and last log entry
   ```

8. Commands:

   MAIN interface

   ```text
   help                   display this help menu
   stop|halt              stop kodi playback
   next                   next kodi playback
   previous|prev          previous kodi playback
   volume|vol 100         set volume 0-100%
   volamp|amp 0|1         increase/decrease volume amplification
   pause                  PlayPause toggle
   shutdown
   reboot
   version                display git version and last log entry
   exit|quit
   iptv                   load iptv interface (work in progress)
   dlrz|dl|rz             switch to download/resize to storage mode.
   ```

   DOWNLOAD / RESIZE interface

   ```text
   home|main              back to main interface
   list                   list all media in destination folder.
   ```

9. Add custom commands to the following script: $HOME/.config/send_to_kodi/send_to_kodi_commands

   ```bash
   # example triggering command
   if [[ "$INPUT" =~ ^(command)$ ]]; then
       unset INPUT #important
       your-custom-function
   fi
   ```

10. IPTV FZF search syntax:
    ```text
    sbtrkt       fuzzy-match	                Items that match sbtrkt
    'wild        exact-match (quoted)	        Items that include wild
    ^music       prefix-exact-match	            Items that start with music
    .mp3$        suffix-exact-match	            Items that end with .mp3
    !fire	     inverse-exact-match	        Items that do not include fire
    !^music      inverse-prefix-exact-match	    Items that do not start with music
    !.mp3$       inverse-suffix-exact-match	    Items that do not end with .mp3
    ```
    Note: Gracefully exit the iptv interface with `ctrl+c` or use an an invalid search term then select the empty field.


