#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VENV_DIR="${ROOT_DIR}/venv"
MODELS_DIR="${ROOT_DIR}/models"
INSWAPPER_URL="https://huggingface.co/hacksider/deep-live-cam/resolve/main/inswapper_128_fp16.onnx?download=true"
GFPGAN_URL="https://huggingface.co/hacksider/deep-live-cam/resolve/main/GFPGANv1.4.onnx?download=true"

choose_python() {
  if command -v python3.11 >/dev/null 2>&1; then
    echo "python3.11"
    return
  fi
  if command -v python3 >/dev/null 2>&1; then
    echo "python3"
    return
  fi
  echo ""
}

PYTHON_BIN="$(choose_python)"
if [[ -z "${PYTHON_BIN}" ]]; then
  echo "Python 3 is not installed. Install Python 3.11 first, then rerun this script."
  exit 1
fi

PYTHON_VERSION="$("${PYTHON_BIN}" -c 'import sys; print(".".join(map(str, sys.version_info[:3])))')"
PYTHON_MINOR="$("${PYTHON_BIN}" -c 'import sys; print(f"{sys.version_info[0]}.{sys.version_info[1]}")')"
ARCH="$(uname -m)"

if [[ "${PYTHON_MINOR}" != "3.11" ]]; then
  echo "Warning: detected Python ${PYTHON_VERSION}. Deep-Live-Cam is most reliable on Python 3.11."
  echo "If install or runtime fails, install Python 3.11 and rerun this script."
fi

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ffmpeg is required but not installed."
  echo "Install it with Homebrew: brew install ffmpeg"
  exit 1
fi

if [[ ! -d "${VENV_DIR}" ]]; then
  "${PYTHON_BIN}" -m venv "${VENV_DIR}"
fi

source "${VENV_DIR}/bin/activate"
python -m pip install --upgrade pip setuptools wheel
python -m pip install -r "${ROOT_DIR}/requirements.txt"

mkdir -p "${MODELS_DIR}"

download_model() {
  local url="$1"
  local output_path="$2"

  if [[ -f "${output_path}" ]]; then
    echo "Model already present: ${output_path}"
    return
  fi

  curl -L "${url}" -o "${output_path}"
}

download_model "${INSWAPPER_URL}" "${MODELS_DIR}/inswapper_128_fp16.onnx"
download_model "${GFPGAN_URL}" "${MODELS_DIR}/GFPGANv1.4.onnx"

echo
echo "Setup complete for macOS (${ARCH}) using Python ${PYTHON_VERSION}."
echo "Next step: ./scripts/run_webcam.sh"
