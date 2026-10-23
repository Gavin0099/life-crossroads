// Versioned, keyed randomness. No Swift Hasher, global state or clock.
public enum KeyedRandom {
    public static let version = "fnv1a-splitmix64-v1"

    public static func mix(_ input: UInt64) -> UInt64 {
        var z = input &+ 0x9e3779b97f4a7c15
        z = (z ^ (z >> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z >> 27)) &* 0x94d049bb133111eb
        return z ^ (z >> 31)
    }

    public static func draw(seed: UInt64, key: String) -> Double {
        var hash: UInt64 = 0xcbf29ce484222325
        for byte in key.utf8 { hash = (hash ^ UInt64(byte)) &* 0x100000001b3 }
        return Double(mix(seed ^ hash) >> 11) / 9_007_199_254_740_992.0
    }

    public static func key(eventID: String, age: Int, channel: String) -> String {
        "\(eventID.utf8.count):\(eventID)|\(age)|0|\(channel.utf8.count):\(channel)"
    }
}
