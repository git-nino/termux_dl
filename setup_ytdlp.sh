#!/bin/bash

# ============================================================
#  Termux YT-DLP Ultimate Installer + Aliases + Bulk download
# ============================================================

# Colors
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

echo -e "${CYAN}[+] Updating system...${RESET}"
pkg update -y && pkg upgrade -y

echo -e "${CYAN}[+] Installing Python & FFmpeg...${RESET}"
pkg install -y python ffmpeg

echo -e "${CYAN}[+] Initializing Termux Storage...${RESET}"
termux-setup-storage

echo -e "${CYAN}[+] Installing latest yt-dlp...${RESET}"
pip install -U yt-dlp

# Create Android folders
mkdir -p "$HOME/storage/music"
mkdir -p "$HOME/storage/movies"

# Create logs directory
mkdir -p "$HOME/.yt-dlp/logs"

# Detect rc file
RC_FILE="$HOME/.bashrc"
[ -f "$HOME/.zshrc" ] && RC_FILE="$HOME/.zshrc"

echo -e "${CYAN}[+] Adding aliases to $RC_FILE ...${RESET}"

cat << 'EOF' >> "$RC_FILE"

# ======================================================
#  YT-DLP Aliases & Bulk Download Functions – Termux
# ======================================================

# --- Colors ---
GREEN="\e[32m"
YELLOW="\e[33m"
CYAN="\e[36m"
RESET="\e[0m"

# --- Log Directory ---
LOG_DIR="$HOME/.yt-dlp/logs"
mkdir -p "$LOG_DIR"

# ---------------------
# Single MP3 download
# ---------------------
mp3() {
    echo -e "${CYAN}[MP3] Downloading...${RESET}"
    yt-dlp -x --audio-format mp3 \
        -o "$HOME/storage/music/%(title)s.%(ext)s" "$1" \
        | tee "$LOG_DIR/mp3_$(date +%F).log"
}

# ---------------------
# Single MP4 download
# ---------------------
mp4() {
    echo -e "${CYAN}[MP4] Downloading...${RESET}"
    yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/mp4" \
        -o "$HOME/storage/movies/%(title)s.%(ext)s" "$1" \
        | tee "$LOG_DIR/mp4_$(date +%F).log"
}

# ---------------------
# Bulk MP3 from file
# ---------------------
mp3file() {
    echo -e "${YELLOW}[Bulk MP3] Reading: $1${RESET}"
    while IFS= read -r url; do
        [ -z "$url" ] && continue
        mp3 "$url"
    done < "$1"
}

# ---------------------
# Bulk MP4 from file
# ---------------------
mp4file() {
    echo -e "${YELLOW}[Bulk MP4] Reading: $1${RESET}"
    while IFS= read -r url; do
        [ -z "$url" ] && continue
        mp4 "$url"
    done < "$1"
}

# ---------------------
# Update yt-dlp easily
# ---------------------
ytupdate() {
    echo -e "${GREEN}[+] Updating yt-dlp...${RESET}"
    pip install -U yt-dlp
}

EOF

echo -e "${CYAN}[+] Reloading shell configuration...${RESET}"
source "$RC_FILE"

echo -e "${GREEN}"
echo "============================================"
echo "  INSTALLATION COMPLETE!"
echo "============================================"
echo -e "${RESET}"
echo "✔ mp3 <url>        → download MP3 to Music"
echo "✔ mp4 <url>        → download MP4 to Movies"
echo "✔ mp3file links.txt → bulk MP3"
echo "✔ mp4file links.txt → bulk MP4"
echo "✔ ytupdate          → update yt-dlp"
echo ""
echo "Logs stored in: ~/.yt-dlp/logs/"
