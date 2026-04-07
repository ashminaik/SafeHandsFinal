import SwiftUI
import SwiftData

enum CeremonyPhase {
    case selectingMood
    case writingNote
    case sealing
    case stillness
    case door
    case talking
}

@Observable
class LoggingViewModel {
    var phase: CeremonyPhase = .selectingMood
    var selectedMood: MoodType? = nil
    var noteText: String = ""
    var isInteractionDisabled: Bool = false
    var showInitial: Bool = false
    var showConfirmation: Bool = false
    var rippleStartDate: Date? = nil
    var child: ChildProfile?

    func loadChild(context: ModelContext) {
        let descriptor = FetchDescriptor<ChildProfile>()
        child = try? context.fetch(descriptor).first
    }

    func selectMood(_ mood: MoodType) {
        selectedMood = mood
    }

    func submitNote(context: ModelContext) {
        guard let mood = selectedMood else { return }

        // Save log
        let log = JourneyLog(mood: mood, note: noteText)
        child?.logs.append(log)
        try? context.save()

        // Move to sealing ceremony
        withAnimation(.easeInOut(duration: 0.3)) {
            phase = .sealing
        }
        rippleStartDate = Date()

        // Run ceremony sequence — fast and felt
        Task { @MainActor in
            // Show child initial after brief pause
            try? await Task.sleep(for: .milliseconds(150))
            withAnimation(.easeIn(duration: 0.25)) {
                showInitial = true
            }
            // Hold for the ripple to expand
            try? await Task.sleep(for: .milliseconds(600))
            // Fade out initial
            withAnimation(.easeOut(duration: 0.2)) {
                showInitial = false
            }
            try? await Task.sleep(for: .milliseconds(250))
            // Advance to door
            withAnimation(.easeInOut(duration: 0.3)) {
                phase = .door
            }
        }
    }

    func reset() {
        phase = .selectingMood
        selectedMood = nil
        noteText = ""
        showInitial = false
        showConfirmation = false
        rippleStartDate = nil
        isInteractionDisabled = false
    }

    var childInitial: String {
        String(child?.name.prefix(1) ?? "A")
    }

    var childName: String {
        child?.name ?? "Aarav"
    }
}
