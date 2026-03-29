cat << 'INNER_EOF' > Safe-Handz/DesignSystem/Fonts.swift
import SwiftUI

enum SHFont {
    static func serif(_ size: CGFloat) -> Font {
        Font.custom("Fraunces-SemiBold", size: size)
    }
    static func body(_ size: CGFloat) -> Font {
        Font.custom("DMSans-Regular", size: size)
    }
    static func medium(_ size: CGFloat) -> Font {
        Font.custom("DMSans-Medium", size: size)
    }
}
INNER_EOF

cat << 'INNER_EOF' > Safe-Handz/DesignSystem/Modifiers.swift
import SwiftUI

struct StandardCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .cornerRadius(18)
            .shadow(
                color: Color.warmShadow.opacity(0.12),
                radius: 14,
                x: 0,
                y: 4
            )
    }
}

struct SageLeftBorderCard: ViewModifier {
    func body(content: Content) -> some View {
        content
            .modifier(StandardCard())
            .overlay(
                Rectangle()
                    .fill(Color.sageGreen)
                    .frame(width: 5)
                    .cornerRadius(18),
                alignment: .leading
            )
    }
}

extension View {
    func standardCard() -> some View {
        modifier(StandardCard())
    }
    func sageLeftBorderCard() -> some View {
        modifier(SageLeftBorderCard())
    }
}
INNER_EOF
