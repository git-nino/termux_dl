#!/bin/bash

# --------------------------------------------------------
#  Termux YT-DLP Installer + MP3/MP4 Aliases
#  Downloads MP3 → ~/storage/music
#            MP4 → ~/storage/movies
# --------------------------------------------------------

echo "[+] Updating system..."
pkg update -y && pkg upgrade -y

echo "[+] Installing required packages..."
pkg install -y python ffmpeg

echo "[+] Running: termux-setup-storage"
termux-setup-storage

echo "[+] Installing latest yt-dlp..."
pip install -U yt-dlp

# Ensure folders exist
mkdir -p "$HOME/storage/music"
mkdir -p "$HOME/storage/movies"

# Detect main shell rc file
RC_FILE="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && RC_FILE="$HOME/.zshrc"

echo "[+] Adding aliases to $RC_FILE ..."

cat << 'EOF' >> "$RC_FILE"

# -----------------------------------------------------
#  YT-DLP Quick Aliases for Termux
# -----------------------------------------------------

# Download MP3 to Android Music folder
mp3() {
    yt-dlp -x --audio-format mp3 \
        -o "$HOME/storage/music/%(title)s.%(ext)s" "$1"
}

# Download MP4 to Android Movies folder
mp4() {
    yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/mp4" \
        -o "$HOME/storage/movies/%(title)s.%(ext)s" "$1"
}

EOF

echo "[+] Reloading shell configuration..."
source "$RC_FILE"

echo ""
echo "[✔] Setup complete!"
echo "[✔] Usage examples:"
echo "    mp3 https://youtube.com/watch?v=XXXX"
echo "    mp4 https://youtube.com/watch?v=XXXX"
echo ""
