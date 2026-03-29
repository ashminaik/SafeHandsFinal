import re

with open('Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift', 'r') as f:
    text = f.read()

new_illustrations = """// MARK: - Illustrations
struct LanternIllustration: View {
    var body: some View {
        ZStack {
            // Concentric circles (sageGreen)
            Circle().stroke(Color.sageGreen.opacity(0.06), lineWidth: 1.5).frame(width: 200)
            Circle().stroke(Color.sageGreen.opacity(0.10), lineWidth: 1.5).frame(width: 150)
            Circle().stroke(Color.sageGreen.opacity(0.15), lineWidth: 1.5).frame(width: 100)
            
            // Phone screen
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.deepIndigo.opacity(0.22), lineWidth: 2)
                .frame(width: 80, height: 120)
            
            // Location Pin on phone
            Path { path in
                path.addArc(center: CGPoint(x: 40, y: 45), radius: 8, startAngle: .degrees(180), endAngle: .degrees(0), clockwise: false)
                path.addLine(to: CGPoint(x: 40, y: 65))
                path.closeSubpath()
            }
            .fill(Color.sageGreen.opacity(0.4))
            .frame(width: 80, height: 120)

            // The mother's hand (simple lines holding the phone)
            Path { path in
                // thumb wrapping over left side
                path.move(to: CGPoint(x: -15, y: 80))
                path.addQuadCurve(to: CGPoint(x: 10, y: 70), control: CGPoint(x: -5, y: 65))
                
                // wrist curving down
                path.move(to: CGPoint(x: -15, y: 80))
                path.addQuadCurve(to: CGPoint(x: -25, y: 140), control: CGPoint(x: -25, y: 110))
                
                // palm bottom
                path.move(to: CGPoint(x: 20, y: 120))
                path.addQuadCurve(to: CGPoint(x: 15, y: 140), control: CGPoint(x: 25, y: 130))
            }
            .stroke(Color.deepIndigo.opacity(0.22), lineWidth: 2)
        }
        .frame(width: 200, height: 160)
    }
}

struct TwoFiguresIllustration: View {
    var body: some View {
        ZStack(alignment: .bottom) {
            // Larger figure (Mira)
            ZStack {
                Circle().stroke(Color.deepIndigo.opacity(0.2), lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .position(x: 35, y: 20)
                
                Path { path in
                    // body back
                    path.move(to: CGPoint(x: 20, y: 35))
                    path.addQuadCurve(to: CGPoint(x: 15, y: 85), control: CGPoint(x: 10, y: 60))
                    
                    // body front
                    path.move(to: CGPoint(x: 50, y: 35))
                    path.addQuadCurve(to: CGPoint(x: 55, y: 85), control: CGPoint(x: 60, y: 60))
                    
                    // gentle arm extended toward Priya
                    path.move(to: CGPoint(x: 40, y: 50))
                    path.addQuadCurve(to: CGPoint(x: 75, y: 60), control: CGPoint(x: 60, y: 50))
                }.stroke(Color.deepIndigo.opacity(0.2), lineWidth: 2)
            }

            // Smaller figure (Priya)
            ZStack {
                Circle().stroke(Color.deepIndigo.opacity(0.2), lineWidth: 2)
                    .frame(width: 20, height: 20)
                    .position(x: 85, y: 35)
                
                Path { path in
                    // body back
                    path.move(to: CGPoint(x: 75, y: 48))
                    path.addQuadCurve(to: CGPoint(x: 70, y: 85), control: CGPoint(x: 65, y: 65))
                    
                    // body front
                    path.move(to: CGPoint(x: 95, y: 48))
                    path.addQuadCurve(to: CGPoint(x: 100, y: 85), control: CGPoint(x: 105, y: 65))
                }.stroke(Color.deepIndigo.opacity(0.2), lineWidth: 2)
            }
        }
        .frame(width: 120, height: 100)
    }
}

struct StaircaseIllustration: View {
    var body: some View {
        ZStack {
            // Steps showing slight perspective progression
            Path { path in
                path.move(to: CGPoint(x: 40, y: 80))
                path.addLine(to: CGPoint(x: 80, y: 80))
                path.addLine(to: CGPoint(x: 80, y: 55))
                path.addLine(to: CGPoint(x: 120, y: 55))
                path.addLine(to: CGPoint(x: 120, y: 30))
                path.addLine(to: CGPoint(x: 160, y: 30))
            }
            .stroke(Color.sageGreen.opacity(0.5), lineWidth: 2)
            
            // Destination Marker (Top step)
            Circle().fill(Color.terracotta)
                .frame(width: 12, height: 12)
                .position(x: 150, y: 18)
            
            // Tiny human figure looking up from the bottom left
            ZStack {
                Circle()
                    .stroke(Color.deepIndigo.opacity(0.2), lineWidth: 2)
                    .frame(width: 8, height: 8)
                    .position(x: 15, y: 65)
                
                Path { path in
                    // torso
                    path.move(to: CGPoint(x: 15, y: 70))
                    path.addLine(to: CGPoint(x: 15, y: 82))
                    
                    // legs
                    path.move(to: CGPoint(x: 15, y: 82))
                    path.addLine(to: CGPoint(x: 10, y: 92))
                    path.move(to: CGPoint(x: 15, y: 82))
                    path.addLine(to: CGPoint(x: 20, y: 92))
                }.stroke(Color.deepIndigo.opacity(0.2), lineWidth: 2)
            }
            
            // Faint dotted path indicating direction of movement
            Path { path in
                path.move(to: CGPoint(x: 25, y: 90))
                path.addQuadCurve(to: CGPoint(x: 50, y: 85), control: CGPoint(x: 35, y: 92))
            }
            .stroke(Color.sageGreen.opacity(0.25), style: StrokeStyle(lineWidth: 1.5, dash: [4, 4]))
        }
        .frame(width: 160, height: 100)
    }
}
"""

replacement = re.sub(
    r'// MARK: - Illustrations\n.*?(?=// MARK: - ReadPreviewView \(Screen 5\))',
    new_illustrations + "\n",
    text,
    flags=re.DOTALL
)

with open('Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift', 'w') as f:
    f.write(replacement)
