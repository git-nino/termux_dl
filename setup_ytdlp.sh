#!/bin/bash

# ============================================================
#  Termux YT-DLP Ultimate Installer + Aliases + Bulk Download
# ============================================================

GREEN="\e[32m"
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

GREEN="\e[32m"
CYAN="\e[36m"
RESET="\e[0m"

LOG_DIR="$HOME/.yt-dlp/logs"
mkdir -p "$LOG_DIR"

# --------------------------
#  Extract URLs from Shorts
#  links <url>
# --------------------------
links() {
    echo -e "${CYAN}[+] Extracting video URLs...${RESET}"
    yt-dlp --flat-playlist --print "%(url)s" "$1" > shorts_urls
    echo -e "${GREEN}✔ Saved to shorts_urls${RESET}"
}

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
# Single MP4 Download
# ---------------------
mp4() {
    echo -e "${CYAN}[MP4] Downloading...${RESET}"
    yt-dlp -f "bv*[ext=mp4]+ba[ext=m4a]/mp4" \
        -o "$HOME/storage/movies/%(title)s.%(ext)s" "$1" \
        | tee "$LOG_DIR/mp4_$(date +%F).log"
}

# -------------------------------------------
# Bulk MP3 Download (full advanced command)
# -------------------------------------------
mp3file() {
    echo -e "${CYAN}[Bulk MP3] Downloading...${RESET}"
    yt-dlp -x --audio-format mp3 --audio-quality 0 \
        --write-subs --sub-langs all \
        -a shorts_urls \
        --download-archive downloaded \
        -o "%(title)s.%(ext)s" \
        --ignore-errors \
        | tee "$LOG_DIR/bulk_mp3_$(date +%F).log"
}

# -------------------------------------------
# Bulk MP4 Download (mp4 version)
# -------------------------------------------
mp4file() {
    echo -e "${CYAN}[Bulk MP4] Downloading...${RESET}"
    yt-dlp -f "bv*+ba/best" \
        --write-subs --sub-langs all \
        -a shorts_urls \
        --download-archive downloaded \
        -o "%(title)s.%(ext)s" \
        --ignore-errors \
        | tee "$LOG_DIR/bulk_mp4_$(date +%F).log"
}

# Update yt-dlp
ytupdate() {
    echo -e "${GREEN}[+] Updating yt-dlp...${RESET}"
    pip install -U yt-dlp
}

EOF

echo
echo -e "${GREEN}============================================"
echo "  INSTALLATION COMPLETE!"
echo "============================================${RESET}"
echo
read -p "Press ENTER to exit Termux..."

# Exit Termux session
kill -9 $PPID
