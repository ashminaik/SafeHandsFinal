import SwiftUI
import SwiftData
import UIKit

// MARK: - Discover View

struct DiscoverView: View {
    @State private var viewModel = DiscoverViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var isVisible = false

    // Navigation state
    @State private var showTherapyFilter = false
    @State private var showEntitlements = false
    @State private var showNGOs = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.warmCream.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {

                        // ── HEADER ───────────────────────
                        headerSection

                        // ── ACTION ROWS ──────────────────
                        actionRowsSection

                        // ── BOTTOM SPACER ────────────────
                        Color.clear.frame(height: 32)
                    }
                }
            }
            .navigationDestination(isPresented: $showTherapyFilter) {
                TherapyFilterView()
            }
            .navigationDestination(isPresented: $showEntitlements) {
                EntitlementsView()
            }
            .navigationDestination(isPresented: $showNGOs) {
                // Placeholder for now
                // Will be TherapistListView filtered to NGO only
                Text("NGOs")
                    .foregroundColor(Color.deepIndigo)
            }
            .navigationBarHidden(true)
        }
        .task {
            viewModel.loadData(context: modelContext)
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true
            }
        }
    }
}

// MARK: - Header Section

extension DiscoverView {

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 0) {

            // Top bar — logo left, bell right
            HStack {
                // Leaf icon — SafeHands brand mark
                Image(systemName: "leaf.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color.sageGreen)

                Spacer()

                // Notification bell — non-functional for now
                Button { } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(Color.warmGrey)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)

            // ── Generous breath between bar and greeting ──
            Spacer().frame(height: 36)

            // Time greeting
            Text(viewModel.timeGreeting)
                .font(SHFont.body(17))
                .foregroundColor(Color.warmGrey)
                .padding(.horizontal, 24)

            // ── Comfortable gap before the big headline ──
            Spacer().frame(height: 10)

            // Main headline — serif, large, deepIndigo
            // "Here's what Aarav needs right now."
            Text(viewModel.headlineText)
                .font(SHFont.serifHeadline(32))
                .foregroundColor(Color.deepIndigo)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 24)

            // ── Room to breathe before action rows ──
            Spacer().frame(height: 40)
        }
        // Entrance animation
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 16)
        .animation(.easeOut(duration: 0.4).delay(0.05),
                   value: isVisible)
    }
}

// MARK: - Action Rows Section

extension DiscoverView {

    private var actionRowsSection: some View {
        VStack(spacing: 12) {

            // ROW 1 — Find a therapist (PRIORITY — terracotta left border)
            DiscoverActionRow(
                icon: "person.2.fill",
                iconColor: Color.terracotta,
                title: "Find a therapist for \(viewModel.childName.isEmpty ? "your child" : viewModel.childName)",
                subtitle: "Speech · OT · Behavioral",
                meta: "\(viewModel.therapyCenterCount) options near Faridabad",
                showLeftBorder: true,
                badgeCount: nil
            ) {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                showTherapyFilter = true
            }

            // ROW 2 — Aarav's entitlements
            DiscoverActionRow(
                icon: "shield.fill",
                iconColor: Color.sageGreen,
                title: "\(viewModel.childName.isEmpty ? "Your child" : viewModel.childName)\u{2019}s entitlements",
                subtitle: "Support the government owes you",
                meta: "\(viewModel.unclaimedEntitlementsCount) benefits not yet claimed",
                showLeftBorder: false,
                badgeCount: viewModel.unclaimedEntitlementsCount
            ) {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                showEntitlements = true
            }

            // ROW 3 — NGOs near you
            DiscoverActionRow(
                icon: "person.3.fill",
                iconColor: Color.warmBrown,
                title: "NGOs near you",
                subtitle: "Quality care, lower cost",
                meta: "\(viewModel.ngoCount) centers in Faridabad",
                showLeftBorder: false,
                badgeCount: nil
            ) {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                showNGOs = true
            }

            // ROW 4 — Not seeing enough progress?
            DiscoverActionRow(
                icon: "chart.line.uptrend.xyaxis",
                iconColor: Color.deepIndigo.opacity(0.6),
                title: "Not seeing enough progress?",
                subtitle: "Signs therapy is working at home",
                meta: nil,
                showLeftBorder: false,
                badgeCount: nil
            ) {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                // Placeholder — content screen built later
            }
        }
        .padding(.horizontal, 20)
        // Staggered entrance animations
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 20)
        .animation(.easeOut(duration: 0.45).delay(0.15),
                   value: isVisible)
    }
}

// MARK: - Discover Action Row Component

private struct DiscoverActionRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let meta: String?
    let showLeftBorder: Bool
    let badgeCount: Int?
    let onTap: () -> Void

    @State private var isPressed = false

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {

                // LEFT BORDER — only on row 1
                // Terracotta vertical bar
                if showLeftBorder {
                    Rectangle()
                        .fill(Color.terracotta)
                        .frame(width: 3)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 2)
                        )
                }

                // ICON CONTAINER
                // Rounded square, icon color at 12% opacity bg
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(iconColor.opacity(0.12))
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(iconColor)
                }

                // TEXT CONTENT
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(SHFont.semibold(15))
                        .foregroundColor(Color.deepIndigo)
                        .lineLimit(1)

                    Text(subtitle)
                        .font(SHFont.body(13).italic())
                        .foregroundColor(Color.warmBrown)
                        .lineLimit(1)

                    if let meta = meta {
                        HStack(spacing: 4) {
                            // sageGreen dot for entitlements badge
                            if badgeCount != nil {
                                Circle()
                                    .fill(Color.sageGreen)
                                    .frame(width: 6, height: 6)
                            }
                            Text(meta)
                                .font(SHFont.medium(11))
                                .foregroundColor(
                                    badgeCount != nil
                                    ? Color.sageGreen
                                    : Color.warmGrey
                                )
                        }
                        .padding(.top, 2)
                    }
                }

                Spacer()

                // CHEVRON
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Color.warmGrey.opacity(0.6))
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 16)
            // Extra leading padding if NO left border
            // to keep text aligned with bordered rows
            .padding(.leading, showLeftBorder ? 0 : 3)
            .background(Color.white)
            .clipShape(
                RoundedRectangle(cornerRadius: 18)
            )
            .shadow(
                color: Color.warmShadow.opacity(0.12),
                radius: 8, x: 0, y: 4
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(
                .spring(response: 0.25, dampingFraction: 0.7),
                value: isPressed
            )
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

// MARK: - Preview

#Preview {
    DiscoverView()
        .modelContainer(for: [
            ChildProfile.self,
            JourneyLog.self,
            JourneyStep.self
        ])
}
