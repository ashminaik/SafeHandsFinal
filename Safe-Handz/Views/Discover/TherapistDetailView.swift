import SwiftUI
import SwiftData

// MARK: - Scroll Offset Preference Key

struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(
        value: inout CGFloat,
        nextValue: () -> CGFloat
    ) {
        value = nextValue()
    }
}

// MARK: - TherapistDetailView

struct TherapistDetailView: View {

    let center: TherapyCenter

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var isVisible = false
    @State private var isSaved = false
    @State private var childName: String = ""

    @State private var scrollOffset: CGFloat = 0
    @State private var heroScale: CGFloat = 1.05

    @State private var screenHeight: CGFloat = 800

    private var heroHeight: CGFloat {
        screenHeight * 0.50
    }

    var body: some View {
        GeometryReader { rootGeo in
        ZStack(alignment: .top) {
            Color.warmCream.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {

                    GeometryReader { geo in
                        Color.clear
                            .preference(
                                key: ScrollOffsetKey.self,
                                value: geo.frame(
                                    in: .named("scroll")
                                ).minY
                            )
                    }
                    .frame(height: 0)

                    // ── HERO IMAGE ─────────────────────────
                    heroImageSection

                    // ── FLOATING NAME CARD ─────────────────
                    nameCard
                        .padding(.horizontal, 16)
                        .offset(y: -36)
                        .zIndex(1)

                    // ── SCROLLABLE CONTENT ─────────────────
                    VStack(alignment: .leading, spacing: 24) {

                        infoChipsGrid

                        aboutSection

                        parentQuoteCard

                        sessionInfoCard

                        // ── BOTTOM CTAs ────────────────────
                        bottomCTAs

                        Color.clear.frame(height: 40)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .offset(y: -24)
                }
                .frame(width: rootGeo.size.width)
                .clipped()
            }
            .coordinateSpace(name: "scroll")
            .ignoresSafeArea(edges: .top)
            .onPreferenceChange(ScrollOffsetKey.self) {
                value in
                scrollOffset = -value
            }

            // ── FLOATING BACK + BOOKMARK ───────────────────
            floatingNavButtons
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .task {
            let descriptor = FetchDescriptor<ChildProfile>()
            if let child = try? modelContext
                .fetch(descriptor).first {
                childName = child.name
            }

            try? await Task.sleep(for: .milliseconds(80))

            // Content fades and rises
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true
            }

            // Hero breath animation
            withAnimation(.easeOut(duration: 0.6)) {
                heroScale = 1.0
            }
        }
        .onAppear {
            screenHeight = rootGeo.size.height
        }
        }
    }
}

// MARK: - Hero Image Section

extension TherapistDetailView {

    private var heroImageSection: some View {
        ZStack(alignment: .bottom) {

            // ── THE IMAGE ──────────────────────────────────
            AsyncImage(
                url: URL(string: center.imageURL)
            ) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .scaleEffect(heroScale)
                        .offset(
                            y: -max(0, scrollOffset * 0.4)
                        )
                case .failure:
                    LinearGradient(
                        colors: [
                            Color.warmBrown.opacity(0.3),
                            Color.warmBrown.opacity(0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                case .empty:
                    Rectangle()
                        .fill(Color.warmBrown.opacity(0.12))
                        .overlay(
                            ProgressView()
                                .tint(Color.warmBrown)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: heroHeight)
            .clipped()

            // ── DARK GRADIENT ──────────────────────────────
            LinearGradient(
                colors: [
                    Color.clear,
                    Color.black.opacity(0.08),
                    Color.black.opacity(0.25),
                    Color.warmCream.opacity(0.6),
                    Color.warmCream
                ],
                startPoint: .init(x: 0.5, y: 0.35),
                endPoint: .bottom
            )

            // ── BADGES ──────────────────────────────────────
            HStack(spacing: 8) {
                if center.isNGOFunded {
                    heroBadge(
                        "NGO FUNDED",
                        color: Color.sageGreen
                    )
                }
                if center.isRCICertified {
                    heroBadge(
                        "✓ RCI Certified",
                        color: Color.softGreen
                    )
                }
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 64)
        }
        .frame(height: heroHeight)
    }

    // Frosted glass badge pill
    private func heroBadge(
        _ text: String,
        color: Color
    ) -> some View {
        Text(text)
            .font(SHFont.medium(11))
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                Capsule()
                    .fill(.ultraThinMaterial)
                    .overlay(
                        Capsule()
                            .fill(color.opacity(0.4))
                    )
            )
    }
}

// MARK: - Floating Nav Buttons

extension TherapistDetailView {

    private var floatingNavButtons: some View {
        HStack {
            Button {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                dismiss()
            } label: {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                        .shadow(
                            color: Color.black.opacity(0.18),
                            radius: 10, x: 0, y: 3
                        )
                    Image(systemName: "chevron.left")
                        .font(.system(
                            size: 14,
                            weight: .semibold
                        ))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                withAnimation(
                    .spring(response: 0.3,
                            dampingFraction: 0.6)
                ) {
                    isSaved.toggle()
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .frame(width: 40, height: 40)
                        .shadow(
                            color: Color.black.opacity(0.18),
                            radius: 10, x: 0, y: 3
                        )
                    Image(systemName: isSaved
                        ? "bookmark.fill"
                        : "bookmark"
                    )
                    .font(.system(
                        size: 14,
                        weight: .semibold
                    ))
                    .foregroundColor(
                        isSaved
                        ? Color.terracotta
                        : .white
                    )
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.top, 56)
    }
}

// MARK: - Name Card

extension TherapistDetailView {

    private var nameCard: some View {
        VStack(spacing: 12) {

            Text(center.name)
                .font(SHFont.serifHeadline(26))
                .foregroundColor(Color.deepIndigo)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(center.therapyTypes, id: \.self) {
                        type in
                        Text(type)
                            .font(SHFont.medium(12))
                            .foregroundColor(Color.warmBrown)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                Capsule()
                                    .fill(
                                        Color.warmBrown
                                            .opacity(0.09)
                                    )
                            )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(
                    color: Color.warmShadow.opacity(0.16),
                    radius: 16, x: 0, y: 8
                )
        )
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 14)
        .animation(
            .easeOut(duration: 0.45).delay(0.1),
            value: isVisible
        )
    }
}

// MARK: - Info Chips Grid

extension TherapistDetailView {

    private var infoChipsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: 10),
                GridItem(.flexible(), spacing: 10)
            ],
            spacing: 10
        ) {
            InfoChip(
                icon: "location.fill",
                iconColor: Color.terracotta,
                label: center.distanceText,
                value: cityFromAddress(center.address)
            )

            InfoChip(
                icon: center.homeVisitsAvailable
                    ? "house.fill"
                    : "building.2.fill",
                iconColor: Color.sageGreen,
                label: center.homeVisitsAvailable
                    ? "Home visits"
                    : "Center only",
                value: center.homeVisitsAvailable
                    ? "\(childName.isEmpty ? "Your child" : childName) learns at home"
                    : "Visit the center"
            )

            InfoChip(
                icon: "checkmark.seal.fill",
                iconColor: center.isRCICertified
                    ? Color.softGreen
                    : Color.warmGrey,
                label: center.isRCICertified
                    ? "RCI Verified"
                    : "Not RCI listed",
                value: center.isRCICertified
                    ? "Govt. recognized"
                    : "Ask center directly"
            )

            InfoChip(
                icon: "text.bubble.fill",
                iconColor: Color.deepIndigo.opacity(0.5),
                label: "Languages",
                value: center.languages
            )
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(
            .easeOut(duration: 0.4).delay(0.15),
            value: isVisible
        )
    }

    private func cityFromAddress(_ address: String) -> String {
        let parts = address
            .components(separatedBy: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        if parts.count >= 2 {
            return parts.suffix(2).joined(separator: ", ")
        }
        return address
    }
}

// MARK: - About Section

extension TherapistDetailView {

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("ABOUT THIS CENTER")
                .font(SHFont.medium(11))
                .foregroundColor(Color.warmGrey)
                .tracking(0.8)

            Text(center.aboutText)
                .font(SHFont.body(15))
                .foregroundColor(Color.deepIndigo)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(
                    color: Color.warmShadow.opacity(0.10),
                    radius: 8, x: 0, y: 4
                )
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(
            .easeOut(duration: 0.4).delay(0.20),
            value: isVisible
        )
    }
}

// MARK: - Parent Quote Card

extension TherapistDetailView {

    private var parentQuoteCard: some View {
        VStack(alignment: .leading, spacing: 10) {

            Text("\u{201C}")
                .font(SHFont.serifHeadline(48))
                .foregroundColor(Color.terracotta)
                .frame(height: 24)
                .padding(.bottom, -6)

            Text(center.parentQuote)
                .font(SHFont.serifHeadline(15).italic())
                .foregroundColor(Color.deepIndigo)
                .lineSpacing(6)
                .fixedSize(horizontal: false, vertical: true)

            Text("— Parent of a child, Faridabad.")
                .font(SHFont.body(12))
                .foregroundColor(Color.warmGrey)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sageLeftBorderCard()
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(
            .easeOut(duration: 0.4).delay(0.25),
            value: isVisible
        )
    }
}

// MARK: - Session Information Card

extension TherapistDetailView {

    private var sessionInfoCard: some View {
        VStack(alignment: .leading, spacing: 14) {

            Text("SESSION INFORMATION")
                .font(SHFont.medium(11))
                .foregroundColor(Color.warmGrey)
                .tracking(0.8)

            VStack(alignment: .leading, spacing: 8) {

                Text("Session fee: \(center.sessionFee)")
                    .font(SHFont.semibold(16))
                    .foregroundColor(Color.deepIndigo)

                if center.niramayaAccepted {
                    HStack(spacing: 6) {
                        Image(systemName:
                            "checkmark.circle.fill"
                        )
                        .font(.system(size: 13))
                        .foregroundColor(Color.softGreen)

                        Text("Niramaya insurance may " +
                             "cover this fully.")
                            .font(SHFont.body(13))
                            .foregroundColor(Color.softGreen)
                    }
                }

                Text("Financial assistance also available" +
                     " — ask the center directly.")
                    .font(SHFont.body(12))
                    .foregroundColor(Color.warmGrey)
                    .italic()
                    .padding(.top, 2)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.sageGreen.opacity(0.07))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(
                                Color.sageGreen.opacity(0.2),
                                lineWidth: 1
                            )
                    )
            )
        }
        .opacity(isVisible ? 1 : 0)
        .offset(y: isVisible ? 0 : 10)
        .animation(
            .easeOut(duration: 0.4).delay(0.30),
            value: isVisible
        )
    }
}

// MARK: - Bottom CTAs (Inside Scroll)

extension TherapistDetailView {

    private var bottomCTAs: some View {
        VStack(spacing: 12) {

            Button {
                UIImpactFeedbackGenerator(style: .medium)
                    .impactOccurred()
                let cleaned = center.phone
                    .components(
                        separatedBy: CharacterSet
                            .decimalDigits.inverted
                    )
                    .joined()
                if let url = URL(
                    string: "tel://\(cleaned)"
                ) {
                    UIApplication.shared.open(url)
                }
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "phone.fill")
                        .font(.system(
                            size: 14,
                            weight: .semibold
                        ))
                    Text("Contact \(center.name)")
                        .font(SHFont.medium(15))
                        .lineLimit(1)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.terracotta)
                .clipShape(Capsule())
                .shadow(
                    color: Color.terracotta.opacity(0.30),
                    radius: 12, x: 0, y: 4
                )
            }
            .buttonStyle(.plain)

            Button {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                withAnimation(
                    .spring(response: 0.3,
                            dampingFraction: 0.6)
                ) {
                    isSaved.toggle()
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: isSaved
                        ? "bookmark.fill"
                        : "bookmark"
                    )
                    .font(.system(
                        size: 13,
                        weight: .semibold
                    ))
                    Text(isSaved
                        ? "Saved to \(childName.isEmpty ? "your" : childName)\u{2019}s list"
                        : "Save to \(childName.isEmpty ? "your child" : childName)\u{2019}s list"
                    )
                    .font(SHFont.medium(15))
                    .lineLimit(1)
                }
                .foregroundColor(
                    isSaved
                    ? Color.sageGreen
                    : Color.deepIndigo
                )
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(
                        isSaved
                        ? Color.sageGreen
                        : Color.warmDivider,
                        lineWidth: 1.5
                    )
                )
                .shadow(
                    color: Color.warmShadow.opacity(0.08),
                    radius: 6, x: 0, y: 2
                )
            }
            .buttonStyle(.plain)
        }
        .opacity(isVisible ? 1 : 0)
        .animation(
            .easeOut(duration: 0.4).delay(0.35),
            value: isVisible
        )
    }
}

// MARK: - InfoChip Subcomponent

private struct InfoChip: View {
    let icon: String
    let iconColor: Color
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(iconColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(SHFont.semibold(13))
                    .foregroundColor(Color.deepIndigo)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
                Text(value)
                    .font(SHFont.body(11))
                    .foregroundColor(Color.warmGrey)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .fixedSize(
                        horizontal: false,
                        vertical: true
                    )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(
            color: Color.warmShadow.opacity(0.10),
            radius: 6, x: 0, y: 3
        )
    }
}
