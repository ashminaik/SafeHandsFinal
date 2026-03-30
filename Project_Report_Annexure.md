# ANNEXURE A: SOURCE CODE IMPLEMENTATION

This annexure contains the key source code files from the Safe Hands iOS application developed using SwiftUI and SwiftData.

---

## A.1 Application Entry Point

**File:** `Safe_HandzApp.swift`

```swift
import SwiftUI
import SwiftData

@main
struct Safe_HandzApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            ChildProfile.self,
            JourneyLog.self,
            JourneyStep.self
        ])
    }
}
```

---

## A.2 Data Models

### A.2.1 Child Profile Model

**File:** `Models/ChildProfile.swift`

```swift
import SwiftData
import Foundation

@Model
final class ChildProfile {
    var id: UUID
    var name: String
    var age: Int
    var stage: Int
    var primaryConcern: String
    var therapyType: String
    var city: String
    var oneLiner: String
    var journeyStartDate: Date

    @Relationship(deleteRule: .cascade)
    var logs: [JourneyLog] = []

    @Relationship(deleteRule: .cascade)
    var steps: [JourneyStep] = []

    init(name: String, age: Int, stage: Int, city: String) {
        self.id = UUID()
        self.name = name
        self.age = age
        self.stage = stage
        self.city = city
        self.primaryConcern = ""
        self.therapyType = ""
        self.oneLiner = ""
        self.journeyStartDate = Date()
    }

    var monthsOnJourney: Int {
        Calendar.current.dateComponents(
            [.month],
            from: journeyStartDate,
            to: Date()
        ).month ?? 0
    }
}
```

### A.2.2 Journey Log Model (Mood Types)

**File:** `Models/JourneyLog.swift`

```swift
import SwiftData
import SwiftUI
import Foundation

// MARK: - Mood Type

enum MoodType: String, Codable, CaseIterable {
    case goodMoment = "good_moment"
    case noticedSomething = "noticed_something"
    case hardDay = "hard_day"
    case justLoggingIn = "just_logging_in"

    var displayName: String {
        switch self {
        case .goodMoment: return "Good moment"
        case .noticedSomething: return "Noticed something"
        case .hardDay: return "Hard day"
        case .justLoggingIn: return "Just logging in"
        }
    }

    // Hard day is NEVER red — it is warm grey
    var color: Color {
        switch self {
        case .goodMoment: return Color.softGreen
        case .noticedSomething: return Color.sageGreen
        case .hardDay: return Color.warmGrey
        case .justLoggingIn: return Color(hex: "#C4B8D4")
        }
    }

    var emoji: String {
        switch self {
        case .goodMoment: return "☀️"
        case .noticedSomething: return "✨"
        case .hardDay: return "🌧️"
        case .justLoggingIn: return "👋"
        }
    }
}

// MARK: - Journey Log

@Model
final class JourneyLog {
    var id: UUID
    var date: Date
    var mood: MoodType
    var note: String
    var stepCompleted: String?
    var aiResponse: String?

    init(mood: MoodType, note: String) {
        self.id = UUID()
        self.date = Date()
        self.mood = mood
        self.note = note
    }
}
```

### A.2.3 Journey Step Model

**File:** `Models/JourneyStep.swift`

```swift
import SwiftData
import Foundation

// MARK: - Journey Step

@Model
final class JourneyStep {
    var id: UUID
    var stepNumber: Int
    var stage: Int
    var title: String
    var detail: String
    var isCompleted: Bool
    var completedDate: Date?

    init(stepNumber: Int, stage: Int, title: String, detail: String) {
        self.id = UUID()
        self.stepNumber = stepNumber
        self.stage = stage
        self.title = title
        self.detail = detail
        self.isCompleted = false
    }
}

// MARK: - Step Content (Curriculum)

/// The step content for every stage.
/// This is the curriculum — hardcoded for MVP.
struct StepContent {
    static func steps(for stage: Int) -> [(number: Int, title: String, detail: String)] {
        switch stage {
        case 1:
            return [
                (1, "Get the diagnosis report", "Ask your doctor for a written copy of Aarav's diagnosis. You will need this for every service and school."),
                (2, "Find a certified therapist", "Look for a therapist certified in ABA, OT, or speech therapy. Ask your pediatrician for a referral."),
                (3, "Join a parent support group", "Connect with other parents at Stage 1. You are not alone in this."),
                (4, "Learn about government schemes", "Udaan, NIMH, and state disability boards offer free therapy support. Research what your state provides."),
                (5, "Create Aarav's communication board", "A simple picture board helps non-verbal children express basic needs.")
            ]
        case 2:
            return [
                (1, "Track therapy attendance", "Keep a record of every session — date, therapist, what was worked on."),
                (2, "Ask your therapist these 5 questions", "What are we working on this month? How will I know if it's working? What can I do at home?"),
                (3, "Set up a home routine", "Consistency at home reinforces what happens in therapy. Create a visual schedule for Aarav's day."),
                (4, "Apply for disability certificate", "A disability certificate unlocks government benefits, school accommodations, and financial support."),
                (5, "Start the Letter of Intent", "Begin documenting who Aarav is — for any future caregiver who loves him.")
            ]
        case 3:
            return [
                (1, "Ask your therapist the five questions", "What is Aarav working on this month? What does progress look like? What can I do at home to reinforce it?"),
                (2, "Document one thing Aarav did this week", "Write down one moment — big or small — that showed you something about who he is becoming."),
                (3, "Research your nearest special school", "Visit one special needs school near you. Ask about their approach, student-to-teacher ratio, and admission process."),
                (4, "Apply for Udaan scheme benefits", "The Udaan scheme provides free therapy support for children under 10 with developmental disabilities."),
                (5, "Build Aarav's sensory profile", "Document what calms Aarav, what overwhelms him, and what helps him regulate. Share this with his teachers.")
            ]
        case 4:
            return [
                (1, "Plan the school transition", "Research inclusive schools and special education programs. Begin the application process 6 months early."),
                (2, "Create an IEP document", "Work with Aarav's therapist to create an Individual Education Plan for his school."),
                (3, "Train a family member", "Teach one family member the techniques his therapist uses so therapy continues at home."),
                (4, "Connect with a disability lawyer", "Understand Aarav's legal rights under the Rights of Persons with Disabilities Act 2016."),
                (5, "Start future planning", "Begin thinking about Aarav's long-term care. The Letter of Intent is the foundation.")
            ]
        case 5:
            return [
                (1, "Review all therapy progress", "Request a comprehensive progress report from every therapist who has worked with Aarav."),
                (2, "Complete the Letter of Intent", "Finish all 9 sections of Aarav's guide — it is the most important document you will ever write."),
                (3, "Explore vocational training", "Research programs that help young autistic adults develop independent living and work skills."),
                (4, "Set up a special needs trust", "Consult a financial planner about protecting Aarav's future financial security."),
                (5, "Become a community mentor", "Your experience can help Stage 1 parents. Consider sharing what you've learned.")
            ]
        default:
            return []
        }
    }
}
```

---

## A.3 Design System

### A.3.1 Color System

**File:** `DesignSystem/Colors.swift`

```swift
import SwiftUI

// MARK: - Hex Initializer

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 6:
            (a, r, g, b) = (255, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = ((int >> 24) & 0xFF, (int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - SafeHands Colour Tokens

extension Color {
    static let warmCream = Color(hex: "F7F3E8")
    static let deepIndigo = Color(hex: "320A5C")
    static let terracotta = Color(hex: "C6855A")
    static let sageGreen = Color(hex: "B2AC88")
    static let softGreen = Color(hex: "7EBF8E")
    static let warmBrown = Color(hex: "7A6E62")
    static let warmGrey = Color(hex: "7A7268")
    static let warmDivider = Color(hex: "E5DDD4")
    static let warmShadow = Color(hex: "B5A898")
    
    // Legacy logging Background
    static let loggingBackground = Color(hex: "2D4A3E")
}
```

---

## A.4 Services Layer

### A.4.1 Google Places Service (Therapist Discovery)

**File:** `Services/GooglePlacesService.swift`

```swift
import Foundation
import CoreLocation

struct TherapyPlace: Identifiable {
    let id: String
    let name: String
    let address: String
    let rating: Double?
    let distance: Double?
    let types: [String]
}

struct GooglePlacesService {

    // MARK: - Mock Data (Gurugram therapy centers)

    static func searchNearbyTherapy(
        latitude: Double,
        longitude: Double,
        radiusMeters: Double = 10000
    ) async throws -> [TherapyPlace] {
        // Simulate network delay
        try? await Task.sleep(for: .milliseconds(800))
        return mockPlaces
    }

    static func cachedSearch(
        latitude: Double,
        longitude: Double
    ) async throws -> [TherapyPlace] {
        return try await searchNearbyTherapy(
            latitude: latitude,
            longitude: longitude
        )
    }

    // MARK: - Hardcoded Real Therapy Centers

    private static let mockPlaces: [TherapyPlace] = [
        TherapyPlace(
            id: "place_001",
            name: "Rainbow Child Development Centre",
            address: "H.No 56, DLF Phase 5, Sector 43, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_002",
            name: "Continua Kids",
            address: "NS-11W, Nirvana Country, Sector 50, Gurugram",
            rating: 4.7,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_003",
            name: "Beautiful Mind Therapy Centre",
            address: "House No 77, Sector 5, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA"]
        ),
        TherapyPlace(
            id: "place_004",
            name: "Blooming Words Centers",
            address: "60 Block H, Greenwood City, Sector 46, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_005",
            name: "Babblz Child Development Centre",
            address: "B-747A, Near Galleria Market, Sector 28, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA"]
        ),
        TherapyPlace(
            id: "place_006",
            name: "Medick Curo Child Development Centre",
            address: "H.No 1650, Sohna Road, Sector 45, Gurugram",
            rating: 4.7,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_007",
            name: "Sunshine By Lissun",
            address: "Plot J-81, Mayfield Garden, Sector 51, Gurugram",
            rating: 4.6,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        ),
        TherapyPlace(
            id: "place_008",
            name: "The Child An Inclusive Therapy Program",
            address: "D Block, Greenwood City, Sector 46, Gurugram",
            rating: 4.9,
            distance: nil,
            types: ["Speech", "OT", "ABA", "Special School"]
        )
    ]
}
```

---

## A.5 Project Structure

```
Safe-Handz/
├── Safe-Handz/
│   ├── Safe_HandzApp.swift          (Entry Point)
│   ├── DesignSystem/
│   │   ├── Colors.swift             (Color Tokens)
│   │   ├── Fonts.swift
│   │   └── Modifiers.swift
│   ├── Models/
│   │   ├── ChildProfile.swift       (SwiftData Model)
│   │   ├── JourneyLog.swift         (SwiftData Model + MoodType)
│   │   └── JourneyStep.swift        (SwiftData Model + StepContent)
│   ├── ViewModels/
│   │   ├── OnboardingViewModel.swift
│   │   ├── HomeViewModel.swift
│   │   ├── LoggingViewModel.swift
│   │   ├── AIViewModel.swift
│   │   └── DiscoverViewModel.swift
│   ├── Views/
│   │   ├── ContentView.swift
│   │   ├── Home/
│   │   ├── Discover/
│   │   ├── AI/
│   │   ├── Logging/
│   │   ├── PreOnboarding/
│   │   └── Profile/
│   └── Services/
│       ├── AnthropicService.swift   (AI Integration)
│       └── GooglePlacesService.swift (Therapist Discovery)
├── Safe-Handz.xcodeproj
├── Safe-HandzTests/
└── Safe-HandzUITests/
```

---

## A.6 Technical Specifications

| Specification | Value |
|---------------|-------|
| Language | Swift 6 |
| UI Framework | SwiftUI (100%) |
| Data Persistence | SwiftData |
| Minimum iOS Version | iOS 17 |
| Architecture | MVVM (Model-View-ViewModel) |
| API Integration | Groq API (Llama 3.3 70B) for AI Companion |
| Build Configuration | Debug/Release |

---

*End of Annexure A*