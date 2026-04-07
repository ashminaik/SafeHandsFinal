import re

with open("Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift", "r") as f:
    content = f.read()

new_ui = """// MARK: - FeatureCardsView (Screens 2, 3, 4)
struct FeatureCardsView: View {
    let onContinue: () -> Void
    let onSkip: () -> Void
    
    @State private var currentPage = 0
    @State private var cardVisible = false
    
    let cards = [
        FeatureCardData(
            sectionLabel: "FIND GUIDANCE",
            headline: "Stop searching\\nin the dark.",
            body: "A clear, guided path to trusted therapists and support, so you never have to walk this journey alone.",
            illustration: .lantern
        ),
        FeatureCardData(
            sectionLabel: "MEET YOUR COMPANION",
            headline: "An older sister who\\ntruly understands.",
            body: "Mira grew up in Delhi with an autistic brother. She is here to listen without judgment, offering warmth and comfort when you need it most.",
            illustration: .twoFigures
        ),
        FeatureCardData(
            sectionLabel: "YOUR JOURNEY",
            headline: "A gentle path\\nforward.",
            body: "We walk with you through every stage, designed specifically for the unique nuances of your family with deep empathy.",
            illustration: .staircase
        )
    ]
    
    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Top bar
                HStack {
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
                            ForEach(0..<cards.count, id: \\.self) { index in
                                VStack(spacing: 0) {
                                    // Soft Cream Top Header Area for Illustration
                                    ZStack {
                                        Color.warmCream.opacity(0.4)
                                        
                                        // Dynamic illustration injection
                                        switch cards[index].illustration {
                                        case .lantern: LanternIllustration()
                                        case .twoFigures: TwoFiguresIllustration()
                                        case .staircase: StaircaseIllustration()
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
}"""

pattern = r"// MARK: - FeatureCardsView \(Screens 2, 3, 4\).*?struct DotIndicatorView:"

new_content = re.sub(pattern, new_ui + "\n\nstruct DotIndicatorView:", content, flags=re.DOTALL)

with open("Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift", "w") as f:
    f.write(new_content)

print("Python modification done.")
