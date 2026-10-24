#!/usr/bin/env python3
"""Offline production-view render: no simulator, app installation or asset modifications.

The macOS-only adapter in render-world.swift loads the exact existing PNG and crop formula.
This does not prove iOS accessibility, file persistence or real-device appearance.
"""
from pathlib import Path
import hashlib
import json
import platform
import plistlib
import subprocess

ROOT = Path(__file__).resolve().parents[4]
EVIDENCE = Path(__file__).resolve().parent
BUILD = ROOT / "artifacts/governance/visual-motion/offline"
APP = BUILD / "WorldRenderer.app"
MODULES = BUILD / "modules"
EXECUTABLE = APP / "Contents/MacOS/WorldRenderer"
LIBRARY = APP / "Contents/Frameworks"
RESOURCES = APP / "Contents/Resources"


def main():
    for directory in [MODULES, EXECUTABLE.parent, LIBRARY, RESOURCES]:
        directory.mkdir(parents=True, exist_ok=True)
    (APP / "Contents/Info.plist").write_bytes(plistlib.dumps({
        "CFBundleExecutable": "WorldRenderer", "CFBundleIdentifier": "org.lifecrossroads.offline-world",
        "CFBundleName": "WorldRenderer", "CFBundlePackageType": "APPL",
    }))
    base = ["xcrun", "swiftc", "-target", f"{platform.machine()}-apple-macos14.0", "-I", str(MODULES),
            "-L", str(LIBRARY), "-module-cache-path", str(BUILD / "cache")]
    commands = []
    for name, directory in [("LifeDomain", "Domain"), ("LifePresentation", "Presentation")]:
        command = base + ["-parse-as-library", "-emit-library", "-emit-module", "-module-name", name,
                          "-emit-module-path", str(MODULES / f"{name}.swiftmodule"), "-o", str(LIBRARY / f"lib{name}.dylib"),
                          "-Xlinker", "-install_name", "-Xlinker", f"@rpath/lib{name}.dylib"]
        if name == "LifePresentation":
            command += ["-lLifeDomain"]
        commands.append(command + [str(path) for path in sorted((ROOT / "LifeCrossroads" / directory).glob("*.swift"))])
    commands.append(["xcrun", "actool", str(ROOT / "LifeCrossroads/App/Assets.xcassets"), "--compile", str(RESOURCES),
                     "--platform", "macosx", "--minimum-deployment-target", "14.0", "--output-format", "human-readable-text"])
    commands.append(base + ["-parse-as-library", "-lLifeDomain", "-lLifePresentation", "-Xlinker", "-rpath", "-Xlinker",
                            "@executable_path/../Frameworks", "-o", str(EXECUTABLE),
                            str(ROOT / "LifeCrossroads/App/LifeWorldMotion.swift"),
                            str(ROOT / "LifeCrossroads/App/LifeWorldScene.swift"), str(EVIDENCE / "render-world.swift")])
    commands.append([str(EXECUTABLE), str(ROOT)])
    with (BUILD / "render-log.txt").open("w") as log:
        for command in commands:
            result = subprocess.run(command, text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
            log.write(" ".join(command) + "\n" + result.stdout + "\n")
            if result.returncode:
                raise RuntimeError(result.stdout)
    manifest = json.loads((EVIDENCE / "offline-render-manifest.json").read_text())
    for image in manifest["images"]:
        image["sha256"] = hashlib.sha256((EVIDENCE / image["file"]).read_bytes()).hexdigest()
    paths = ["LifeCrossroads/App/LifeWorldScene.swift", "LifeCrossroads/App/LifeWorldMotion.swift",
             "LifeCrossroads/Presentation/LifeWorldFrame.swift", "LifeCrossroads/Data/Resources/catalog.json",
             "LifeCrossroads/App/Assets.xcassets/StoryCast.imageset/story-cast.png",
             "LifeCrossroads/App/Assets.xcassets/RiverCrossroads.imageset/river-crossroads.png"]
    manifest["sourceHashes"] = {path: hashlib.sha256((ROOT / path).read_bytes()).hexdigest() for path in paths}
    (EVIDENCE / "offline-render-manifest.json").write_text(json.dumps(manifest, ensure_ascii=False, indent=2) + "\n")
    print(f"Rendered {len(manifest['images'])} offline frames; hashes and actual Session provenance recorded.")


if __name__ == "__main__":
    main()
