#!/bin/bash
# ==========================================
# Aider Native Android Auto-Installer & Desktop Setup
# ==========================================

echo "=========================================="
echo "📱 Requesting Storage Permissions..."
echo "👉 PLEASE CLICK 'ALLOW' ON YOUR PHONE SCREEN!"
echo "=========================================="
termux-setup-storage
sleep 5

echo ""
echo "=== Updating System & Installing Core Repositories ==="
pkg update && pkg upgrade -y

echo ""
echo "=== Installing X11 Desktop & Proot Environment ==="
pkg install -y git wget curl nano proot tar
pkg install -y tur-repo
pkg install -y x11-repo
pkg install -y termux-x11-nightly
pkg install -y pulseaudio
pkg install -y termux-api
pkg install -y proot-distro

echo ""
echo "=== Installing Aider Native Dependencies ==="
pkg install -y python python-numpy python-psutil rust ninja libjpeg-turbo libpng freetype tree-sitter

echo ""
echo "=== Configuring Python Virtual Environment ==="
cd ~
python -m venv --system-site-packages aider-env
source ~/aider-env/bin/activate

export ANDROID_API_LEVEL=28
export CFLAGS="-I/data/data/com.termux/files/usr/include"

echo ""
echo "=== Installing Pre-Compiled Packages ==="
# Return to the cloned GitHub repository folder to access the 'packages' directory
cd - > /dev/null
WHEEL_VAULT="./packages"

# 1. Install the massive SciPy file directly from GitHub Releases
echo "[*] Downloading and installing SciPy from GitHub Releases..."
pip install "https://github.com/mikey-7x/aider-termux-installer/releases/download/v1.0/scipy-1.15.3-cp313-cp313-android_24_arm64_v8a.whl"

# 2. Install the 29 local files
echo "[*] Detecting local pre-compiled packages in $WHEEL_VAULT..."
if [ -d "$WHEEL_VAULT" ]; then
    echo "[*] Installing remaining dependencies directly from local vault..."
    pip install --no-index --find-links="$WHEEL_VAULT" "$WHEEL_VAULT"/*.whl
    
    # Run a final check to lock Aider into the system
    pip install --no-index --find-links="$WHEEL_VAULT" aider-chat==0.86.2
    
    echo ""
    echo "================================================="
    echo "✅ SUCCESS! Aider and Termux:X11 Setup is Complete."
    echo "================================================="
    echo "To start coding, simply run:"
    echo "  source ~/aider-env/bin/activate"
    echo "  aider --model openrouter/deepseek/deepseek-r1"
else
    echo "[!] Error: Vault directory $WHEEL_VAULT not found!"
    echo "[!] Make sure you run this script from inside the downloaded 'aider-termux-installer' folder."
fi
