import SwiftUI
import SwiftData
import UIKit

// MARK: - Therapy Focus Enum

enum TherapyFocus: CaseIterable, Identifiable {
    case speech
    case sensory
    case behavior
    case notSure

    var id: Self { self }

    var title: String {
        switch self {
        case .speech:    return "Speech & Communication"
        case .sensory:   return "Sensory & Movement"
        case .behavior:  return "Behavior & Daily Routines"
        case .notSure:   return "I\u{2019}m not sure yet"
        }
    }

    var iconName: String {
        switch self {
        case .speech:   return "bubble.left.fill"
        case .sensory:  return "waveform.path"
        case .behavior: return "calendar"
        case .notSure:  return "questionmark.circle"
        }
    }

    var isNotSure: Bool {
        return self == .notSure
    }
}

// MARK: - Therapy Filter View

struct TherapyFilterView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var selectedFocus: TherapyFocus? = nil
    @State private var isVisible = false
    @State private var childName: String = ""
    @State private var navigateToList = false

    var body: some View {
        ZStack(alignment: .bottom) {

            // Background
            Color.warmCream.ignoresSafeArea()

            // Scrollable content
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Back button + breadcrumb
                    topBar

                    // Headline block
                    headlineBlock

                    // Four category cards
                    categoryCards

                    // Bottom space — clears the sticky CTA
                    Color.clear.frame(height: 120)
                }
            }

            // Sticky CTA — only visible when selection made
            if selectedFocus != nil {
                stickyCTA
                    .transition(
                        .move(edge: .bottom)
                        .combined(with: .opacity)
                    )
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $navigateToList) {
            TherapistListView(
                selectedFocus: selectedFocus ?? .notSure
            )
        }
        .task {
            // Load child name from SwiftData
            let descriptor = FetchDescriptor<ChildProfile>()
            if let child = try? modelContext
                .fetch(descriptor).first {
                childName = child.name
            }
            try? await Task.sleep(
                for: .milliseconds(80)
            )
            withAnimation(.easeOut(duration: 0.4)) {
                isVisible = true
            }
        }
        .animation(
            .spring(response: 0.4, dampingFraction: 0.8),
            value: selectedFocus
        )
    }
}

// MARK: - Top Bar

extension TherapyFilterView {

    private var topBar: some View {
        HStack {
            // Back button — SHBackButton already exists
            SHBackButton {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                dismiss()
            }

            Spacer()

            // Breadcrumb label
            Text("DISCOVER")
                .font(SHFont.medium(11))
                .foregroundColor(Color.warmGrey)
                .tracking(0.8)
        }
        .padding(.horizontal, 24)
        .padding(.top, 56)
        .padding(.bottom, 8)
        .opacity(isVisible ? 1 : 0)
        .animation(
            .easeOut(duration: 0.3).delay(0.0),
            value: isVisible
        )
    }
}

// MARK: - Headline Block

extension TherapyFilterView {

    private var headlineBlock: some View {
        VStack(alignment: .leading, spacing: 8) {

            // "What is Atharv"
            Text("What is \(childName.isEmpty ? "your child" : childName)")
                .font(SHFont.body(19))
                .foregroundColor(Color.warmGrey)

            // "working on right now?"
            // Serif, large, deepIndigo — emotional weight
            Text("working on right now?")
                .font(SHFont.serifHeadline(30))
                .foregroundColor(Color.deepIndigo)
                .lineSpacing(3)

            // Subtitle
            Text("Choose what \(childName.isEmpty ? "your child" : childName) needs most support with right now.")
                .font(SHFont.body(14).italic())
                .foregroundColor(Color.warmBrown)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 4)
        }
        .padding(.horizontal, 24)
        .padding(.top, 24)
        .padding(.bottom, 32)
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 12)
        .animation(
            .easeOut(duration: 0.4).delay(0.06),
            value: isVisible
        )
    }
}

// MARK: - Category Cards

extension TherapyFilterView {

    private var categoryCards: some View {
        VStack(spacing: 14) {
            ForEach(Array(TherapyFocus.allCases.enumerated()),
                    id: \.element.id) { index, focus in

                TherapyCategoryCard(
                    focus: focus,
                    childName: childName,
                    isSelected: selectedFocus == focus,
                    anySelected: selectedFocus != nil
                ) {
                    UIImpactFeedbackGenerator(style: .medium)
                        .impactOccurred()
                    withAnimation(
                        .spring(response: 0.3,
                                dampingFraction: 0.7)
                    ) {
                        if selectedFocus == focus {
                            selectedFocus = nil
                        } else {
                            selectedFocus = focus
                        }
                    }
                }
                .opacity(isVisible ? 1 : 0)
                .offset(y: isVisible ? 0 : 18)
                .animation(
                    .easeOut(duration: 0.4)
                        .delay(0.10 + Double(index) * 0.07),
                    value: isVisible
                )
            }
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - Sticky CTA

extension TherapyFilterView {

    private var stickyCTA: some View {
        VStack(spacing: 0) {

            // Gradient fade above the button
            // So content doesn't hard-cut behind it
            LinearGradient(
                colors: [
                    Color.warmCream.opacity(0),
                    Color.warmCream
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .frame(height: 32)
            .allowsHitTesting(false)

            // Button container
            VStack(spacing: 0) {
                Button {
                    UIImpactFeedbackGenerator(style: .medium)
                        .impactOccurred()
                    navigateToList = true
                } label: {
                    HStack(spacing: 10) {
                        Text("Show me therapists for \(childName.isEmpty ? "your child" : childName)")
                            .font(SHFont.medium(16))
                            .foregroundColor(.white)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14,
                                         weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.terracotta)
                    .clipShape(Capsule())
                    .shadow(
                        color: Color.terracotta.opacity(0.30),
                        radius: 12, x: 0, y: 4
                    )
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
                .padding(.top, 8)
                .background(Color.warmCream)
            }
        }
    }
}

// MARK: - Therapy Category Card Component

private struct TherapyCategoryCard: View {
    let focus: TherapyFocus
    let childName: String
    let isSelected: Bool
    let anySelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 16) {

                // ICON
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(
                            isSelected
                            ? Color.sageGreen.opacity(0.15)
                            : Color.warmGrey.opacity(0.08)
                        )
                        .frame(width: 48, height: 48)

                    Image(systemName: focus.iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(
                            isSelected
                            ? Color.sageGreen
                            : Color.warmGrey
                        )
                }
                .animation(.easeIn(duration: 0.2),
                           value: isSelected)

                // TEXT
                VStack(alignment: .leading, spacing: 4) {
                    // Title
                    Text(focus.title
                        .replacingOccurrences(of: "\n",
                                              with: " "))
                        .font(SHFont.semibold(16))
                        .foregroundColor(
                            isSelected
                            ? Color.deepIndigo
                            : focus.isNotSure
                              ? Color.warmGrey
                              : Color.deepIndigo.opacity(0.7)
                        )
                        .lineLimit(2)
                        .animation(.easeIn(duration: 0.2),
                                   value: isSelected)

                    // Subtitle — uses real child name
                    Text(subtitleText)
                        .font(SHFont.body(13))
                        .foregroundColor(
                            focus.isNotSure
                            ? Color.warmGrey.opacity(0.7)
                            : Color.warmBrown
                        )
                        .lineLimit(2)
                        .fixedSize(horizontal: false,
                                   vertical: true)
                }

                Spacer()

                // SELECTION INDICATOR
                // Checkmark when selected, empty circle when not
                ZStack {
                    Circle()
                        .stroke(
                            isSelected
                            ? Color.sageGreen
                            : Color.warmDivider,
                            lineWidth: 1.5
                        )
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11,
                                         weight: .semibold))
                            .foregroundColor(Color.sageGreen)
                            .transition(.scale.combined(
                                with: .opacity
                            ))
                    }
                }
                .animation(
                    .spring(response: 0.25,
                            dampingFraction: 0.65),
                    value: isSelected
                )
            }
            .padding(.vertical, 20)
            .padding(.horizontal, 18)
            .background(
                // Selected: white + sageGreen border
                // Unselected: white + faint divider border
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .stroke(
                                isSelected
                                ? Color.sageGreen
                                : Color.warmDivider
                                    .opacity(0.6),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
            .shadow(
                color: Color.warmShadow.opacity(
                    isSelected ? 0.16 : 0.08
                ),
                radius: isSelected ? 12 : 6,
                x: 0,
                y: isSelected ? 6 : 3
            )
            // Unselected cards dim when another is chosen
            .opacity(
                anySelected && !isSelected ? 0.45 : 1.0
            )
            .scaleEffect(isSelected ? 1.01 : 1.0)
            .animation(
                .spring(response: 0.3, dampingFraction: 0.7),
                value: isSelected
            )
            .animation(
                .easeInOut(duration: 0.2),
                value: anySelected
            )
        }
        .buttonStyle(.plain)
    }

    // Subtitle replacing placeholder with real child name
    private var subtitleText: String {
        let name = childName.isEmpty ? "your child" : childName
        switch focus {
        case .speech:
            return "Building words, and being understood"
        case .sensory:
            return "How \(name) experiences the world around him"
        case .behavior:
            return "Structure, calm, and everyday independence"
        case .notSure:
            return "Show me everything near Faridabad"
        }
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TherapyFilterView()
            .modelContainer(for: [
                ChildProfile.self,
                JourneyLog.self,
                JourneyStep.self
            ])
    }
}
