![N3](N3.png)

# 🍋‍🟩[1]Aider Native Android Installer 🍋‍🟩📱

A fully offline, native auto-installer for running [Aider](https://aider.chat/) and a full **X11 Linux Desktop** environment natively in Termux on Android. 

Building Aider and its heavy dependencies (like SciPy and Numpy) natively on Android/ARM64 takes hours and often fails. This repository contains **30 pre-compiled `.whl` packages**, allowing you to bypass the C++ compilation process and install Aider instantly.

## 🚀 Features
* **Zero-Compilation:** All heavy Python dependencies (SciPy, Numpy, psutil, tree-sitter) are pre-compiled for Termux.
* **X11 Desktop Ready:** Automatically installs `termux-x11-nightly`, `proot-distro`, and `pulseaudio` for full GUI desktop capabilities.
* **Hybrid Installation:** Downloads the oversized 25MB SciPy binary directly from GitHub Releases, while installing all other 29 dependencies completely offline from the `packages/` vault.
* **Optimized for LLMs:** Perfect for running Claude, DeepSeek-R1, or Llama models directly from your phone.

## 📋 Prerequisites
Install [Termux](https://f-droid.org/en/packages/com.termux/) from F-Droid. *(Do not use the Google Play Store version, it is outdated and broken).*

## 🛠️ Installation

1. Clone this repository:
```bash
# 1. Update the blank system and install git
pkg update && pkg upgrade -y
pkg install git -y

# 2. Download your repository
git clone https://github.com/mikey-7x/aider-termux-installer.git

# 3. Enter the folder, make it executable, and run the magic!
cd aider-termux-installer
chmod +x install.sh
./install.sh
```

2. Set Your API Key & Run:
Aider requires an API key to connect to AI models. We recommend OpenRouter for free/cheap access to DeepSeek and Llama. Get a key at [openrouter.ai](https://openrouter.ai/), then run:

```bash
# Export your API key so Aider can use it
export OPENROUTER_API_KEY="your_api_key_here"

# Activate the virtual environment
source ~/aider-env/bin/activate

# Launch Aider with DeepSeek-R1
aider --model openrouter/deepseek/deepseek-r1
```

#  🍋‍🟩[2]Aider + NVIDIA NIM on Termux (Ubuntu PRoot)🍋‍🟩

A complete guide to installing and configuring the Aider terminal coding agent using NVIDIA's free NIM APIs. This setup is specifically optimized for running within an Ubuntu PRoot environment on Android via Termux, providing desktop-grade AI coding assistance on mobile architectures.

🚀 Phase 1: Installation
Due to PEP 668 ("externally managed environments") in modern Ubuntu, we must isolate the installation using a Python virtual environment and the ultra-fast uv package manager.
Run the following commands sequentially in your Ubuntu terminal:

1. Create and enter the project directory
```
mkdir aider
cd aider
```

2. Create and activate a Python virtual environment
```
python3 -m venv aider_env
source aider_env/bin/activate
```

3. Install the 'uv' package manager
```
pip install uv
```

4. Install Aider globally using uv
```
python -m uv tool install --force --python python3.12 aider-chat@latest
```

5. Add Aider to your system PATH
```
export PATH="/root/.local/bin:$PATH"
```

🔑 Phase 2: NVIDIA API Configuration
NVIDIA hosts free, state-of-the-art open-source models. To use them, you need an API key.
 * Go to [build.nvidia.com](https://build.nvidia.com/explore/discover)
 * Log in and navigate to your preferred model (e.g., Kimi-k2.5 or Nemotron-3-super).
 * Click View Code or Generate API Key.
 * Copy the generated key (it should start with nvapi-).
Set the Environment Variable
For Ubuntu / Linux (Termux):
```
echo "NVIDIA_NIM_API_KEY=nvapi-YOUR_API_KEY_HERE" > .env
```

For Windows (PowerShell):
```
"NVIDIA_NIM_API_KEY=nvapi-YOUR_API_KEY_HERE" | Out-File -FilePath .env -Encoding ascii
```

🧠 Phase 3:Launching Aider

Launch Aider by specifying the nvidia_nim/ provider prefix followed by the model registry name.
For Moonshot AI (Terminal Coding):
```
aider --model nvidia_nim/moonshotai/kimi-k2.5
```

For Z.ai GLM-5:
```
aider --model nvidia_nim/z.ai/glm-5
```

🛠️ Troubleshooting: The "Bulletproof" Fallback Method

Sometimes, API endpoints experience routing bugs, resulting in 404 Not Found errors or the terminal freezing on Waiting for....
If the standard nvidia_nim/ prefix fails, you can bypass the routing logic entirely by using the OpenAI compatibility layer.

1. Overwrite your .env file with the OpenAI base URL and your NVIDIA key:
```
echo "OPENAI_API_BASE=https://integrate.api.nvidia.com/v1" > .env
echo "OPENAI_API_KEY=nvapi-YOUR_API_KEY_HERE" >> .env
```

2. Launch Aider using the openai/ prefix instead:

Example: Launching Nemotron-3-Super (1-Million Context Window)
```
aider --model openai/nvidia/nemotron-3-super-120b-a12b
```

## **📜 Credits**  
Developed by **[mikey-7x](https://github.com/mikey-7x)** 🚀🔥  

