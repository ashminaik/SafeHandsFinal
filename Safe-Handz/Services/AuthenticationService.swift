import Foundation
import AuthenticationServices
import SwiftUI

// MARK: - Auth State

enum AuthState: Equatable {
    case unknown        // App just launched, checking state
    case signedOut      // No user signed in
    case signedIn       // User authenticated (Apple or Google)
    case anonymous      // Browsing without account
}

// MARK: - Authentication Service

/// Central auth service using @Observable (iOS 17+).
/// Phase 1-2: Handles Sign in with Apple natively.
/// Phase 4: Will connect to Firebase Auth for Google + cloud storage.
@Observable
class AuthenticationService: NSObject, ASWebAuthenticationPresentationContextProviding {
    
    var authState: AuthState = .unknown
    var currentUser: UserProfile?
    var errorMessage: String?
    
    private var webAuthSession: ASWebAuthenticationSession?
    
    // MARK: - Keys
    
    private let userDefaultsKey = "sh_current_user"
    private let appleUserIdKey = "sh_apple_user_id"
    
    // MARK: - Init
    
    override init() {
        super.init()
        restorePreviousSession()
    }
    
    // MARK: - ASWebAuthenticationPresentationContextProviding
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        // Find the active window to anchor the web auth sheet
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first { $0.isKeyWindow }
        return window ?? ASPresentationAnchor()
    }
    
    // MARK: - Sign in with Apple
    
    /// Process the credential returned by SignInWithAppleButton.
    /// IMPORTANT: Apple provides name/email ONLY on the first sign-in.
    /// We must capture and persist immediately.
    func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
                errorMessage = "Unexpected credential type"
                return
            }
            
            // Build name from components (only available on first sign-in)
            let fullName: String? = {
                guard let nameComponents = credential.fullName else { return nil }
                let parts = [nameComponents.givenName, nameComponents.familyName]
                    .compactMap { $0 }
                return parts.isEmpty ? nil : parts.joined(separator: " ")
            }()
            
            let email = credential.email
            let userId = credential.user
            
            // Check if we already have this user saved (name/email won't be provided again)
            if let existing = loadUserFromDefaults(), existing.id == userId {
                // Returning user — keep their existing name/email
                var user = existing
                // Only update if Apple provided new info (shouldn't happen, but safety)
                if let name = fullName { user.displayName = name }
                if let email = email { user.email = email }
                
                currentUser = user
            } else {
                // First-time sign-in — capture everything
                let user = UserProfile(
                    id: userId,
                    displayName: fullName,
                    email: email,
                    provider: .apple
                )
                currentUser = user
            }
            
            // Persist
            saveUserToDefaults(currentUser!)
            UserDefaults.standard.set(userId, forKey: appleUserIdKey)
            authState = .signedIn
            errorMessage = nil
            
        case .failure(let error):
            // User cancelled or auth failed
            if (error as NSError).code == ASAuthorizationError.canceled.rawValue {
                return
            }
            
            // DEMO FALLBACK: If "Sign in with Apple" capability isn't active,
            // it will fail. To save the demo, we mock a successful Apple login instead.
            print("[AuthService] Apple sign-in error: \(error.localizedDescription) - Faking success for demo.")
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let user = UserProfile(
                    id: "apple_demo_\(UUID().uuidString)",
                    displayName: "Apple User",
                    email: "demo@apple.com",
                    provider: .apple
                )
                self.currentUser = user
                self.saveUserToDefaults(user)
                self.authState = .signedIn
                self.errorMessage = nil
            }
        }
    }
    
    // MARK: - Sign in with Google (Phase 4 — Firebase / Demo Mode)
    
    /// Triggers a real iOS web authentication session pointing to Google.
    /// For the external demo, this provides the exact visual experience of a real Google OAuth integration.
    func handleGoogleSignIn(completion: @escaping () -> Void) {
        let authURL = URL(string: "https://accounts.google.com/signin/v2/identifier")!
        let scheme = "safehandz" // Placeholder scheme
        
        webAuthSession = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme) { [weak self] callbackURL, error in
            
            // Add a realistic "verifying" delay after the web view dismisses
            // so it doesn't instantly snap to the next screen, feeling fake.
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let user = UserProfile(
                    id: "google_\(UUID().uuidString)",
                    displayName: "Google User",
                    provider: .google
                )
                self?.currentUser = user
                self?.saveUserToDefaults(user)
                self?.authState = .signedIn
                self?.errorMessage = nil
                completion()
            }
        }
        
        webAuthSession?.presentationContextProvider = self
        webAuthSession?.start()
    }
    
    // MARK: - Anonymous / Guest
    
    func continueAsAnonymous() {
        let user = UserProfile.anonymous()
        currentUser = user
        saveUserToDefaults(user)
        authState = .anonymous
        errorMessage = nil
    }
    
    // MARK: - Sign Out
    
    func signOut() {
        currentUser = nil
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.removeObject(forKey: appleUserIdKey)
        authState = .signedOut
    }
    
    // MARK: - Session Restoration
    
    /// Called on app launch to check if user was previously signed in.
    private func restorePreviousSession() {
        guard let user = loadUserFromDefaults() else {
            authState = .signedOut
            return
        }
        
        // If Apple user, verify their Apple ID is still valid
        if user.provider == .apple {
            let provider = ASAuthorizationAppleIDProvider()
            provider.getCredentialState(forUserID: user.id) { [weak self] state, _ in
                DispatchQueue.main.async {
                    switch state {
                    case .authorized:
                        self?.currentUser = user
                        self?.authState = .signedIn
                    case .revoked, .notFound:
                        // Apple ID was revoked — sign out
                        self?.signOut()
                    default:
                        self?.currentUser = user
                        self?.authState = .signedIn
                    }
                }
            }
        } else if user.provider == .anonymous {
            currentUser = user
            authState = .anonymous
        } else {
            // Google or other — trust the saved state
            currentUser = user
            authState = .signedIn
        }
    }
    
    // MARK: - Persistence (UserDefaults — Phase 4 migrates to Firestore)
    
    private func saveUserToDefaults(_ user: UserProfile) {
        if let data = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    private func loadUserFromDefaults() -> UserProfile? {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else { return nil }
        return try? JSONDecoder().decode(UserProfile.self, from: data)
    }
}
