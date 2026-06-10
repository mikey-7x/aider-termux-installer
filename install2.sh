#!/bin/bash
# ==========================================
# Aider Native Android Auto-Installer & Desktop Setup
# ==========================================

# Safely get the absolute directory where this script is located
SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
WHEEL_VAULT="$SCRIPT_DIR/packages"

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
# Added clang for C++ standard library linking during wheel builds
pkg install -y python python-numpy python-psutil rust ninja libjpeg-turbo libpng freetype tree-sitter clang

echo ""
echo "=== Configuring Python Virtual Environment ==="
cd ~
python -m venv --system-site-packages aider-env
source ~/aider-env/bin/activate

export ANDROID_API_LEVEL=28
export CFLAGS="-I/data/data/com.termux/files/usr/include"
# Force Termux to link the C++ shared library for native extensions
export LDFLAGS="-lc++_shared" 

echo ""
echo "=== Installing Pre-Compiled Packages ==="

# 1. Install the massive SciPy file directly from GitHub Releases
echo "[*] Downloading and installing SciPy from GitHub Releases..."
pip install "https://github.com/mikey-7x/aider-termux-installer/releases/download/v1.0/scipy-1.15.3-cp313-cp313-android_24_arm64_v8a.whl"

# 2. Process and Install local files
echo "[*] Detecting local pre-compiled packages in $WHEEL_VAULT..."
if [ -d "$WHEEL_VAULT" ]; then
    
    # Auto-fix: Rename any strict android_28 tags to match Termux's android_24 expectation
    echo "[*] Checking for platform tag mismatches..."
    for file in "$WHEEL_VAULT"/*android_28*.whl; do
        if [ -e "$file" ]; then
            new_file="${file//_28_/_24_}"
            mv "$file" "$new_file"
            echo "    -> Auto-renamed to $(basename "$new_file")"
        fi
    done

    # Clean up duplicate hf_xet wheel to prevent dependency collisions
    echo "[*] Removing conflicting duplicate packages..."
    if [ -f "$WHEEL_VAULT/hf_xet-1.2.0-py3-none-any.whl" ]; then
        rm "$WHEEL_VAULT/hf_xet-1.2.0-py3-none-any.whl"
        echo "    -> Deleted duplicate hf_xet pure-Python wheel."
    fi

    echo "[*] Installing remaining dependencies directly from local vault..."
    pip install --find-links="$WHEEL_VAULT" "$WHEEL_VAULT"/*.whl
    
    # Run a final check to lock Aider into the system, bypassing the Python 3.13 version block
    echo "[*] Fetching aider-chat..."
    pip install --ignore-requires-python --find-links="$WHEEL_VAULT" aider-chat==0.86.2

    # Execute the Surgical Bypass for the broken YAML C++ scanner
    echo "[*] Applying surgical bypass for YAML parser..."
    python -c '
import os
file_path = os.path.expanduser("~/aider-env/lib/python3.13/site-packages/tree_sitter_language_pack/__init__.py")
try:
    with open(file_path, "r") as f:
        content = f.read()
    
    # Comment out the broken YAML imports
    content = content.replace("import tree_sitter_yaml", "# import tree_sitter_yaml")
    content = content.replace("\"yaml\": tree_sitter_yaml.language(),", "# \"yaml\": tree_sitter_yaml.language(),")
    
    with open(file_path, "w") as f:
        f.write(content)
    print("    -> YAML parser safely disabled.")
except Exception as e:
    print(f"    -> [!] Patch failed: {e}")
'

    echo ""
    echo "================================================="
    echo "✅ SUCCESS! Aider Setup is Fully Complete."
    echo "================================================="
    echo "To start coding with Nvidia NIM, copy and paste the block below:"
    echo "-------------------------------------------------"
    echo "source ~/aider-env/bin/activate"
    echo "export OPENAI_API_BASE=\"https://integrate.api.nvidia.com/v1\""
    echo "export OPENAI_API_KEY=\"nvapi-YOUR_API_KEY_HERE\""
    echo "aider --model openai/meta/llama-3.1-70b-instruct --assistant-output-color white --user-input-color white"
    echo "-------------------------------------------------"
    echo "Note: Replace 'nvapi-YOUR_API_KEY_HERE' with your actual key."
else
    echo "[!] Error: Vault directory $WHEEL_VAULT not found!"
    echo "[!] Make sure you run this script from inside the downloaded 'aider-termux-installer' folder."
fi
