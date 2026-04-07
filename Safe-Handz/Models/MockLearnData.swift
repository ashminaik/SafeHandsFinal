import Foundation

struct MockLearnData {
    static let articles: [Article] = [
        Article(
            title: "Understanding Autism Spectrum Disorder",
            author: "Dr. Anjali Mehta",
            readTime: 8,
            category: .education,
            tags: ["asd", "basics", "diagnosis", "education"],
            markdownBody: """
            # Understanding Autism Spectrum Disorder
            
            Autism Spectrum Disorder (ASD) is a developmental condition that affects how a person communicates, interacts with others, and experiences the world around them.
            
            ## What is Autism?
            Autism is called a "spectrum" disorder because it affects people in different ways and to varying degrees. Some individuals may need significant support in their daily lives, while others may need less support and, in some cases, live entirely independently.
            
            ### Common Signs and Symptoms
            - Differences in social communication
            - Repetitive behaviors
            - Sensory sensitivities
            
            Remember, every child is unique and their journey will be their own.
            """,
            isBookmarked: false
        ),
        Article(
            title: "Communication Strategies for Non-Verbal Kids",
            author: "Rajesh Kumar",
            readTime: 6,
            category: .guide,
            tags: ["non-verbal", "communication", "speech", "guide"],
            markdownBody: """
            # Communication Strategies
            
            Finding ways to communicate with a non-verbal child requires patience and creativity. Here are some strategies you can implement at home...
            """,
            isBookmarked: false
        ),
        Article(
            title: "Sensory Integration Activities",
            author: "Sarah Jenkins, OT",
            readTime: 10,
            category: .activities,
            tags: ["sensory", "occupational-therapy", "play", "activities"],
            markdownBody: "Content for sensory integration activities...",
            isBookmarked: true
        ),
        Article(
            title: "Managing Meltdowns: A Parent's Guide",
            author: "Dr. Emily Chen",
            readTime: 7,
            category: .health,
            tags: ["meltdowns", "behavior", "regulation", "health"],
            markdownBody: "Content for managing and understanding meltdowns...",
            isBookmarked: false
        ),
        Article(
            title: "Understanding the IEP Process",
            author: "Legal Advocate Group",
            readTime: 12,
            category: .legal,
            tags: ["iep", "school", "rights", "legal"],
            markdownBody: "Content explaining the Individualized Education Program (IEP)...",
            isBookmarked: false
        )
    ]
}
