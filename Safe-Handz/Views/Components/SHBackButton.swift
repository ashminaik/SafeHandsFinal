import SwiftUI
import UIKit

struct SHBackButton: View {
    let action: () -> Void
    var showLabel: Bool = false
    
    @State private var isPressed: Bool = false
    
    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            HStack(spacing: 4) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .bold))
                
                if showLabel {
                    Text("Back")
                        .font(.system(size: 15, weight: .semibold, design: .rounded))
                }
            }
            .foregroundColor(Color.deepIndigo)
            .frame(width: showLabel ? nil : 40, height: 40)
            .padding(.horizontal, showLabel ? 14 : 0)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
            )
            .overlay(
                Capsule()
                    .stroke(Color.white.opacity(0.8), lineWidth: 1.5)
            )
            .shadow(
                color: Color.deepIndigo.opacity(isPressed ? 0.05 : 0.1),
                radius: isPressed ? 4 : 8,
                x: 0,
                y: isPressed ? 2 : 4
            )
            .scaleEffect(isPressed ? 0.95 : 1.0)
        }
        .buttonStyle(.plain)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in isPressed = true }
                .onEnded { _ in isPressed = false }
        )
    }
}

#Preview {
    ZStack {
        // A complex background to show off the glass effect
        LinearGradient(colors: [Color.warmCream, Color.sageGreen.opacity(0.3)], startPoint: .topLeading, endPoint: .bottomTrailing).ignoresSafeArea()
        
        VStack(spacing: 20) {
            SHBackButton(action: {})
            SHBackButton(action: {}, showLabel: true)
        }
    }
}
