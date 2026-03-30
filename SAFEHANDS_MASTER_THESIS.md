# Safe-Handz: The Complete Master Thesis

## A Comprehensive Guide to Building an AI-Powered Mobile Companion for Parents of Autistic Children in India

---

# Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Problem Statement & Product Vision](#2-problem-statement--product-vision)
3. [Target Audience](#3-target-audience)
4. [Technical Architecture](#4-technical-architecture)
5. [Design System](#5-design-system)
6. [Data Models & Persistence](#6-data-models--persistence)
7. [User Interface & User Experience](#7-user-interface--user-experience)
8. [The AI Engine: Mira](#8-the-ai-engine-mira)
9. [Core Features & Workflows](#9-core-features--workflows)
10. [API Integrations](#10-api-integrations)
11. [Project Structure](#11-project-structure)
12. [Build Configuration](#12-build-configuration)
13. [Future Roadmap](#13-future-roadmap)
14. [Conclusion](#14-conclusion)

---

# 1. Executive Summary

## 1.1 What is Safe-Handz?

Safe-Handz is a native iOS application built entirely with Swift and SwiftUI, designed specifically to support parents of autistic children in India. The application serves a dual purpose: it provides a structured system for tracking the child's developmental journey, and it offers an emotionally intelligent AI-powered companion named Mira who guides parents through the complexities of the Indian autism ecosystem.

The name "Safe-Handz" embodies the application's core philosophy—the notion of holding someone's hand through a challenging journey. Just as a parent would protectively hold their child's hand while crossing a busy street, Safe-Handz aims to provide that same sense of security, guidance, and support to parents navigating the often overwhelming world of autism care in India.

## 1.2 Core Product Identity

The product identity defines every decision made in Safe-Handz, from the choice of colors to the tone of AI responses. Understanding this identity is essential for any designer or developer working on the project.

**Name:** Safe-Handz  
**Language:** Swift 6  
**UI Framework:** SwiftUI (100% pure, no UIKit)  
**Architecture Pattern:** MVVM (Model-View-ViewModel)  
**Persistence:** SwiftData (Local device storage only for MVP)  
**Minimum iOS Version:** 17.0  
**Deployment Target:** iPhone only  
**Third-Party Dependencies:** None (Pure Apple frameworks)

The decision to use pure SwiftUI without any UIKit dependencies reflects the project's commitment to modern Apple development practices. SwiftUI provides a declarative approach to building user interfaces that aligns perfectly with the project's need for rapid iteration and clean, maintainable code. The choice of SwiftData as the persistence layer ensures type-safe data management with compile-time checking, reducing runtime errors and improving overall application reliability.

## 1.3 The Two Pillars of Safe-Handz

Safe-Handz rests on two fundamental pillars that define its value proposition to users:

**Pillar One: Journey Tracking**  
The first pillar is a structured system for tracking the child's developmental journey. Parents need a way to document their observations, track progress against defined milestones, and maintain a chronological record of their child's growth. This pillar addresses the practical need for organization and documentation that many parents struggle with while managing multiple therapy appointments, medical appointments, and daily interventions.

**Pillar Two: AI Companion (Mira)**  
The second pillar is Mira, an AI-powered companion designed to provide emotional support and domain-specific knowledge. Mira is not a generic chatbot or a clinical diagnostic tool. Instead, she embodies the persona of a warm, experienced older sister who understands the Indian context—someone who has walked a similar path and can offer guidance, validation, and practical information about the autism ecosystem in India.

---

# 2. Problem Statement & Product Vision

## 2.1 The Problem Landscape

The landscape of autism care in India presents unique challenges that Safe-Handz aims to address. According to various estimates, India has anywhere between 10 to 20 million autistic individuals, though the exact numbers remain debated due to varying definitions and diagnostic criteria. What is clear is that the number of children being diagnosed with autism spectrum conditions has been steadily increasing, and the support infrastructure has not kept pace with this growth.

Parents of autistic children in India face a multifaceted challenges:

**Information Asymmetry:** The average parent, upon receiving a diagnosis, knows very little about autism, therapies, government schemes, or available resources. The information landscape is fragmented, with resources scattered across government websites, private therapy centers, NGO networks, and parent communities. Parents often don't know what questions to ask, let alone where to find answers.

**Emotional Isolation:** The journey of raising an autistic child can be emotionally isolating. Family members may not understand the challenges, friends may offer well-meaning but unhelpful advice, and the general public often lacks awareness about autism. Parents need a space where their experiences are validated and their emotions are acknowledged.

**Systemic Complexity:** India's disability ecosystem involves multiple government schemes (UDID card, Niramaya health insurance, disability pension), various therapy modalities (ABA, Occupational Therapy, Speech Therapy, DIR/Floortime), and regulatory bodies (RCI - Rehabilitation Council of India). Navigating this system requires knowledge that most parents acquire slowly, if at all, through trial and error.

**Financial Burden:** Therapy and interventions are expensive, and government support, while available, is often underutilized due to lack of awareness. Parents need guidance on accessing available resources to mitigate the financial burden.

## 2.2 The Safe-Handz Solution

Safe-Handz addresses these challenges through a carefully designed mobile application that combines practical tracking tools with an emotionally intelligent AI companion. The product vision centers on the following core principles:

**Non-Medical Approach:** Safe-Handz deliberately avoids a clinical, medical, or diagnostic tone. The application is designed to feel like a supportive journal rather than a medical tracking tool. This choice reflects the understanding that parents are already navigating a medicalized world and need a space that feels human and warm.

**India-Centric Design:** Every aspect of Safe-Handz is contextualized for India. The AI companion understands Indian government schemes, therapy modalities available in Indian cities, and the cultural context in which families operate. This differentiates Safe-Handz from international applications that may have excellent features but lack local relevance.

**Emotional Validation First:** The application prioritizes emotional validation over problem-solving. When a parent logs a "hard day," the system doesn't immediately offer solutions or toxic positivity. Instead, it acknowledges the difficulty and provides space for processing. This philosophy extends to Mira's responses, which are designed to sit with difficult emotions rather than rushing to fix them.

**Practical Empowerment:** Beyond emotional support, Safe-Handz provides practical tools for journey tracking, milestone management, and resource discovery. The combination of emotional and practical support creates a holistic product that addresses both the felt and practical needs of parents.

---

# 3. Target Audience

## 3.1 Primary User: Priya

To understand Safe-Handz's design decisions, it helps to visualize the primary user. Meet Priya, a mother in Gurugram with a six-year-old son named Aarav who was diagnosed with autism two years ago.

Priya works as a marketing professional but has reduced her working hours to accommodate Aarav's therapy sessions. She spends her mornings managing Aarav's daily routine, afternoons at therapy centers, and evenings trying to fit in occupational therapy exercises at home. Between appointments, she scours the internet for information about new therapies, government schemes, and parent support groups.

Priya loves her son deeply but often feels overwhelmed, confused, and alone in her journey. She has questions about Aarav's future, concerns about whether she's doing enough, and moments of frustration that she feels guilty about expressing. She doesn't have time to read lengthy articles or attend support group meetings in person, but she does have small pockets of time during her commute or after bedtime where she could benefit from a supportive conversation.

## 3.2 User Characteristics

Understanding Priya's characteristics helps explain design decisions throughout Safe-Handz:

**Time-Poor:** Priya has limited uninterrupted time. The application must be designed for brief, interrupted usage sessions. The logging ceremony, for example, can be completed in a few minutes but provides a meaningful ritual that parents can fit into their day.

**Information-Seeking:** Priya is looking for answers but may not know what questions to ask. The AI companion must be proactive in offering relevant information without overwhelming the user.

**Emotionally Vulnerable:** Priya experiences a range of emotions—joy at Aarav's progress, grief for the life she imagined, frustration at the system, and guilt for feeling frustrated. The application must provide emotional support without judgment.

**Tech-Savvy but Not Developer:** Priya uses smartphones daily and is comfortable with modern apps. However, she doesn't understand technical details and shouldn't need to. The interface must be intuitive without requiring explanations.

**Contextualized to India:** Priya lives in India and needs information relevant to her context—local therapy centers, government schemes she can access, and an AI companion who understands Indian culture and systems.

---

# 4. Technical Architecture

## 4.1 Technology Stack Overview

The technical architecture of Safe-Handz reflects a deliberate choice to use modern, native Apple technologies. This section provides a comprehensive overview of the technology stack from both a developer's and designer's perspective.

### Language: Swift 6

Swift 6 represents the latest evolution of Apple's programming language, bringing with it enhanced concurrency features and improved safety guarantees. The choice of Swift 6 enables the use of modern async/await patterns, making asynchronous code more readable and less prone to errors. For Safe-Handz, this translates to cleaner code for API calls, database operations, and streaming responses.

From a developer's perspective, Swift 6's strict concurrency checking at compile time prevents many common multithreading bugs. The language's evolution from Swift 5.x means that legacy patterns can be replaced with more modern approaches, and Safe-Handz takes advantage of these patterns throughout its codebase.

### UI Framework: SwiftUI (100% Pure)

Safe-Handz is built entirely with SwiftUI, with zero UIKit dependencies. This is a significant architectural decision that deserves explanation.

SwiftUI's declarative syntax allows for clearer expression of user interface intent. Rather than imperative commands to create and position views, SwiftUI allows developers to describe what the interface should look like, letting the framework handle the underlying complexity. This results in code that is easier to read, maintain, and modify.

The choice to avoid UIKit entirely reflects the project's commitment to modern Apple development. While UIKit remains powerful and is used by many applications, SwiftUI offers several advantages for Safe-Handz:

**State Management:** SwiftUI's @State, @Binding, and @Observable patterns provide a natural way to manage UI state, reducing the boilerplate code required for view controllers.

**Preview Support:** SwiftUI's preview functionality allows designers and developers to see UI changes in real-time without building the entire application, accelerating the design iteration process.

**Animation:** SwiftUI's animation system makes creating smooth, meaningful animations significantly easier than UIKit's core animation APIs.

**Future-Proofing:** Apple is clearly investing in SwiftUI as the future of Apple platform UI development. By committing fully to SwiftUI, Safe-Handz positions itself to benefit from future framework improvements.

### Architecture Pattern: MVVM

Safe-Handz follows the Model-View-ViewModel (MVVM) architectural pattern, which provides a clean separation of concerns that enhances testability and maintainability.

**Models:** The data layer consists of SwiftData models that represent the application's core entities—ChildProfile, JourneyLog, and JourneyStep. These models are purely data-focused and contain no UI or business logic.

**Views:** SwiftUI views that are entirely concerned with presentation. Views observe ViewModels and render the UI based on the current state. Views do not directly manipulate data or make network requests.

**ViewModels:** The business logic layer that sits between Models and Views. ViewModels expose observable properties that Views observe, transform data for presentation, and handle user interactions. ViewModels also manage API calls, database operations, and other asynchronous tasks.

This separation ensures that business logic is testable in isolation from the UI, views remain focused purely on presentation, and data models remain simple and persistent.

### Persistence: SwiftData

SwiftData is Apple's modern persistence framework, designed to work seamlessly with SwiftUI. It provides type-safe data management with compile-time checking, reducing runtime errors and improving developer productivity.

SwiftData uses the @Model macro to define persistent entities, which the framework then uses to generate the underlying database schema. Relationships between entities are defined declaratively, and the framework handles all the complexity of object graph management and persistence.

For Safe-Handz, SwiftData provides an ideal solution for local-first data storage. The application stores all user data locally on the device, which addresses privacy concerns and works without internet connectivity. Future iterations may add cloud synchronization, but the current MVP uses local storage exclusively.

### Minimum iOS Version: 17.0

The decision to target iOS 17.0 as the minimum deployment version reflects the project's dependence on SwiftData and modern SwiftUI features introduced in iOS 17. While this limits the application's reach to older devices, the trade-off is acceptable given the project's focus on providing a modern, feature-rich experience.

iOS 17 introduced significant improvements to SwiftData, SwiftUI's navigation system, and various other frameworks that Safe-Handz relies upon. By targeting iOS 17, the development team can use these modern APIs without complexity of supporting older versions.

---

# 5. Design System

## 5.1 Design Philosophy

The design system of Safe-Handz is built on a foundation of warmth, calm, and non-clinical aesthetics. The application should feel like a supportive journal rather than a medical tool, and every design decision reflects this philosophy.

### Warmth Over Clinical Precision

Traditional medical applications often rely on sterile whites, clinical blues, and sharp几何 shapes. Safe-Handz deliberately breaks from this convention. The color palette draws inspiration from earth tones, natural materials, and warm, inviting spaces. The typography balances emotional expression with readability, using serif fonts for headlines to evoke a sense of humanity and connection.

### Calming Presence

The application must provide a calming presence in users' lives. Parents are already navigating a stressful journey, and the application should be a source of peace rather than another cause of anxiety. This is achieved through generous whitespace, smooth animations, and a consistent visual language that users can learn and trust.

### Non-Medical Language

The design avoids medical terminology and clinical visual cues. Instead of words like "diagnosis," "treatment," and "patient," Safe-Handz uses language like "journey," "milestones," and "parent." The visual language similarly avoids symbols associated with healthcare, instead using organic shapes and warm colors.

## 5.2 Color System

The color system is the foundation of Safe-Handz's visual identity. Every color has been carefully selected to convey specific emotions and meanings, and developers must use these colors consistently throughout the application.

### Color Tokens

The design system defines a set of color tokens that are used consistently across the entire application:

| Token | Hex Code | Usage | Emotional Meaning |
|-------|----------|-------|-------------------|
| warmCream | #F7F3E8 | Screen backgrounds | Paper-like, warm, inviting |
| deepIndigo | #320A5C | Primary text | Readable, human, not stark black |
| terracotta | #C6855A | Primary CTA buttons | Earthy, Indian-inspired, action |
| sageGreen | #B2AC88 | Active states, left borders | Calming, growth, active steps |
| softGreen | #7EBF8E | Completed states | Positive reinforcement, success |
| warmBrown | #7A6E62 | Supporting copy | Warm, secondary information |
| warmGrey | #7A7268 | Labels, metadata, hard day mood | Soft, subdued, never alarming |
| warmDivider | #E5DDD4 | Dividers | Subtle separation |
| warmShadow | #B5A898 | All shadows | Soft depth, never harsh |
| loggingBackground | #2D4A3E | Logging ceremony only | Dark forest green, ritual space |

### Critical Design Rules

**Hard Day is Never Red:** This is perhaps the most important design rule in Safe-Handz. The "hard day" mood indicator uses warmGrey (#7A7268) rather than red. Red signals danger, alarm, or urgency—the opposite of what a parent experiencing a hard day needs to see. WarmGrey acknowledges difficulty without alarming or further stressing the user.

**One Terracotta Per Screen:** To maintain visual calm, each screen should contain at most one terracotta (primary action) element. This prevents visual overload and guides users toward the most important action on each screen.

**Shadows Use Warm Shadow Color:** All drop shadows throughout the application must use the warmShadow color (#B5A898). Never use default black or grey shadows, as they feel harsh and disconnected from the warm visual language.

### Implementation

Color tokens are implemented as SwiftUI Color extensions in Colors.swift:

```swift
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
    static let loggingBackground = Color(hex: "2D4A3E")
}
```

The Color extension includes a hex initializer that allows colors to be created from hex code strings, enabling the exact specification of colors as defined in the design system.

## 5.3 Typography System

The typography system balances emotional expression with practical readability. Safe-Handz uses system fonts exclusively to ensure fast loading, optimal rendering, and accessibility support without requiring custom font files.

### Type Hierarchy

**Emotional Headlines:** Serif font with semibold weight. Used for headlines and titles where emotional connection is important.

```swift
.font(.system(size: 28, weight: .semibold, design: .serif))
```

**Body and Information:** Default system font with regular or medium weight. Used for body text, labels, and secondary information where readability is paramount.

```swift
.font(.system(size: 16, weight: .regular, design: .default))
.font(.system(size: 14, weight: .medium, design: .default))
```

### Design Principles

**No Custom Fonts:** The decision to use system fonts exclusively avoids the complexity and performance implications of loading custom font files. System fonts are optimized for Apple devices, render crisply at all sizes, and support dynamic type accessibility features.

**Hierarchy Through Weight and Size:** Typography hierarchy is established through weight (semibold for headlines, regular for body) and size rather than through multiple font families.

**Lowercase Tab Labels:** Tab labels throughout the application use lowercase text, contributing to the informal, warm visual language.

## 5.4 Component System

### Card Components

All cards in Safe-Handz follow a consistent visual pattern:

**Standard Card:** Used for general content display

- Background: White (#FFFFFF)
- Corner radius: 18 points
- Shadow: warmShadow at 12% opacity, 8-point radius, no x-offset, 4-point y-offset
- Shadow implementation: `.shadow(color: Color.warmShadow.opacity(0.12), radius: 8, x: 0, y: 4)`

**Left Border Card (Sage Card):** Used for active or tertiary actions

- 5-point left border overlay using sageGreen color
- Applied as a separate view overlay on the left edge
- Indicates active step progress or contextual information

### Mood Cards

Mood selection cards are large, tappable components that display mood options with emoji and color coding. Each mood card includes:

- Large emoji display (mood indicator)
- Mood name text
- Background color matching the mood's semantic meaning
- Selection animation with staggered appearance (80ms delay between cards)

### Floating Action Button (FAB)

The Home screen includes a floating action button for initiating the logging ceremony. The FAB uses terracotta color and appears in a consistent position (bottom-right quadrant of the screen) across all states.

---

# 6. Data Models & Persistence

## 6.1 SwiftData Architecture

Safe-Handz uses SwiftData for all local data persistence. SwiftData is Apple's modern, type-safe persistence framework that provides compile-time checking and seamless integration with SwiftUI. This section details the data model architecture from both a developer's designer's perspective.

### Why SwiftData?

SwiftData was chosen over alternatives like Core Data or SQLite for several reasons:

**Type Safety:** SwiftData models are defined using Swift's type system, providing compile-time checking that catches errors before runtime.

**SwiftUI Integration:** SwiftData is designed to work natively with SwiftUI, providing @Query property wrappers that automatically update views when data changes.

**Declarative Schema:** Relationships and constraints are defined declaratively, making the data model easy to understand and modify.

**Modern API:** SwiftData represents Apple's current direction for data persistence, ensuring the codebase remains current with modern best practices.

### Model Relationships

The data model consists of three primary entities with well-defined relationships:

```
ChildProfile (1) ────── Logs (many) ────── JourneyLog
     │
     └── Steps (many) ────── JourneyStep
```

**ChildProfile** is the central entity, representing the child whose journey is being tracked. It has one-to-many relationships with both JourneyLog and JourneyStep entities. Both relationships use cascade delete rules, meaning that when a ChildProfile is deleted, all associated logs and steps are automatically deleted.

This relationship structure makes intuitive sense: a child's journey encompasses all their daily logs and milestone steps. Deleting the child should logically delete all associated data.

## 6.2 Core Entities

### ChildProfile

ChildProfile is the primary entity that represents the child being tracked by the application. It contains all basic information about the child and serves as the parent entity for logs and steps.

```swift
@Model
final class ChildProfile {
    var id: UUID
    var name: String
    var age: Int
    var stage: Int              // 1-5 representing journey stage
    var city: String
    var primaryConcern: String
    var therapyType: String
    var oneLiner: String        // Brief description
    var journeyStartDate: Date
    
    @Relationship(deleteRule: .cascade)
    var logs: [JourneyLog] = []
    
    @Relationship(deleteRule: .cascade)
    var steps: [JourneyStep] = []
}
```

**Fields Explained:**

- **id:** Unique identifier for the profile
- **name:** Child's name (used throughout the app)
- **age:** Child's age in years
- **stage:** Journey stage (1-5), determines curriculum content
- **city:** City for localized therapy discovery
- **primaryConcern:** Parent's primary concern about the child
- **therapyType:** Type of therapy the child is receiving
- **oneLiner:** Brief description or tagline for the child
- **journeyStartDate:** Date when journey tracking began

**Computed Properties:**

- **monthsOnJourney:** Calculates the number of months since journeyStartDate. Used by the AI system to provide contextually relevant responses.

### JourneyLog

JourneyLog represents a single daily entry in the journey. Each log captures the parent's observation for a particular day, including the mood, note, and any associated AI response.

```swift
@Model
final class JourneyLog {
    var id: UUID
    var date: Date
    var mood: MoodType         // Enum
    var note: String           // Parent's observation
    var stepCompleted: String? // Optional step reference
    var aiResponse: String?    // Mira's response if logged
}
```

**MoodType Enum:**

The MoodType enum defines four possible moods, each with specific visual properties:

| Mood | Key | Emoji | Color | When to Use |
|------|-----|-------|-------|-------------|
| Good Moment | good_moment | ☀️ | softGreen | When something positive happened |
| Noticed Something | noticed_something | ✨ | sageGreen | When parent observed something notable |
| Hard Day | hard_day | 🌧️ | warmGrey | When it's been a difficult day |
| Just Logging In | just_logging_in | 👋 | lavender (#C4B8D4) | When just checking in without specific observation |

The MoodType enum includes computed properties for displayName, color, and emoji, making it easy to render mood displays consistently throughout the application.

### JourneyStep

JourneyStep represents a single milestone or task within the journey curriculum. Steps are organized by stage and include a completion mechanism.

```swift
@Model
final class JourneyStep {
    var id: UUID
    var stepNumber: Int        // 1-5 within each stage
    var stage: Int             // 1-5 representing journey stage
    var title: String
    var detail: String         // Full description
    var isCompleted: Bool
    var completedDate: Date?
}
```

**Stage-Based Curriculum:**

The application seeds JourneyStep entities based on the child's selected stage during onboarding. Each stage has five steps, creating a total of 25 possible steps in the curriculum. This structured approach provides parents with actionable tasks and clear progress indicators.

## 6.3 UserDefaults Storage

While SwiftData handles complex entities, certain simple values are stored in UserDefaults for quick access:

**parentName:** The parent's name, used throughout the app for personalized greetings.

**onboardingComplete:** Boolean flag indicating whether the user has completed the onboarding flow.

**preOnboardingComplete:** Boolean flag indicating whether the pre-onboarding (introduction) flow has been completed.

---

# 7. User Interface & User Experience

## 7.1 Navigation Architecture

Safe-Handz uses a TabView-based navigation structure with five primary tabs. Each tab represents a major feature area and is accessible from any screen within the application.

### Tab Structure

| Tab | Icon | Label | Purpose |
|-----|------|-------|---------|
| Home | house | home | Journey dashboard, stats, logging access |
| Discover | magnifyingglass | discover | Find therapists and NGOs |
| Community | person.2 | community | Parent community (future) |
| AI | bubble.left | ai | Chat with Mira |
| Profile | person | profile | Child profile and settings |

### Custom Tab Bar

The native iOS tab bar is hidden, replaced with a custom overlay that adheres to Safe-Handz's design system:

- Background: warmCream
- Shadow: warmShadow along the top edge
- Active indicator: deepIndigo icon with terracotta capsule underline (using matchedGeometryEffect)
- Inactive icons: warmGrey
- All labels: lowercase

This customization ensures the tab bar feels like an integrated part of the application rather than a generic system component.

## 7.2 Screen Flows

### Pre-Onboarding Flow

The pre-onboarding flow is the first introduction users have to Safe-Handz. It uses a swipe-card interface to introduce the application's core value propositions before requesting any personal information.

**Purpose:** Build emotional connection and trust before asking for data.

**Content:** Three to four swipe cards explaining the application's features and philosophy.

**Exit:** Users proceed to either full onboarding or skip to main app (depending on flow design).

### Onboarding Flow (6 Screens)

The onboarding flow collects essential information about the parent and child through a sequential, conversational interface:

1. **Parent Name:** "What's your name?"
2. **Child Name:** "What is your child's name?"
3. **Child Age:** "How old is [childName]?"
4. **Journey Stage:** "Where are you in your journey?" (5 cards representing stages 1-5)
5. **Primary Concern:** "What concerns you most?"
6. **City:** "Which city are you in?" + Loading state

The conversational structure makes data collection feel like a dialogue rather than a form-filling exercise. Each screen focuses on a single piece of information, reducing cognitive load.

**Stage Definitions:**

- Stage 1: Just Diagnosed / Early Awareness
- Stage 2: Building Routines
- Stage 3: Active Therapy
- Stage 4: Integration & Inclusion
- Stage 5: Long-term Planning

### Home Screen

The Home screen serves as the journey dashboard, providing at-a-glance information about the child's progress and quick access to logging features.

**Components:**

- **Greeting Section:** Time-based greeting (Good morning/afternoon/evening) with parent's name
- **Stats Row:** Months on journey, steps completed, days logged
- **Quote Card:** Context-aware inspirational or informational quote
- **Daily Action Plan:** Step cards showing current uncompleted steps
- **Log FAB:** Floating action button to start logging ceremony

### The Logging Ceremony

The logging ceremony is one of Safe-Handz's most innovative features. Rather than a simple form for recording daily observations, it is designed as a six-phase ritual that makes the act of reflection feel meaningful and intentional.

**Phase 1: Selecting Mood**
The parent sees four mood cards (Good moment, Noticed something, Hard day, Just logging in) and selects one. Cards appear with staggered animation (80ms delay).

**Phase 2: Writing Note**
The selected mood is displayed with a text input area for the parent to write their observation.

**Phase 3: Sealing**
A RippleView animation plays, creating a sense of closure and ritual. The animation includes the child's first initial in serif font.

**Phase 4: Stillness**
A mandatory 2.5-second pause with no interaction allowed. This enforces a moment of reflection and prevents rushed logging.

**Phase 5: Door**
The parent chooses between "Save and close" or "Talk to Mira" (proceed to AI chat).

**Phase 6: Talking (Optional)**
If the parent chooses to talk to Mira, the AI chat interface opens with context from the just-logged mood and note.

**Design Note:** The logging ceremony uses a distinct background color (loggingBackground: #2D4A3E), creating a visual break from the rest of the application and reinforcing the ritualistic nature of the experience.

### AI Chat (Mira)

The AI chat interface provides a conversational interface for interacting with Mira. Key features include:

- Chat bubble interface with parent and Mira messages
- Streaming text responses (feels like Mira is typing)
- Contextual suggestions based on last logged mood
- Light mode (from tab bar) or dark mode (from logging ceremony)

### Discover Screen

The Discover screen helps parents find therapists and resources near them:

- **Therapist Search:** Find therapy centers by type (ABA, OT, SLP)
- **Location Filter:** Search by current city
- **Entitlements:** Information about government schemes
- **NGO Discovery:** Find support organizations

### Profile Screen

The Profile screen manages the child's profile information and application settings:

- Child avatar and summary statistics
- Edit profile functionality
- Developer tools (reset steps, sign out)
- About and help information

---

# 8. The AI Engine: Mira

## 8.1 What is Mira?

Mira is the AI companion embedded within Safe-Handz, designed to provide emotional support and domain-specific knowledge to parents. However, Mira is not a chatbot in the traditional sense. She is a carefully crafted persona—a warm, experienced older sister figure who has walked a similar path.

### Persona Definition

**Background:** Mira grew up in Delhi with an autistic younger brother. She has lived experience of the Indian autism ecosystem and understands both the emotional and practical challenges parents face.

**Tone:** Warm, empathetic, and practical. She never uses toxic positivity (e.g., "You're doing an amazing job!") and instead sits with emotions authentically.

**Knowledge Domain:** Deep familiarity with the Indian context, including:

- Therapy modalities (ABA, DIR/Floortime, ESDM, OT, SLP, AAC)
- Government schemes (RPwD Act 2016, UDID card, Niramaya health insurance)
- RCI (Rehabilitation Council of India) registered therapists
- Crisis support resources (Tele-MANAS 14416, iCall)

**Response Style:** 3-5 sentences maximum, always ending with one specific question to deepen the conversation.

## 8.2 Technical Implementation

### AnthropicService Architecture

Mira's functionality is powered by the AnthropicService, which connects to Groq's API using the Llama-3.3-70b-versatile model. The service implements Server-Sent Events (SSE) streaming for real-time responses.

**Key Technical Features:**

- **Streaming Responses:** Uses AsyncThrowingStream for fluid, real-time text generation
- **API Key Rotation:** Implements automatic key rotation when keys are exhausted (429 errors) or invalid (401 errors)
- **Context Injection:** Dynamically builds system prompts with child-specific context
- **Error Handling:** Graceful degradation with user-friendly error messages

**API Key Management:**

```swift
private static var apiKeys: [String] {
    return Secrets.groqAPIKeys
}

private static var currentKeyIndex: Int = 0
```

API keys are stored in a local Secrets.swift file (excluded from version control) that provides an array of keys. If one key hits a rate limit (429) or becomes invalid (401), the service automatically rotates to the next key and retries.

### Dynamic Context Injection

Mira's intelligence comes from dynamic context injection. Before every message, the system builds a comprehensive prompt that includes:

- **Parent Name:** `{parentName}`
- **Child Name:** `{childName}`
- **Child Age:** `{childAge}`
- **Journey Stage:** `{stage}`
- **City:** `{city}`
- **Months on Journey:** `{monthsOnJourney}`
- **Last Mood:** `{lastMoodDisplayName}`
- **Last Note:** `{lastLogNote}`

This contextual information allows Mira to provide personalized, relevant responses that acknowledge the specific situation of each parent.

### Response Generation Flow

1. **User Sends Message:** AIView receives user input and passes to ViewModel
2. **ViewModel Builds Prompt:** AIViewModel constructs system prompt with dynamic context
3. **Stream Request:** AnthropicService.stream() is called with messages and system prompt
4. **Streaming Response:** AsyncThrowingStream delivers chunks of text in real-time
5. **UI Updates:** ViewModel appends chunks to message content, UI updates progressively
6. **Final Response:** Stream completes, message is finalized

## 8.3 Behavioral Rules

### Tone Calibration

Mira's tone actively calibrates based on the most recently logged mood:

**Good Moment:** Mira witnesses the positive moment without inflating it. She acknowledges and encourages gently.

**Noticed Something:** Mira shows curiosity and interest, asking follow-up questions to understand what was observed.

**Hard Day:** This is critical. Mira does NOT offer solutions or toxic positivity. She sits with the pain, validates the difficulty, and provides space for the parent to express themselves. She may gently offer support resources if appropriate, but never in a prescriptive way.

**Just Logging In:** Mira keeps it light and available, offering casual check-in without deep inquiry.

### Crisis Protocol

Mira is trained to recognize signs of caregiver crisis or despair. If detected, she follows a soft escalation protocol:

1. **Validate:** Sit with the emotion authentically
2. **Offer Resources:** Gently mention Tele-MANAS (14416) or iCall if genuine crisis indicators
3. **Do Not Diagnose:** Never attempt to diagnose mental health conditions
4. **Encourage Professional Help:** Suggest speaking with a professional if persistent distress

This crisis protocol is encoded in Mira's system prompt and guides her responses in high-risk situations.

### Response Constraints

- **Length:** Maximum 3-5 sentences unless providing procedural information
- **Questions:** Always end with exactly ONE specific question to deepen conversation
- **No Bullet Points:** For emotional matters, use flowing prose instead of lists
- **Domain Boundaries:** Never provide clinical diagnoses, never recommend medication, never replace therapist advice

---

# 9. Core Features & Workflows

## 9.1 Journey Tracking

The journey tracking feature provides a structured system for documenting the child's developmental progress. It combines SwiftData persistence with a carefully designed UI that makes logging meaningful rather than burdensome.

### Stage-Based Curriculum

The application uses a stage-based curriculum system where each stage (1-5) contains five actionable steps. These steps are seeded into the database during onboarding based on the selected stage.

**Stage 1:** Early awareness and acceptance
**Stage 2:** Building foundational routines
**Stage 3:** Active therapy engagement
**Stage 4:** Social integration and inclusion
**Stage 5:** Long-term planning and future preparation

Each step includes a title and detailed description, providing parents with actionable tasks rather than vague goals.

### Progress Tracking

The Home screen displays progress indicators including:

- Months on journey
- Steps completed
- Days logged

This provides parents with concrete metrics of their efforts and the child's progress.

## 9.2 Resource Discovery

The Discover feature helps parents find relevant resources in their area, including:

**Therapist Search:**
- Search by therapy type (ABA, Occupational Therapy, Speech Therapy)
- Location-based results using Google Places API
- Therapist details including name, location, and contact information

**NGO Discovery:**
- Find local support organizations
- Access community resources

**Entitlements Information:**
- Government scheme information
- Application process guidance

## 9.3 Community Features

The Community tab represents a future feature area for parent-to-parent connection. While not fully implemented in the current MVP, the tab structure anticipates this functionality.

---

# 10. API Integrations

## 10.1 Groq API (AI)

**Purpose:** Power Mira's conversational intelligence  
**Model:** Llama-3.3-70b-versatile  
**Protocol:** Server-Sent Events (SSE) streaming  
**Endpoint:** https://api.groq.com/openai/v1/chat/completions

The Groq API was chosen for its fast inference times and cost-effective pricing. The streaming implementation ensures that Mira's responses feel natural and conversational.

**Implementation Details:**

- API keys managed through local Secrets.swift
- Automatic key rotation for quota management
- Streaming responses via AsyncThrowingStream
- Error handling with user-friendly messages

## 10.2 Google Places API (Discover)

**Purpose:** Find therapy centers and NGOs near the user  
**API Version:** Google Places API v1  
**Features:** Nearby search, text search

The Google Places API enables the Discover feature to surface real therapy centers and resources. Search results include place details, locations, and contact information.

**Implementation Details:**

- Async loading of place data
- Filter by therapy type
- Display of place details in cards with directions links

---

# 11. Project Structure

## 11.1 Directory Organization

```
Safe-Handz/
├── Safe_HandzApp.swift              # Application entry point
├── DesignSystem/
│   ├── Colors.swift                 # Color token definitions
│   ├── Fonts.swift                  # Typography helpers
│   └── Modifiers.swift              # Reusable view modifiers
├── Models/
│   ├── ChildProfile.swift           # SwiftData model
│   ├── JourneyLog.swift             # SwiftData model + MoodType
│   └── JourneyStep.swift            # SwiftData model
├── ViewModels/
│   ├── OnboardingViewModel.swift    # Onboarding flow logic
│   ├── HomeViewModel.swift          # Home screen logic
│   ├── LoggingViewModel.swift       # Logging ceremony logic
│   ├── AIViewModel.swift            # AI chat logic
│   └── DiscoverViewModel.swift      # Discovery logic
├── Views/
│   ├── ContentView.swift            # Main TabView container
│   ├── Onboarding/
│   │   └── OnboardingView.swift     # 6-screen onboarding
│   ├── Home/
│   │   ├── HomeView.swift           # Dashboard
│   │   ├── StepCard.swift           # Step display card
│   │   └── StepDetailView.swift     # Step details
│   ├── Logging/
│   │   ├── LoggingCeremonyView.swift # 6-phase ceremony
│   │   ├── MoodCard.swift           # Mood selection
│   │   └── RippleView.swift         # Animation
│   ├── AI/
│   │   └── AIView.swift             # Chat interface
│   ├── Discover/
│   │   ├── DiscoverView.swift       # Discovery main
│   │   ├── TherapistListView.swift  # List view
│   │   ├── TherapistDetailView.swift # Detail view
│   │   └── TherapistCard.swift      # Place card
│   └── Profile/
│       └── ProfileView.swift        # Profile management
├── Services/
│   ├── AnthropicService.swift       # AI streaming
│   ├── GooglePlacesService.swift    # Places API
│   └── AuthenticationService.swift  # Auth (future)
└── Assets.xcassets/                 # Images and colors
```

## 11.2 File Dependencies

Understanding file dependencies helps developers navigate the codebase and make changes confidently:

- **Safe_HandzApp.swift** → Entry point, sets up modelContainer
- **Colors.swift** → Foundation for all visual design
- **Fonts.swift** → Depends on Colors.swift
- **Modifiers.swift** → Depends on Colors.swift
- **ChildProfile.swift** → Core entity
- **JourneyLog.swift** → Depends on ChildProfile
- **JourneyStep.swift** → Depends on ChildProfile
- **ViewModels** → Depend on Models and Services
- **Views** → Depend on ViewModels and DesignSystem

---

# 12. Build Configuration

## 12.1 Xcode Project Setup

The Safe-Handz Xcode project is configured with specific settings to ensure successful builds:

- **Project Name:** Safe-Handz
- **Deployment Target:** iOS 17.0
- **Swift Version:** 6.0
- **Target Device:** iPhone only

## 12.2 Build Order

The application is built in defined phases to ensure dependencies are available:

**Phase 1: Foundation**

- Colors.swift
- Fonts.swift
- Modifiers.swift

**Phase 2: Data**

- ChildProfile.swift
- JourneyLog.swift
- JourneyStep.swift
- Update Safe_HandzApp.swift with modelContainer

**Phase 3: ViewModels**

- OnboardingViewModel.swift
- HomeViewModel.swift
- LoggingViewModel.swift
- AIViewModel.swift

**Phase 4: Services**

- AnthropicService.swift
- GooglePlacesService.swift

**Phase 5: Navigation**

- ContentView.swift

**Phase 6: Screens**

- All view files

## 12.3 Common Pitfalls

**SwiftData Integration:** Ensure @Model classes are properly configured with correct imports.

**Color Hex Initialization:** The Color(hex:) initializer must be available in Colors.swift before use.

**MoodType in Models:** MoodType used in @Model must be Codable.

**Streaming State:** ChatMessage.content must be a variable (var) not constant (let) because it's updated during streaming.

**Google Places Response:** Response has nested displayName.text structure requiring careful parsing.

---

# 13. Future Roadmap

## 13.1 Near-Term Enhancements

**AI Memory (RAG):** Implementing Retrieval-Augmented Generation to give Mira context across all historical JourneyLogs, addressing context window limitations for long-term usage.

**Cloud Sync:** Adding CloudKit or Firebase synchronization for cross-device access and backup.

**Real-Time Directory:** Connecting DiscoverView to live authorized therapy APIs (RCI verified only) rather than mock data.

## 13.2 Medium-Term Features

**Community:** Building parent-to-parent connection features including forums and peer support.

**Family Accounts:** Supporting multiple family members on one account.

**Therapist Communication:** Adding features for therapist-parent communication within the app.

## 13.3 Long-Term Vision

**AI Evolution:** Continuously improving Mira's capabilities through feedback and learning.

**Ecosystem Integration:** Expanding beyond India to support parents in other contexts.

**Research Partnership:** Anonymized, aggregated data could support autism research initiatives.

---

# 14. Conclusion

Safe-Handz represents a thoughtful approach to supporting parents of autistic children in India. By combining modern Swift development practices with deep understanding of the target audience's needs, the application provides genuine value in a challenging context.

The technical architecture—built on Swift 6, SwiftUI, and SwiftData—ensures the application is maintainable, modern, and ready for future enhancements. The design system creates a warm, non-clinical experience that respects users' emotional states. And Mira, the AI companion, provides contextual, emotionally intelligent support that goes beyond generic chatbot functionality.

For designers, Safe-Handz offers a model for creating warm, accessible applications without sacrificing functionality. For developers, it demonstrates how modern Apple technologies can be leveraged to build robust, type-safe applications.

The journey of building Safe-Handz is ongoing, but the foundation established in this master thesis provides clear guidance for the path ahead.

---

*Document Version: 1.0*  
*Last Updated: April 2026*  
*Project: Safe-Handz*  
*Purpose: Comprehensive Master Reference*