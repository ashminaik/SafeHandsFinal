import SwiftUI
import SwiftData
import UIKit

// THE COMPLETE FILE STRUCTURE:
// 1. OnboardingView — main container managing step state
// 2. FlowLayout — custom layout for chip wrapping
// 3. PainPointChip / CityChip — chip components
// 4. OnboardingStep1View — child name
// 5. OnboardingStep2View — child age
// 6. OnboardingStep3View — journey stage
// 7. OnboardingStep4View_PainPoints — what weighs on you
// 8. OnboardingStep5View_City — location
// 9. OnboardingStep6View_Threshold — arrival

// ═══════════════════════════
// MAIN CONTAINER
// ═══════════════════════════

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = OnboardingViewModel()
    @State private var currentStep: Int = 0
    @State private var advancingForward: Bool = true
    
    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()
            
            // Slide between steps
            Group {
                switch currentStep {
                case 0:
                    OnboardingStep1View(viewModel: viewModel) {
                        next()
                    }
                    .transition(.asymmetric(
                        insertion: .move(edge: advancingForward ? .trailing : .leading),
                        removal: .move(edge: advancingForward ? .leading : .trailing)
                    ))
                case 1:
                    OnboardingStep2View(viewModel: viewModel,
                        onBack: { back() },
                        onContinue: { next() }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: advancingForward ? .trailing : .leading),
                        removal: .move(edge: advancingForward ? .leading : .trailing)
                    ))
                case 2:
                    OnboardingStep3View(viewModel: viewModel,
                        onBack: { back() },
                        onContinue: { next() }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: advancingForward ? .trailing : .leading),
                        removal: .move(edge: advancingForward ? .leading : .trailing)
                    ))
                case 3:
                    OnboardingStep4View_PainPoints(
                        vm: viewModel,
                        back: { back() },
                        onContinue: { next() }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: advancingForward ? .trailing : .leading),
                        removal: .move(edge: advancingForward ? .leading : .trailing)
                    ))
                case 4:
                    OnboardingStep5View_City(
                        vm: viewModel,
                        back: { back() },
                        onContinue: { next() }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: advancingForward ? .trailing : .leading),
                        removal: .move(edge: advancingForward ? .leading : .trailing)
                    ))
                case 5:
                    OnboardingStep6View_Threshold(vm: viewModel)
                        .transition(.opacity)
                default:
                    EmptyView()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentStep)
        }
    }
    
    func next() {
        advancingForward = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        withAnimation(.easeInOut(duration: 0.3)) { currentStep += 1 }
    }
    
    func back() {
        advancingForward = false
        withAnimation(.easeInOut(duration: 0.3)) { currentStep -= 1 }
    }
}

// ═══════════════════════════
// SHARED COMPONENTS
// ═══════════════════════════

// Progress dots with step indicator
struct OnboardingProgressDots: View {
    var totalSteps: Int = 6
    let currentStep: Int
    
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(0..<totalSteps, id: \.self) { index in
                    Circle()
                        .fill(index == currentStep
                              ? Color.deepIndigo
                              : Color.warmGrey.opacity(0.3))
                        .frame(
                            width: index == currentStep ? 8 : 6,
                            height: index == currentStep ? 8 : 6
                        )
                        .animation(
                            .spring(response: 0.3, dampingFraction: 0.7),
                            value: currentStep
                        )
                }
            }
            
            Text("Step \(currentStep + 1) of \(totalSteps)")
                .font(SHFont.caption(11))
                .foregroundColor(Color.warmGrey)
        }
    }
}

// Continue pill button — terracotta, full width, 56pt height
// disabled = 50% opacity
struct OnboardingContinueButton: View {
    let title: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            action()
        } label: {
            Text(title)
                .font(SHFont.medium(17))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.terracotta)
                .clipShape(Capsule())
        }
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.5)
        .padding(.horizontal, 24)
        .padding(.bottom, 32)
        .animation(.easeInOut(duration: 0.2), value: isEnabled)
    }
}

// ═══════════════════════════
// SCREEN 1 — CHILD'S NAME
// ═══════════════════════════

struct OnboardingStep1View: View {
    @Bindable var viewModel: OnboardingViewModel
    let onContinue: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Top bar
            HStack {
                Spacer()
                Text("1 of 6")
                    .font(SHFont.body(13))
                    .foregroundColor(Color.warmGrey)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .frame(height: 56)
            
            // Progress dots
            OnboardingProgressDots(currentStep: 0)
                .padding(.top, 8)
            
            Spacer().frame(height: 48)
            
            // Question
            VStack(alignment: .leading, spacing: 4) {
                Text("What is your")
                    .font(SHFont.body(17))
                    .foregroundColor(Color.warmBrown)
                
                Text("child's name?")
                    .font(SHFont.serifHeadline(32))
                    .foregroundColor(Color.deepIndigo)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 48)
            
            // Underline text field
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .leading) {
                    if viewModel.childName.isEmpty {
                        Text("Aarav...")
                            .font(SHFont.body(17).italic())
                            .foregroundColor(Color.sageGreen.opacity(0.6))
                    }
                    TextField("", text: $viewModel.childName)
                        .font(SHFont.serifBody(20))
                        .foregroundColor(Color.deepIndigo)
                        .focused($isFocused)
                        .autocorrectionDisabled()
                }
                
                // Underline — 1pt normal, 2pt focused
                Rectangle()
                    .fill(Color.sageGreen)
                    .frame(height: isFocused ? 2 : 1)
                    .animation(.easeInOut(duration: 0.2), value: isFocused)
                
                // Helper
                Text("We'll use this name throughout the app")
                    .font(SHFont.body(13))
                    .foregroundColor(Color.warmGrey)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            // Continue button
            OnboardingContinueButton(
                title: "Continue →",
                isEnabled: !viewModel.childName
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                    .isEmpty,
                action: onContinue
            )
        }
        .background(Color.warmCream.ignoresSafeArea())
        .onTapGesture { isFocused = false }
    }
}

// ═══════════════════════════
// SCREEN 2 — CHILD'S AGE
// ═══════════════════════════

struct OnboardingStep2View: View {
    @Bindable var viewModel: OnboardingViewModel
    let onBack: () -> Void
    let onContinue: () -> Void
    
    // Age options - non-overlapping for clarity
    let ageOptions = ["0 – 3", "4 – 7", "8 – 12", "13 – 17", "18+"]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Top bar with back button
            HStack {
                SHBackButton(action: onBack)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .frame(height: 56)
            
            // Progress dots
            OnboardingProgressDots(currentStep: 1)
                .padding(.top, 8)
            
            Spacer().frame(height: 48)
            
            // Question using child's name
            VStack(alignment: .center, spacing: 4) {
                Text("How old is")
                    .font(SHFont.body(17))
                    .foregroundColor(Color.warmBrown)
                
                Text("\(viewModel.childName)?")
                    .font(SHFont.serifHeadline(32))
                    .foregroundColor(Color.deepIndigo)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 40)
            
            // 2x2 age card grid
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ],
                spacing: 16
            ) {
                ForEach(ageOptions, id: \.self) { option in
                    AgeCard(
                        ageRange: option,
                        isSelected: viewModel.childAge == option,
                        onTap: {
                            UIImpactFeedbackGenerator(style: .light)
                                .impactOccurred()
                            withAnimation(.spring(
                                response: 0.3,
                                dampingFraction: 0.7
                            )) {
                                viewModel.childAge = option
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            OnboardingContinueButton(
                title: "Continue",
                isEnabled: !viewModel.childAge.isEmpty,
                action: onContinue
            )
        }
        .background(Color.warmCream.ignoresSafeArea())
    }
}

// Age card — white, rounded, sage border when selected
struct AgeCard: View {
    let ageRange: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 6) {
                Text(ageRange)
                    .font(SHFont.serifHeadline(22))
                    .foregroundColor(Color.deepIndigo)
                
                Text("years")
                    .font(SHFont.body(13))
                    .foregroundColor(Color.warmGrey)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(
                        isSelected
                            ? Color.sageGreen
                            : Color.clear,
                        lineWidth: 2
                    )
            )
            .shadow(
                color: Color.warmShadow.opacity(0.12),
                radius: 8, x: 0, y: 4
            )
            .scaleEffect(isSelected ? 1.03 : 1.0)
        }
        .buttonStyle(.plain)
    }
}

// ═══════════════════════════
// SCREEN 3 — JOURNEY STAGE
// ═══════════════════════════

struct OnboardingStep3View: View {
    @Bindable var viewModel: OnboardingViewModel
    let onBack: () -> Void
    let onContinue: () -> Void
    
    struct StageOption: Identifiable {
        let id: Int
        let title: String
        let description: String
    }
    
    let stages = [
        StageOption(id: 1,
            title: "I'm just noticing signs",
            description: "Looking for early information and initial resources"),
        StageOption(id: 2,
            title: "We were recently diagnosed",
            description: "Need guidance on immediate next steps"),
        StageOption(id: 3,
            title: "We're in therapy now",
            description: "Finding the right support and treatments"),
        StageOption(id: 4,
            title: "We've established routines",
            description: "Seeking ongoing community and specialized services"),
        StageOption(id: 5,
            title: "Planning for the future",
            description: "Long-term planning and transitions")
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            
            // Top bar
            HStack {
                SHBackButton(action: onBack)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .frame(height: 56)
            
            // Progress dots
            OnboardingProgressDots(currentStep: 2)
                .padding(.top, 8)
            
            Spacer().frame(height: 48)
            
            // Question
            VStack(alignment: .leading, spacing: 4) {
                Text("Where are you")
                    .font(SHFont.body(17))
                    .foregroundColor(Color.warmBrown)
                
                Text("right now?")
                    .font(SHFont.serifHeadline(32))
                    .foregroundColor(Color.deepIndigo)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            
            Spacer().frame(height: 32)
            
            // Stage cards — vertical list
            VStack(spacing: 12) {
                ForEach(stages) { stage in
                    StageCard(
                        title: stage.title,
                        description: stage.description,
                        isSelected: viewModel.selectedStage == stage.id,
                        onTap: {
                            UIImpactFeedbackGenerator(style: .light)
                                .impactOccurred()
                            withAnimation(.easeIn(duration: 0.2)) {
                                viewModel.selectedStage = stage.id
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 24)
            
            Spacer()
            
            OnboardingContinueButton(
                title: "Continue",
                isEnabled: viewModel.selectedStage > 0,
                action: onContinue
            )
        }
        .background(Color.warmCream.ignoresSafeArea())
    }
}

// Stage card with multiple selection signals
struct StageCard: View {
    let title: String
    let description: String
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 0) {
                // Left border — 4pt sage when selected, 1pt divider when not
                Rectangle()
                    .fill(isSelected ? Color.sageGreen : Color.warmDivider)
                    .frame(width: isSelected ? 4 : 1)
                    .animation(.easeIn(duration: 0.2), value: isSelected)
                
                // Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(SHFont.semibold(16))
                        .foregroundColor(Color.deepIndigo)
                        .multilineTextAlignment(.leading)
                    
                    Text(description)
                        .font(SHFont.body(13))
                        .foregroundColor(Color.warmBrown)
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
                .padding(16)
                
                Spacer()
                
                // Checkmark appears when selected
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundColor(Color.sageGreen)
                    .opacity(isSelected ? 1 : 0)
                    .scaleEffect(isSelected ? 1 : 0.5)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(isSelected ? Color.sageGreen.opacity(0.08) : Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(isSelected ? Color.sageGreen : Color.warmDivider, lineWidth: isSelected ? 2 : 1)
            )
            .shadow(
                color: Color.warmShadow.opacity(isSelected ? 0.16 : 0.12),
                radius: isSelected ? 12 : 8, x: 0, y: isSelected ? 6 : 4
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// ═══════════════════════════
// FLOW LAYOUT — chip wrapping
// ═══════════════════════════

struct FlowLayout: Layout {
    var horizontalSpacing: CGFloat = 10
    var verticalSpacing: CGFloat = 10

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let maxWidth = proposal.width ?? UIScreen.main.bounds.width
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > maxWidth, currentX > 0 {
                currentX = 0
                currentY += rowHeight + verticalSpacing
                rowHeight = 0
            }
            currentX += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
        return CGSize(
            width: maxWidth,
            height: currentY + rowHeight
        )
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var currentX: CGFloat = bounds.minX
        var currentY: CGFloat = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX + size.width > bounds.maxX, currentX > bounds.minX {
                currentX = bounds.minX
                currentY += rowHeight + verticalSpacing
                rowHeight = 0
            }
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            currentX += size.width + horizontalSpacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

// ═══════════════════════════
// CHIP COMPONENTS
// ═══════════════════════════

struct PainPointChip: View {
    let label: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            onTap()
        }) {
            Text(label)
                .font(SHFont.body(15))
                .foregroundColor(isSelected ? Color.white : Color.deepIndigo)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.sageGreen : Color.white)
                )
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? Color.clear : Color.warmDivider,
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
    }
}

struct CityChip: View {
    let city: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            onTap()
        }) {
            Text(city)
                .font(SHFont.body(15))
                .foregroundColor(isSelected ? Color.white : Color.deepIndigo)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.sageGreen : Color.white)
                )
                .overlay(
                    Capsule()
                        .stroke(
                            isSelected ? Color.clear : Color.warmDivider,
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
    }
}

// ═══════════════════════════
// SCREEN 4 — PAIN POINTS
// ═══════════════════════════

struct OnboardingStep4View_PainPoints: View {
    @Bindable var vm: OnboardingViewModel
    let back: () -> Void
    let onContinue: () -> Void

    let painPoints = [
        "Understanding the diagnosis",
        "Finding the right therapy",
        "Managing daily meltdowns",
        "Honestly — everything",
        "Talking to family",
        "Navigating school",
        "Connecting with other parents",
        "Just seeking peace"
    ]

    var body: some View {
        VStack(spacing: 0) {

            // ── TOP BAR ──────────────────────────────────────────
            HStack {
                SHBackButton(action: back)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .frame(height: 56)

            // ── PROGRESS DOTS ──────────────────────────────────────
            OnboardingProgressDots(totalSteps: 6, currentStep: 3)
                .padding(.top, 8)

            // ── HEADLINE ───────────────────────────────────────────
            VStack(alignment: .leading, spacing: 4) {
                Text("What's weighing")
                    .font(SHFont.body(17))
                    .foregroundColor(Color.warmBrown)

                Text("on you most?")
                    .font(SHFont.serifHeadline(32))
                    .foregroundColor(Color.deepIndigo)

                Text("You can select more than one")
                    .font(SHFont.body(13))
                    .foregroundColor(Color.warmGrey)
                    .padding(.top, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.top, 32)

            // ── CHIPS FLOW ─────────────────────────────────────────
            ScrollView {
                FlowLayout(horizontalSpacing: 10, verticalSpacing: 12) {
                    ForEach(painPoints, id: \.self) { point in
                        PainPointChip(
                            label: point,
                            isSelected: vm.selectedPainPoints.contains(point)
                        ) {
                            withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                if vm.selectedPainPoints.contains(point) {
                                    vm.selectedPainPoints.remove(point)
                                } else {
                                    vm.selectedPainPoints.insert(point)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 8)
            }

            Spacer()

            // ── ZERO SELECTION HINT ────────────────────────────────
            if vm.selectedPainPoints.isEmpty {
                Text("You can always update this later")
                    .font(SHFont.body(11))
                    .foregroundColor(Color.warmGrey)
                    .padding(.bottom, 8)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.2), value: vm.selectedPainPoints.isEmpty)
            }

            // ── CONTINUE BUTTON ────────────────────────────────────
            // ALWAYS ENABLED — zero selection is valid
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onContinue()
            } label: {
                Text("Continue")
                    .font(SHFont.medium(17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.terracotta)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.warmCream.ignoresSafeArea())
    }
}

// ═══════════════════════════
// SCREEN 5 — CITY (UPGRADED)
// ═══════════════════════════

struct OnboardingStep5View_City: View {
    @Bindable var vm: OnboardingViewModel
    let back: () -> Void
    let onContinue: () -> Void

    @FocusState private var searchFocused: Bool

    let quickSelectCities = [
        "Delhi", "Mumbai", "Bengaluru", "Chennai",
        "Hyderabad", "Pune", "Gurugram", "Noida"
    ]

    var body: some View {
        VStack(spacing: 0) {

            // ── TOP BAR ──────────────────────────────────────────
            HStack {
                SHBackButton(action: back)

                Spacer()

                Text("Location")
                    .font(SHFont.medium(15))
                    .foregroundColor(Color.deepIndigo)

                Spacer()

                Button("Skip") {
                    vm.skipCity = true
                    vm.city = ""
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onContinue()
                }
                .font(SHFont.medium(15))
                .foregroundColor(Color.warmGrey)
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .frame(height: 56)

            // ── PROGRESS DOTS ──────────────────────────────────────
            OnboardingProgressDots(totalSteps: 6, currentStep: 4)
                .padding(.top, 8)

            // ── SCROLL CONTENT ─────────────────────────────────────
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {

                    // ── HEADLINE ─────────────────────────────────────
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Which city")
                            .font(SHFont.body(17))
                            .foregroundColor(Color.warmBrown)

                        Text("are you in?")
                            .font(SHFont.serifHeadline(32))
                            .foregroundColor(Color.deepIndigo)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                    // ── SEARCH FIELD ──────────────────────────────────
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 12) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 16, weight: .regular))
                                .foregroundColor(Color.warmGrey)

                            ZStack(alignment: .leading) {
                                if vm.city.isEmpty {
                                    Text("Type your city...")
                                        .font(SHFont.body(17).italic())
                                        .foregroundColor(Color.warmGrey.opacity(0.6))
                                }
                                TextField("", text: $vm.city)
                                    .font(SHFont.serifHeadline(20))
                                    .foregroundColor(Color.deepIndigo)
                                    .focused($searchFocused)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.words)
                            }
                        }

                        Rectangle()
                            .fill(Color.sageGreen)
                            .frame(height: searchFocused ? 2 : 1)
                            .animation(.easeInOut(duration: 0.2), value: searchFocused)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)

                    // ── QUICK SELECT ──────────────────────────────────
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Quick select")
                            .font(SHFont.medium(11))
                            .foregroundColor(Color.warmGrey)
                            .textCase(.uppercase)
                            .tracking(0.5)
                            .padding(.horizontal, 24)

                        FlowLayout(horizontalSpacing: 10, verticalSpacing: 10) {
                            ForEach(quickSelectCities, id: \.self) { city in
                                CityChip(
                                    city: city,
                                    isSelected: vm.city == city
                                ) {
                                    withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
                                        if vm.city == city {
                                            vm.city = ""
                                        } else {
                                            vm.city = city
                                            searchFocused = false
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                    }
                    .padding(.top, 24)

                    // ── INFO / TRUST CARD ─────────────────────────────
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.sageGreen)
                            .padding(.top, 1)

                        Text("This helps us show you nearby therapists, NGOs, and support groups tailored to your location. We never share your location.")
                            .font(SHFont.body(13))
                            .foregroundColor(Color.warmBrown)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(16)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color.sageGreen.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.sageGreen.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
                }
            }
            .scrollDismissesKeyboard(.interactively)

            Spacer()

            // ── CTA BUTTON ────────────────────────────────────────
            Button {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                searchFocused = false
                onContinue()
            } label: {
                Text("Let's begin →")
                    .font(SHFont.medium(17))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(Color.terracotta)
                    .clipShape(Capsule())
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.warmCream.ignoresSafeArea())
        .ignoresSafeArea(.keyboard)
    }
}

// ═══════════════════════════
// SCREEN 6 — THRESHOLD / ARRIVAL
// ═══════════════════════════

struct OnboardingStep6View_Threshold: View {
    @Environment(\.modelContext) private var modelContext
    let vm: OnboardingViewModel

    @State private var showIcon = false
    @State private var showLoadingText = false
    @State private var progressValue: CGFloat = 0
    @State private var showProgressBar = false
    @State private var showCompletionText = false
    @State private var iconPulse = false

    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                // ── LEAF ICON ─────────────────────────────────────────
                ZStack {
                    Circle()
                        .fill(Color.sageGreen.opacity(0.12))
                        .frame(width: 100, height: 100)

                    Image(systemName: "leaf.fill")
                        .font(.system(size: 36, weight: .regular))
                        .foregroundColor(Color.sageGreen)
                        .rotationEffect(.degrees(-30))
                }
                .scaleEffect(showIcon ? (iconPulse ? 1.08 : 1.0) : 0.6)
                .opacity(showIcon ? 1.0 : 0)
                .animation(
                    .spring(response: 0.6, dampingFraction: 0.7),
                    value: showIcon
                )
                .animation(
                    .spring(response: 0.3, dampingFraction: 0.5),
                    value: iconPulse
                )

                Spacer().frame(height: 32)

                // ── LOADING TEXT ──────────────────────────────────────
                if showLoadingText {
                    Text("Setting up \(vm.childName)'s space...")
                        .font(SHFont.body(15))
                        .foregroundColor(Color.warmGrey)
                        .transition(.opacity)
                }

                // ── COMPLETION TEXT ───────────────────────────────────
                if showCompletionText {
                    Text("You're in the right place.")
                        .font(SHFont.serifHeadline(22))
                        .foregroundColor(Color.deepIndigo)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .lineSpacing(4)
                        .transition(.opacity)
                }

                Spacer().frame(height: 24)

                // ── PROGRESS BAR ──────────────────────────────────────
                if showProgressBar {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.warmDivider)
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.sageGreen)
                                .frame(
                                    width: geo.size.width * progressValue,
                                    height: 4
                                )
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 64)
                    .transition(.opacity)
                }

                Spacer()
            }
        }
        .task {
            // t = 200ms: icon appears
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation { showIcon = true }

            // t = 400ms: loading text appears
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.easeIn(duration: 0.3)) { showLoadingText = true }

            // t = 500ms: progress bar appears and begins filling
            try? await Task.sleep(for: .milliseconds(100))
            withAnimation { showProgressBar = true }
            withAnimation(.easeInOut(duration: 0.8)) {
                progressValue = 0.8
            }

            // t = 1300ms: save the profile
            try? await Task.sleep(for: .milliseconds(800))
            vm.saveProfile(context: modelContext)

            // t = 1600ms: bar completes to 100%
            try? await Task.sleep(for: .milliseconds(300))
            withAnimation(.easeOut(duration: 0.3)) {
                progressValue = 1.0
            }

            // t = 1800ms: loading text and bar fade out
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.easeOut(duration: 0.2)) {
                showLoadingText = false
                showProgressBar = false
            }

            // t = 2000ms: completion text + success haptic
            try? await Task.sleep(for: .milliseconds(200))
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            withAnimation(.easeIn(duration: 0.3)) {
                showCompletionText = true
            }

            // t = 2200ms: leaf pulses once
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                iconPulse = true
            }
            try? await Task.sleep(for: .milliseconds(200))
            withAnimation(.spring(response: 0.25, dampingFraction: 0.5)) {
                iconPulse = false
            }

            // t = 2500ms: signal onboarding complete
            try? await Task.sleep(for: .milliseconds(300))
            NotificationCenter.default.post(
                name: Notification.Name("onboardingCompleted"),
                object: nil
            )
        }
    }
}
