# Safe-Handz: Learning Hub Production Roadmap

This document outlines the step-by-step engineering roadmap for replacing the "Community" tab with the AI-Powered "Learning Hub" in the Safe-Handz iOS application.

## Core Philosophy
- **Frictionless UI:** For parents experiencing cognitive overload and compassion fatigue.
- **Local-First:** Must work instantly offline in a pediatrician's waiting room.
- **Empathetic Gamification:** No punitive streaks; dynamic goals and stress-based auto-freezes.

---

## Phase 1: Data Architecture & Storage Strategy
**Goal:** Establish the `SwiftData` models and local bundling strategy so the UI has immediate data.

1. **Create the `Article` Model**
   - **Properties:** `id` (UUID), `title` (String), `author` (String), `readTime` (Int), `category` (Enum: Education, Guide, Activities, Health, Legal), `tags` ([String]), `markdownBody` (String), `isBookmarked` (Bool), `completionState` (Enum: unread, inProgress, completed).
   - Use `@Model` macro for local persistence.
2. **Setup Local Markdown Bundling**
   - Create a `Content/Articles` folder in Xcode.
   - Bundle initial 20-30 `.md` files.
   - Write a `DataLoader` that reads these files on first launch and seeds the `SwiftData` context.
3. **Hybrid Remote Manifest (Post-Launch)**
   - Draft the logic to asynchronously fetch a JSON version manifest from a remote URL to update local Markdown files without App Store reviews.

---

## Phase 2: Atomic UI Components (The "Lego Blocks")
**Goal:** Build the small, reusable SwiftUI views based on the Figma/Screenshots.

1. **`ProgressRingView`**: Circular path showing weekly goal (e.g., "3 of 8 articles") + flaming streak pill.
2. **`StartHereCard`**: Large horizontal blue/pink cards (e.g., "New Parent Guide").
3. **`RecommendationCard`**: Clean white card with icon, title, author, and orange category pill.
4. **`CategoryGridCard`**: The 5 colored squares for quick browsing.
5. **`BookmarkButton`**: Reusable component that toggles the `isBookmarked` state in SwiftData with a soft haptic bump.
6. **`SearchBar`**: Native iOS `.searchable` modifier setup for instantaneous in-memory `.filter` operations.

---

## Phase 3: Screen Assembly & Markdown Rendering
**Goal:** Bring the components together into the main screens.

1. **`LearnView` (Main Hub)**
   - Assemble components inside a master `ScrollView`.
   - Add the Navigation Bar with the Search Bar and "Saved Articles" icon.
2. **`ArticleDetailView` (The Reader)**
   - Implement native Markdown rendering (`Text(markdownString)` or a lightweight library like `MarkdownUI` to handle native image/header parsing).
   - Ensure dynamic text sizing works flawlessly for accessibility.
3. **`SavedArticlesView`**
   - A list grouped by `Section` (Category) strictly for bookmarked articles.

---

## Phase 4: Empathetic Gamification Engine
**Goal:** Build the tracking logic without overwhelming the user.

1. **The "Read" State Dual-Trigger**
   - Track `ScrollView` offset reaching 90% depth.
   - Track View `onAppear` time hitting >20% of `readTime`. 
   - When both true -> trigger `UIImpactFeedbackGenerator(style: .light)` and mark article `completed`.
2. **Timezone-Aware Streaks**
   - Calculate streaks using `Calendar.current.timeZone` and `startOfDay(for:)`.
   - Update the streak integer if 1 article is completed in the local 24-hour window.
3. **Stress-Based Auto-Freezes**
   - Write logic to check the `JourneyLog`: if a high-stress event (meltdown, crisis) is logged, automatically apply a "streak freeze" for that day.

---

## Phase 5: The Two-Brain Recommendation Engine
**Goal:** Surface the exact right article at the right time.

1. **Brain 1: Local Tag Intersection (Instant)**
   - Extract tags from `ChildProfile` (static) and recent `JourneyLog` entries (dynamic, weighted 3x if within 48 hours).
   - Run a programmatic `Set.intersection` against the `Article` catalog.
   - Render the top matched articles instantly in the UI.
2. **Brain 2: Anthropic Semantic Ranking (Asynchronous)**
   - Take the top 10 local matches.
   - Construct a strict XML-tagged prompt masking PII but detailing the child's context.
   - Send to `AnthropicService` requesting a JSON array of ranked IDs.
   - Silently update the UI ranking once the response arrives.

---

## Phase 6: Tab Swap & Final Integration
**Goal:** Retire "Community" and launch "Learn".

1. **`ContentView` Updates**
   - Remove Community Tab.
   - Inject `LearnView`.
2. **QA & Edge Cases**
   - Test offline search.
   - Verify layout works on iPhone SE and iPhone 15 Pro Max.
   - Test Dark Mode contrast for pastoral colors.