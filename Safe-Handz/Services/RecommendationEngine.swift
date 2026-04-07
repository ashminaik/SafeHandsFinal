import Foundation
import SwiftData

struct RecommendationEngine {
    
    // MARK: - 1. Local Tag Intersection
    /// Examines the child profile and recent logs to find the most relevant articles locally.
    static func getLocalRecommendations(
        for profile: ChildProfile,
        recentLogs: [JourneyLog],
        catalog: [Article]
    ) -> [Article] {
        
        // 1. Build the User Need Vector (Weighted Tags)
        var userTags: [String: Double] = [:]
        
        // Base profile tags (Weight: 1.0)
        let profileTags = [
            profile.primaryConcern.lowercased(),
            profile.therapyType.lowercased(),
            "age-\(profile.age)"
        ].filter { !$0.isEmpty }
        
        for tag in profileTags {
            userTags[tag] = 1.0
        }
        
        // Recent log tags (High volatility, Weight: 3.0)
        // We only care about logs from the last 48 hours for immediate relevance
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date()
        let recentRelevantLogs = recentLogs.filter { $0.date > twoDaysAgo }
        
        for log in recentRelevantLogs {
            // Map moods to tags
            let moodTag = log.mood.rawValue
            // If they had a hard day, strongly favor giving them articles tagged "meltdown", "regulation", etc.
            if log.mood == .hardDay {
                userTags["meltdowns"] = (userTags["meltdowns"] ?? 0) + 3.0
                userTags["regulation"] = (userTags["regulation"] ?? 0) + 3.0
                userTags["health"] = (userTags["health"] ?? 0) + 2.0
            }
            userTags[moodTag] = (userTags[moodTag] ?? 0) + 2.0
        }
        
        // 2. Score the Catalog
        var scoredArticles: [(article: Article, score: Double)] = []
        
        for article in catalog {
            var score: Double = 0
            for tag in article.tags {
                if let weight = userTags[tag.lowercased()] {
                    score += weight
                }
            }
            // Add a tiny baseline score so zero-match articles still appear at the bottom
            scoredArticles.append((article, score))
        }
        
        // 3. Sort high-to-low and return top 10 candidates
        let sorted = scoredArticles.sorted { $0.score > $1.score }
        return sorted.prefix(10).map { $0.article }
    }
    
    // MARK: - 2. AI Semantic Ranking (Anthropic/Groq)
    /// Sends the top local matches to the LLM for deep contextual ranking based on the user's specific text notes.
    static func rankWithAI(
        candidates: [Article],
        profile: ChildProfile,
        recentLogs: [JourneyLog]
    ) async throws -> [Article] {
        
        // If there are less than 2 candidates, don't bother wasting an API call
        guard candidates.count > 1 else { return candidates }
        
        // 1. Build the Anonymized Context
        let recentNotes = recentLogs.prefix(3).map { "Mood: \($0.mood.displayName), Note: \($0.note)" }.joined(separator: " | ")
        let profileSummary = "Age: \(profile.age), Concern: \(profile.primaryConcern), Therapy: \(profile.therapyType)"
        
        // 2. Build the JSON Catalog for the prompt (Stripping markdown bodies to save context window)
        let catalogJSON = candidates.map {
            ["id": $0.id.uuidString, "title": $0.title, "tags": $0.tags.joined(separator: ",")]
        }
        let catalogData = try JSONSerialization.data(withJSONObject: catalogJSON, options: .prettyPrinted)
        let catalogString = String(data: catalogData, encoding: .utf8) ?? "[]"
        
        // 3. Construct the strict XML Prompt
        let systemPrompt = """
        You are an expert pediatric behavioral specialist. Your sole task is to rank a provided list of educational articles based on their immediate utility to a caregiver, given the child's profile and recent events. You must output ONLY a valid JSON array of ranked article UUIDs, and absolutely nothing else. No conversational filler.
        """
        
        let userPrompt = """
        <profile>\(profileSummary)</profile>
        <recent_logs>\(recentNotes)</recent_logs>
        <article_catalog>\(catalogString)</article_catalog>
        
        Output format required:
        [
          "UUID-1",
          "UUID-2"
        ]
        """
        
        // 4. Hit the Service (Noting that SafeHands currently aliases AnthropicService -> Groq LLaMA pipeline)
        let messages = [["role": "user", "content": userPrompt]]
        
        do {
            let stream = try await AnthropicService.stream(messages: messages, systemPrompt: systemPrompt)
            
            var fullResponse = ""
            for try await chunk in stream {
                fullResponse += chunk
            }
            
            // 5. Parse the JSON array from the response safely
            guard let data = fullResponse.data(using: .utf8),
                  let rankedUUIDStrings = try? JSONSerialization.jsonObject(with: data) as? [String] else {
                print("Failed to parse LLM ranking array. Falling back to local ranking.")
                return candidates // Fallback to local if LLM hallucinates
            }
            
            // 6. Reconstruct the sorted article array
            var rankedArticles: [Article] = []
            for uuidString in rankedUUIDStrings {
                if let uuid = UUID(uuidString: uuidString),
                   let matchedArticle = candidates.first(where: { $0.id == uuid }) {
                    rankedArticles.append(matchedArticle)
                }
            }
            
            // Append any articles the LLM dropped at the bottom
            for article in candidates where !rankedArticles.contains(where: { $0.id == article.id }) {
                rankedArticles.append(article)
            }
            
            return rankedArticles
            
        } catch {
            print("AI Ranking failed: \(error). Falling back to local ranking.")
            return candidates // Fallback to local if offline or API fails
        }
    }
}
