import SwiftUI

@main
struct WorldGameplayApp: App {
    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.arguments.contains("-acting-contact-sheet") {
                ActingContactSheet()
            } else {
                WorldGameplayView()
            }
        }
    }
}
