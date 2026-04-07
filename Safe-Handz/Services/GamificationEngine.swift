import Foundation
import SwiftData

struct GamificationEngine {
    
    // MARK: - Streak Tracker
    /// Validates the user's streak based on local timezone. Evaluates if a freeze is needed based on logs.
    static func evaluateStreak(
        currentStreak: Int,
        lastReadDate: Date?,
        recentLogs: [JourneyLog]
    ) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        guard let lastRead = lastReadDate else { return 0 }
        let lastReadDay = calendar.startOfDay(for: lastRead)
        
        let daysPassed = calendar.dateComponents([.day], from: lastReadDay, to: today).day ?? 0
        
        // If they read an article today, streak maintains
        if daysPassed == 0 { return currentStreak }
        
        // If it's been exactly one day, they maintained the streak beautifully
        if daysPassed == 1 { return currentStreak } // This assumes we already did currentStreak += 1 when they read it
        
        // If they missed a day, check for a valid freeze (did they log a Hard Day?)
        let missedDays = daysPassed - 1
        let freezesUsed = checkStressFreezes(from: lastReadDay, to: today, logs: recentLogs)
        
        // If the number of hard days logged covers the number of missed days, freeze the streak (preserve it).
        if freezesUsed >= missedDays {
            return currentStreak
        } else {
            // The grace period ran out.
            return 0
        }
    }
    
    // MARK: - Empathetic Freezes (The "Get Out of Jail Free" Card)
    /// Scans the JourneyLog to count how many "Hard Days" were logged during the missed window.
    private static func checkStressFreezes(from startDate: Date, to endDate: Date, logs: [JourneyLog]) -> Int {
        var freezeCount = 0
        
        // Filter purely to the dates between the last read and today
        let missingDateLogs = logs.filter { log in
            log.date >= startDate && log.date < endDate
        }
        
        // Count the high stress days
        for log in missingDateLogs {
            if log.mood == .hardDay {
                freezeCount += 1
            }
        }
        
        return freezeCount
    }
}
