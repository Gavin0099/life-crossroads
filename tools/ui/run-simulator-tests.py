#!/usr/bin/env python3
"""Run a UI prototype on a temporary Simulator; retain evidence, always delete device."""
import argparse
from contextlib import contextmanager
import json
from pathlib import Path
import subprocess
import uuid

ROOT = Path(__file__).resolve().parents[2]


def select_runtime(device_type, requested=None):
    runtimes = json.loads(subprocess.check_output(
        ["xcrun", "simctl", "list", "runtimes", "-j"], text=True))["runtimes"]
    available = [r for r in runtimes if r.get("isAvailable") and r.get("platform") == "iOS"
                 and any(d["identifier"] == device_type for d in r.get("supportedDeviceTypes", []))
                 and (requested is None or r["identifier"] == requested)]
    if not available:
        raise ValueError("No installed iOS runtime supports the requested device type")
    return max(available, key=lambda r: tuple(int(n) for n in r["version"].split(".")))["identifier"]


@contextmanager
def temporary_simulator(device_type, runtime):
    # Only this returned ID is owned; never delete by a broad name or 'all'.
    device_id = subprocess.check_output([
        "xcrun", "simctl", "create", f"LC UI temporary {uuid.uuid4().hex[:8]}",
        device_type, runtime], text=True).strip()
    print(f"Created temporary Simulator: {device_id}", flush=True)
    try:
        yield device_id
    finally:
        # A successful test run may already have shut it down.
        subprocess.run(["xcrun", "simctl", "shutdown", device_id],
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
        subprocess.run(["xcrun", "simctl", "delete", device_id], check=True)
        print(f"Deleted temporary Simulator: {device_id}", flush=True)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--scheme", choices=["EventFirst", "WorldGameplay"], default="EventFirst")
    parser.add_argument("--device-type", default="iPhone-17", help="simctl type identifier or suffix")
    parser.add_argument("--runtime", help="Optional installed runtime identifier")
    parser.add_argument("--result-bundle", type=Path, help="External xcresult path (must not exist)")
    parser.add_argument("--only-testing", action="append", default=[], help="Xcode test identifier")
    args = parser.parse_args()
    device_type = args.device_type if args.device_type.startswith("com.apple.") else "com.apple.CoreSimulator.SimDeviceType." + args.device_type
    runtime = select_runtime(device_type, args.runtime)
    result = args.result_bundle or (ROOT / f"UIPrototype/{args.scheme}/DerivedData" / f"run-{uuid.uuid4().hex}.xcresult")
    result = result.resolve()
    if result.exists():
        parser.error(f"Result bundle already exists: {result}")
    result.parent.mkdir(parents=True, exist_ok=True)
    print(f"Retained result bundle: {result}", flush=True)
    with temporary_simulator(device_type, runtime) as device_id:
        command = ["xcodebuild", "-project", f"UIPrototype/{args.scheme}.xcodeproj", "-scheme", args.scheme,
                   "-destination", f"platform=iOS Simulator,id={device_id}", "-parallel-testing-enabled", "NO",
                   "-collect-test-diagnostics", "never", "-test-timeouts-enabled", "YES",
                   "-maximum-test-execution-time-allowance", "120", "-derivedDataPath", f"UIPrototype/{args.scheme}/DerivedData",
                   "-resultBundlePath", str(result), "CODE_SIGNING_ALLOWED=NO", "test"]
        command.extend(f"-only-testing:{test}" for test in args.only_testing)
        return subprocess.run(command, cwd=ROOT, check=False).returncode


if __name__ == "__main__":
    raise SystemExit(main())
