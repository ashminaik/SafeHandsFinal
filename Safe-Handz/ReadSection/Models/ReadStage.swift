import Foundation

struct ReadStage: Identifiable, Hashable {
    let id: Int
    let title: String
    let subtitle: String
}

extension ReadStage {
    static let all: [ReadStage] = [
        ReadStage(id: 1, title: "Just noticing signs", subtitle: "Understanding early signs and next steps"),
        ReadStage(id: 2, title: "Recently diagnosed", subtitle: "Navigating the first weeks and months"),
        ReadStage(id: 3, title: "Already in therapy", subtitle: "Making therapy work and supporting at home"),
        ReadStage(id: 4, title: "Planning for the future", subtitle: "Long-term care, school, and independence")
    ]
}
