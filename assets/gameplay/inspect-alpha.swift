// Read-only asset QA. Run from repo root: swift assets/gameplay/inspect-alpha.swift
// This inspects source pixels; it never writes or edits a raster image.
import AppKit

let path = "assets/gameplay/characters-atlas-v2.png"
let bitmap = NSBitmapImageRep(data: try Data(contentsOf: URL(fileURLWithPath: path)))!
let width = bitmap.pixelsWide, height = bitmap.pixelsHigh
var alpha = [UInt8](repeating: 0, count: width * height)
var histogram = [Int](repeating: 0, count: 256)
for y in 0..<height {
    for x in 0..<width {
        var channels = [UInt](repeating: 0, count: 4)
        bitmap.getPixel(&channels, atX: x, y: y)
        alpha[y * width + x] = UInt8(channels[3])
        histogram[Int(channels[3])] += 1
    }
}

// Alpha >= 16/255 excludes only the faint outer fringe. This is the visible
// silhouette boundary used to validate rectangles, not a modified output.
var visited = [Bool](repeating: false, count: width * height)
var components = [[String: Int]]()
for start in 0..<(width * height) where !visited[start] && alpha[start] >= 16 {
    var queue = [start], index = 0
    var minX = start % width, maxX = minX, minY = start / width, maxY = minY
    visited[start] = true
    while index < queue.count {
        let pixel = queue[index]; index += 1
        let x = pixel % width, y = pixel / width
        minX = min(minX, x); maxX = max(maxX, x)
        minY = min(minY, y); maxY = max(maxY, y)
        for next in [x > 0 ? pixel - 1 : -1, x + 1 < width ? pixel + 1 : -1,
                     y > 0 ? pixel - width : -1, y + 1 < height ? pixel + width : -1] {
            if next >= 0 && !visited[next] && alpha[next] >= 16 {
                visited[next] = true; queue.append(next)
            }
        }
    }
    if queue.count > 500 {
        components.append(["x": minX, "y": minY, "width": maxX - minX + 1,
                           "height": maxY - minY + 1, "pixels": queue.count])
    }
}
let manifest = try JSONSerialization.jsonObject(with: Data(contentsOf:
    URL(fileURLWithPath: "assets/gameplay/manifest.json"))) as! [String: Any]
let asset = (manifest["assets"] as! [[String: Any]]).first {
    $0["asset_id"] as? String == "gs-characters-atlas-v2"
}!
let sprites = asset["sprites"] as! [[String: Any]]
let checks: [[String: Any]] = sprites.map { sprite in
    let rect = sprite["crop_rect_px"] as! [String: Int]
    let contained = components.filter { c in
        c["x"]! >= rect["x"]! && c["y"]! >= rect["y"]! &&
        c["x"]! + c["width"]! <= rect["x"]! + rect["width"]! &&
        c["y"]! + c["height"]! <= rect["y"]! + rect["height"]!
    }
    return ["sprite": sprite["id"]!, "one_complete_visible_component": contained.count == 1,
            "contained_components": contained]
}
let pass = bitmap.hasAlpha && components.count == 5 && histogram[0] > width * height / 2 &&
    checks.allSatisfy { $0["one_complete_visible_component"] as! Bool }
let result: [String: Any] = [
    "path": path, "width": width, "height": height, "has_alpha": bitmap.hasAlpha,
    "fully_transparent_pixels": histogram[0], "total_pixels": width * height,
    "visible_alpha_threshold": 16, "major_components": components.count,
    "crop_checks": checks, "result": pass ? "PASS" : "FAIL",
    "claim_boundary": "Pixel transparency and visible crop containment only; no human art, age or licensing approval."
]
print(String(data: try JSONSerialization.data(withJSONObject: result,
    options: [.prettyPrinted, .sortedKeys]), encoding: .utf8)!)
if !pass { exit(1) }
