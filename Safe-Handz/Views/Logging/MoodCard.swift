import SwiftUI

struct MoodCardView: View {
    let mood: MoodType
    let isSelected: Bool
    let anySelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            onTap()
        } label: {
            HStack(spacing: 0) {
                Circle()
                    .fill(isSelected ? Color.softGreen : Color.white.opacity(0.25))
                    .frame(width: 10, height: 10)

                Spacer().frame(width: 14)

                Text(mood.displayName)
                    .font(SHFont.semibold(17))
                    .foregroundColor(isSelected ? .white : .white.opacity(0.5))

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white.opacity(isSelected ? 0.10 : 0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(
                                isSelected ? Color.softGreen.opacity(0.6) : Color.white.opacity(0.06),
                                lineWidth: isSelected ? 1.5 : 1
                            )
                    )
            )
            .contentShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
        .opacity(anySelected && !isSelected ? 0.35 : 1.0)
        .scaleEffect(isSelected ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.2), value: anySelected)
    }
}
