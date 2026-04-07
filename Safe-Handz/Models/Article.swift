import Foundation
import SwiftData
import SwiftUI

// MARK: - Article Category
enum ArticleCategory: String, Codable, CaseIterable {
    case education = "Education"
    case guide = "Guide"
    case activities = "Activities"
    case health = "Health"
    case legal = "Legal"
    
    // We map categories to SafeHands brand colors to maintain consistency
    var color: Color {
        switch self {
        case .education: return Color.terracotta
        case .guide: return Color.softGreen
        case .activities: return Color.sageGreen
        case .health: return Color.warmBrown
        case .legal: return Color.deepIndigo
        }
    }
}

// MARK: - Completion State
enum CompletionState: Int, Codable {
    case unread = 0
    case inProgress = 1
    case completed = 2
}

// MARK: - Article Model
@Model
final class Article {
    @Attribute(.unique) var id: UUID
    var title: String
    var author: String
    var readTime: Int // in minutes
    var categoryRaw: String
    var tags: [String]
    var markdownBody: String
    var isBookmarked: Bool
    var completionStateRaw: Int
    
    // Computed properties for Enums (safeguard for SwiftData)
    var category: ArticleCategory {
        get { ArticleCategory(rawValue: categoryRaw) ?? .education }
        set { categoryRaw = newValue.rawValue }
    }
    
    var completionState: CompletionState {
        get { CompletionState(rawValue: completionStateRaw) ?? .unread }
        set { completionStateRaw = newValue.rawValue }
    }
    
    init(id: UUID = UUID(), title: String, author: String, readTime: Int, category: ArticleCategory, tags: [String], markdownBody: String, isBookmarked: Bool = false, completionState: CompletionState = .unread) {
        self.id = id
        self.title = title
        self.author = author
        self.readTime = readTime
        self.categoryRaw = category.rawValue
        self.tags = tags
        self.markdownBody = markdownBody
        self.isBookmarked = isBookmarked
        self.completionStateRaw = completionState.rawValue
    }
}
