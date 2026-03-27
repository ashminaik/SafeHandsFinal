import SwiftUI
import SwiftData

struct ProfileView: View {

    @State private var viewModel = HomeViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var showResetConfirm = false
    @State private var showSignOutConfirm = false
    @AppStorage("onboardingComplete") private var onboardingComplete = false
    @AppStorage("preOnboardingComplete") private var preOnboardingComplete = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer()

                // ── Avatar ────────────────────────────────
                if let child = viewModel.child {
                    Text(String(child.name.prefix(1)))
                        .font(SHFont.serifHeadline(32))
                        .foregroundColor(.white)
                        .frame(width: 72, height: 72)
                        .background(Color.sageGreen)
                        .clipShape(Circle())
                }

                Text("Profile")
                    .font(SHFont.serifHeadline(22))
                    .foregroundStyle(Color.deepIndigo)

                if let child = viewModel.child {
                    Text("\(child.name) · Stage \(child.stage)")
                        .font(SHFont.body(14))
                        .foregroundColor(Color.warmBrown)

                    if !viewModel.parentName.isEmpty {
                        Text("Parent: \(viewModel.parentName)")
                            .font(SHFont.body(13))
                            .foregroundColor(Color.warmGrey)
                    }

                    // ── Stats ─────────────────────────────
                    HStack(spacing: 24) {
                        ProfileStatView(
                            number: "\(child.logs.count)",
                            label: "logs"
                        )
                        Rectangle()
                            .fill(Color.warmDivider)
                            .frame(width: 1, height: 28)
                        ProfileStatView(
                            number: "\(child.monthsOnJourney)",
                            label: "months"
                        )
                    }
                    .padding(.top, 4)
                }

                Spacer()

                // ── Dev tools ─────────────────────────────
                VStack(spacing: 10) {
                    Text("DEVELOPER TOOLS")
                        .font(SHFont.medium(10))
                        .foregroundColor(Color.warmGrey)
                        .tracking(0.5)

                    Button {
                        showResetConfirm = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.counterclockwise")
                                .font(.system(size: 13, weight: .medium))
                            Text("Reset current stage steps")
                                .font(SHFont.medium(14))
                        }
                        .foregroundColor(Color.terracotta)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.terracotta.opacity(0.08))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)

                    Button {
                        showSignOutConfirm = true
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.system(size: 13, weight: .medium))
                            Text("Sign out & reset all data")
                                .font(SHFont.medium(14))
                        }
                        .foregroundColor(.red.opacity(0.8))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 13)
                        .background(Color.red.opacity(0.06))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
            .safeHandsBackground()
            .navigationTitle("profile")
            .navigationBarTitleDisplayMode(.inline)
            // ── Reset Steps Alert ─────────────────────
            .alert("Reset Steps?", isPresented: $showResetConfirm) {
                Button("Reset", role: .destructive) {
                    viewModel.resetCurrentStageSteps(context: modelContext)
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    // Tell HomeView to reload its data
                    NotificationCenter.default.post(
                        name: Notification.Name("reloadHomeData"),
                        object: nil
                    )
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will mark all steps in the current stage as not completed.")
            }
            // ── Sign Out Alert ────────────────────────
            .alert("Sign out & reset?", isPresented: $showSignOutConfirm) {
                Button("Sign Out", role: .destructive) {
                    signOutAndReset()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will delete all data — child profile, logs, steps — and return to onboarding. This cannot be undone.")
            }
            .task {
                viewModel.loadData(context: modelContext)
            }
        }
    }

    // ── Full data wipe ────────────────────────────
    private func signOutAndReset() {
        UINotificationFeedbackGenerator().notificationOccurred(.warning)

        // 1. Delete all SwiftData models
        do {
            let children = try modelContext.fetch(FetchDescriptor<ChildProfile>())
            for child in children {
                modelContext.delete(child)  // cascade-deletes logs + steps
            }
            try modelContext.save()
        } catch {
            print("Reset error: \(error)")
        }

        // 2. Clear AppStorage flags and UserDefaults keys
        UserDefaults.standard.removeObject(forKey: "parentName")
        
        // Ensure UserDefaults is explicitly updated
        UserDefaults.standard.set(false, forKey: "preOnboardingComplete")
        UserDefaults.standard.set(false, forKey: "onboardingComplete")
        
        // 3. Flip AppStorage flags immediately so ContentView picks them up
        withAnimation(.easeInOut(duration: 0.4)) {
            preOnboardingComplete = false
            onboardingComplete = false
        }
    }
}

// ── Small stat component ──────────────────────────
private struct ProfileStatView: View {
    let number: String
    let label: String

    var body: some View {
        VStack(spacing: 2) {
            Text(number)
                .font(SHFont.semibold(18))
                .foregroundColor(Color.deepIndigo)
            Text(label)
                .font(SHFont.body(12))
                .foregroundColor(Color.warmGrey)
        }
    }
}
