import re

with open("Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift", "r") as f:
    content = f.read()

new_illus = """// MARK: - Illustrations
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
}"""

# Using regex to replace everything from "MARK: - Illustrations" to "MARK: - ReadPreviewView (Screen 5)"
pattern = r"// MARK: - Illustrations.*?// MARK: - ReadPreviewView \(Screen 5\)"

new_content = re.sub(pattern, new_illus + "\n\n// MARK: - ReadPreviewView (Screen 5)", content, flags=re.DOTALL)

with open("Safe-Handz/Views/PreOnboarding/SwipeCardsView.swift", "w") as f:
    f.write(new_content)

print("Python modification done.")
