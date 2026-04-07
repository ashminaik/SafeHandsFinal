import SwiftData
import Foundation

// MARK: - Journey Step

@Model
final class JourneyStep {
    var id: UUID
    var stepNumber: Int
    var stage: Int
    var title: String
    var detail: String
    var isCompleted: Bool
    var completedDate: Date?

    init(stepNumber: Int, stage: Int, title: String, detail: String) {
        self.id = UUID()
        self.stepNumber = stepNumber
        self.stage = stage
        self.title = title
        self.detail = detail
        self.isCompleted = false
    }
}

// MARK: - Step Content (Curriculum)

/// The step content for every stage.
/// This is the curriculum — hardcoded for MVP.
struct StepContent {
    static func steps(for stage: Int) -> [(number: Int, title: String, detail: String)] {
        switch stage {
        case 1:
            return [
                (1, "Get the diagnosis report", "Ask your doctor for a written copy of Aarav's diagnosis. You will need this for every service and school."),
                (2, "Find a certified therapist", "Look for a therapist certified in ABA, OT, or speech therapy. Ask your pediatrician for a referral."),
                (3, "Join a parent support group", "Connect with other parents at Stage 1. You are not alone in this."),
                (4, "Learn about government schemes", "Udaan, NIMH, and state disability boards offer free therapy support. Research what your state provides."),
                (5, "Create Aarav's communication board", "A simple picture board helps non-verbal children express basic needs.")
            ]
        case 2:
            return [
                (1, "Track therapy attendance", "Keep a record of every session — date, therapist, what was worked on."),
                (2, "Ask your therapist these 5 questions", "What are we working on this month? How will I know if it's working? What can I do at home?"),
                (3, "Set up a home routine", "Consistency at home reinforces what happens in therapy. Create a visual schedule for Aarav's day."),
                (4, "Apply for disability certificate", "A disability certificate unlocks government benefits, school accommodations, and financial support."),
                (5, "Start the Letter of Intent", "Begin documenting who Aarav is — for any future caregiver who loves him.")
            ]
        case 3:
            return [
                (1, "Ask your therapist the five questions", "What is Aarav working on this month? What does progress look like? What can I do at home to reinforce it?"),
                (2, "Document one thing Aarav did this week", "Write down one moment — big or small — that showed you something about who he is becoming."),
                (3, "Research your nearest special school", "Visit one special needs school near you. Ask about their approach, student-to-teacher ratio, and admission process."),
                (4, "Apply for Udaan scheme benefits", "The Udaan scheme provides free therapy support for children under 10 with developmental disabilities."),
                (5, "Build Aarav's sensory profile", "Document what calms Aarav, what overwhelms him, and what helps him regulate. Share this with his teachers.")
            ]
        case 4:
            return [
                (1, "Plan the school transition", "Research inclusive schools and special education programs. Begin the application process 6 months early."),
                (2, "Create an IEP document", "Work with Aarav's therapist to create an Individual Education Plan for his school."),
                (3, "Train a family member", "Teach one family member the techniques his therapist uses so therapy continues at home."),
                (4, "Connect with a disability lawyer", "Understand Aarav's legal rights under the Rights of Persons with Disabilities Act 2016."),
                (5, "Start future planning", "Begin thinking about Aarav's long-term care. The Letter of Intent is the foundation.")
            ]
        case 5:
            return [
                (1, "Review all therapy progress", "Request a comprehensive progress report from every therapist who has worked with Aarav."),
                (2, "Complete the Letter of Intent", "Finish all 9 sections of Aarav's guide — it is the most important document you will ever write."),
                (3, "Explore vocational training", "Research programs that help young autistic adults develop independent living and work skills."),
                (4, "Set up a special needs trust", "Consult a financial planner about protecting Aarav's future financial security."),
                (5, "Become a community mentor", "Your experience can help Stage 1 parents. Consider sharing what you've learned.")
            ]
        default:
            return []
        }
    }
}
