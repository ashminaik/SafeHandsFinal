import SwiftUI
import SwiftData
import UIKit

// MARK: - Therapy Center Model

struct TherapyCenter: Identifiable {
    let id: UUID = UUID()
    let name: String
    let address: String
    let distanceText: String
    let phone: String
    let website: String
    let therapyTypes: [String]
    let isRCICertified: Bool
    let isNGOFunded: Bool
    let homeVisitsAvailable: Bool
    let languages: String
    let sessionFee: String
    let niramayaAccepted: Bool
    let parentQuote: String
    let aboutText: String
    let imageURL: String
    let isHero: Bool
}

// MARK: - Real Data — 5 Centers

let therapyCenters: [TherapyCenter] = [

    TherapyCenter(
        name: "Continua Kids",
        address: "Sector 9, Faridabad, Haryana",
        distanceText: "3–4 km",
        phone: "8800132666",
        website: "continuakids.com",
        therapyTypes: ["ABA", "OT", "Speech",
                       "Physio", "Special Ed"],
        isRCICertified: true,
        isNGOFunded: false,
        homeVisitsAvailable: false,
        languages: "Hindi · English",
        sessionFee: "Contact for fee",
        niramayaAccepted: false,
        parentQuote: "My daughter came to Continua when she was 2.8 years. She has improved a lot — the ABA and speech team put in so much effort.",
        aboutText: "Continua Kids operates a highly medicalized, multidisciplinary therapy model guided by developmental pediatricians and neurologists. They provide ABA, occupational, and speech therapies designed to foster holistic independence in neurodivergent children.",
        imageURL: "https://images.unsplash.com/photo-1587654780291-39c9404d746b?w=800",
        isHero: true
    ),

    TherapyCenter(
        name: "AADI",
        address: "2, Balbir Saxena Marg, Hauz Khas, New Delhi",
        distanceText: "~25 km",
        phone: "011-26864714",
        website: "aadi-india.org",
        therapyTypes: ["Special Ed", "Early Intervention",
                       "OT", "Vocational"],
        isRCICertified: true,
        isNGOFunded: true,
        homeVisitsAvailable: true,
        languages: "Hindi · English",
        sessionFee: "Subsidised",
        niramayaAccepted: true,
        parentQuote: "Within a few sessions I felt encouraged — my child adjusted well and the team genuinely understood what our family needed.",
        aboutText: "AADI is a pioneering non-profit dedicated to holistic rehabilitation and societal inclusion. They provide comprehensive therapeutic services, inclusive education, and actively help families enroll in the Niramaya insurance scheme.",
        imageURL: "https://images.unsplash.com/photo-1516627145497-ae6968895b74?w=800",
        isHero: false
    ),

    TherapyCenter(
        name: "Prayas Special School",
        address: "Mohna Road, Ballabhgarh, Sector 64, Faridabad",
        distanceText: "10–12 km",
        phone: "9540726222",
        website: "prayassws.org",
        therapyTypes: ["Special Ed", "Vocational",
                       "Basic Healthcare"],
        isRCICertified: false,
        isNGOFunded: true,
        homeVisitsAvailable: false,
        languages: "Hindi · English",
        sessionFee: "Free",
        niramayaAccepted: false,
        parentQuote: "For families who cannot afford private care, Prayas has been a lifeline. They treat every child with dignity.",
        aboutText: "Prayas is a deeply committed ISO-certified NGO operating since 1999. It provides completely free education and vocational training to children from economically marginalized backgrounds.",
        imageURL: "https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=800",
        isHero: false
    ),

    TherapyCenter(
        name: "Tamana Special School",
        address: "D-6, Vasant Vihar, New Delhi",
        distanceText: "~30 km",
        phone: "011-26151572",
        website: "tamana.ngo",
        therapyTypes: ["Special Ed", "Speech",
                       "OT", "Digital Therapeutics"],
        isRCICertified: true,
        isNGOFunded: true,
        homeVisitsAvailable: false,
        languages: "Hindi · English",
        sessionFee: "Subsidised",
        niramayaAccepted: false,
        parentQuote: "Do not give up hope. If my family had given up on me I would not be a teacher, a marathoner, a TEDx speaker.",
        aboutText: "Tamana is an internationally recognized NGO with UN Special Consultative Status. They provide end-to-end support from early intervention to vocational independence using Individualized Education Programs.",
        imageURL: "https://images.unsplash.com/photo-1544776193-352d25ca82cd?w=800",
        isHero: false
    ),

    TherapyCenter(
        name: "Milestones Child Development",
        address: "Sector 57, Gurugram, Haryana",
        distanceText: "25–30 km",
        phone: "09818475778",
        website: "milestonescdc.co.in",
        therapyTypes: ["OT", "Speech", "DMI",
                       "Sensory Integration", "Physio"],
        isRCICertified: false,
        isNGOFunded: false,
        homeVisitsAvailable: false,
        languages: "Hindi · English",
        sessionFee: "Premium",
        niramayaAccepted: false,
        parentQuote: "The center has a holistic approach to child development and provides a one-stop solution for complex developmental needs.",
        aboutText: "Led by highly credentialed specialists, Milestones is a premium private center known for advanced interventions like Dynamic Movement Intervention and Sensory Integration therapy.",
        imageURL: "https://images.unsplash.com/photo-1560969184-10fe8719e047?w=800",
        isHero: false
    )
]

// MARK: - List Filter Enum

enum ListFilter: CaseIterable, Identifiable {
    case nearest
    case homeVisits
    case ngoFunded

    var id: Self { self }

    var label: String {
        switch self {
        case .nearest:    return "Nearest first"
        case .homeVisits: return "Home visits"
        case .ngoFunded:  return "NGO funded"
        }
    }
}

// MARK: - Therapist List View

struct TherapistListView: View {

    let selectedFocus: TherapyFocus

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @State private var childName: String = ""
    @State private var activeFilter: ListFilter = .nearest
    @State private var isVisible = false
    @State private var selectedCenter: TherapyCenter? = nil
    @State private var showDetail = false

    // Filtered and sorted centers based on activeFilter
    var displayedCenters: [TherapyCenter] {
        switch activeFilter {
        case .nearest:
            return therapyCenters
        case .homeVisits:
            let filtered = therapyCenters.filter {
                $0.homeVisitsAvailable
            }
            let rest = therapyCenters.filter {
                !$0.homeVisitsAvailable
            }
            return filtered + rest
        case .ngoFunded:
            let filtered = therapyCenters.filter {
                $0.isNGOFunded
            }
            let rest = therapyCenters.filter {
                !$0.isNGOFunded
            }
            return filtered + rest
        }
    }

    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {

                    // Top bar
                    topBar

                    // Headline
                    headlineBlock

                    // Filter pills
                    filterPills
                        .padding(.bottom, 20)

                    // Result count
                    Text("\(displayedCenters.count) options near Faridabad")
                        .font(SHFont.body(13))
                        .foregroundColor(Color.warmGrey)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 16)

                    // Cards
                    LazyVStack(spacing: 20) {
                        ForEach(Array(
                            displayedCenters.enumerated()),
                            id: \.element.id
                        ) { index, center in

                            if index == 0 {
                                // HERO CARD — first center
                                HeroTherapistCard(
                                    center: center
                                ) {
                                    selectedCenter = center
                                    showDetail = true
                                }
                                .opacity(isVisible ? 1 : 0)
                                .offset(y: isVisible ? 0 : 24)
                                .animation(
                                    .easeOut(duration: 0.5)
                                        .delay(0.1),
                                    value: isVisible
                                )
                            } else {
                                // STANDARD CARDS
                                StandardTherapistCard(
                                    center: center
                                ) {
                                    selectedCenter = center
                                    showDetail = true
                                }
                                .opacity(isVisible ? 1 : 0)
                                .offset(y: isVisible ? 0 : 20)
                                .animation(
                                    .easeOut(duration: 0.45)
                                        .delay(
                                            0.15 +
                                            Double(index) * 0.06
                                        ),
                                    value: isVisible
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 20)

                    // Can't find footer
                    cantFindFooter

                    Color.clear.frame(height: 40)
                }
            }
        }
        .navigationBarHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .navigationDestination(isPresented: $showDetail) {
            if let center = selectedCenter {
                TherapistDetailView(center: center)
            }
        }
        .task {
            let descriptor = FetchDescriptor<ChildProfile>()
            if let child = try? modelContext
                .fetch(descriptor).first {
                childName = child.name
            }
            try? await Task.sleep(for: .milliseconds(80))
            withAnimation(.easeOut(duration: 0.5)) {
                isVisible = true
            }
        }
        .animation(
            .spring(response: 0.4, dampingFraction: 0.8),
            value: activeFilter
        )
    }
}

// MARK: - Top Bar

extension TherapistListView {

    private var topBar: some View {
        HStack {
            SHBackButton {
                UIImpactFeedbackGenerator(style: .light)
                    .impactOccurred()
                dismiss()
            }
            Spacer()
            Text("DISCOVER")
                .font(SHFont.medium(11))
                .foregroundColor(Color.warmGrey)
                .tracking(0.8)
            // Filter icon — non-functional for now
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color.warmGrey)
        }
        .padding(.horizontal, 24)
        .padding(.top, 56)
        .padding(.bottom, 8)
    }
}

// MARK: - Headline Block

extension TherapistListView {

    private var headlineBlock: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Speech therapists near you")
                .font(SHFont.serifHeadline(24))
                .foregroundColor(Color.deepIndigo)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
        .padding(.bottom, 20)
    }
}

// MARK: - Filter Pills

extension TherapistListView {

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(ListFilter.allCases) { filter in
                    Button {
                        UIImpactFeedbackGenerator(style: .light)
                            .impactOccurred()
                        withAnimation(
                            .spring(response: 0.3,
                                    dampingFraction: 0.7)
                        ) {
                            activeFilter = filter
                        }
                    } label: {
                        Text(filter.label)
                            .font(SHFont.medium(13))
                            .foregroundColor(
                                activeFilter == filter
                                ? Color.white
                                : Color.deepIndigo
                            )
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule().fill(
                                    activeFilter == filter
                                    ? Color.terracotta
                                    : Color.white
                                )
                            )
                            .overlay(
                                Capsule().stroke(
                                    activeFilter == filter
                                    ? Color.clear
                                    : Color.warmDivider,
                                    lineWidth: 1
                                )
                            )
                            .shadow(
                                color: activeFilter == filter
                                ? Color.terracotta.opacity(0.25)
                                : Color.warmShadow
                                    .opacity(0.08),
                                radius: 6, x: 0, y: 2
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 24)
        }
    }
}

// MARK: - Can't Find Footer

extension TherapistListView {

    private var cantFindFooter: some View {
        VStack(spacing: 6) {
            Text("Can\u{2019}t find what you\u{2019}re looking for?")
                .font(SHFont.body(14))
                .foregroundColor(Color.warmGrey)
            Text("Tell us and we\u{2019}ll help")
                .font(SHFont.medium(14))
                .foregroundColor(Color.terracotta)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TherapistListView(selectedFocus: .speech)
            .modelContainer(for: [
                ChildProfile.self,
                JourneyLog.self,
                JourneyStep.self
            ])
    }
}
