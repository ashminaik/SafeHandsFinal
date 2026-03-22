import SwiftUI

struct StepCard: View {
    let step: JourneyStep
    let onComplete: () -> Void

    var body: some View {
        Text(step.title)
    }
}
