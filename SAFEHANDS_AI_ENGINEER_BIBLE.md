# SAFE-HANDZ: AI Engineer's Comprehensive Codebase Bible

## 1. Executive Summary & Philosophy
**Safe-Handz** is an iOS application designed exclusively for parents of autistic children in India. It serves two main purposes: systematically tracking the child's developmental journey and providing an emotionally intelligent, AI-powered companion named **Mira**. The app is built entirely in SwiftUI and SwiftData, targeting iOS 17+.

Unlike generic medical apps, everything in Safe-Handz is contextualized for the Indian ecosystem (e.g., UDID cards, RCI registered therapists, Niramaya insurance).

---

## 2. Technical Stack & Architecture
*   **Language:** Swift 6
*   **UI Framework:** SwiftUI (100% pure, no UIKit dependencies)
*   **Architecture Pattern:** MVVM (Model-View-ViewModel)
*   **Persistence:** SwiftData (Local device storage)
*   **Minimum Deployment Target:** iOS 17.0
*   **AI Integration:** Anthropic API (Claude) via Server-Sent Events (SSE) streaming.
*   **Third-Party Dependencies:** None, pure standard library and SPM-only if explicitly required.

---

## 3. Data Models & SwiftData Relational Structure
The app utilizes SwiftData with the following primary entities found in the `/Models` directory:

1.  **`ChildProfile` (@Model)**
    *   **Fields:** `id`, `name`, `age`, `stage` (1-5), `city`, `primaryConcern`, `therapyType`, `oneLiner`, `journeyStartDate`.
    *   **Computed Properties:** `monthsOnJourney` (used for AI context).
    *   **Relationships:**
        *   `logs: [JourneyLog]` (Cascade delete)
        *   `steps: [JourneyStep]` (Cascade delete)

2.  **`JourneyLog` (@Model)**
    *   Represents daily observations.
    *   **Fields:** `id`, `date`, `mood` (Enum), `note`, `stepCompleted`, `aiResponse`.
    *   **MoodTypes:** `.goodMoment` (☀️, softGreen), `.noticedSomething` (✨, sageGreen), `.hardDay` (🌧️, warmGrey - NEVER red), `.justLoggingIn` (👋, lavender).

3.  **`JourneyStep` (@Model)**
    *   Stage-specific actionable steps.
    *   **Fields:** `id`, `stepNumber`, `stage`, `title`, `detail`, `isCompleted`, `completedDate`.

*Note: User defaults currently store `parentName` and `onboardingComplete` flags.*

---

## 4. The AI Heart: "Mira" & Prompt Engineering (Crucial for AI Engineer)
The AI feature is not a generic chatbot. It is a highly contextual companion built into `ViewModels/AIViewModel.swift` and `Services/AnthropicService.swift`. 

### The AI Inject Framework
Before `AnthropicService.stream()` is called, the app dynamically constructs the system prompt injecting the following live state:
*   `{parentName}` & `{childName}` & `{childAge}`
*   `{stage}` & `{city}`
*   `{monthsOnJourney}`
*   `{lastMoodDisplayName}` & `{lastLogNote}`

**Mira's Persona constraints:**
*   She is an older sister figure who grew up in Delhi with an autistic brother. She knows the emotional toll and systemic reality of Indian autism care.
*   She never provides clinical diagnoses or toxic positivity (e.g., "You're doing an amazing job!").
*   She responds in 3-5 sentences and **always ends with exactly ONE question**.
*   Her tone actively calibrates against the *last logged mood*. (e.g., if "Hard day", she sits with the sorrow; she does not offer 5 solutions).

### The AI Knowledge Base Encoded into Prompt
The prompt enforces Mira's deep domain knowledge:
*   **Therapies:** Modern ABA, DIR/Floortime, ESDM, OT, SLP, AAC.
*   **Indian specific legalities:** RPwD Act 2016, UDID Card applications (swavlamban.gov.in), Niramaya Health Insurance.
*   **Crisis Protocols:** Recognizes caregiver depression and routes to Tele-MANAS (14416) or iCall if a crisis is verified.

*Data Flow: The UI (`AIView`) triggers `AIViewModel.sendMessage()`. `AnthropicService` returns an `AsyncThrowingStream<String, Error>` which the ViewModel appends to `ChatMessage.content` chunk by chunk for fluid streaming.*

---

## 5. UI/UX, Design System, & Core Flows
The design language is non-clinical, warm, and highly structured (located in `DesignSystem/`).
*   **Global Background:** `Color.warmCream` (#F7F3E8)
*   **Typography:** System fonts only (Serif for headers, Default for body).
*   **Shadows:** `warmShadowColor` (#B5A898); NEVER black or grey.
*   **Primary CTA:** `terracotta` (#C6855A) - strictly limited to 1 per screen.
*   **Card System:** All white, 18pt radius. Completed states get a `sageGreen` left-edge overlay.

### Key Workflows:
1.  **Onboarding:** 5 sequential screens capturing parent name, child name, age, journey stage, and city, ending in a loading state that seeds the database with stage-appropriate `JourneyStep`s.
2.  **Home:** Shows the child's journey stats, current uncompleted steps (in `StepCard`), and a prominent Floating Action Button (FAB) for logging.
3.  **The Logging Ceremony:** A 6-phase interactive flow:
    *   Select Mood → Write Note → Ripple Seal Animation → Mandatory 2.5s stillness → Door (Save & Close OR Talk to Mira).
4.  **Discover:** A localized view displaying mock therapy centers (Gurugram/Delhi NCR), filtering for ABA, OT, Speech Therapy, etc. Uses `GooglePlacesService`.

---

## 6. File Structure Reference (Naked Codebase View)
*   **`Safe_HandzApp.swift`**: Application entry. Injects `.modelContainer`.
*   **`DesignSystem/`**: `Colors.swift`, `Fonts.swift`, `Modifiers.swift` (contains the crucial `.safeHandsBackground()` modifier).
*   **`Models/`**: `ChildProfile.swift`, `JourneyLog.swift`, `JourneyStep.swift`.
*   **`Services/`**: `AnthropicService.swift` (AI streaming), `GooglePlacesService.swift`, `AuthenticationService.swift` (Future-proofing).
*   **`ViewModels/`**: Orchestrators for all views. Includes `AIViewModel`, `HomeViewModel`, `LoggingViewModel`, `OnboardingViewModel`.
*   **`Views/`**: Grouped sequentially (Onboarding, Home, Logging, AI, Discover, Profile).

---

## 7. Immediate Next Steps / Future Scope
1.  **AI Backend Extension:** Moving the prompt generation, or embedding memory (RAG) across all `JourneyLog`s to an external backend or cloud function to bypass context window limits on the device over years of usage.
2.  **Authentication & Cloud:** Migrating from purely local SwiftData to a CloudKit/Firebase sync.
3.  **Real-Time Directory:** Hooking `DiscoverView` to live authorized therapy APIs (RCI verified only) rather than the mock framework.
