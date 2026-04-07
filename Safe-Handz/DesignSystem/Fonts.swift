import SwiftUI

// MARK: - SafeHands Typography

/// System font substitutes until custom fonts (Fraunces + DM Sans) are added to the bundle.
/// - Serif (design: .serif) → replaces Fraunces — used for emotional headlines
/// - Default (design: .default) → replaces DM Sans — used for all body and information

enum SHFont {

    // MARK: - Serif (Fraunces substitute) — emotional headlines

    static func serifHeadline(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .serif)
    }

    static func serifBody(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .serif)
    }

    // MARK: - Sans (DM Sans substitute) — body and information

    static func body(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }

    static func medium(_ size: CGFloat) -> Font {
        .system(size: size, weight: .medium, design: .default)
    }

    static func semibold(_ size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .default)
    }

    // MARK: - Caption

    static func caption(_ size: CGFloat) -> Font {
        .system(size: size, weight: .regular, design: .default)
    }
}

// Added extensions for new views
extension SHFont {
    static func serif(_ size: CGFloat) -> Font {
        .custom("Fraunces-SemiBold", size: size)
    }
}
