# SAFEHANDS — BUILD REFERENCE (Copilot Internal)

---

## 1. PROJECT IDENTITY

- **Xcode project:** Safe-Handz
- **All source files go in:** `Safe-Handz/` folder
- **App entry:** `Safe_HandzApp.swift`
- **Target user:** Priya, mother of Aarav (6yo, Stage 3, Delhi)
- **Purpose:** Navigation companion for parents of autistic children in India

---

## 2. TECH STACK (LOCKED)

| Item              | Value                              |
|-------------------|------------------------------------|
| Language          | Swift 6                            |
| UI                | SwiftUI (100% pure, no UIKit)      |
| Architecture      | MVVM                               |
| Persistence       | SwiftData                          |
| Min iOS           | 17                                 |
| Dependencies      | SPM only, no 3rd party unless asked|
| Fonts             | System fonts (serif + default)     |
| Colors            | All in Colors.swift only           |

---

## 3. FILE STRUCTURE (20 files to build)

```
Safe-Handz/
├── DesignSystem/
│   ├── Colors.swift          ← All color definitions + hex init
│   ├── Fonts.swift           ← System font helpers (serif/default)
│   ├── Modifiers.swift       ← .safeHandsBackground(), card shadows
│   ├── LeafShape.swift       ← Decorative shape (if needed)
│   └── UnderlineTextField.swift ← Reusable text input component
├── Models/
│   ├── ChildProfile.swift    ← @Model, relationships to logs+steps
│   ├── ParentProfile.swift   ← (if needed, parentName in UserDefaults for now)
│   ├── JourneyLog.swift      ← @Model + MoodType enum
│   ├── JourneyStep.swift     ← @Model + StepContent static data
│   └── LOISection.swift      ← Letter of Intent (future)
├── ViewModels/
│   ├── OnboardingViewModel.swift  ← 5-screen flow, saves to SwiftData
│   ├── HomeViewModel.swift        ← Loads child, steps, greeting
│   ├── LoggingViewModel.swift     ← Ceremony phases, mood, note
│   └── AIViewModel.swift          ← Chat messages, Anthropic streaming
├── Views/
│   ├── ContentView.swift          ← TabView + custom tab bar
│   ├── CustomTabBar.swift         ← (part of ContentView or separate)
│   ├── Onboarding/
│   │   └── OnboardingView.swift   ← 5 sequential screens
│   ├── Home/
│   │   ├── HomeView.swift         ← Greeting, stats, steps, log FAB
│   │   └── StepCard.swift         ← White card, sage border, complete btn
│   ├── Logging/
│   │   ├── LoggingCeremonyView.swift ← Dark bg, 4 phases
│   │   ├── MoodCard.swift         ← Emoji + label, selection animation
│   │   └── RippleView.swift       ← TimelineView + Canvas, single ring
│   ├── AI/
│   │   └── AIView.swift           ← Chat UI, streaming, suggestions
│   ├── Discover/
│   │   ├── DiscoverView.swift     ← Location-based therapy search
│   │   └── TherapistCard.swift    ← Place card with directions link
│   └── Profile/
│       └── ProfileView.swift      ← Identity, child card, settings
├── Services/
│   ├── AnthropicService.swift     ← SSE streaming to Claude
│   └── GooglePlacesService.swift  ← Places API v1 nearby search
└── Safe_HandzApp.swift            ← Entry point, modelContainer, onboarding check
```

---

## 4. COLOR SYSTEM (memorized)

| Token             | Hex       | Usage                              |
|-------------------|-----------|------------------------------------|
| warmCream         | #F7F3E8   | EVERY screen background            |
| deepIndigo        | #320A5C   | All primary text                   |
| terracotta        | #C6855A   | ONE primary CTA per screen         |
| sageGreen         | #B2AC88   | Active states, left borders        |
| softGreen         | #7EBF8E   | Completed states                   |
| warmBrown         | #7A6E62   | Supporting copy                    |
| warmGrey          | #7A7268   | Labels, metadata, HARD DAY mood    |
| warmDivider       | #E5DDD4   | All dividers                       |
| warmShadowColor   | #B5A898   | ALL shadows (never black/grey)     |
| loggingBackground | #2D4A3E   | Logging ceremony ONLY              |

**Critical:** Hard day is NEVER red. It is warmGrey.

---

## 5. TYPOGRAPHY SYSTEM

```swift
// Emotional headlines (where Fraunces would go):
Font.system(size: X, weight: .semibold, design: .serif)

// Body/info (where DM Sans would go):
Font.system(size: X, weight: .regular, design: .default)
Font.system(size: X, weight: .medium, design: .default)
```

No custom font files. System only until explicitly told otherwise.

---

## 6. CARD SYSTEM

Every card:
- Background: `Color.white`
- Corner radius: `18`
- Shadow: `.shadow(color: Color.warmShadowColor.opacity(0.12), radius: 8, x: 0, y: 4)`

Left border cards (sage):
- 5pt left border in sageGreen
- Applied as overlay on left edge ONLY (not full outline)

---

## 7. GLOBAL VIEW RULES

1. Background: ALWAYS `Color.warmCream` (via `.safeHandsBackground()`)
2. Exception: LoggingCeremonyView uses `loggingBackground`
3. One terracotta element per screen MAX
4. All shadows: warmShadowColor — never black/grey
5. Section labels: medium weight, 11pt, warmGrey, lowercase
6. Child referenced by NAME — never "your child"
7. Async: use `.task` modifier, not `.onAppear`
8. Concurrency: `async/await` + `Task.sleep` — never `DispatchQueue`
9. Mutations: always `try? context.save()` after writes

---

## 8. DATA MODEL RELATIONSHIPS

```
ChildProfile (1)
  ├── logs: [JourneyLog] (many) — cascade delete
  └── steps: [JourneyStep] (many) — cascade delete
```

- Parent name: stored in `UserDefaults` (key: "parentName")
- Onboarding flag: `UserDefaults` (key: "onboardingComplete")
- Steps seeded from `StepContent.steps(for: stage)` during onboarding

---

## 9. MOOD TYPES (critical — memorize)

| Mood              | Key               | Emoji | Color                    |
|-------------------|-------------------|-------|--------------------------|
| Good moment       | good_moment       | ☀️    | softGreen (#7EBF8E)     |
| Noticed something | noticed_something | ✨    | sageGreen (#B2AC88)     |
| Hard day          | hard_day          | 🌧️    | warmGrey (#7A7268) ⚠️   |
| Just logging in   | just_logging_in   | 👋    | lavender (#C4B8D4)      |

---

## 10. LOGGING CEREMONY PHASES

```
selectingMood → writingNote → sealing → stillness → door → talking
```

1. **selectingMood:** "How was today?" + 4 MoodCards (staggered 80ms)
2. **writingNote:** Selected mood shown + text input + "Done →"
3. **sealing:** RippleView + child initial (serif 72pt amber), fade in/out
4. **stillness:** 2.5s no interaction allowed
5. **door:** "Save and close" or "Talk to SafeHands →"
6. **talking:** Transitions to AI view (optional)

---

## 11. AI SYSTEM PROMPT CONTEXT

Built from: child name, age, stage, city, months on journey, parent name, most recent log
Personality: warm older sister, plain language, no toxic positivity
Boundaries: never diagnose, never recommend meds, never replace therapist
Responses: 2-4 sentences unless more asked

---

## 12. ONBOARDING FLOW (5 screens)

1. Parent name → "What's your name?"
2. Child name → "What is your child's name?"
3. Child age → "How old is [childName]?"
4. Stage → "Where are you in your journey?" (5 cards, most important)
5. City → "Which city are you in?"
6. Loading → "Setting up [childName]'s journey..." (1s → save → dismiss)

---

## 13. TAB BAR (5 tabs)

| Tab       | Icon                | Label      |
|-----------|---------------------|------------|
| Home      | house               | home       |
| Discover  | magnifyingglass     | discover   |
| Community | person.2            | community  |
| AI        | bubble.left         | ai         |
| Profile   | person              | profile    |

- Native tab bar: HIDDEN
- Custom overlay: warmCream bg, warm shadow on top
- Active: deepIndigo + 2pt terracotta capsule underline (matchedGeometryEffect)
- Inactive: warmGrey
- All labels lowercase

---

## 14. BUILD ORDER (strict)

### Phase 1 — Foundation
1. `Colors.swift`
2. `Fonts.swift`
3. `Modifiers.swift`

### Phase 2 — Data
4. `ChildProfile.swift`
5. `JourneyLog.swift`
6. `JourneyStep.swift`
7. Update `Safe_HandzApp.swift` (add modelContainer)

### Phase 3 — ViewModels
8. `OnboardingViewModel.swift`
9. `HomeViewModel.swift`
10. `LoggingViewModel.swift`
11. `AIViewModel.swift`

### Phase 4 — Services
12. `AnthropicService.swift`
13. `GooglePlacesService.swift`

### Phase 5 — Navigation
14. `ContentView.swift` (with custom tab bar)

### Phase 6 — Screens
15. `OnboardingView.swift`
16. `HomeView.swift` + `StepCard.swift`
17. `LoggingCeremonyView.swift` + `MoodCard.swift` + `RippleView.swift`
18. `AIView.swift`
19. `DiscoverView.swift` + `TherapistCard.swift`
20. `ProfileView.swift`

---

## 15. THINGS TO WATCH FOR

- `MoodType.color` returns `Color` → needs `import SwiftUI` in JourneyLog.swift
- `Color(hex:)` initializer must be defined in Colors.swift
- `MoodType` is used in `@Model` class → must be `Codable` + `RawRepresentable` for SwiftData
- `AnthropicService.stream()` returns `AsyncThrowingStream<String, Error>`
- GooglePlaces response has nested `displayName.text` structure
- `ChatMessage.content` is `var` (not let) because it's updated during streaming
- `LeafShape.swift`, `UnderlineTextField.swift`, `ParentProfile.swift`, `LOISection.swift` — in structure but no spec given yet; build only when asked
- The `Color(hex: "#C4B8D4")` for justLoggingIn mood must work via hex initializer

---

## 16. COMMANDS I RESPOND TO

- **"Build [filename]"** → Write that complete file, nothing else
- **"Fix [error]"** → Fix only that error, nothing else
- **"Add [feature] to [filename]"** → Modify only that file

---

*This reference was generated from the master prompt. Every value is locked.*
