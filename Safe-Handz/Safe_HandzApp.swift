import SwiftUI
import SwiftData

@main
struct Safe_HandzApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            ChildProfile.self,
            JourneyLog.self,
            JourneyStep.self
        ])
    }
}
