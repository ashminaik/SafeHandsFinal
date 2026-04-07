import SwiftUI
import SwiftData

@Observable
final class DiscoverViewModel {

    var childName: String = ""
    var parentName: String = ""
    var childStage: Int = 1
    var therapyCenterCount: Int = 5
    var ngoCount: Int = 3
    var unclaimedEntitlementsCount: Int = 2

    func loadData(context: ModelContext) {
        // Load from SwiftData
        let descriptor = FetchDescriptor<ChildProfile>()
        if let child = try? context.fetch(descriptor).first {
            childName = child.name
            childStage = child.stage
        }
        // Load parent name from UserDefaults
        parentName = UserDefaults.standard
            .string(forKey: "parentName") ?? ""
    }

    // Time-based greeting — returns "Good morning" etc
    var timeGreeting: String {
        let hour = Calendar.current
            .component(.hour, from: Date())
        if hour < 12      { return "Good morning." }
        else if hour < 17 { return "Good afternoon." }
        else if hour < 21 { return "Good evening." }
        else              { return "Hey." }
    }

    // Headline uses child name
    // "Here's what Aarav needs right now."
    var headlineText: String {
        guard !childName.isEmpty else {
            return "Here\u{2019}s what your child needs right now."
        }
        return "Here\u{2019}s what \(childName) needs right now."
    }
}
