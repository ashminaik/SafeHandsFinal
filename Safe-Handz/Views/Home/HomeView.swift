// HomeView.swift
// SafeHands — Views/Home/HomeView.swift
//
// Version 2 — Fixes:
// 1. Auto-completion bug: replaced onTapGesture with Button + .buttonStyle(.plain)
// 2. Sticky button: .safeAreaInset(edge: .bottom) — the correct SwiftUI approach
// 3. Glass nav: .safeAreaInset(edge: .top) — content automatically clears it
// 4. Greeting: defensive rendering, always shows something meaningful

import SwiftUI
import SwiftData

// ─────────────────────────────────────────────
// MARK: — HomeView
// ─────────────────────────────────────────────

struct HomeView: View {

    @State private var viewModel = HomeViewModel()
    @Environment(\.modelContext) private var modelContext

    @State private var showLogging = false
    @State private var isVisible = false

    var switchToAI: (() -> Void)? = nil

    var body: some View {
        NavigationStack {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                // ── Greeting ──────────────────────────────────────
                greetingSection
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 14)
                    .animation(.easeOut(duration: 0.45).delay(0.05), value: isVisible)

                Spacer().frame(height: 24)

                // ── Stats ─────────────────────────────────────────
                statsRow
                    .padding(.horizontal, 24)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 14)
                    .animation(.easeOut(duration: 0.45).delay(0.10), value: isVisible)

                Spacer().frame(height: 14)

                // ── Quote card — contextually aware ───────────────
                quoteCard
                    .padding(.horizontal, 24)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 14)
                    .animation(.easeOut(duration: 0.45).delay(0.15), value: isVisible)

                Spacer().frame(height: 14)

                // ── Log card — changes face based on history ──────
                logContextCard
                    .padding(.horizontal, 24)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 14)
                    .animation(.easeOut(duration: 0.45).delay(0.20), value: isVisible)

                Spacer().frame(height: 32)

                // ── Daily action plan ─────────────────────────────
                dailyActionSection
                    .padding(.horizontal, 24)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 14)
                    .animation(.easeOut(duration: 0.45).delay(0.25), value: isVisible)

                Spacer().frame(height: 32)

                // ── Quick access ──────────────────────────────────
                quickAccessSection
                    .padding(.horizontal, 24)
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 14)
                    .animation(.easeOut(duration: 0.45).delay(0.30), value: isVisible)

                Spacer().frame(height: 32)
            }
        }
        .background(Color.warmCream.ignoresSafeArea())

        // ── NATIVE NAV — Liquid Glass on iOS 26 ─────────────────
        .navigationTitle("safehands")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                } label: {
                    Image(systemName: "bell")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.deepIndigo)
                }
                .buttonStyle(.plain)
            }
        }

        // ── STICKY BOTTOM BUTTON — pinned above tab bar ──────────
        // .safeAreaInset(edge: .bottom) tells ScrollView:
        // "content ends ABOVE this view." Auto-insets the scroll.
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.warmDivider)
                    .frame(height: 0.5)

                StickyLogButton(childName: viewModel.child?.name ?? "Aarav") {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showLogging = true
                }
                .padding(.horizontal, 24)
                .padding(.top, 14)
                .padding(.bottom, 12)
            }
            .background {
                ZStack {
                    Rectangle().fill(.ultraThinMaterial)
                    Color.warmCream.opacity(0.7)
                }
                .ignoresSafeArea()
            }
        }

        .fullScreenCover(isPresented: $showLogging) {
            LoggingCeremonyView(switchToAI: switchToAI)
        }
        .task {
            viewModel.loadData(context: modelContext)
            try? await Task.sleep(for: .milliseconds(80))
            withAnimation {
                isVisible = true
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: Notification.Name("reloadHomeData")
            )
        ) { _ in
            viewModel.loadData(context: modelContext)
        }
        } // NavigationStack
    }

    // ─────────────────────────────────────────
    // MARK: — Greeting Section
    // ─────────────────────────────────────────
    private var greetingSection: some View {
        VStack(alignment: .leading, spacing: 4) {

            Text(viewModel.greeting + ",")
                .font(SHFont.body(15))
                .foregroundColor(Color.warmGrey)

            Text(viewModel.parentName.isEmpty ? "Welcome back" : viewModel.parentName)
                .font(SHFont.serifHeadline(30))
                .foregroundColor(Color.deepIndigo)

            Spacer().frame(height: 4)

            if let child = viewModel.child {
                HStack(spacing: 6) {
                    Text(child.name + "'s journey")
                        .font(SHFont.body(14))
                        .foregroundColor(Color.warmBrown)

                    Text("·")
                        .foregroundColor(Color.warmDivider)

                    Text("Stage \(child.stage)")
                        .font(SHFont.medium(12))
                        .foregroundColor(Color.sageGreen)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.sageGreen.opacity(0.12))
                        .clipShape(Capsule())
                }
            }
        }
    }

    // ─────────────────────────────────────────
    // MARK: — Stats Row
    // ─────────────────────────────────────────
    private var statsRow: some View {
        HStack(spacing: 0) {
            if let child = viewModel.child {
                HomeStatItem(number: "\(child.monthsOnJourney)", label: "months")
                Spacer()
                Rectangle().fill(Color.warmDivider).frame(width: 1, height: 32)
                Spacer()
                HomeStatItem(number: "\(viewModel.completedCount)", label: "steps done")
                Spacer()
                Rectangle().fill(Color.warmDivider).frame(width: 1, height: 32)
                Spacer()
                HomeStatItem(number: "\(child.logs.count)", label: "days logged")
            } else {
                HomeStatItem(number: "—", label: "months")
                Spacer()
                Rectangle().fill(Color.warmDivider).frame(width: 1, height: 32)
                Spacer()
                HomeStatItem(number: "—", label: "steps done")
                Spacer()
                Rectangle().fill(Color.warmDivider).frame(width: 1, height: 32)
                Spacer()
                HomeStatItem(number: "—", label: "days logged")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    // ─────────────────────────────────────────
    // MARK: — Quote Card (Dynamic / Contextual)
    // ─────────────────────────────────────────
    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(contextualQuote)
                .font(SHFont.serifHeadline(17).italic())
                .foregroundColor(Color.deepIndigo)
                .lineSpacing(7)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    private var contextualQuote: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let childName = viewModel.child?.name ?? "your child"
        let lastMood = viewModel.child?.logs.last?.mood
        let logsCount = viewModel.child?.logs.count ?? 0

        // First time — no logs yet
        if logsCount == 0 {
            return "\"You are not alone in this journey. There is beauty in every step you take with \(childName).\""
        }

        // Respond to last logged mood
        switch lastMood {
        case .hardDay:
            return "\"Hard days are part of this too. \(childName) is lucky to have someone who notices.\""
        case .goodMoment:
            return "\"You captured something beautiful. Keep looking — there's more where that came from.\""
        case .noticedSomething:
            return "\"Every observation is a small light. You're building the map, one moment at a time.\""
        default:
            break
        }

        // Time-of-day awareness
        if hour < 12 {
            return "\"Each morning is a fresh page in \(childName)'s story. You help write it.\""
        } else if hour < 17 {
            return "\"The middle of the day is full of small moments. You're watching. That matters.\""
        } else {
            return "\"The quiet evenings matter as much as the milestones. You're doing more than you know.\""
        }
    }

    // ─────────────────────────────────────────
    // MARK: — Contextual Log Card
    // ─────────────────────────────────────────
    @ViewBuilder
    private var logContextCard: some View {
        if viewModel.child?.logs.isEmpty ?? true {
            // Empty state — invite to log
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    if let name = viewModel.child?.name {
                        Text("Log your first observation")
                            .font(SHFont.serifHeadline(17))
                            .foregroundColor(Color.deepIndigo)
                        Text("about \(name)")
                            .font(SHFont.serifHeadline(17))
                            .foregroundColor(Color.deepIndigo)
                    } else {
                        Text("Log your first observation")
                            .font(SHFont.serifHeadline(17))
                            .foregroundColor(Color.deepIndigo)
                    }

                    Spacer().frame(height: 4)

                    Text("Even one line begins to build the picture.")
                        .font(SHFont.body(13).italic())
                        .foregroundColor(Color.warmBrown)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                // Terracotta arrow
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    showLogging = true
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color.terracotta)
                            .frame(width: 44, height: 44)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
            }
            .padding(20)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)

        } else if let lastLog = viewModel.child?.logs.last {
            // Returning user — last log summary
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(lastLog.mood.color.opacity(0.15))
                        .frame(width: 48, height: 48)
                    Text(lastLog.mood.emoji)
                        .font(.system(size: 24))
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("last logged")
                        .font(SHFont.medium(10))
                        .foregroundColor(Color.warmGrey)
                        .textCase(.uppercase)
                        .tracking(0.5)

                    Text(lastLog.mood.displayName)
                        .font(SHFont.semibold(15))
                        .foregroundColor(Color.deepIndigo)

                    if !lastLog.note.isEmpty {
                        Text(lastLog.note)
                            .font(SHFont.body(12))
                            .foregroundColor(Color.warmBrown)
                            .lineLimit(1)
                    }
                }

                Spacer()

                Text(timeAgo(from: lastLog.date))
                    .font(SHFont.body(12))
                    .foregroundColor(Color.warmGrey)
            }
            .padding(16)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
        }
    }

    // ─────────────────────────────────────────
    // MARK: — Daily Action Section
    // ─────────────────────────────────────────
    private var dailyActionSection: some View {
        VStack(alignment: .leading, spacing: 14) {

            HStack {
                Text("daily action plan")
                    .font(SHFont.medium(11))
                    .foregroundColor(Color.warmGrey)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
                Text("for today")
                    .font(SHFont.body(12))
                    .foregroundColor(Color.warmGrey)
            }

            if viewModel.currentSteps.isEmpty {
                VStack(spacing: 6) {
                    Text("All steps complete ✓")
                        .font(SHFont.serifHeadline(20))
                        .foregroundColor(Color.deepIndigo)
                    if let child = viewModel.child {
                        Text("You've completed Stage \(child.stage)")
                            .font(SHFont.body(14))
                            .foregroundColor(Color.warmBrown)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(24)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)

            } else {
                VStack(spacing: 0) {
                    let firstStepNumber = viewModel.currentSteps.first?.stepNumber ?? 0
                    let childName = viewModel.child?.name ?? "Aarav"
                    let totalSteps = viewModel.child?.steps.filter { $0.stage == viewModel.child?.stage }.count ?? 5

                    ForEach(Array(viewModel.currentSteps.enumerated()), id: \.element.id) { index, step in

                        let nextStep: JourneyStep? = (index + 1 < viewModel.currentSteps.count)
                            ? viewModel.currentSteps[index + 1]
                            : nil

                        HomeStepRow(
                            step: step,
                            isLocked: step.stepNumber != firstStepNumber,
                            isVisible: isVisible,
                            rowIndex: index,
                            childName: childName,
                            completedSteps: viewModel.completedCount,
                            totalSteps: totalSteps,
                            nextStep: nextStep
                        ) {
                            viewModel.completeStep(step, context: modelContext)
                        }

                        if index < viewModel.currentSteps.count - 1 {
                            Rectangle()
                                .fill(Color.warmDivider)
                                .frame(height: 1)
                                .padding(.leading, 64)
                        }
                    }
                }
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
            }
        }
    }

    // ─────────────────────────────────────────
    // MARK: — Quick Access Section
    // ─────────────────────────────────────────
    private var quickAccessSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("explore")
                .font(SHFont.medium(11))
                .foregroundColor(Color.warmGrey)
                .textCase(.uppercase)
                .tracking(0.5)

            HStack(spacing: 12) {
                HomeQuickCard(
                    icon: "magnifyingglass",
                    title: "Find providers",
                    subtitle: "Near you"
                )

                HomeQuickCard(
                    icon: "person.3.fill",
                    title: "Join community",
                    subtitle: "Parents like you"
                )
            }
        }
    }

    // ─────────────────────────────────────────
    // MARK: — Helper
    // ─────────────────────────────────────────
    private func timeAgo(from date: Date) -> String {
        let interval = Date().timeIntervalSince(date)
        if interval < 3600  { return "\(max(1, Int(interval / 60)))m ago" }
        if interval < 86400 { return "\(Int(interval / 3600))h ago" }
        return "\(Int(interval / 86400))d ago"
    }
}

// ─────────────────────────────────────────
// MARK: — HomeStepRow
// ─────────────────────────────────────────

struct HomeStepRow: View {
    let step: JourneyStep
    let isLocked: Bool
    let isVisible: Bool
    let rowIndex: Int
    let childName: String
    let completedSteps: Int
    let totalSteps: Int
    let nextStep: JourneyStep?
    let onComplete: () -> Void

    @State private var showDetail = false

    var body: some View {
        Button {
            if isLocked {
                UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
            } else {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showDetail = true
            }
        } label: {
            HStack(spacing: 16) {
                // Numbered circle
                ZStack {
                    Circle()
                        .stroke(isLocked ? Color.warmDivider : Color.sageGreen, lineWidth: 1.5)
                        .frame(width: 34, height: 34)

                    if isLocked {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color.warmGrey.opacity(0.5))
                    } else {
                        Text("\(step.stepNumber)")
                            .font(SHFont.medium(13))
                            .foregroundColor(Color.deepIndigo)
                    }
                }

                // Step content
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.title)
                        .font(SHFont.semibold(15))
                        .foregroundColor(isLocked ? Color.warmGrey : Color.deepIndigo)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(isLocked ? "Complete step \(step.stepNumber - 1) to unlock" : step.detail)
                        .font(SHFont.body(13))
                        .foregroundColor(isLocked ? Color.warmGrey.opacity(0.7) : Color.warmBrown)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer()

                if isLocked {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.warmGrey.opacity(0.4))
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.warmGrey)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .sheet(isPresented: $showDetail) {
            StepDetailView(
                step: step,
                childName: childName,
                completedSteps: completedSteps,
                totalSteps: totalSteps,
                nextStep: nextStep,
                onComplete: {
                    onComplete()
                }
            )
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(
            .easeOut(duration: 0.4).delay(Double(rowIndex) * 0.08 + 0.28),
            value: isVisible
        )
    }
}

// ─────────────────────────────────────────────
// MARK: — HomeGlassNavBar
// ─────────────────────────────────────────────

struct HomeGlassNavBar: View {
    let childName: String

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 2) {
                Text("safehands")
                    .font(SHFont.semibold(14))
                    .foregroundColor(Color.deepIndigo)
                    .tracking(0.3)

                if !childName.isEmpty {
                    Text(childName + "'s space")
                        .font(SHFont.body(11))
                        .foregroundColor(Color.warmGrey)
                }
            }

            Spacer()

            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
            }) {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
                    Image(systemName: "bell")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(Color.deepIndigo)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background {
            ZStack {
                Rectangle().fill(.ultraThinMaterial)
                Color.warmCream.opacity(0.5)
            }
            .ignoresSafeArea()
        }
    }
}

// ─────────────────────────────────────────────
// MARK: — HomeStatItem
// ─────────────────────────────────────────────

struct HomeStatItem: View {
    let number: String
    let label: String

    var body: some View {
        VStack(spacing: 3) {
            Text(number)
                .font(SHFont.serifHeadline(26))
                .foregroundColor(Color.deepIndigo)
            Text(label)
                .font(SHFont.body(12))
                .foregroundColor(Color.warmGrey)
        }
        .frame(maxWidth: .infinity)
    }
}

// ─────────────────────────────────────────────
// MARK: — HomeQuickCard
// ─────────────────────────────────────────────

struct HomeQuickCard: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(Color.warmGrey)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(SHFont.semibold(14))
                    .foregroundColor(Color.deepIndigo)

                Text(subtitle)
                    .font(SHFont.body(12))
                    .foregroundColor(Color.warmGrey)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}

// ─────────────────────────────────────────────
// MARK: — PressScaleButtonStyle
// ─────────────────────────────────────────────

struct PressScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.65), value: configuration.isPressed)
    }
}

// ─────────────────────────────────────────────
// MARK: — StickyLogButton
// ─────────────────────────────────────────────

struct StickyLogButton: View {
    let childName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Text("How was \(childName) today?")
                    .font(SHFont.medium(16))
                    .foregroundColor(.white)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(Color.terracotta)
            .clipShape(Capsule())
            .shadow(color: Color.terracotta.opacity(0.35), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(PressScaleButtonStyle())
    }
}
