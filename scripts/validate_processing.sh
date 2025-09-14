#!/usr/bin/env bash
# Quick validation of Celeb-DF preprocessing outputs
FRAMES_DIR="storage/uploads/celeb-df/processed/frames"
FACES_DIR="storage/uploads/celeb-df/processed/face_crops"
AUDIO_DIR="storage/uploads/celeb-df/processed/audio"

echo "[INFO] Frames folders: $(ls -1 ${FRAMES_DIR} | wc -l)"
echo "[INFO] Face crops folders: $(ls -1 ${FACES_DIR} | wc -l 2>/dev/null || echo 0)"
echo "[INFO] Audio files: $(ls -1 ${AUDIO_DIR}/*.wav 2>/dev/null | wc -l)"
