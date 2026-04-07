import SwiftUI

// MARK: - Tab Definition

enum SHTab: String, CaseIterable {
    case home
    case discover
    case learn
    case ai
    case profile
}

// MARK: - Content View

struct ContentView: View {
    @State private var selectedTab: SHTab = .home
    @AppStorage("preOnboardingComplete") var preOnboardingComplete: Bool = false
    @AppStorage("onboardingComplete") var onboardingComplete: Bool = false
    @State private var aiFromLogging = false
    
    // Auth Service is initialized here at the root level
    @State private var authService = AuthenticationService()

    var body: some View {
        Group {
            if !preOnboardingComplete {
                PreOnboardingCoordinator(authService: authService)
            } else if !onboardingComplete {
                OnboardingView()
            } else {
                mainTabView
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: Notification.Name("onboardingCompleted")
            )
        ) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                onboardingComplete = true
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: Notification.Name("preOnboardingCompleted")
            )
        ) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                preOnboardingComplete = true
            }
        }
    }

    // MARK: - Main Tab View

    private var mainTabView: some View {
        TabView(selection: $selectedTab) {
            Tab("home", systemImage: "house.fill", value: .home) {
                HomeView(switchToAI: {
                    aiFromLogging = true
                    selectedTab = .ai
                })
            }

            Tab("discover", systemImage: "magnifyingglass", value: .discover) {
                DiscoverView()
            }

            Tab("learn", systemImage: "book.pages.fill", value: .learn) {
                LearnHubView()
            }

            Tab("ai", systemImage: "sparkles", value: .ai) {
                AIView(fromLogging: aiFromLogging)
            }

            Tab("profile", systemImage: "person.fill", value: .profile) {
                ProfileView()
            }
        }
        .tint(Color.deepIndigo)
        .onChange(of: selectedTab) { oldTab, newTab in
            if newTab == .ai && oldTab != .home {
                aiFromLogging = false
            }
            if oldTab == .ai && newTab != .ai {
                aiFromLogging = false
            }
        }
        .onChange(of: onboardingComplete) { _, newValue in
            if !newValue {
                selectedTab = .home
            }
        }
    }
}
