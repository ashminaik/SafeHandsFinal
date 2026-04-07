import SwiftUI
import SwiftData

@Observable
class HomeViewModel {
    var child: ChildProfile?
    var currentSteps: [JourneyStep] = []
    var completedCount: Int = 0

    func loadData(context: ModelContext) {
        let descriptor = FetchDescriptor<ChildProfile>()
        let children = try? context.fetch(descriptor)
        self.child = children?.first

        guard let child = child else { return }

        // Get next 3 uncompleted steps for her stage
        currentSteps = child.steps
            .filter { $0.stage == child.stage && !$0.isCompleted }
            .sorted { $0.stepNumber < $1.stepNumber }
            .prefix(3)
            .map { $0 }

        completedCount = child.steps
            .filter { $0.isCompleted && $0.stage == child.stage }
            .count
    }

    func completeStep(_ step: JourneyStep, context: ModelContext) {
        step.isCompleted = true
        step.completedDate = Date()
        try? context.save()
        loadData(context: context)
    }

    /// Resets ALL steps for the current stage back to not-completed.
    func resetCurrentStageSteps(context: ModelContext) {
        guard let child = child else { return }
        for step in child.steps where step.stage == child.stage {
            step.isCompleted = false
            step.completedDate = nil
        }
        try? context.save()
        loadData(context: context)
    }

    var parentName: String {
        UserDefaults.standard.string(forKey: "parentName") ?? "Parent"
    }

    var greeting: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<17: return "Good afternoon"
        case 17..<21: return "Good evening"
        default: return "Good night"
        }
    }
}
