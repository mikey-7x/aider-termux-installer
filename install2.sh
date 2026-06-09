# 2. Install the 29 local files
echo "[*] Detecting local pre-compiled packages in $WHEEL_VAULT..."
if [ -d "$WHEEL_VAULT" ]; then
    echo "[*] Installing dependencies directly from local vault..."
    # Keep --no-index here to force offline installation of your heavy wheels
    pip install --no-index --find-links="$WHEEL_VAULT" "$WHEEL_VAULT"/*.whl
    
    echo "[*] Fetching aider-chat and any remaining pure-Python dependencies..."
    # REMOVED --no-index so pip can download aider-chat from the internet
    # It still uses --find-links to prioritize your local vault if dependencies overlap
    pip install --find-links="$WHEEL_VAULT" aider-chat==0.86.2
    
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
