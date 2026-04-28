#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="${ROOT_DIR}/venv"

if [[ ! -d "${VENV_DIR}" ]]; then
  echo "Virtual environment not found. Run ./scripts/setup_webcam_mac.sh first."
  exit 1
fi

if [[ ! -f "${ROOT_DIR}/models/inswapper_128_fp16.onnx" ]]; then
  echo "Missing model: models/inswapper_128_fp16.onnx"
  echo "Run ./scripts/setup_webcam_mac.sh first."
  exit 1
fi

source "${VENV_DIR}/bin/activate"
exec python "${ROOT_DIR}/run.py" --execution-provider cpu --live-mirror
