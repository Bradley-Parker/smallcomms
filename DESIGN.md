# SAR Comms Log & Scratchpad — Design Document

## 1. Executive Summary
Search and Rescue (SAR) volunteers operating in the field or at an Incident Command Post (ICP) need an agile, lightweight tool to log radio traffic, quick verbal sitreps, and tactical notes during exercises and small events. Traditional full ICS-309 logs can be overly rigid and distracting when operating radio gear, while generic note-taking apps lack audio dictation and automatic timestamping.

This project delivers a **zero-install, zero-build, in-browser web application** that sits halfway between a formal comms log and a fast scratchpad. It features push-to-talk (PTT) dictation with an in-browser Whisper speech-to-text model, automatic timestamping, audio replay, manual typing capability, and instant CSV export.

---

## 2. Requirements & Key Decisions

| Requirement | Design Decision | Rationale |
|---|---|---|
| **Runtime Environment** | Pure client-side in-browser web application (WASM / WebGPU) | Zero installation required; runs directly in any modern browser on field laptops, tablets, or phones. |
| **Model & Transcription** | Local Whisper via `@xenova/transformers` (Transformers.js) | Runs entirely on-device with no data sent to external cloud servers; private and functional in zero-connectivity environments. |
| **Model Selection** | Default `whisper-tiny.en` (~39MB); switchable to `whisper-base.en` (~74MB) | Tiny offers ultra-low battery drain and near-instant transcription; Base is available for noisy radio environments. |
| **Offline Operation** | Browser Cache Storage & IndexedDB persistence | Once loaded or pre-cached, the app and AI models function 100% offline in remote field areas. |
| **Dictation UX** | Hold-to-Talk (PTT) via touch/mouse or keyboard `Spacebar` | Familiar radio mic paradigm; avoids accidental open mics and background chatter. |
| **Data Fields** | Timestamp, Audio Clip, Auto-Transcript, and Editable User Notes | Keeps data entry fast and clutter-free without forcing rigid callsign forms during high-stress operations. |
| **Data Retention** | Single continuous scratchpad saved to IndexedDB | Prevents accidental data loss on refresh; includes "Export to CSV" and "Clear Log" controls. |
| **Visual Design** | High-contrast clean modern theme (light background) | Clear sunlight readability and crisp card-based radio message hierarchy. |
| **Browser Security Handling** | `file://` protocol detection banner + `run.bat` launcher | Informs operators when browser permissions block microphone access on `file://` URLs and provides an instant one-click local server launcher. |

---

## 3. Architecture & Data Flow

```
[ User Microphone ]
        │
        ▼ (Hold-to-Talk / Spacebar)
[ MediaRecorder API ] ──► Raw Audio Blob (.webm / .mp4)
        │
        ├──► Saved to IndexedDB (Entry Created, Status: Transcribing)
        │
        ▼ (Decode & Resample to 16kHz Mono Float32)
[ AudioContext ]
        │
        ▼
[ Transformers.js / ONNX Runtime Web ]
        │  (Loaded from Cache API or CDN)
        │  - whisper-tiny.en (~39MB)
        │  - whisper-base.en (~74MB)
        │
        ▼
[ Auto-Transcript Text ]
        │
        ├──► Updates Entry in IndexedDB
        └──► Injected into Editable Note Box in UI Feed
```

---

## 4. Technical Specifications

### 4.1 Audio Processing
- **Capture**: `navigator.mediaDevices.getUserMedia({ audio: true })` with noise suppression and echo cancellation enabled.
- **Resampling**: Decoded via `AudioContext` and resampled to 16,000 Hz, single-channel (mono) `Float32Array` required by Whisper ONNX models.
- **Playback**: Embedded HTML5 `<audio>` player generated via `URL.createObjectURL(blob)` for instant verification of transmissions.

### 4.2 Storage Schema (IndexedDB)
- **Database**: `SAR_Comms_DB` (Version 1)
- **Object Store**: `comms_entries`
- **Keys & Indices**:
  - `id`: Unique string (`entry_<timestamp>_<rand>`)
  - `timestamp`: ISO-8601 date string
  - `displayTime`: Local time string (`HH:MM:SS`)
  - `audioBlob`: Raw recorded audio Blob (optional, null for manual text notes)
  - `transcript`: Auto-transcribed text from Whisper
  - `userNotes`: Operator's editable field note
  - `durationSec`: Audio duration in seconds
  - `isTranscribing`: Boolean flag for UI loading state

### 4.3 Export Format (CSV)
Columns:
1. `Entry`: Sequential entry number (chronological)
2. `Timestamp`: Local formatted time (`HH:MM:SS`)
3. `Type`: `VOICE` or `MANUAL`
4. `Duration(s)`: Audio duration
5. `Auto_Transcript`: Raw Whisper transcription text
6. `User_Notes`: Operator's verified notes or edits

---

## 5. File Structure
- `index.html`: Fully self-contained single-page application with CSS, markup, and vanilla ES modules.
- `run.bat`: Windows one-click launcher starting Python's built-in `http.server` or Node server and opening the browser.
- `run.ps1`: PowerShell equivalent launcher.
- `DESIGN.md`: Architecture and specifications document.
- `README.md`: Field user guide and offline preparation instructions.

