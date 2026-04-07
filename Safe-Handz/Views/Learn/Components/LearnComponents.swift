import SwiftUI

// MARK: - Progress Ring Component
struct LearningProgressCard: View {
    var completed: Int
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("\(completed) articles this week")
                    .font(SHFont.body(16))
                    .foregroundColor(Color.warmGrey)
            }
            Spacer()
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shSoftCard()
    }
}

// MARK: - Start Here Card (Big Hero Style)
struct StartHereCard: View {
    let title: String
    let subtitle: String
    let iconName: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                // Ensure text goes all the way
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(SHFont.serif(18))
                        .foregroundColor(Color.deepIndigo)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .font(.system(size: 12))
                        Text(subtitle)
                    }
                    .font(SHFont.medium(13))
                    .foregroundColor(Color.warmGrey)
                }
                Spacer(minLength: 0)
                
                Image(systemName: iconName)
                    .font(.system(size: 24))
                    .foregroundColor(Color.sageGreen)
                    .padding(12)
                    .background(Color.warmCream)
                    .clipShape(Circle())
            }
            .padding(20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        // Fixed white background, sageGreen left border
        .background(
            Color.white
                .overlay(
                    Rectangle()
                        .fill(Color.sageGreen)
                        .frame(width: 6),
                    alignment: .leading
                )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .shSoftCard()
    }
}

// MARK: - Recommendation / Article Row Card
struct ArticleRowCard: View {
    let article: Article
    
    // Choose a subtle brand background color based on the category
    private var categoryColor: Color {
        switch article.category {
        case .education: return Color.sageGreen.opacity(0.15)
        case .guide: return Color.terracotta.opacity(0.15)
        case .activities: return Color.softGreen.opacity(0.15)
        case .health: return Color.warmBrown.opacity(0.15)
        case .legal: return Color.warmShadow.opacity(0.15)
        }
    }
    
    var body: some View {
        HStack(spacing: 20) {
            // Soft image thumbnail replacing the stark white box
            categoryColor
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    Image(systemName: "book.pages")
                        .font(.title2)
                        .foregroundColor(Color.deepIndigo.opacity(0.7))
                )
            
            VStack(alignment: .leading, spacing: 8) {
                // Minimal Grayscale Category Pill
                Text(article.category.rawValue.uppercased())
                    .font(.system(size: 11, weight: .bold, design: .default))
                    .tracking(1.5)
                    .foregroundColor(Color.warmGrey)
                
                Text(article.title)
                    .font(SHFont.serif(18))
                    .foregroundColor(Color.deepIndigo)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true) // Prevents awkward truncation when possible
                
                HStack(spacing: 6) {
                    Image(systemName: "clock")
                        .font(.system(size: 11))
                    Text("\(article.readTime) min read")
                    Text("•").foregroundColor(Color.warmDivider)
                    Text(article.author)
                }
                .font(SHFont.medium(12))
                .foregroundColor(Color.warmGrey)
                .lineLimit(1)
            }
            
            Spacer(minLength: 0)
        }
        .padding(16)
        .background(Color.white)
        .shSoftCard()
    }
}

// MARK: - Category Pill Item (Replaces Grid Item)
struct CategoryGridItem: View {
    let category: ArticleCategory
    let iconName: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: iconName)
                .font(.system(size: 16))
                .foregroundColor(Color.deepIndigo)
            
            Text(category.rawValue)
                .font(SHFont.semibold(15))
                .foregroundColor(Color.deepIndigo)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(Color.white)
        .clipShape(Capsule())
        .shSoftCard() // Standardizes the shadow and removes the stroke
    }
}

#Preview {
    ZStack {
        Color.warmCream.ignoresSafeArea() 
        VStack(spacing: 16) {
            LearningProgressCard(completed: 3)
            
            VStack(spacing: 12) {
                StartHereCard(title: "Navigating the First Steps", subtitle: "5 min read", iconName: "book.fill")
                StartHereCard(title: "Sensory Processing Basics", subtitle: "3 min read", iconName: "heart.fill")
            }
            
            ArticleRowCard(article: MockLearnData.articles[0])
            ArticleRowCard(article: MockLearnData.articles[2])
            
            HStack {
                CategoryGridItem(category: .education, iconName: "book.closed")
                CategoryGridItem(category: .guide, iconName: "map")
            }
        }
        .padding()
    }
}
