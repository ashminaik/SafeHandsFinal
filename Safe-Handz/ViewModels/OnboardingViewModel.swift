import SwiftUI
import SwiftData

@Observable
class OnboardingViewModel {
    var currentStep: Int = 0
    var childName: String = ""
    var childAge: String = ""
    var selectedStage: Int = 0
    var city: String = ""
    var primaryConcern: String = ""
    var parentName: String = ""
    var selectedPainPoints: Set<String> = []
    var skipCity: Bool = false

    var isOnboardingComplete: Bool {
        !childName.isEmpty && !parentName.isEmpty && selectedStage > 0
    }

    let stages = [
        (number: 1, title: "Just diagnosed", description: "We received the diagnosis recently"),
        (number: 2, title: "Early intervention", description: "Started therapy in the last year"),
        (number: 3, title: "In therapy", description: "Regular therapy for 1–2 years"),
        (number: 4, title: "School transition", description: "Preparing for school integration"),
        (number: 5, title: "Long term planning", description: "Planning for adult life")
    ]

    func saveProfile(context: ModelContext) {
        let age = Int(childAge) ?? 6
        let child = ChildProfile(
            name: childName,
            age: age,
            stage: selectedStage,
            city: city
        )
        child.primaryConcern = selectedPainPoints.isEmpty
            ? primaryConcern
            : selectedPainPoints.joined(separator: ", ")

        // Seed the steps for her stage
        let stepContents = StepContent.steps(for: selectedStage)
        for content in stepContents {
            let step = JourneyStep(
                stepNumber: content.number,
                stage: selectedStage,
                title: content.title,
                detail: content.detail
            )
            child.steps.append(step)
        }

        context.insert(child)

        // Save parent name to UserDefaults
        UserDefaults.standard.set(parentName, forKey: "parentName")
        UserDefaults.standard.set(true, forKey: "onboardingComplete")

        try? context.save()
    }
}
