# Aider Native Android Installer 🤖📱

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

**1. Clone this repository:**
```bash
git clone [https://github.com/mikey-7x/aider-termux-installer.git](https://github.com/mikey-7x/aider-termux-installer.git)
cd aider-termux-installer
```

2. Run the Auto-Installer:
(A popup will appear asking for storage permissions. Please click "Allow").
```
chmod +x install.sh
./install.sh
```

3. Activate and Run:
Whenever you open a new Termux session, activate the virtual environment before starting Aider:
```
source ~/aider-env/bin/activate
aider --model openrouter/deepseek/deepseek-r1
```
