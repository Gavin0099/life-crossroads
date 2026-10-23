import SwiftUI

@main
struct LifeCrossroadsApp: App {
    var body: some Scene {
        WindowGroup {
            if ProcessInfo.processInfo.arguments.contains("-workshop") { WorkshopWorldView() }
            else { CrossroadsView() }
        }
    }
}
