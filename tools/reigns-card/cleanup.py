"""Delete only Simulator UUIDs recorded by this capture, including after CI cancellation."""
import json
from pathlib import Path
import subprocess
import sys
from uuid import UUID


def inventory():
    data = json.loads(subprocess.check_output(["xcrun", "simctl", "list", "devices", "-j"], text=True))
    return {item["udid"] for devices in data["devices"].values() for item in devices}


def cleanup(folder):
    folder = Path(folder)
    owned = sorted({p.read_text().strip() for p in folder.glob("*/device.txt")})
    # Validate all records before the first mutation. Never derive ownership from inventory.
    for device in owned:
        if str(UUID(device)).upper() != device.upper():
            raise ValueError("Invalid recorded Simulator UUID")
    before = inventory()
    deleted = []
    for device in owned:
        if device not in before:
            continue
        subprocess.run(["xcrun", "simctl", "shutdown", device], check=False,
                       stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        subprocess.run(["xcrun", "simctl", "delete", device], check=True)
        deleted.append(device)
    after = inventory()
    if set(owned) & after:
        raise RuntimeError("Recorded Simulator still exists after cleanup")
    receipt = {"recorded": owned, "deletedByBackup": deleted,
               "alreadyAbsent": sorted(set(owned) - before), "remainingOtherDevices": sorted(after)}
    folder.mkdir(parents=True, exist_ok=True)
    (folder / "cleanup.json").write_text(json.dumps(receipt, indent=2) + "\n")
    return receipt


if __name__ == "__main__":
    print(json.dumps(cleanup(sys.argv[1])))
