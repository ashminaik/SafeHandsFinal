import SwiftData
import Foundation

@Model
final class ChildProfile {
    var id: UUID
    var name: String
    var age: Int
    var stage: Int
    var primaryConcern: String
    var therapyType: String
    var city: String
    var oneLiner: String
    var journeyStartDate: Date

    @Relationship(deleteRule: .cascade)
    var logs: [JourneyLog] = []

    @Relationship(deleteRule: .cascade)
    var steps: [JourneyStep] = []

    init(name: String, age: Int, stage: Int, city: String) {
        self.id = UUID()
        self.name = name
        self.age = age
        self.stage = stage
        self.city = city
        self.primaryConcern = ""
        self.therapyType = ""
        self.oneLiner = ""
        self.journeyStartDate = Date()
    }

    var monthsOnJourney: Int {
        Calendar.current.dateComponents(
            [.month],
            from: journeyStartDate,
            to: Date()
        ).month ?? 0
    }
}
