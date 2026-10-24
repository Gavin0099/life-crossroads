#!/usr/bin/env python3
"""Build actual baseline/candidate Scene and real saved-session fixtures, without a Simulator."""
import argparse
import hashlib
import json
import platform
import plistlib
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
BASE = "b896e058bf49f61ec8eafec2a4134a35edff6ddc"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--baseline", action="store_true")
    args = parser.parse_args()
    label = "baseline" if args.baseline else "candidate"
    build = ROOT / ".build/world-trace-visual" / label
    output = ROOT / "artifacts/evidence/world-trace-visual" / label
    app = build / "WorldTrace.app/Contents"
    modules, libraries = build / "modules", app / "Frameworks"
    executable = app / "MacOS/WorldTrace"
    resources = app / "Resources"
    for folder in [output, modules, libraries, executable.parent, resources]:
        folder.mkdir(parents=True, exist_ok=True)
    (app / "Info.plist").write_bytes(plistlib.dumps({"CFBundleExecutable": "WorldTrace",
        "CFBundleIdentifier": "org.life-crossroads.offline-trace", "CFBundlePackageType": "APPL"}))
    scene = ROOT / "LifeCrossroads/App/LifeWorldScene.swift"
    if args.baseline:
        scene = build / "BaselineScene.swift"
        scene.write_bytes(subprocess.check_output(["git", "show", f"{BASE}:LifeCrossroads/App/LifeWorldScene.swift"], cwd=ROOT))
    source_paths = [p for folder in ["Domain", "Presentation", "Persistence"]
                    for p in sorted((ROOT / "LifeCrossroads" / folder).glob("*.swift"))]
    source_paths += [ROOT / "LifeCrossroads/App/LifeWorldMotion.swift", Path(__file__),
                    ROOT / "tools/world-trace-visual/Render.swift",
                    ROOT / "LifeCrossroads/App/StoryVisuals.swift",
                    ROOT / "LifeCrossroads/Data/Resources/catalog.json"]
    for asset in ["StoryCast", "RiverCrossroads"]:
        source_paths += sorted((ROOT / f"LifeCrossroads/App/Assets.xcassets/{asset}.imageset").glob("*"))
    source_hashes = {str(p.relative_to(ROOT)): hashlib.sha256(p.read_bytes()).hexdigest() for p in source_paths}
    scene_hash = hashlib.sha256(scene.read_bytes()).hexdigest()
    base = ["xcrun", "swiftc", "-swift-version", "6", "-target", f"{platform.machine()}-apple-macos14.0",
            "-I", str(modules), "-L", str(libraries), "-module-cache-path", str(build / "cache")]
    commands = []
    for name, folder in [("LifeDomain", "Domain"), ("LifePresentation", "Presentation"), ("LifePersistence", "Persistence")]:
        command = base + ["-parse-as-library", "-emit-library", "-emit-module", "-module-name", name,
            "-emit-module-path", str(modules / f"{name}.swiftmodule"), "-o", str(libraries / f"lib{name}.dylib"),
            "-Xlinker", "-install_name", "-Xlinker", f"@rpath/lib{name}.dylib"]
        if name != "LifeDomain":
            command += ["-lLifeDomain"]
        commands.append(command + [str(p) for p in sorted((ROOT / "LifeCrossroads" / folder).glob("*.swift"))])
    commands.append(["xcrun", "actool", str(ROOT / "LifeCrossroads/App/Assets.xcassets"), "--compile", str(resources),
                     "--platform", "macosx", "--minimum-deployment-target", "14.0", "--output-format", "human-readable-text"])
    commands.append(base + ([] if args.baseline else ["-D", "WORLD_TRACE_CANDIDATE"]) + ["-parse-as-library",
        "-lLifeDomain", "-lLifePresentation", "-lLifePersistence", "-Xlinker", "-rpath", "-Xlinker",
        "@executable_path/../Frameworks", "-o", str(executable), str(scene),
        str(ROOT / "LifeCrossroads/App/LifeWorldMotion.swift"), str(ROOT / "tools/world-trace-visual/Render.swift")])
    commands.append([str(executable), str(ROOT), str(output), str(build / "saves")])
    attempt = len(list(build.glob("build-and-render-*.txt"))) + 1
    with (build / f"build-and-render-{attempt}.txt").open("w") as log:
        for command in commands:
            completed = subprocess.run(command, cwd=ROOT, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
            log.write(" ".join(command) + "\n" + completed.stdout + "\n")
            log.flush()
            if completed.returncode:
                raise SystemExit(completed.stdout)
    manifest = json.loads((output / "manifest.json").read_text())
    manifest["baselineCommit"] = BASE
    manifest["candidate"] = not args.baseline
    assert hashlib.sha256(scene.read_bytes()).hexdigest() == scene_hash, "Scene changed during render"
    assert all(hashlib.sha256((ROOT / p).read_bytes()).hexdigest() == h for p, h in source_hashes.items()), "Source changed during build"
    manifest["sceneSHA256"] = scene_hash
    manifest["sourceHashes"] = source_hashes
    for entry in manifest["images"]:
        entry["sha256"] = hashlib.sha256((output / entry["file"]).read_bytes()).hexdigest()
        entry["saveSHA256"] = hashlib.sha256(Path(entry["savedArchive"]).read_bytes()).hexdigest()
    (output / "manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    print(label, "frames", len(manifest["images"]), "checks", manifest["checks"], "scene", manifest["sceneSHA256"])


if __name__ == "__main__":
    main()
