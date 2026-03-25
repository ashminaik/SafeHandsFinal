import SwiftUI
import SwiftData

// MARK: - AIView

struct AIView: View {

    @State private var viewModel = AIViewModel()
    @Environment(\.modelContext) private var modelContext
    @State private var scrollProxy: ScrollViewProxy? = nil
    @State private var isVisible = false
    @FocusState private var isInputFocused: Bool

    /// When true the screen came from logging -> dark forest green.
    /// When false (default, via tab bar) -> warm cream light theme.
    var fromLogging: Bool = false

    // Palette that flips based on entry path

    private var textPrimary: Color {
        fromLogging ? .white : Color.deepIndigo
    }

    private var textSecondary: Color {
        fromLogging ? Color.white.opacity(0.6) : Color.warmBrown
    }

    private var textTertiary: Color {
        fromLogging ? Color.white.opacity(0.35) : Color.warmGrey
    }

    private var bubbleUserBg: Color {
        fromLogging ? Color.white.opacity(0.10) : Color.deepIndigo.opacity(0.08)
    }

    private var bubbleUserText: Color {
        fromLogging ? .white : Color.deepIndigo
    }

    private var assistantTextColor: Color {
        fromLogging ? Color.white.opacity(0.92) : Color.deepIndigo.opacity(0.85)
    }

    private var inputBg: Color {
        fromLogging ? Color.white.opacity(0.06) : Color.white
    }

    private var inputBorder: Color {
        fromLogging ? Color.white.opacity(0.12) : Color.warmDivider
    }

    private var navBgOverlay: Color {
        fromLogging ? Color(hex: "2D4A3E").opacity(0.6) : Color.warmCream.opacity(0.7)
    }

    private var chipBg: Color {
        fromLogging ? Color.white.opacity(0.07) : Color.white
    }

    private var chipBorder: Color {
        fromLogging ? Color.white.opacity(0.15) : Color.warmDivider
    }

    private var chipTextColor: Color {
        fromLogging ? Color.white.opacity(0.9) : Color.deepIndigo
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            // BACKGROUND
            if fromLogging {
                RadialGradient(
                    colors: [
                        Color(hex: "3A6B56"),
                        Color(hex: "2D4A3E")
                    ],
                    center: .top,
                    startRadius: 0,
                    endRadius: 600
                )
                .ignoresSafeArea()
            } else {
                Color.warmCream.ignoresSafeArea()
            }

            // MAIN CONTENT
            VStack(spacing: 0) {
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 0) {

                            if viewModel.messages.isEmpty {
                                AIEmptyState(
                                    viewModel: viewModel,
                                    isVisible: isVisible,
                                    textPrimary: textPrimary,
                                    textSecondary: textSecondary,
                                    chipBg: chipBg,
                                    chipBorder: chipBorder,
                                    chipText: chipTextColor
                                ) { chipText in
                                    viewModel.inputText = chipText
                                    Task {
                                        await viewModel.sendMessage(
                                            context: modelContext
                                        )
                                    }
                                }
                            } else {
                                ForEach(viewModel.messages) { message in
                                    if !(message.role == "assistant" && message.content.isEmpty) {
                                        AIMessageBubble(
                                            message: message,
                                            userBg: bubbleUserBg,
                                            userText: bubbleUserText,
                                            assistantText: assistantTextColor,
                                            fromLogging: fromLogging
                                        )
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 6)
                                        .id(message.id)
                                    }
                                }

                                if viewModel.isStreaming,
                                   viewModel.messages.last?.content.isEmpty == true {
                                    StreamingIndicator()
                                        .padding(.leading, 24)
                                        .padding(.vertical, 8)
                                        .id("streamingIndicator")
                                }
                            }

                            Color.clear.frame(height: 90)
                                .id("bottomSpacer")
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                    .onAppear { scrollProxy = proxy }
                    .onChange(of: viewModel.messages.count) {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("bottomSpacer", anchor: .bottom)
                        }
                    }
                    .onChange(of: viewModel.messages.last?.content ?? "") { _, _ in
                        if viewModel.isStreaming {
                            withAnimation(.easeOut(duration: 0.15)) {
                                proxy.scrollTo("bottomSpacer", anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: viewModel.isStreaming) {
                        if viewModel.isStreaming {
                            withAnimation {
                                proxy.scrollTo("streamingIndicator",
                                               anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                AINavBar(
                    childName: viewModel.child?.name ?? "",
                    textPrimary: textPrimary,
                    textSecondary: textSecondary,
                    navBgOverlay: navBgOverlay
                ) {
                    // New Chat
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation(.easeOut(duration: 0.3)) {
                        viewModel.messages.removeAll()
                        viewModel.inputText = ""
                        viewModel.errorMessage = nil
                        viewModel.isStreaming = false
                        isVisible = false
                    }
                    Task {
                        try? await Task.sleep(for: .milliseconds(150))
                        withAnimation(.easeOut(duration: 0.5)) {
                            isVisible = true
                        }
                    }
                }
            }

            // FLOATING INPUT BAR + ERROR
            VStack(spacing: 8) {
                if let error = viewModel.errorMessage {
                    HStack(spacing: 8) {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 13))
                        Text(error)
                            .font(SHFont.caption(13))
                            .lineLimit(2)
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(
                        Capsule()
                            .fill(Color.red.opacity(0.85))
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onTapGesture { viewModel.errorMessage = nil }
                    .onAppear {
                        Task {
                            try? await Task.sleep(for: .seconds(5))
                            withAnimation { viewModel.errorMessage = nil }
                        }
                    }
                }

                AIInputBar(
                    text: $viewModel.inputText,
                    isFocused: $isInputFocused,
                    isStreaming: viewModel.isStreaming,
                    childName: viewModel.child?.name ?? "",
                    fromLogging: fromLogging,
                    inputBg: inputBg,
                    inputBorder: inputBorder,
                    textPrimary: textPrimary,
                    textTertiary: textTertiary
                ) {
                    guard !viewModel.inputText
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty else { return }
                    isInputFocused = false
                    Task {
                        await viewModel.sendMessage(context: modelContext)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
            .animation(.easeOut(duration: 0.25), value: viewModel.errorMessage != nil)
        }
        .task {
            viewModel.loadContext(context: modelContext)
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation(.easeOut(duration: 0.5)) { isVisible = true }
        }
    }
}

// MARK: - AINavBar

private struct AINavBar: View {
    let childName: String
    let textPrimary: Color
    let textSecondary: Color
    let navBgOverlay: Color
    let onNewChat: () -> Void

    var body: some View {
        HStack {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(Color.softGreen.opacity(0.3))
                        .frame(width: 18, height: 18)
                    Circle()
                        .fill(Color.softGreen)
                        .frame(width: 8, height: 8)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("SafeHands AI")
                        .font(SHFont.semibold(15))
                        .foregroundColor(textPrimary)

                    if !childName.isEmpty {
                        Text("Here for you & \(childName)")
                            .font(SHFont.caption(12))
                            .foregroundColor(textSecondary)
                    }
                }
            }

            Spacer()

            Button(action: onNewChat) {
                HStack(spacing: 5) {
                    Image(systemName: "plus.bubble")
                        .font(.system(size: 14, weight: .medium))
                    Text("New")
                        .font(SHFont.medium(12))
                }
                .foregroundColor(textSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(Color.white.opacity(0.08))
                        .overlay(
                            Capsule()
                                .stroke(Color.white.opacity(0.12), lineWidth: 1)
                        )
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 14)
        .background {
            ZStack {
                Rectangle().fill(.ultraThinMaterial)
                navBgOverlay
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - AIEmptyState

private struct AIEmptyState: View {
    let viewModel: AIViewModel
    let isVisible: Bool
    let textPrimary: Color
    let textSecondary: Color
    let chipBg: Color
    let chipBorder: Color
    let chipText: Color
    let onChipTap: (String) -> Void

    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            ZStack {
                Circle()
                    .fill(Color.softGreen.opacity(0.15))
                    .frame(width: 64, height: 64)
                Image(systemName: "sparkles")
                    .font(.system(size: 26, weight: .medium))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.softGreen, Color.sageGreen],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .opacity(isVisible ? 1 : 0)
            .scaleEffect(isVisible ? 1 : 0.7)
            .animation(.spring(response: 0.5, dampingFraction: 0.7).delay(0.05), value: isVisible)

            Spacer().frame(height: 24)

            VStack(spacing: 8) {
                Text(greetingLine)
                    .font(SHFont.serifHeadline(28))
                    .foregroundColor(textPrimary)
                    .multilineTextAlignment(.center)

                Text(contextLine)
                    .font(SHFont.body(17).italic())
                    .foregroundColor(textSecondary)
                    .multilineTextAlignment(.center)
                    .lineSpacing(5)
            }
            .opacity(isVisible ? 1 : 0)
            .offset(y: isVisible ? 0 : 20)
            .animation(.easeOut(duration: 0.5).delay(0.1), value: isVisible)

            Spacer().frame(height: 48)

            VStack(spacing: 12) {
                ForEach(Array(contextualChips.enumerated()), id: \.element) { index, chip in
                    AIChip(
                        text: chip,
                        chipBg: chipBg,
                        chipBorder: chipBorder,
                        chipText: chipText
                    ) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        onChipTap(chip)
                    }
                    .opacity(isVisible ? 1 : 0)
                    .offset(y: isVisible ? 0 : 16)
                    .animation(
                        .easeOut(duration: 0.4).delay(0.2 + Double(index) * 0.08),
                        value: isVisible
                    )
                }
            }

            Spacer()
        }
        .padding(.horizontal, 24)
        .containerRelativeFrame(.vertical) { height, _ in
            height * 0.7
        }
    }

    private var greetingLine: String {
        let hour = Calendar.current.component(.hour, from: Date())
        let name = UserDefaults.standard.string(forKey: "parentName") ?? "Priya"

        let timeWord: String
        if hour < 12       { timeWord = "Good morning" }
        else if hour < 17  { timeWord = "Good afternoon" }
        else if hour < 21  { timeWord = "Good evening" }
        else               { timeWord = "Hey" }

        return "\(timeWord), \(name)."
    }

    private var contextLine: String {
        guard let recentLog = viewModel.recentLog else {
            return "What\u{2019}s on your mind today?"
        }

        let isToday = Calendar.current.isDateInToday(recentLog.date)
        let isYesterday = Calendar.current.isDateInYesterday(recentLog.date)

        guard isToday || isYesterday else {
            return "What\u{2019}s on your mind today?"
        }

        let timeRef = isYesterday ? "Yesterday" : "Today"

        switch recentLog.mood {
        case .hardDay:
            return "\(timeRef) was heavy. I\u{2019}m here."
        case .goodMoment:
            return "You noticed something beautiful \(isYesterday ? "yesterday" : "today")."
        case .noticedSomething:
            return "You\u{2019}re paying attention. That matters."
        case .justLoggingIn:
            return "You showed up. That\u{2019}s enough."
        }
    }

    private var contextualChips: [String] {
        guard let recentLog = viewModel.recentLog else {
            return defaultChips
        }

        let isRecent = Calendar.current.isDateInToday(recentLog.date)
            || Calendar.current.isDateInYesterday(recentLog.date)

        guard isRecent else {
            return defaultChips
        }

        switch recentLog.mood {
        case .hardDay:
            return [
                "I don\u{2019}t even know where today went wrong",
                "He was so frustrated and I didn\u{2019}t know what to do",
                "Tell me this gets easier"
            ]
        case .goodMoment:
            return [
                "Something happened today and I need to tell someone",
                "I think I actually saw him try",
                "Is this the progress we\u{2019}ve been waiting for?"
            ]
        case .noticedSomething:
            return [
                "I noticed something but I don\u{2019}t know what it means",
                "Should I tell his therapist about this?",
                "Am I reading too much into small things?"
            ]
        case .justLoggingIn:
            return [
                "I\u{2019}m not okay but I don\u{2019}t know why",
                "I just needed somewhere to put this",
                "How do other parents get through this?"
            ]
        }
    }

    private var defaultChips: [String] {
        [
            "How do I know if therapy is working?",
            "I don\u{2019}t know what to do next",
            "How do other parents get through this?"
        ]
    }
}

// MARK: - AIMessageBubble

private struct AIMessageBubble: View {
    let message: ChatMessage
    let userBg: Color
    let userText: Color
    let assistantText: Color
    let fromLogging: Bool

    var body: some View {
        if message.role == "user" {
            userBubble
        } else {
            assistantBubble
        }
    }

    private var userBubble: some View {
        HStack {
            Spacer(minLength: 60)

            Text(message.content)
                .font(SHFont.body(15))
                .foregroundColor(userText)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background {
                    if fromLogging {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(.ultraThinMaterial)
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color.white.opacity(0.10))
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(userBg)
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .transition(.asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .opacity
        ))
    }

    private var assistantBubble: some View {
        HStack {
            HStack(alignment: .top, spacing: 10) {

                Circle()
                    .fill(Color.softGreen)
                    .frame(width: 8, height: 8)
                    .padding(.top, 7)

                Text(message.content)
                    .font(SHFont.body(15))
                    .foregroundColor(assistantText)
                    .lineSpacing(6)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .frame(
                maxWidth: UIScreen.main.bounds.width * 0.85,
                alignment: .leading
            )
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))

            Spacer(minLength: 40)
        }
        .transition(.asymmetric(
            insertion: .move(edge: .leading).combined(with: .opacity),
            removal: .opacity
        ))
    }
}

// MARK: - StreamingIndicator

private struct StreamingIndicator: View {
    @State private var opacity1 = 0.3
    @State private var opacity2 = 0.3
    @State private var opacity3 = 0.3

    var body: some View {
        HStack(spacing: 6) {
            Circle().fill(Color.softGreen).frame(width: 7, height: 7)
                .opacity(opacity1)
            Circle().fill(Color.softGreen).frame(width: 7, height: 7)
                .opacity(opacity2)
            Circle().fill(Color.softGreen).frame(width: 7, height: 7)
                .opacity(opacity3)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onAppear {
            withAnimation(
                .easeInOut(duration: 0.6)
                .repeatForever()
                .delay(0.0)
            ) { opacity1 = 1.0 }
            withAnimation(
                .easeInOut(duration: 0.6)
                .repeatForever()
                .delay(0.2)
            ) { opacity2 = 1.0 }
            withAnimation(
                .easeInOut(duration: 0.6)
                .repeatForever()
                .delay(0.4)
            ) { opacity3 = 1.0 }
        }
    }
}

// MARK: - AIInputBar

private struct AIInputBar: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let isStreaming: Bool
    let childName: String
    let fromLogging: Bool
    let inputBg: Color
    let inputBorder: Color
    let textPrimary: Color
    let textTertiary: Color
    let onSend: () -> Void

    var body: some View {
        HStack(spacing: 12) {

            Image(systemName: "sparkle")
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(
                    LinearGradient(
                        colors: [Color.softGreen, Color.sageGreen],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )

            ZStack(alignment: .leading) {
                if text.isEmpty {
                    Text("Ask anything about \(childName)...")
                        .font(SHFont.body(15).italic())
                        .foregroundColor(textTertiary)
                }
                TextField("", text: $text, axis: .vertical)
                    .font(SHFont.body(15))
                    .foregroundColor(textPrimary)
                    .focused(isFocused)
                    .lineLimit(1...4)
                    .tint(Color.softGreen)
                    .submitLabel(.send)
                    .onSubmit {
                        onSend()
                    }
            }

            if !text.trimmingCharacters(in: .whitespaces).isEmpty
                && !isStreaming {
                Button(action: onSend) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.terracotta, Color.terracotta.opacity(0.8)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 34, height: 34)
                        Image(systemName: "arrow.up")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .buttonStyle(.plain)
                .transition(.scale.combined(with: .opacity))
            }

            if isStreaming {
                ProgressView()
                    .tint(Color.softGreen)
                    .scaleEffect(0.8)
                    .transition(.scale.combined(with: .opacity))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background {
            if fromLogging {
                ZStack {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(.ultraThinMaterial)
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .fill(Color.white.opacity(0.06))
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.18),
                                    Color.white.opacity(0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
                .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 8)
            } else {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(inputBg)
                    .overlay(
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(
                                isFocused.wrappedValue
                                    ? LinearGradient(
                                        colors: [Color.softGreen.opacity(0.5), Color.sageGreen.opacity(0.3)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                    : LinearGradient(
                                        colors: [inputBorder, inputBorder],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    ),
                                lineWidth: 1
                            )
                    )
                    .shadow(
                        color: isFocused.wrappedValue
                            ? Color.softGreen.opacity(0.12)
                            : Color.warmShadow.opacity(0.08),
                        radius: isFocused.wrappedValue ? 12 : 6,
                        x: 0,
                        y: 4
                    )
            }
        }
        .animation(
            .spring(response: 0.3, dampingFraction: 0.7),
            value: text.isEmpty
        )
        .animation(
            .easeInOut(duration: 0.2),
            value: isFocused.wrappedValue
        )
    }
}

// MARK: - AIChip

private struct AIChip: View {
    let text: String
    let chipBg: Color
    let chipBorder: Color
    let chipText: Color
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(text)
                .font(SHFont.medium(14))
                .foregroundColor(chipText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
                .background {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(chipBg)
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(chipBorder, lineWidth: 1)
                        )
                }
        }
        .buttonStyle(PressScaleButtonStyle())
    }
}

// MARK: - Preview

#Preview("Light - Tab Bar") {
    AIView(fromLogging: false)
}

#Preview("Dark - From Logging") {
    AIView(fromLogging: true)
}
