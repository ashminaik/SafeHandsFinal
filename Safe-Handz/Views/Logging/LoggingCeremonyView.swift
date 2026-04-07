import SwiftUI
import SwiftData

// ═══════════════════════════════════════════════════════
// MARK: — Radial Background
// ═══════════════════════════════════════════════════════

/// Radial gradient background matching the Figma designs —
/// a soft green glow in the upper-center fading into deep forest.
private struct LoggingRadialBackground: View {
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color(hex: "#1A2F26")
                RadialGradient(
                    colors: [
                        Color(hex: "#3B6B54").opacity(0.8),
                        Color(hex: "#2D4A3E").opacity(0.6),
                        Color(hex: "#1A2F26").opacity(0.0)
                    ],
                    center: .init(x: 0.5, y: 0.25),
                    startRadius: 20,
                    endRadius: geo.size.height * 0.75
                )
            }
        }
        .ignoresSafeArea()
    }
}

// ═══════════════════════════════════════════════════════
// MARK: — LoggingCeremonyView
// ═══════════════════════════════════════════════════════

struct LoggingCeremonyView: View {
    @State private var viewModel = LoggingViewModel()
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    var switchToAI: (() -> Void)? = nil

    var body: some View {
        ZStack {
            LoggingRadialBackground()

            switch viewModel.phase {
            case .selectingMood:
                MoodSelectionPhaseView(
                    viewModel: viewModel,
                    dismiss: { dismiss() },
                    modelContext: modelContext
                )
                .transition(.opacity)

            case .writingNote:
                NoteWritingPhaseView(
                    viewModel: viewModel,
                    modelContext: modelContext
                )
                .transition(.opacity)

            case .sealing, .stillness:
                SealingPhaseView(viewModel: viewModel)
                    .transition(.opacity)

            case .door:
                DoorPhaseView(
                    viewModel: viewModel,
                    dismiss: { dismiss() },
                    switchToAI: switchToAI
                )
                .transition(.opacity)

            case .talking:
                LoggingRadialBackground()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.phase == .selectingMood)
        .animation(.easeInOut(duration: 0.3), value: viewModel.phase == .writingNote)
        .animation(.easeInOut(duration: 0.3), value: viewModel.phase == .sealing)
        .animation(.easeInOut(duration: 0.3), value: viewModel.phase == .door)
        .task {
            viewModel.loadChild(context: modelContext)
        }
    }
}

// ═══════════════════════════════════════════════════════
// MARK: — Phase 1: Mood Selection
// ═══════════════════════════════════════════════════════

private struct MoodSelectionPhaseView: View {
    @Bindable var viewModel: LoggingViewModel
    let dismiss: () -> Void
    let modelContext: ModelContext

    @State private var isVisible = false
    @State private var showContinueHint = false

    var body: some View {
        ZStack(alignment: .topTrailing) {

            VStack(spacing: 0) {
                // ── Headline ──────────────────────────────
                VStack(spacing: 6) {
                    Text("What kind of day was it for")
                        .font(SHFont.body(17))
                        .foregroundColor(.white.opacity(0.7))

                    Text(viewModel.childName + "?")
                        .font(SHFont.serifHeadline(34))
                        .foregroundColor(.white)
                }
                .multilineTextAlignment(.center)
                .padding(.top, 90)
                .padding(.horizontal, 32)

                // ── Subtitle ──────────────────────────────
                Text("Choose what feels most true.")
                    .font(SHFont.body(14).italic())
                    .foregroundColor(.white.opacity(0.4))
                    .padding(.top, 8)

                // ── Mood Cards ────────────────────────────
                VStack(spacing: 10) {
                    ForEach(Array(MoodType.allCases.enumerated()), id: \.element) { index, mood in
                        MoodCardView(
                            mood: mood,
                            isSelected: viewModel.selectedMood == mood,
                            anySelected: viewModel.selectedMood != nil,
                            onTap: {
                                if mood != viewModel.selectedMood {
                                    // First tap — select this mood
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        viewModel.selectMood(mood)
                                    }
                                    showContinueHint = false
                                } else {
                                    // Second tap — advance to note writing
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.phase = .writingNote
                                    }
                                }
                            }
                        )
                        .opacity(isVisible ? 1 : 0)
                        .offset(y: isVisible ? 0 : 16)
                        .animation(
                            .easeOut(duration: 0.35).delay(Double(index) * 0.07),
                            value: isVisible
                        )
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 32)

                // ── Acknowledgment Line ───────────────────
                Spacer().frame(height: 28)

                Text(acknowledgmentLine)
                    .font(SHFont.serifHeadline(22))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .opacity(viewModel.selectedMood != nil ? 1 : 0)
                    .offset(y: viewModel.selectedMood != nil ? 0 : 8)
                    .animation(.easeOut(duration: 0.35), value: viewModel.selectedMood)

                // ── Continue Hint ─────────────────────────
                Spacer().frame(height: 14)

                Text("Tap again to continue →")
                    .font(SHFont.body(13))
                    .foregroundColor(.white.opacity(0.4))
                    .opacity(showContinueHint ? 1 : 0)
                    .animation(.easeOut(duration: 0.3), value: showContinueHint)

                Spacer()
            }

            // ── Close Button ──────────────────────────
            Button {
                if viewModel.selectedMood != nil {
                    viewModel.submitNote(context: modelContext)
                }
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 32, height: 32)
                    .background(.ultraThinMaterial.opacity(0.5))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.top, 56)
            .padding(.trailing, 20)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation { isVisible = true }
        }
        .onChange(of: viewModel.selectedMood) { _, newValue in
            if newValue != nil {
                showContinueHint = false
                Task {
                    try? await Task.sleep(for: .milliseconds(600))
                    withAnimation { showContinueHint = true }
                }
            } else {
                showContinueHint = false
            }
        }
    }

    private var acknowledgmentLine: String {
        switch viewModel.selectedMood {
        case .goodMoment:       return "Hold onto that."
        case .noticedSomething: return "That\u{2019}s how it starts."
        case .hardDay:          return "That counts too."
        case .justLoggingIn:    return "Showing up is enough."
        case nil:               return ""
        }
    }
}

// ═══════════════════════════════════════════════════════
// MARK: — Phase 2: Note Writing
// ═══════════════════════════════════════════════════════

private struct NoteWritingPhaseView: View {
    @Bindable var viewModel: LoggingViewModel
    let modelContext: ModelContext

    @FocusState private var isFieldFocused: Bool
    @State private var isVisible = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {

            // ── Child Initial Watermark ───────────────
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text(viewModel.childInitial)
                        .font(SHFont.serifHeadline(160))
                        .foregroundColor(.white.opacity(0.03))
                        .padding(.bottom, 60)
                        .padding(.trailing, 8)
                }
            }
            .ignoresSafeArea(.keyboard)

            VStack(spacing: 0) {
                // ── Selected Mood Pill ────────────────────
                HStack(spacing: 8) {
                    Text(viewModel.selectedMood?.emoji ?? "")
                        .font(.system(size: 22))
                    Text(viewModel.selectedMood?.displayName ?? "")
                        .font(SHFont.semibold(16))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                )
                .padding(.top, 80)

                // ── Acknowledgment Line ───────────────────
                Text(acknowledgmentLine)
                    .font(SHFont.serifHeadline(22))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)

                // ── Note Field ────────────────────────────
                ZStack(alignment: .topLeading) {
                    if viewModel.noteText.isEmpty {
                        Text(notePlaceholder)
                            .font(SHFont.body(17))
                            .foregroundColor(.white.opacity(0.25))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                    }
                    TextEditor(text: $viewModel.noteText)
                        .font(SHFont.body(17))
                        .foregroundColor(.white)
                        .tint(.white)
                        .scrollContentBackground(.hidden)
                        .focused($isFieldFocused)
                        .frame(minHeight: 80, maxHeight: 140)
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 24)
                .padding(.top, 36)

                Spacer().frame(height: 20)

                // ── Done Button — visible inline ──────────
                Button {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    isFieldFocused = false
                    Task {
                        try? await Task.sleep(for: .milliseconds(150))
                        viewModel.submitNote(context: modelContext)
                    }
                } label: {
                    Text("Done →")
                        .font(SHFont.medium(16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color.terracotta)
                        )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)

                // ── Skip link ─────────────────────────────
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    isFieldFocused = false
                    viewModel.noteText = ""
                    Task {
                        try? await Task.sleep(for: .milliseconds(150))
                        viewModel.submitNote(context: modelContext)
                    }
                } label: {
                    Text("Skip note")
                        .font(SHFont.body(14))
                        .foregroundColor(.white.opacity(0.35))
                }
                .buttonStyle(.plain)
                .padding(.top, 12)

                Spacer()
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 12)
        }
        // ── Back Button ───────────────────────────
        .overlay(alignment: .topLeading) {
            Button {
                isFieldFocused = false
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.phase = .selectingMood
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 32, height: 32)
                    .background(.ultraThinMaterial.opacity(0.5))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
            .padding(.top, 56)
            .padding(.leading, 20)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation(.easeOut(duration: 0.35)) { isVisible = true }
            try? await Task.sleep(for: .milliseconds(250))
            isFieldFocused = true
        }
    }

    private var acknowledgmentLine: String {
        switch viewModel.selectedMood {
        case .goodMoment:       return "Hold onto that."
        case .noticedSomething: return "That\u{2019}s how it starts."
        case .hardDay:          return "That counts too."
        case .justLoggingIn:    return "Showing up is enough."
        case nil:               return ""
        }
    }

    private var notePlaceholder: String {
        switch viewModel.selectedMood {
        case .goodMoment:       return "What happened was…"
        case .noticedSomething: return "What I noticed was…"
        case .hardDay:          return "\(viewModel.childName) tried to…"
        case .justLoggingIn:    return "Anything on my mind…"
        case nil:               return "Tell me more…"
        }
    }
}

// ═══════════════════════════════════════════════════════
// MARK: — Phase 3: Sealing Ceremony
// ═══════════════════════════════════════════════════════

private struct SealingPhaseView: View {
    @Bindable var viewModel: LoggingViewModel

    var body: some View {
        ZStack {
            LoggingRadialBackground()

            RippleView(startDate: viewModel.rippleStartDate ?? Date())

            // ── Acknowledgment text ───────────────────
            VStack(spacing: 12) {
                Text(sealingLine)
                    .font(SHFont.serifHeadline(22))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            .offset(y: -40)

            // ── Child Initial ─────────────────────────
            if viewModel.showInitial {
                Text(viewModel.childInitial)
                    .font(SHFont.serifHeadline(80))
                    .foregroundColor(Color(hex: "F4A261"))
                    .transition(.opacity)
            }
        }
    }

    private var sealingLine: String {
        switch viewModel.selectedMood {
        case .goodMoment:       return "That counts too."
        case .noticedSomething: return "That\u{2019}s how it starts."
        case .hardDay:          return "That counts too."
        case .justLoggingIn:    return "Showing up is enough."
        case nil:               return ""
        }
    }
}

// ═══════════════════════════════════════════════════════
// MARK: — Phase 4: Door
// ═══════════════════════════════════════════════════════

private struct DoorPhaseView: View {
    @Bindable var viewModel: LoggingViewModel
    let dismiss: () -> Void
    var switchToAI: (() -> Void)?

    @State private var isVisible = false

    var body: some View {
        ZStack {
            LoggingRadialBackground()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 4) {
                    Text("Do you want to talk")
                        .font(SHFont.serifHeadline(26))
                        .foregroundColor(.white)
                    Text("about today?")
                        .font(SHFont.serifHeadline(26))
                        .foregroundColor(.white)
                }

                Spacer().frame(height: 14)

                Text("Either way, today is already saved for \(viewModel.childName).")
                    .font(SHFont.body(14).italic())
                    .foregroundColor(.white.opacity(0.5))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 40)

                Spacer().frame(height: 36)

                // ── Option Cards ──────────────────────────
                VStack(spacing: 10) {
                    // Card 1 — Yes, let's talk
                    Button {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        viewModel.phase = .talking
                        switchToAI?()
                        dismiss()
                    } label: {
                        HStack(spacing: 0) {
                            Circle()
                                .fill(Color.softGreen)
                                .frame(width: 10, height: 10)

                            Spacer().frame(width: 14)

                            Text("Yes, let\u{2019}s talk")
                                .font(SHFont.semibold(16))
                                .foregroundColor(.white)

                            Spacer()

                            Image(systemName: "chevron.right")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white.opacity(0.4))
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.08))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.softGreen.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)

                    // Card 2 — Just save and close
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        dismiss()
                    } label: {
                        HStack(spacing: 0) {
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .frame(width: 10, height: 10)

                            Spacer().frame(width: 14)

                            Text("Just save and close")
                                .font(SHFont.semibold(16))
                                .foregroundColor(.white.opacity(0.6))

                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.white.opacity(0.05))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                                )
                        )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 28)

                Spacer()
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 16)
        }
        .task {
            try? await Task.sleep(for: .milliseconds(80))
            withAnimation(.easeOut(duration: 0.4)) { isVisible = true }
        }
    }
}
