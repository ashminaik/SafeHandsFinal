// StepDetailView.swift
// SafeHands — Views/Home/StepDetailView.swift
//
// 3-screen flow presented as .sheet from HomeStepRow.
// Screen 1: Step detail with question cards
// Screen 2: Session questions (warm bg)
// Screen 3: Completion celebration + up next

import SwiftUI

// ─────────────────────────────────────────────
// MARK: — StepDetailView (Container)
// ─────────────────────────────────────────────

struct StepDetailView: View {
    let step: JourneyStep
    let childName: String
    let completedSteps: Int
    let totalSteps: Int
    let nextStep: JourneyStep?
    let onComplete: () -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var currentScreen: Int = 1

    var body: some View {
        ZStack {
            switch currentScreen {
            case 1:
                StepDetailScreen1(
                    step: step,
                    childName: childName,
                    totalSteps: totalSteps,
                    onDismiss: { dismiss() },
                    onReady: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 2
                        }
                    }
                )
                .transition(.move(edge: .leading))

            case 2:
                StepDetailScreen2(
                    step: step,
                    childName: childName,
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 1
                        }
                    },
                    onSessionComplete: {
                        onComplete()
                        withAnimation(.easeInOut(duration: 0.3)) {
                            currentScreen = 3
                        }
                    }
                )
                .transition(.move(edge: .trailing))

            case 3:
                StepDetailScreen3(
                    step: step,
                    childName: childName,
                    completedSteps: completedSteps + 1,
                    totalSteps: totalSteps,
                    nextStep: nextStep,
                    onBackToHome: { dismiss() }
                )
                .transition(.move(edge: .trailing))

            default:
                EmptyView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: currentScreen)
    }
}

// ═════════════════════════════════════════════
// MARK: — Screen 1: Step Detail + Question Cards
// ═════════════════════════════════════════════

private struct StepDetailScreen1: View {
    let step: JourneyStep
    let childName: String
    let totalSteps: Int
    let onDismiss: () -> Void
    let onReady: () -> Void

    @State private var isVisible = false

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                Spacer().frame(height: 100)

                // ── Identity section ─────────────────────────
                Group {
                    // Step pill
                    Text("STEP \(step.stepNumber)")
                        .font(SHFont.medium(11))
                        .foregroundColor(Color.terracotta)
                        .tracking(0.5)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color.terracotta.opacity(0.12))
                        .clipShape(Capsule())

                    Spacer().frame(height: 12)

                    // Subtitle
                    Text("Ask your therapist")
                        .font(SHFont.body(16))
                        .foregroundColor(Color.sageGreen)

                    Spacer().frame(height: 4)

                    // Main headline — serif, emotional
                    Text("the right questions.")
                        .font(SHFont.serifHeadline(32))
                        .foregroundColor(Color.deepIndigo)

                    Spacer().frame(height: 20)

                    // Time row
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 13))
                            .foregroundColor(Color.warmGrey)
                        Text("Takes 5 minutes · Do this at your next session")
                            .font(SHFont.body(13))
                            .foregroundColor(Color.warmGrey)
                    }
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.05), value: isVisible)

                Spacer().frame(height: 28)

                // ── Context card ─────────────────────────────
                Group {
                    contextCard
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.12), value: isVisible)

                Spacer().frame(height: 32)

                // ── What to ask section ──────────────────────
                Group {
                    Text("What to ask — word for word")
                        .font(SHFont.semibold(17))
                        .foregroundColor(Color.deepIndigo)

                    Spacer().frame(height: 4)

                    Text("You can show your therapist this screen directly.")
                        .font(SHFont.body(13))
                        .foregroundColor(Color.warmBrown)

                    Spacer().frame(height: 16)

                    VStack(spacing: 12) {
                        ForEach(Array(questionCards.enumerated()), id: \.offset) { index, card in
                            QuestionCard(
                                question: card.question,
                                reason: card.reason
                            )
                            .opacity(isVisible ? 1 : 0)
                            .offset(y: isVisible ? 0 : 12)
                            .animation(
                                .easeOut(duration: 0.35).delay(0.22 + Double(index) * 0.06),
                                value: isVisible
                            )
                        }
                    }
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.19), value: isVisible)

                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.warmCream.ignoresSafeArea())

        // ── Back button ──────────────────────────────────
        .overlay(alignment: .topLeading) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onDismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 36, height: 36)
                        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.deepIndigo)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 56)
            .padding(.leading, 24)
        }

        // ── Step counter ─────────────────────────────────
        .overlay(alignment: .topTrailing) {
            Text("Step \(step.stepNumber) of \(totalSteps)")
                .font(SHFont.body(13))
                .foregroundColor(Color.warmGrey)
                .padding(.top, 64)
                .padding(.trailing, 24)
        }

        // ── Bottom CTA ───────────────────────────────────
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.warmDivider.opacity(0.6))
                    .frame(height: 0.5)

                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onReady()
                } label: {
                    HStack(spacing: 10) {
                        Text("I'm ready — show me this at my next session")
                            .font(SHFont.medium(15))
                        Image(systemName: "arrow.right")
                            .font(.system(size: 13, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.terracotta)
                    .clipShape(Capsule())
                    .shadow(color: Color.terracotta.opacity(0.30), radius: 12, x: 0, y: 4)
                }
                .buttonStyle(.plain)
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

        .task {
            try? await Task.sleep(for: .milliseconds(80))
            withAnimation { isVisible = true }
        }
    }

    // ── Context card ─────────────────────────────────
    private var contextCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("\(childName) spends ")
                .font(SHFont.body(15))
                .foregroundColor(Color.deepIndigo)
            +
            Text("3 hours")
                .font(SHFont.semibold(15))
                .foregroundColor(Color.deepIndigo)
            +
            Text(" a week with his therapist. He spends ")
                .font(SHFont.body(15))
                .foregroundColor(Color.deepIndigo)
            +
            Text("165 hours")
                .font(SHFont.semibold(15))
                .foregroundColor(Color.deepIndigo)
            +
            Text(" a week with you...")
                .font(SHFont.body(15))
                .foregroundColor(Color.deepIndigo)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    // ── Question data ────────────────────────────────
    private var questionCards: [(question: String, reason: String)] {
        [
            (
                "\"What specific skill did you work on with \(childName) today?\"",
                "Focuses the conversation on actionable takeaways rather than general summaries."
            ),
            (
                "\"How did he respond to frustration when practicing this?\"",
                "Helps you anticipate challenges when practicing the same skill at home."
            ),
            (
                "\"Is there a specific prompt or phrase I should use at home?\"",
                "Consistency in language between therapy and home accelerates learning."
            ),
            (
                "\"What should I do if he refuses to practice the skill?\"",
                "Prepares you with a concrete backup plan for inevitable resistance."
            ),
            (
                "\"When should I follow up on this specific goal with you?\"",
                "Establishes a clear timeline for measuring progress."
            )
        ]
    }
}

// ═════════════════════════════════════════════
// MARK: — Screen 2: Session Questions
// ═════════════════════════════════════════════

private struct StepDetailScreen2: View {
    let step: JourneyStep
    let childName: String
    let onBack: () -> Void
    let onSessionComplete: () -> Void

    @State private var isVisible = false

    private let sessionQuestions = [
        "What triggers were most prevalent this week?",
        "How effectively did Aarav use coping strategies?",
        "Were there any notable improvements in mood stability?",
        "How is the current medication dosage working out?",
        "What should be the main focus for next week's exercises?"
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                Spacer().frame(height: 100)

                // ── Section label ────────────────────────────
                Group {
                    Text("QUESTIONS FOR TODAY'S SESSION")
                        .font(SHFont.medium(11))
                        .foregroundColor(Color.white.opacity(0.7))
                        .tracking(0.5)

                    Spacer().frame(height: 8)

                    Text("For \(childName)'s session today")
                        .font(SHFont.serifHeadline(26))
                        .foregroundColor(Color.white)
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.05), value: isVisible)

                Spacer().frame(height: 32)

                // ── Numbered questions ───────────────────────
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(Array(sessionQuestions.enumerated()), id: \.offset) { index, question in
                        HStack(alignment: .top, spacing: 14) {
                            Text("\(index + 1)")
                                .font(SHFont.medium(14))
                                .foregroundColor(Color.white.opacity(0.5))
                                .frame(width: 20, alignment: .trailing)

                            Text(question)
                                .font(SHFont.body(16))
                                .foregroundColor(Color.white)
                                .fixedSize(horizontal: false, vertical: true)
                                .lineSpacing(4)
                        }
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible ? 0 : 10)
                        .animation(
                            .easeOut(duration: 0.35).delay(0.12 + Double(index) * 0.06),
                            value: isVisible
                        )
                    }
                }

                Spacer().frame(height: 40)

                // ── Helper text ──────────────────────────────
                Text("Tap when your session is complete")
                    .font(SHFont.body(13))
                    .foregroundColor(Color.white.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .opacity(isVisible ? 1 : 0)
                    .animation(.easeOut(duration: 0.4).delay(0.5), value: isVisible)

                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.terracotta.ignoresSafeArea())

        // ── Back button ──────────────────────────────────
        .overlay(alignment: .topLeading) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onBack()
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Show your therapist")
                        .font(SHFont.medium(14))
                }
                .foregroundColor(Color.white)
            }
            .buttonStyle(.plain)
            .padding(.top, 60)
            .padding(.leading, 24)
        }

        // ── Bottom CTA ───────────────────────────────────
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                UINotificationFeedbackGenerator().notificationOccurred(.success)
                onSessionComplete()
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: "checkmark")
                        .font(.system(size: 14, weight: .semibold))
                    Text("Session complete — mark step as done")
                        .font(SHFont.medium(15))
                }
                .foregroundColor(Color.terracotta)
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(Color.white)
                .clipShape(Capsule())
                .shadow(color: Color.warmShadow.opacity(0.2), radius: 12, x: 0, y: 4)
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.top, 14)
            .padding(.bottom, 12)
        }

        .task {
            try? await Task.sleep(for: .milliseconds(80))
            withAnimation { isVisible = true }
        }
    }
}

// ═════════════════════════════════════════════
// MARK: — Screen 3: Completion Celebration
// ═════════════════════════════════════════════

private struct StepDetailScreen3: View {
    let step: JourneyStep
    let childName: String
    let completedSteps: Int
    let totalSteps: Int
    let nextStep: JourneyStep?
    let onBackToHome: () -> Void

    @State private var isVisible = false

    private var progressPercent: Int {
        guard totalSteps > 0 else { return 0 }
        return Int((Double(completedSteps) / Double(totalSteps)) * 100)
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {

                Spacer().frame(height: 100)

                // ── Progress section ─────────────────────────
                Group {
                    HStack {
                        Text("\(completedSteps) of \(totalSteps) steps complete")
                            .font(SHFont.body(13))
                            .foregroundColor(Color.warmGrey)
                        Spacer()
                        Text("\(progressPercent)%")
                            .font(SHFont.medium(13))
                            .foregroundColor(Color.warmGrey)
                    }

                    Spacer().frame(height: 8)

                    // Progress bar
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.warmDivider)
                                .frame(height: 6)

                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.terracotta)
                                .frame(
                                    width: geo.size.width * CGFloat(completedSteps) / CGFloat(max(totalSteps, 1)),
                                    height: 6
                                )
                        }
                    }
                    .frame(height: 6)
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.05), value: isVisible)

                Spacer().frame(height: 24)

                // ── Completed step card (green) ──────────────
                Group {
                    HStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 22))
                            .foregroundColor(Color.softGreen)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(step.title)
                                .font(SHFont.semibold(15))
                                .foregroundColor(Color.deepIndigo)

                            Text("Completed today")
                                .font(SHFont.body(13))
                                .foregroundColor(Color.softGreen)
                        }

                        Spacer()
                    }
                    .padding(16)
                    .background(Color.softGreen.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.12), value: isVisible)

                Spacer().frame(height: 32)

                // ── Benefit text ─────────────────────────────
                Group {
                    Text("\(childName) benefits from what you just did.")
                        .font(SHFont.serifHeadline(26))
                        .foregroundColor(Color.deepIndigo)
                        .fixedSize(horizontal: false, vertical: true)

                    Spacer().frame(height: 12)

                    Text("You now know what to practice at home to support his progress.")
                        .font(SHFont.body(15))
                        .foregroundColor(Color.warmBrown)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 16)
                .animation(.easeOut(duration: 0.4).delay(0.19), value: isVisible)

                Spacer().frame(height: 32)

                // ── Up Next section ──────────────────────────
                if let next = nextStep {
                    Group {
                        Text("UP NEXT")
                            .font(SHFont.medium(11))
                            .foregroundColor(Color.warmGrey)
                            .tracking(0.5)

                        Spacer().frame(height: 12)

                        HStack(spacing: 14) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Step \(next.stepNumber) · \(next.title)")
                                    .font(SHFont.semibold(15))
                                    .foregroundColor(Color.deepIndigo)
                                    .fixedSize(horizontal: false, vertical: true)

                                Text("At home activity")
                                    .font(SHFont.body(13))
                                    .foregroundColor(Color.warmBrown)
                            }

                            Spacer()

                            Text("Unlocked →")
                                .font(SHFont.medium(13))
                                .foregroundColor(Color.sageGreen)
                        }
                        .padding(16)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
                    }
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 16)
                    .animation(.easeOut(duration: 0.4).delay(0.26), value: isVisible)
                }

                Spacer().frame(height: 40)
            }
            .padding(.horizontal, 24)
        }
        .background(Color.warmCream.ignoresSafeArea())

        // ── Back button + SafeHands header ───────────────
        .overlay(alignment: .topLeading) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onBackToHome()
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(Color.deepIndigo)
                }
            }
            .buttonStyle(.plain)
            .padding(.top, 60)
            .padding(.leading, 24)
        }

        .overlay(alignment: .top) {
            Text("SafeHands")
                .font(SHFont.semibold(16))
                .foregroundColor(Color.deepIndigo)
                .padding(.top, 60)
        }

        // ── Bottom CTA ───────────────────────────────────
        .safeAreaInset(edge: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Rectangle()
                    .fill(Color.warmDivider.opacity(0.6))
                    .frame(height: 0.5)

                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    onBackToHome()
                } label: {
                    HStack(spacing: 10) {
                        Text("Back to home")
                        Image(systemName: "house.fill")
                            .font(.system(size: 14))
                    }
                    .font(SHFont.medium(16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(Color.terracotta)
                    .clipShape(Capsule())
                    .shadow(color: Color.terracotta.opacity(0.30), radius: 12, x: 0, y: 4)
                }
                .buttonStyle(.plain)
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

        .task {
            try? await Task.sleep(for: .milliseconds(80))
            withAnimation { isVisible = true }
        }
    }
}

// ═════════════════════════════════════════════
// MARK: — Question Card (sage left border)
// ═════════════════════════════════════════════

private struct QuestionCard: View {
    let question: String
    let reason: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(question)
                .font(SHFont.semibold(15))
                .foregroundColor(Color.deepIndigo)
                .fixedSize(horizontal: false, vertical: true)

            Text("Why: \(reason)")
                .font(SHFont.body(13))
                .foregroundColor(Color.warmBrown)
                .italic()
                .fixedSize(horizontal: false, vertical: true)
                .lineSpacing(3)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.sageGreen)
                    .frame(width: 4)
                Rectangle()
                    .fill(Color.white)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)
    }
}
