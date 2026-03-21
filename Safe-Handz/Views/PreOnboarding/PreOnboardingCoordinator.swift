import SwiftUI

enum PreOnboardingStep {
    case awareness
    case featureCards
    case readPreview
    case entryPoint
}

struct PreOnboardingCoordinator: View {
    @State private var currentStep: PreOnboardingStep = .awareness
    
    var authService: AuthenticationService
    
    var body: some View {
        switch currentStep {
        case .awareness:
            Screen1_AwarenessView(
                onBegin: {
                    withAnimation { currentStep = .featureCards }
                },
                onSkip: {
                    withAnimation { currentStep = .entryPoint }
                }
            )
        case .featureCards:
            FeatureCardsView(
                onBack: {
                    withAnimation { currentStep = .awareness }
                },
                onContinue: {
                    withAnimation { currentStep = .readPreview }
                },
                onSkip: {
                    withAnimation { currentStep = .entryPoint }
                }
            )
        case .readPreview:
            ReadPreviewView(
                onBack: {
                    withAnimation { currentStep = .featureCards }
                },
                onStageSelected: {
                    withAnimation { currentStep = .entryPoint }
                }
            )
        case .entryPoint:
            EntryPointView(
                authService: authService,
                onBack: {
                    withAnimation { currentStep = .readPreview }
                },
                onComplete: {
                    UserDefaults.standard.set(true, forKey: "preOnboardingComplete")
                    NotificationCenter.default.post(
                        name: Notification.Name("preOnboardingCompleted"),
                        object: nil
                    )
                }
            )
        }
    }
}
