import SwiftUI

// ── HERO CARD ─────────────────────────────────────────────
// First card. Full width. Tall image. Text overlaid.
// Immersive. Emotional. Makes her stop scrolling.

struct HeroTherapistCard: View {
    let center: TherapyCenter
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {

                // IMAGE with overlay
                ZStack(alignment: .bottom) {

                    // Photo
                    AsyncImage(url: URL(
                        string: center.imageURL)
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.warmBrown.opacity(0.15))
                            .overlay(
                                ProgressView()
                                    .tint(Color.warmBrown)
                            )
                    }
                    .frame(height: 220)
                    .clipped()

                    // Dark gradient from bottom
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.55)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    // Badges — top left
                    VStack {
                        HStack(spacing: 8) {
                            if center.isNGOFunded {
                                badgePill(
                                    "NGO FUNDED",
                                    color: Color.sageGreen
                                )
                            }
                            if center.isRCICertified {
                                badgePill(
                                    "✓ RCI Certified",
                                    color: Color.softGreen
                                )
                            }
                            Spacer()
                        }
                        .padding(14)
                        Spacer()
                    }

                    // Center name + distance over gradient
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(center.name)
                                .font(SHFont.serifHeadline(22))
                                .foregroundColor(.white)

                            HStack(spacing: 6) {
                                Image(systemName: "location.fill")
                                    .font(.system(size: 11))
                                    .foregroundColor(
                                        Color.white.opacity(0.8)
                                    )
                                Text(center.distanceText)
                                    .font(SHFont.medium(12))
                                    .foregroundColor(
                                        Color.white.opacity(0.8)
                                    )

                                if center.homeVisitsAvailable {
                                    Text("·")
                                        .foregroundColor(
                                            Color.white.opacity(0.5)
                                        )
                                    Image(systemName: "house.fill")
                                        .font(.system(size: 11))
                                        .foregroundColor(
                                            Color.white.opacity(0.8)
                                        )
                                    Text("Home visit available")
                                        .font(SHFont.medium(12))
                                        .foregroundColor(
                                            Color.white.opacity(0.8)
                                        )
                                }
                            }
                        }
                        Spacer()
                    }
                    .padding(16)
                }
                .frame(height: 220)

                // WHITE BOTTOM SECTION
                VStack(alignment: .leading, spacing: 12) {

                    // Specialty tags
                    ScrollView(.horizontal,
                               showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(center.therapyTypes,
                                    id: \.self) { type in
                                Text(type)
                                    .font(SHFont.medium(11))
                                    .foregroundColor(
                                        Color.warmBrown
                                    )
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        Capsule()
                                            .fill(Color.warmBrown
                                                .opacity(0.08))
                                    )
                            }
                        }
                    }

                    // Parent quote
                    Text("\u{201C}\(center.parentQuote)\u{201D}")
                        .font(SHFont.body(13).italic())
                        .foregroundColor(Color.warmBrown)
                        .lineSpacing(5)
                        .fixedSize(horizontal: false,
                                   vertical: true)

                    // View details CTA
                    HStack {
                        Spacer()
                        Text("View details \u{2192}")
                            .font(SHFont.medium(13))
                            .foregroundColor(Color.terracotta)
                    }
                }
                .padding(18)
                .background(Color.white)
            }
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: Color.warmShadow.opacity(0.15),
            radius: 12, x: 0, y: 6
        )
    }

    // Frosted glass badge pill
    private func badgePill(
        _ text: String, color: Color
    ) -> some View {
        Text(text)
            .font(SHFont.medium(10))
            .foregroundColor(.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(color.opacity(0.35))
                    )
            )
    }
}

// ── STANDARD CARD ──────────────────────────────────────────
// Cards 2–5. Slightly shorter image. Same structure.

struct StandardTherapistCard: View {
    let center: TherapyCenter
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {

                // IMAGE
                ZStack(alignment: .bottom) {

                    AsyncImage(url: URL(
                        string: center.imageURL)
                    ) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.warmBrown.opacity(0.12))
                    }
                    .frame(height: 160)
                    .clipped()

                    LinearGradient(
                        colors: [
                            Color.black.opacity(0),
                            Color.black.opacity(0.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )

                    // Badges top left
                    VStack {
                        HStack(spacing: 8) {
                            if center.isNGOFunded {
                                standardBadge(
                                    "NGO Funded",
                                    color: Color.sageGreen
                                )
                            }
                            if center.isRCICertified {
                                standardBadge(
                                    "✓ RCI",
                                    color: Color.softGreen
                                )
                            }
                            Spacer()
                        }
                        .padding(12)
                        Spacer()
                    }

                    // Name + distance
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading,
                               spacing: 3) {
                            Text(center.name)
                                .font(SHFont.semibold(17))
                                .foregroundColor(.white)
                            Text(center.therapyTypes
                                .prefix(2)
                                .joined(separator: " · "))
                                .font(SHFont.body(12))
                                .foregroundColor(
                                    Color.white.opacity(0.8)
                                )
                        }
                        Spacer()
                        HStack(spacing: 4) {
                            Image(systemName: "location.fill")
                                .font(.system(size: 10))
                            Text(center.distanceText)
                                .font(SHFont.medium(12))
                        }
                        .foregroundColor(
                            Color.white.opacity(0.85)
                        )
                    }
                    .padding(14)
                }
                .frame(height: 160)

                // WHITE BOTTOM
                VStack(alignment: .leading, spacing: 10) {

                    Text(
                        "\u{201C}\(center.parentQuote)\u{201D}"
                    )
                        .font(SHFont.body(13).italic())
                        .foregroundColor(Color.warmBrown)
                        .lineSpacing(4)
                        .lineLimit(3)
                        .fixedSize(horizontal: false,
                                   vertical: true)

                    HStack {
                        // Fee tag
                        Text(center.sessionFee)
                            .font(SHFont.medium(12))
                            .foregroundColor(
                                center.sessionFee == "Free"
                                ? Color.softGreen
                                : Color.warmGrey
                            )
                        Spacer()
                        Text("View details \u{2192}")
                            .font(SHFont.medium(13))
                            .foregroundColor(Color.terracotta)
                    }
                }
                .padding(16)
                .background(Color.white)
            }
        }
        .buttonStyle(.plain)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(
            color: Color.warmShadow.opacity(0.12),
            radius: 8, x: 0, y: 4
        )
    }

    private func standardBadge(
        _ text: String, color: Color
    ) -> some View {
        Text(text)
            .font(SHFont.medium(10))
            .foregroundColor(.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(color.opacity(0.3))
                    )
            )
    }
}
