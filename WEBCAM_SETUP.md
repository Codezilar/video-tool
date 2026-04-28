# Webcam Face Swap Setup

This repo is now prepared for a local webcam face-swap build on macOS, including Intel Macs.

## What changed

- `requirements.txt` now installs plain `onnxruntime` on Intel macOS instead of `onnxruntime-gpu`.
- `scripts/setup_webcam_mac.sh` creates a virtual environment, installs dependencies, and downloads the webcam model plus the optional GFPGAN ONNX model.
- `scripts/run_webcam.sh` launches the GUI in webcam mode with CPU execution.

## Recommended path on this machine

1. Install prerequisites:

```bash
brew install python@3.11 ffmpeg
```

2. From the project root, run:

```bash
chmod +x scripts/setup_webcam_mac.sh scripts/run_webcam.sh
./scripts/setup_webcam_mac.sh
```

3. Launch the app:

```bash
./scripts/run_webcam.sh
```

4. In the GUI:

- Click `Select a face`
- Pick your webcam from the camera dropdown
- Click `Live`

## Notes

- The first live preview can take 10-30 seconds to warm up.
- macOS will likely prompt for camera permission the first time OpenCV opens the webcam.
- `scripts/run_webcam.sh` only requires `models/inswapper_128_fp16.onnx`. The GFPGAN model is optional unless you enable the face enhancer in the UI.
- This machine currently lacks both `python3.11` and `ffmpeg`, so setup will not complete until those are installed.
- If Python 3.11 is not available yet, the setup script will fall back to `python3`, but the upstream project is most reliable on 3.11.
