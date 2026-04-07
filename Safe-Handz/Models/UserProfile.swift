import Foundation

// MARK: - Auth Provider

enum AuthProvider: String, Codable {
    case apple
    case google
    case anonymous
}

// MARK: - User Profile

/// Minimal user model for authentication state.
/// Stored locally after sign-in; synced to Firestore in Phase 4.
struct UserProfile: Codable, Identifiable {
    let id: String              // Firebase UID or Apple user identifier
    var displayName: String?
    var email: String?
    let provider: AuthProvider
    var selectedStageId: Int?   // From ReadPreview stage selection
    let createdAt: Date
    
    init(
        id: String,
        displayName: String? = nil,
        email: String? = nil,
        provider: AuthProvider,
        selectedStageId: Int? = nil
    ) {
        self.id = id
        self.displayName = displayName
        self.email = email
        self.provider = provider
        self.selectedStageId = selectedStageId
        self.createdAt = Date()
    }
    
    /// Anonymous user — no auth, browsing Read Section only
    static func anonymous() -> UserProfile {
        UserProfile(
            id: UUID().uuidString,
            provider: .anonymous
        )
    }
}
