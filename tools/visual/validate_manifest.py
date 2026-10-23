"""Small candidate-asset check. It does not grant legal or artistic approval."""
import argparse
import hashlib
import json
from pathlib import Path
import struct

MAX_BYTES = 12 * 1024 * 1024
REVIEW_KEYS = ("review_child_safety", "review_visual_consistency", "review_cultural_context", "review_licensing")


def png_info(path):
    data = path.read_bytes()
    if len(data) < 33 or data[:8] != b"\x89PNG\r\n\x1a\n" or data[12:16] != b"IHDR":
        raise ValueError("not a PNG with IHDR")
    width, height = struct.unpack(">II", data[16:24])
    # Alpha channel presence only; opaque RGBA is not proof of a transparent cutout.
    return width, height, data[25] in (4, 6)


def validate(manifest, root):
    errors = []
    seen = set()
    root = root.resolve()
    if not isinstance(manifest, dict) or not isinstance(manifest.get("assets"), list):
        return ["manifest.assets must be a list"]
    if not manifest["assets"]:
        return ["manifest.assets must not be empty"]
    for index, row in enumerate(manifest["assets"]):
        label = f"asset[{index}]"
        if not isinstance(row, dict):
            errors.append(f"{label}: must be object")
            continue
        asset_id = row.get("asset_id")
        if not isinstance(asset_id, str) or not asset_id.strip() or asset_id in seen:
            errors.append(f"{label}: missing or duplicate asset_id")
        else:
            seen.add(asset_id)
        for key in ("path", "prompt_path"):
            value = row.get(key)
            if not isinstance(value, str) or not value:
                errors.append(f"{label}: missing {key}")
                continue
            path = (root / value).resolve()
            if not path.is_relative_to(root) or not path.is_file():
                errors.append(f"{label}: invalid {key}")
                continue
            if key == "prompt_path":
                if not path.read_text(encoding="utf-8").strip():
                    errors.append(f"{label}: empty prompt")
                continue
            if path.stat().st_size > MAX_BYTES:
                errors.append(f"{label}: file over budget")
            if hashlib.sha256(path.read_bytes()).hexdigest() != row.get("output_sha256"):
                errors.append(f"{label}: SHA256 mismatch")
            try:
                width, height, alpha = png_info(path)
                if (width, height) != (row.get("width"), row.get("height")):
                    errors.append(f"{label}: dimension mismatch")
                if not 1 <= width <= 4096 or not 1 <= height <= 4096:
                    errors.append(f"{label}: dimensions outside budget")
                if alpha != row.get("has_alpha_channel"):
                    errors.append(f"{label}: alpha channel mismatch")
            except ValueError as exc:
                errors.append(f"{label}: {exc}")
        if not isinstance(row.get("approved_for_app"), bool):
            errors.append(f"{label}: approved_for_app must be boolean")
        if row.get("approved_for_app") is True:
            if any(row.get(key) != "human_approved" for key in REVIEW_KEYS):
                errors.append(f"{label}: approval requires all human reviews")
            if not row.get("license_evidence"):
                errors.append(f"{label}: approval requires license evidence")
    return errors


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    args = parser.parse_args()
    try:
        problems = validate(json.loads(args.manifest.read_text()), Path(__file__).resolve().parents[2])
    except (OSError, ValueError) as exc:
        problems = [str(exc)]
    print(json.dumps({"status": "FAIL" if problems else "PASS", "errors": problems}, indent=2))
    raise SystemExit(bool(problems))
