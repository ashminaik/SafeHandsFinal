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
