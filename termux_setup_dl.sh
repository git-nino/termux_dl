#!/data/data/com.termux/files/usr/bin/bash

# --- Termux Setup Script ---

# 1. Update and Upgrade
echo "Starting Termux package update and upgrade..."
pkg update -y && pkg upgrade -y
echo "Update and upgrade complete."
echo "---"

# 2. Install Dependencies (Python, yt-dlp, and ffmpeg)
echo "Installing required packages: python, yt-dlp, and ffmpeg..."
pkg install python -y
pip install yt-dlp
pkg install ffmpeg -y
echo "Installation complete."
echo "---"

# 3. Request Storage Access (Essential for Music Folder)
echo "Requesting storage permission (necessary for accessing Music folder)..."
termux-setup-storage
echo "Storage setup complete. You may need to grant permission manually if prompted."
echo "---"

# 4. Create Shortcut Functions (dl3 and dl4)

# Define the location for the shortcut script (Termux's profile source directory)
PROFILE_D="$PREFIX/etc/profile.d"
SHORTCUT_SCRIPT="$PROFILE_D/yt_shortcuts.sh"

echo "Creating custom shortcut script in $SHORTCUT_SCRIPT..."

# Note: The 'Music' folder is typically symlinked to '$HOME/storage/music' after running termux-setup-storage
MUSIC_DIR="$HOME/storage/music"

# Ensure the profile.d directory exists
mkdir -p "$PROFILE_D"

# Write the shortcut functions to the script file
cat > "$SHORTCUT_SCRIPT" << EOF
# --- Custom yt-dlp Shortcuts ---

# dl3: Download MP3 (audio-only) to the smartphone's Music folder.
# Usage: dl3 <url>
dl3() {
    if [ -z "\$1" ]; then
        echo "Usage: dl3 <video_url>"
        return 1
    fi
    echo "Downloading MP3 audio to $MUSIC_DIR..."
    yt-dlp -x --audio-format mp3 -o "$MUSIC_DIR/%(title)s.%(ext)s" "\$1"
}

# dl4: Download MP4 (video + audio) to the smartphone's Music folder.
# Usage: dl4 <url>
dl4() {
    if [ -z "\$1" ]; then
        echo "Usage: dl4 <video_url>"
        return 1
    fi
    echo "Downloading MP4 video to $MUSIC_DIR..."
    yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o "$MUSIC_DIR/%(title)s.%(ext)s" "\$1"
}
EOF

echo "Shortcut script created. Please **restart Termux** or run **source $SHORTCUT_SCRIPT** to use the new commands."
echo "---"
echo "Setup complete! You can now use the 'dl3 <url>' and 'dl4 <url>' commands."
