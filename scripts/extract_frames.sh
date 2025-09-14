#!/usr/bin/env bash
# Extract frames (jpg) and audio (wav) from videos in Celeb-DF raw/
# Usage: bash scripts/extract_frames.sh

set -euo pipefail

SRC_DIR="storage/uploads/celeb-df/raw"
OUT_DIR="storage/uploads/celeb-df/processed"
FRAMES_PER_SEC=1   # change if you want more frames

AUDIO_DIR="${OUT_DIR}/audio"
FRAMES_DIR="${OUT_DIR}/frames"

mkdir -p "${AUDIO_DIR}"
mkdir -p "${FRAMES_DIR}"

echo "[INFO] Scanning ${SRC_DIR} for videos..."

find "${SRC_DIR}" -type f \( -iname "*.mp4" -o -iname "*.avi" -o -iname "*.mov" -o -iname "*.mkv" \) | while read -r vid; do
  base=$(basename "${vid%.*}")
  out_frames="${FRAMES_DIR}/${base}"
  out_audio="${AUDIO_DIR}/${base}.wav"

  mkdir -p "${out_frames}"
  echo "[INFO] Extracting frames from ${vid} -> ${out_frames} (fps=${FRAMES_PER_SEC})"
  ffmpeg -hide_banner -loglevel error -i "$vid" -vf "fps=${FRAMES_PER_SEC}" "${out_frames}/frame_%05d.jpg"

  echo "[INFO] Extracting audio -> ${out_audio}"
  ffmpeg -hide_banner -loglevel error -y -i "$vid" -vn -ac 1 -ar 16000 -f wav "${out_audio}"
done

echo "[DONE] frames -> ${FRAMES_DIR}, audio -> ${AUDIO_DIR}"
