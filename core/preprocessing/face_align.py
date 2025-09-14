#!/usr/bin/env python3
"""
Face crop pipeline using MTCNN (facenet-pytorch).
Usage:
    python core/preprocessing/face_align.py \
      --frames_dir storage/uploads/celeb-df/processed/frames \
      --out_dir storage/uploads/celeb-df/processed/face_crops
"""
import argparse
from pathlib import Path
from facenet_pytorch import MTCNN
from PIL import Image
from tqdm import tqdm

def crop_frames(frames_root: Path, out_root: Path, min_face_size=40):
    mtcnn = MTCNN(keep_all=True, thresholds=[0.6,0.7,0.7], min_face_size=min_face_size, device='cpu')
    out_root.mkdir(parents=True, exist_ok=True)

    for video_dir in sorted(frames_root.iterdir()):
        if not video_dir.is_dir():
            continue
        out_video_dir = out_root / video_dir.name
        out_video_dir.mkdir(parents=True, exist_ok=True)
        frames = sorted(video_dir.glob("*.jpg"))
        for f in tqdm(frames, desc=f"Processing {video_dir.name}", leave=False):
            try:
                img = Image.open(f).convert("RGB")
                boxes, _ = mtcnn.detect(img)
                if boxes is None:
                    continue
                for i, box in enumerate(boxes):
                    x1, y1, x2, y2 = [int(x) for x in box]
                    crop = img.crop((x1, y1, x2, y2)).resize((256, 256))
                    out_path = out_video_dir / f"{f.stem}_face{i+1}.jpg"
                    crop.save(out_path, quality=90)
            except Exception:
                continue

if __name__ == "__main__":
    p = argparse.ArgumentParser()
    p.add_argument("--frames_dir", required=True)
    p.add_argument("--out_dir", required=True)
    p.add_argument("--min_face_size", type=int, default=40)
    args = p.parse_args()
    crop_frames(Path(args.frames_dir), Path(args.out_dir), args.min_face_size)
