import SwiftUI

struct Screen1_AwarenessView: View {
    var onBegin: () -> Void
    var onSkip: () -> Void
    
    @State private var showContent = false
    
    var body: some View {
        ZStack {
            // Background
            Color.warmCream.ignoresSafeArea()
            
            VStack {
                // Top Action Bar
                HStack {
                    Text("Safe-Handz")
                        .font(.custom("Georgia-Italic", size: 20)) // Use custom font or system serif if SHFont doesn't have italic
                        .foregroundColor(.deepIndigo)
                        .padding(.leading, 24)
                    
                    Spacer()
                }
                .padding(.top, 16)
                
                Spacer(minLength: 60) // Larger spacer at top pushes content down
                
                // Content Group (Illustration + Text + Buttons)
                VStack(spacing: 8) { // Tighter spacing brings illustration/text together
                    
                    // Illustration Area
                    if let uiImage = UIImage(named: "illustration_awareness") {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 380) // Larger illustration size
                            .scaleEffect(1.1) // Slightly scale up outside natural bounds
                            .padding(.bottom, 24) // Spacing before the text
                    } else {
                        // Clean, invisible placeholder holding the minimal layout space
                        Color.clear.frame(height: 10) 
                    }
                    
                    // Text Content Area
                    VStack(spacing: 12) {
                        Text("You are not the only\nmother awake right\nnow.")
                            .font(SHFont.serifHeadline(30))
                            .foregroundColor(.deepIndigo)
                            .multilineTextAlignment(.center)
                            .lineSpacing(9)
                        
                        Text("In India, this journey often takes years.\nYou no longer have to walk it alone.")
                            .font(SHFont.body(16))
                            .foregroundColor(.warmBrown)
                            .multilineTextAlignment(.center)
                            .lineSpacing(4)
                            .padding(.horizontal, 24)
                    }
                    
                    // CTA Area
                    VStack(spacing: 24) {
                        Button(action: onBegin) {
                            Text("Begin")
                                .font(SHFont.medium(17))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(Color.terracotta)
                                .clipShape(RoundedRectangle(cornerRadius: 28))
                        }
                        .padding(.horizontal, 24)
                        
                        Button(action: onSkip) {
                            Text("Skip")
                                .font(SHFont.medium(13))
                                .foregroundColor(.warmGrey)
                        }
                    }
                    .padding(.top, 16)
                    
                }
                .opacity(showContent ? 1 : 0)
                .offset(y: showContent ? 0 : 30) // Adjusted slightly
                
                Spacer(minLength: 40) // Allow resting towards bottom gracefully
            }
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                showContent = true
            }
        }
    }
}

#Preview {
    Screen1_AwarenessView(onBegin: {}, onSkip: {})
}
