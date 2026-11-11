# 📻 SAR Comms Log & Scratchpad

A lightweight, zero-install in-browser web app designed for Search and Rescue (SAR) volunteers to easily track radio communications, verbal SITREPs, and operational notes during small events, training exercises, and field incidents.

---

## ✨ Features

- **Push-to-Talk (PTT) Dictation**: Hold the tactile mic button on screen or hold <kbd>Spacebar</kbd> to record radio transmissions.
- **On-Device Whisper Transcription**: Transcribes audio directly in your browser using `@xenova/transformers` (WebAssembly & WebGPU). Zero audio leaves your laptop or tablet.
- **100% Offline Capable**: Model files and runtime are cached in the browser's storage. After initial setup, no internet or cellular coverage is needed.
- **Automatic Timestamping**: Every voice message and manual note is tagged with an accurate local timestamp.
- **Embedded Audio Replay**: Re-listen to original radio transmissions anytime to verify callsigns, coordinates, or garbled speech.
- **Editable Notes**: Whisper transcription immediately populates an editable field note box where you can fix names, add coordinates, or make corrections.
- **Quick Manual Logging**: Type a written note and hit `Enter` when you can't or don't want to speak.
- **Local Persistence**: All entries and audio clips persist in `IndexedDB`. Refreshing or closing the tab will not lose your data.
- **Export to CSV**: Download your comms log in CSV format anytime for operational debriefs or ICS paperwork.

---

## 🚀 Quick Start

### Option 1: Double-click launcher (Recommended for Windows)
1. Double-click `run.bat` (or right-click `run.ps1` -> *Run with PowerShell*).
2. Your browser will automatically open to `http://localhost:8000`.

> **Why a local server?** Modern web browsers enforce strict security that blocks microphone access (`getUserMedia`) and WebAssembly workers on direct `file://` URLs. Running via `http://localhost:8000` allows the microphone and Whisper AI engine to run securely without needing any software installation.

### Option 2: Command Line
From this project directory, run:
```bash
# Using Python
python -m http.server 8000

# OR using Node
npx serve -l 8000 .
```
Then navigate to `http://localhost:8000` in Chrome, Edge, Safari, or Firefox.

---

## 📴 Preparing for Field (Offline) Use

Before heading into the field with no internet:
1. Open the app while connected to Wi-Fi.
2. Click the **⚙️ Settings** icon in the top header.
3. Select your model (Default: `whisper-tiny.en` ~39MB, or `whisper-base.en` ~74MB).
4. Click **📥 Download & Cache Model Now**.
5. Once the progress bar reaches 100%, the AI model is safely stored in your browser's persistent cache.
6. You can now disconnect from Wi-Fi and use the app fully offline.

---

## 🎙️ Controls & Shortcuts

| Action | Control |
|---|---|
| **Hold-to-Talk (PTT)** | Click & hold the large circular mic button, OR hold the <kbd>Spacebar</kbd> |
| **Stop & Transcribe** | Release the mouse/touch button or release the <kbd>Spacebar</kbd> |
| **Manual Note** | Type in the text bar and press <kbd>Enter</kbd> |
| **Edit Entry** | Click directly on the note text box under any card to make edits |
| **Export Log** | Click **📥 Export CSV** in the top navigation bar |
| **Clear Scratchpad** | Click **🗑️ Clear** in the top navigation bar |
