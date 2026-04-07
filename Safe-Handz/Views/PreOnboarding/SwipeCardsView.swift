import SwiftUI

// MARK: - Models
enum IllustrationType {
    case lantern
    case twoFigures
    case staircase
}

struct FeatureCardData {
    let sectionLabel: String
    let headline: String
    let body: String
    let illustration: IllustrationType
}

// MARK: - FeatureCardsView (Screens 2, 3, 4)
struct FeatureCardsView: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    let onSkip: () -> Void
    
    @State private var currentPage = 0
    @State private var cardVisible = false
    
    let cards = [
        FeatureCardData(
            sectionLabel: "FIND GUIDANCE",
            headline: "You don’t have to\nfigure this out alone.",
            body: "We’ll guide you.",
            illustration: .lantern
        ),
        FeatureCardData(
            sectionLabel: "MEET YOUR COMPANION",
            headline: "Someone who\nunderstands.",
            body: "Here with you. No judgment.",
            illustration: .twoFigures
        ),
        FeatureCardData(
            sectionLabel: "YOUR JOURNEY",
            headline: "We’ll take this one\nstep at a time.",
            body: "At your pace.",
            illustration: .staircase
        )
    ]
    
    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar
                HStack {
                    SHBackButton(action: onBack)
                    Spacer()
                    Button("Skip") {
                        onSkip()
                    }
                    .font(.system(size: 15, weight: .medium, design: .default))
                    .foregroundColor(.warmGrey)
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 16)
                
                // Unified Full-Screen Card Layout
                ZStack {
                    RoundedRectangle(cornerRadius: 36, style: .continuous)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.05), radius: 24, x: 0, y: 12)
                    
                    VStack(spacing: 0) {
                        TabView(selection: $currentPage) {
                            ForEach(0..<cards.count, id: \.self) { index in
                                VStack(spacing: 0) {
                                    // Soft Cream Top Header Area for Illustration
                                    ZStack {
                                        Color.warmCream.opacity(0.4)
                                        
                                        // Dynamic illustration injection
                                        switch cards[index].illustration {
                                        case .lantern: Image("illustration_journey").resizable().scaledToFit().scaleEffect(1.35)
                                        case .twoFigures: Image("illustration_companion").resizable().scaledToFit().scaleEffect(1.35)
                                        case .staircase: Image("illustration_family_walk").resizable().scaledToFit().scaleEffect(1.35)
                                        }
                                    }
                                    .frame(maxWidth: .infinity)
                                    .frame(height: UIScreen.main.bounds.height * 0.35)
                                    .clipShape(RoundedCornerShape(radius: 36, corners: [.topLeft, .topRight]))
                                    
                                    // Text Layout matching eye natural flow
                                    VStack(alignment: .leading, spacing: 0) {
                                        Text(cards[index].sectionLabel)
                                            .font(.system(size: 12, weight: .bold, design: .default))
                                            .tracking(1.5)
                                            .foregroundColor(Color.sageGreen)
                                            .textCase(.uppercase)
                                        
                                        Text(cards[index].headline)
                                            .font(.system(size: 32, weight: .bold, design: .serif))
                                            .foregroundColor(Color.deepIndigo)
                                            .lineSpacing(4)
                                            .padding(.top, 16)
                                            .padding(.bottom, 16)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Text(cards[index].body)
                                            .font(.system(size: 16, weight: .regular, design: .default))
                                            .foregroundColor(Color.warmBrown)
                                            .lineSpacing(6)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        Spacer(minLength: 0)
                                    }
                                    .padding(.horizontal, 32)
                                    .padding(.top, 32)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .tag(index)
                            }
                        }
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        
                        // Unified bottom CTA area INSIDE the card completely
                        VStack(spacing: 24) {
                            DotIndicatorView(current: currentPage, total: 3)
                            
                            Button(action: {
                                withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                    if currentPage < 2 {
                                        currentPage += 1
                                    } else {
                                        onContinue()
                                    }
                                }
                            }) {
                                Text(currentPage == 2 ? "Continue →" : "Next →")
                                    .font(.system(size: 17, weight: .bold, design: .default))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(Color.terracotta)
                                    .clipShape(Capsule())
                                    .shadow(color: Color.terracotta.opacity(0.3), radius: 10, x: 0, y: 4)
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                    }
                }
                .padding(.horizontal, 20) // Sole horizontal padding so nothing is squished
                .padding(.bottom, 24)
                
                // Animation states mapping
                .opacity(cardVisible ? 1 : 0)
                .offset(y: cardVisible ? 0 : 40)
                .animation(.spring(response: 0.55, dampingFraction: 0.75), value: cardVisible)
                .onAppear {
                    cardVisible = true
                }
            }
        }
    }
}

struct DotIndicatorView: View {
    let current: Int
    let total: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index == current ? Color.sageGreen : Color.warmGrey.opacity(0.35))
                    .frame(width: index == current ? 24 : 8, height: 8)
                    .animation(.spring(response: 0.3, dampingFraction: 0.7), value: current)
            }
        }
    }
}

struct RoundedCornerShape: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - Illustrations
struct LanternIllustration: View {
    var body: some View {
        ZStack {
            // Soft background abstract circles
            Circle().fill(Color.sageGreen.opacity(0.15))
                .frame(width: 140)
                .offset(y: -10)
            
            Circle().fill(Color.terracotta.opacity(0.1))
                .frame(width: 100)
                .offset(x: -30, y: 20)
            
            // Minimal device silhouette
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .frame(width: 76, height: 120)
                .shadow(color: .black.opacity(0.04), radius: 10, y: 4)
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(Color.deepIndigo.opacity(0.4), lineWidth: 3)
                .frame(width: 76, height: 120)
            
            // Map Pin / Lantern
            Path { path in
                path.addArc(center: CGPoint(x: 38, y: 45), radius: 10, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
                path.addQuadCurve(to: CGPoint(x: 38, y: 70), control: CGPoint(x: 50, y: 60))
                path.addQuadCurve(to: CGPoint(x: 28, y: 45), control: CGPoint(x: 26, y: 60))
                path.closeSubpath()
            }
            .fill(Color.sageGreen.opacity(0.8))
            .frame(width: 76, height: 120)
            
            // Comforting warm glow from pin
            Circle().fill(Color.warmCream.opacity(0.8))
                .frame(width: 8)
                .position(x: 38, y: 45)
                
            // Elegant thick sweeping hand gesture
            Path { path in
                path.move(to: CGPoint(x: -25, y: 90))
                path.addQuadCurve(to: CGPoint(x: 10, y: 80), control: CGPoint(x: -10, y: 70))
                path.addQuadCurve(to: CGPoint(x: -20, y: 150), control: CGPoint(x: -15, y: 120))
            }
            .stroke(Color.deepIndigo.opacity(0.7), style: StrokeStyle(lineWidth: 6, lineCap: .round))
        }
        .frame(width: 200, height: 160)
    }
}

struct TwoFiguresIllustration: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // Calm background blob
            Circle().fill(Color.sageGreen.opacity(0.15))
                .frame(width: 140)
                .offset(y: -10)
                
            // Larger figure (Mira) - solid soft shape
            Path { path in
                path.move(to: CGPoint(x: 25, y: 90))
                path.addQuadCurve(to: CGPoint(x: 40, y: 35), control: CGPoint(x: 20, y: 45))
                path.addQuadCurve(to: CGPoint(x: 55, y: 90), control: CGPoint(x: 60, y: 45))
                path.closeSubpath()
            }
            .fill(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
            
            Path { path in
                path.move(to: CGPoint(x: 25, y: 90))
                path.addQuadCurve(to: CGPoint(x: 40, y: 35), control: CGPoint(x: 20, y: 45))
                path.addQuadCurve(to: CGPoint(x: 55, y: 90), control: CGPoint(x: 60, y: 45))
            }
            .stroke(Color.deepIndigo.opacity(0.6), style: StrokeStyle(lineWidth: 4, lineCap: .round))
            
            // Head
            Circle().fill(Color.white).frame(width: 28, height: 28).position(x: 40, y: 18)
            Circle().stroke(Color.deepIndigo.opacity(0.6), lineWidth: 4).frame(width: 28, height: 28).position(x: 40, y: 18)

            // Smaller figure (Priya)
            Path { path in
                path.move(to: CGPoint(x: 75, y: 90))
                path.addQuadCurve(to: CGPoint(x: 88, y: 45), control: CGPoint(x: 75, y: 55))
                path.addQuadCurve(to: CGPoint(x: 100, y: 90), control: CGPoint(x: 100, y: 55))
                path.closeSubpath()
            }
            .fill(Color.white)
            .shadow(color: .black.opacity(0.04), radius: 8, y: 3)
            
            Path { path in
                path.move(to: CGPoint(x: 75, y: 90))
                path.addQuadCurve(to: CGPoint(x: 88, y: 45), control: CGPoint(x: 75, y: 55))
                path.addQuadCurve(to: CGPoint(x: 100, y: 90), control: CGPoint(x: 100, y: 55))
            }
            .stroke(Color.sageGreen.opacity(0.8), style: StrokeStyle(lineWidth: 4, lineCap: .round))
            
            // Small Head
            Circle().fill(Color.white).frame(width: 22, height: 22).position(x: 88, y: 30)
            Circle().stroke(Color.sageGreen.opacity(0.8), lineWidth: 4).frame(width: 22, height: 22).position(x: 88, y: 30)
            
            // Connecting element
            Path { path in
                path.move(to: CGPoint(x: 50, y: 65))
                path.addQuadCurve(to: CGPoint(x: 80, y: 70), control: CGPoint(x: 65, y: 75))
            }
            .stroke(Color.terracotta.opacity(0.8), style: StrokeStyle(lineWidth: 4, lineCap: .round))
        }
        .frame(width: 140, height: 120)
    }
}

struct StaircaseIllustration: View {
    var body: some View {
        ZStack {
            Circle().fill(Color.terracotta.opacity(0.1))
                .frame(width: 130)
                .offset(y: -10)
                
            // Elegantly thick steps
            Path { path in
                path.move(to: CGPoint(x: 20, y: 90))
                path.addLine(to: CGPoint(x: 60, y: 90))
                path.addLine(to: CGPoint(x: 60, y: 60))
                path.addLine(to: CGPoint(x: 100, y: 60))
                path.addLine(to: CGPoint(x: 100, y: 30))
                path.addLine(to: CGPoint(x: 140, y: 30))
            }
            .stroke(Color.sageGreen.opacity(0.6), style: StrokeStyle(lineWidth: 5, lineCap: .round, lineJoin: .round))
            
            // Progress orb instead of a stick human
            Circle().fill(Color.white)
                .frame(width: 24, height: 24)
                .position(x: 60, y: 48)
                .shadow(color: .black.opacity(0.08), radius: 6, y: 2)
            Circle().stroke(Color.deepIndigo.opacity(0.7), lineWidth: 4)
                .frame(width: 24, height: 24)
                .position(x: 60, y: 48)
                
            // Destination Star
            AnimatedStar()
                .frame(width: 28, height: 28)
                .position(x: 130, y: 15)
        }
        .frame(width: 170, height: 120)
    }
}

struct AnimatedStar: View {
    @State private var pulse = false
    
    var body: some View {
        Image(systemName: "sparkles")
            .font(.system(size: 20, weight: .bold))
            .foregroundColor(Color.terracotta)
            .scaleEffect(pulse ? 1.1 : 0.9)
            .opacity(pulse ? 0.9 : 0.6)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
    }
}

// MARK: - Journey Stage Data Model

struct JourneyStage: Identifiable {
    let id: Int
    let title: String
    let description: String
    let topics: [String]
}

// All 4 stages — the architecture of the entire app's content
private let journeyStages: [JourneyStage] = [
    JourneyStage(
        id: 1,
        title: "Just noticing signs",
        description: "Understanding the early differences you're seeing",
        topics: ["Early signs", "First talks", "What to look for"]
    ),
    JourneyStage(
        id: 2,
        title: "Recently diagnosed",
        description: "Making sense of the diagnosis and finding next steps",
        topics: ["Reports", "Therapists", "Telling family"]
    ),
    JourneyStage(
        id: 3,
        title: "Already in therapy",
        description: "Getting the right support while managing daily life",
        topics: ["Therapy types", "School", "Daily routines"]
    ),
    JourneyStage(
        id: 4,
        title: "Planning for the future",
        description: "Long-term thinking for your child's independence",
        topics: ["Skill building", "Transitions", "Planning"]
    )
]

// MARK: - Timeline Dot

/// Small circle on the vertical timeline — hollow when unselected, filled when selected.
struct JourneyTimelineDot: View {
    let isSelected: Bool
    
    var body: some View {
        Circle()
            .fill(isSelected ? Color.sageGreen : Color.white)
            .frame(width: 10, height: 10)
            .overlay(
                Circle()
                    .stroke(Color.sageGreen, lineWidth: 1.5)
            )
            .scaleEffect(isSelected ? 1.25 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSelected)
    }
}

// MARK: - Topic Pill

/// Small capsule tag showing a content topic inside a stage card.
/// Uses deepIndigo text on a warm tinted background so it reads
/// as distinct content, not decoration.
struct JourneyTopicPill: View {
    let label: String
    let isSelected: Bool
    
    var body: some View {
        Text(label)
            .font(SHFont.medium(11))
            .foregroundColor(isSelected ? Color.deepIndigo : Color.warmBrown)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(isSelected ? Color.sageGreen.opacity(0.12) : Color.warmDivider.opacity(0.5))
            )
            .overlay(
                Capsule()
                    .stroke(isSelected ? Color.sageGreen.opacity(0.4) : Color.warmDivider, lineWidth: 1)
            )
    }
}

// MARK: - Stage Card

/// Rich card showing stage number, title, description, and topic pills.
/// Unselected: white card with subtle border to separate from cream background.
/// Selected: white card with sageGreen border + left accent bar + lifted shadow.
struct JourneyStageCard: View {
    let stage: JourneyStage
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .leading) {
                // Left accent bar — visible only when selected
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color.sageGreen)
                    .frame(width: 4)
                    .padding(.vertical, 8)
                    .opacity(isSelected ? 1 : 0)
                    .scaleEffect(x: 1, y: isSelected ? 1 : 0.3, anchor: .center)
                
                // Card content
                VStack(alignment: .leading, spacing: 0) {
                    // Row 1: Stage number + title
                    HStack(spacing: 6) {
                        Text("Stage \(stage.id)")
                            .font(SHFont.semibold(12))
                            .foregroundColor(Color.sageGreen)
                        
                        Text("·")
                            .font(SHFont.body(12))
                            .foregroundColor(Color.warmGrey)
                        
                        Text(stage.title)
                            .font(SHFont.semibold(15))
                            .foregroundColor(Color.deepIndigo)
                    }
                    
                    // Row 2: Description
                    Text(stage.description)
                        .font(SHFont.body(13))
                        .foregroundColor(Color.warmBrown)
                        .lineSpacing(2)
                        .padding(.top, 5)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    // Row 3: Topic pills
                    HStack(spacing: 6) {
                        ForEach(stage.topics, id: \.self) { topic in
                            JourneyTopicPill(label: topic, isSelected: isSelected)
                        }
                    }
                    .padding(.top, 10)
                }
                .padding(.leading, isSelected ? 16 : 12)
                .padding(.trailing, 14)
                .padding(.vertical, 14)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isSelected ? Color.sageGreen.opacity(0.6) : Color.warmDivider.opacity(0.6),
                        lineWidth: isSelected ? 1.5 : 1
                    )
            )
            .shadow(
                color: Color.warmShadow.opacity(isSelected ? 0.22 : 0.12),
                radius: isSelected ? 16 : 8,
                x: 0,
                y: isSelected ? 8 : 4
            )
            .scaleEffect(isSelected ? 1.02 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isSelected)
    }
}

// WrappingTopicPills removed — pills now inline in card to avoid .fixedSize() layout overflow

// MARK: - ReadPreviewView (Screen 5) — Stage Education

struct ReadPreviewView: View {
    let onBack: () -> Void
    let onStageSelected: () -> Void
    
    @State private var selectedStage: Int? = nil
    @State private var contentAppeared = false
    
    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                // ── TOP BAR ──────────────────────────────────────
                HStack {
                    SHBackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                // ── HEADER ───────────────────────────────────────
                VStack(alignment: .leading, spacing: 0) {
                    // Contextual label — teaches "this is structured"
                    Text("YOUR READING JOURNEY")
                        .font(SHFont.semibold(11))
                        .tracking(1.5)
                        .foregroundColor(Color.sageGreen)
                        .padding(.bottom, 10)
                    
                    // Headline — the personal question
                    Text("Where are you\nright now?")
                        .font(SHFont.serifHeadline(28))
                        .foregroundColor(Color.deepIndigo)
                        .lineSpacing(4)
                        .padding(.bottom, 8)
                    
                    // Subtitle — the education sentence
                    Text("We organize everything around where you are.")
                        .font(SHFont.body(14))
                        .foregroundColor(Color.warmBrown)
                        .lineSpacing(2)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
                // Header entrance animation
                .opacity(contentAppeared ? 1 : 0)
                .offset(y: contentAppeared ? 0 : 16)
                .animation(.easeOut(duration: 0.5), value: contentAppeared)
                
                // ── TIMELINE + CARDS ─────────────────────────────
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 14) {
                        // Left column: dots + connecting line
                        ZStack {
                            // The connecting line
                            Rectangle()
                                .fill(Color.sageGreen.opacity(0.30))
                                .frame(width: 1.5)
                                .padding(.vertical, 30)
                            
                            // The dots — one per stage, spaced to match cards
                            VStack(spacing: 14) {
                                ForEach(journeyStages) { stage in
                                    JourneyTimelineDot(isSelected: selectedStage == stage.id)
                                        .frame(maxHeight: .infinity)
                                }
                            }
                        }
                        .frame(width: 10)
                        .padding(.leading, 4)
                        
                        // Right column: the stage cards
                        VStack(spacing: 14) {
                            ForEach(Array(journeyStages.enumerated()), id: \.element.id) { index, stage in
                                JourneyStageCard(
                                    stage: stage,
                                    isSelected: selectedStage == stage.id,
                                    onTap: {
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                        withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                                            selectedStage = stage.id
                                        }
                                    }
                                )
                                // Staggered entrance — each card slides in from the left
                                .opacity(contentAppeared ? 1 : 0)
                                .offset(x: contentAppeared ? 0 : -12)
                                .animation(
                                    .spring(response: 0.5, dampingFraction: 0.8)
                                    .delay(0.15 + Double(index) * 0.08),
                                    value: contentAppeared
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                
                Spacer(minLength: 12)
                
                // ── CTA SECTION ──────────────────────────────────
                VStack(spacing: 0) {
                    // Continue button — activates on selection
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        onStageSelected()
                    }) {
                        Text("Continue →")
                            .font(SHFont.medium(17))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.terracotta)
                            .clipShape(Capsule())
                            .shadow(color: Color.terracotta.opacity(0.3), radius: 10, x: 0, y: 4)
                    }
                    .disabled(selectedStage == nil)
                    .opacity(selectedStage != nil ? 1.0 : 0.4)
                    .animation(.easeInOut(duration: 0.25), value: selectedStage)
                    .padding(.horizontal, 24)
                    
                    // Pressure release — removes anxiety of choosing wrong
                    Text("You can always change this later.")
                        .font(SHFont.body(13))
                        .foregroundColor(Color.warmGrey)
                        .padding(.top, 10)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    // Privacy trust signal
                    Text("Your reading is completely private.")
                        .font(SHFont.body(12))
                        .foregroundColor(Color.warmGrey)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 6)
                        .padding(.bottom, 32)
                }
            }
        }
        .onAppear {
            // Trigger entrance animations
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                contentAppeared = true
            }
        }
    }
}

// MARK: - EntryPointView (Screen 6) — Authentication Gateway
struct EntryPointView: View {
    let authService: AuthenticationService
    let onBack: () -> Void
    let onComplete: () -> Void
    
    @State private var showContent = false
    @State private var showButtons = false
    
    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ── TOP NAVIGATION BAR ───────────────────────────
                HStack {
                    SHBackButton(action: onBack)
                    Spacer()
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)
                
                Spacer()
                
                // ── BRAND MARK + HEADLINE ────────────────────────
                VStack(spacing: 0) {
                    // Subtle brand mark
                    Text("Safe-Handz")
                        .font(.custom("Georgia-Italic", size: 16))
                        .foregroundColor(.deepIndigo.opacity(0.5))
                        .padding(.bottom, 28)
                    
                    // Headline — acknowledgment + hope
                    Text("You showed up.\nThat changes everything.")
                        .font(SHFont.serifHeadline(28))
                        .foregroundColor(.deepIndigo)
                        .multilineTextAlignment(.center)
                        .lineSpacing(6)
                        .padding(.bottom, 16)
                    
                    // Body — safety + hope
                    Text("Choose how you would like to move\nforward today.")
                        .font(SHFont.body(16))
                        .foregroundColor(.warmBrown)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 20)
                }
                .padding(.horizontal, 24)
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 20)
                .animation(.easeOut(duration: 0.7), value: showContent)
                
                Spacer()
                
                // ── ACTION PATHS ─────────────────────────────────
                VStack(spacing: 16) {
                    // Path 1: Core Setup Flow
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        // For the teacher's demo, bypass Auth walls entirely
                        onComplete() 
                    }) {
                        HStack {
                            Text("Set up my child's space")
                                .font(SHFont.medium(17))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "arrow.right")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.terracotta)
                        .clipShape(Capsule())
                        .shadow(color: Color.terracotta.opacity(0.3), radius: 10, x: 0, y: 4)
                    }
                    
                    // Path 2: Just Reading (No Account)
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        authService.continueAsAnonymous()
                        onComplete()
                    }) {
                        HStack {
                            Text("I just want to read for now")
                                .font(SHFont.medium(16))
                                .foregroundColor(.deepIndigo)
                            Spacer()
                            Image(systemName: "book.pages")
                                .font(.system(size: 18))
                                .foregroundColor(.sageGreen)
                        }
                        .padding(.horizontal, 24)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.white)
                        .clipShape(Capsule())
                        .overlay(
                            Capsule().stroke(Color.warmDivider, lineWidth: 1.5)
                        )
                        .shadow(color: Color.black.opacity(0.02), radius: 8, x: 0, y: 4)
                    }
                    
                    // Privacy trust signal
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 11))
                        Text("Your data stays private")
                    }
                    .font(SHFont.body(12))
                    .foregroundColor(.warmGrey.opacity(0.8))
                    .padding(.top, 16)
                    
                    // ── DEVELOPER MODE ────────────────────────────
                    // Secret bypass directly to onboarding
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        authService.continueAsAnonymous() // Prevents loop
                        onComplete()
                    }) {
                        Text("Developer Mode: Skip")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.warmGrey.opacity(0.4))
                    }
                    .padding(.top, 20)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 30)
                .opacity(showButtons ? 1 : 0)
                .offset(y: showButtons ? 0 : 16)
                .animation(.easeOut(duration: 0.5).delay(0.15), value: showButtons)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                showContent = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                showButtons = true
            }
        }
    }
}


