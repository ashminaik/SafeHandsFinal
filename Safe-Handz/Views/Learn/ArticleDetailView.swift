import SwiftUI
import SwiftData
import Combine

struct ArticleDetailView: View {
    @Bindable var article: Article
    
    @Environment(\.dismiss) private var dismiss
    
    // Tracking Mechanics
    @State private var timeSpent: TimeInterval = 0
    @State private var hasReachedBottom = false
    @State private var justCompleted = false // For the haptic/visual feedback
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    // Minimum 20% of estimated read time (in seconds) to register as read
    var minTimeRequired: TimeInterval {
        Double(article.readTime * 60) * 0.2
    }
    
    // Dynamic Header gradient logic based on category
    private var headerGradient: [Color] {
        switch article.category {
        case .education: return [Color.sageGreen.opacity(0.4), .clear]
        case .guide: return [Color.terracotta.opacity(0.4), .clear]
        case .activities: return [Color.softGreen.opacity(0.4), .clear]
        case .health: return [Color.warmBrown.opacity(0.3), .clear]
        case .legal: return [Color.warmShadow.opacity(0.4), .clear]
        }
    }
    
    var body: some View {
        ScrollView {
            // MARK: - Premium Editorial Header
            VStack(alignment: .leading, spacing: 0) {
                // High-Bleed Edge-to-Edge gradient header replacing plain whitespace
                ZStack(alignment: .bottomLeading) {
                    LinearGradient(
                        colors: headerGradient,
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 320)
                    
                    VStack(alignment: .leading, spacing: 12) {
                        Text(article.category.rawValue.uppercased())
                            .font(.system(size: 13, weight: .bold))
                            .tracking(2.5)
                            .foregroundColor(Color.deepIndigo.opacity(0.8))
                        
                        Text(article.title)
                            .font(SHFont.serif(36)) // Massive hero font
                            .foregroundColor(Color.deepIndigo)
                            .lineSpacing(2)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(24)
                    .padding(.bottom, 24) // Extra breathing room before meta
                }
                
                // Metadata Block
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color.warmShadow.opacity(0.2))
                        .frame(width: 40, height: 40)
                        .overlay(
                            Image(systemName: "person.fill")
                                .foregroundColor(Color.warmGrey)
                        )
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(article.author)
                            .font(SHFont.semibold(15))
                            .foregroundColor(Color.deepIndigo)
                        
                        HStack(spacing: 6) {
                            Text("\(article.readTime) min read")
                            Text("•")
                            Text("Updated Today")
                        }
                        .font(SHFont.medium(13))
                        .foregroundColor(Color.warmGrey)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, -12) // Overlaps naturally out of the gradient
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
                .padding(.horizontal, 24)
                .padding(.vertical, 32) // Extreme breathing room
            
            // MARK: - Markdown Body
            VStack(alignment: .leading, spacing: 24) { // Increased extreme spacing
                
                // Human Acknowledgement Line
                Text("Many parents come to this after a long night of searching. You're in the right place.")
                    .font(SHFont.serif(18).italic())
                    .foregroundColor(Color.warmBrown)
                    .lineSpacing(4)
                
                // Custom Safe-Handz Markdown rendering
                SHMarkdownView(markdown: article.markdownBody)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 60) // Extra slack at bottom
            .frame(maxWidth: .infinity, alignment: .leading)
            
            // MARK: - Completion Tracker Anchor
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        // When this bottom view appears on screen, they hit the bottom of the article
                        hasReachedBottom = true
                        checkCompletion()
                    }
                    .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                        hasReachedBottom = true
                        checkCompletion()
                    }
            }
            .frame(height: 40)
            
            if justCompleted {
                HStack {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(Color.softGreen)
                    Text("Article Completed!")
                        .font(SHFont.semibold(14))
                        .foregroundColor(Color.softGreen)
                }
                .padding()
                // Simple animation hook
                .transition(.scale.combined(with: .opacity))
            }
        }
        .ignoresSafeArea(edges: .top) // Let gradient bleed to top Notch
        .background(Color.warmCream.ignoresSafeArea())
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        // MARK: - Toolbar & Bookmarks
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.deepIndigo)
                        .padding(12)
                        .background(Color.white.opacity(0.85)) // Translucent for bleed-through
                        .clipShape(Circle())
                        .shadow(color: .black.opacity(0.06), radius: 8, y: 4)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    let impact = UIImpactFeedbackGenerator(style: .medium)
                    impact.impactOccurred()
                    article.isBookmarked.toggle()
                }) {
                    Image(systemName: article.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(article.isBookmarked ? article.category.color : Color.deepIndigo)
                }
            }
        }
        // MARK: - Timer Logic
        .onReceive(timer) { _ in
            if article.completionState != .completed {
                timeSpent += 1
                checkCompletion()
            }
        }
    }
    
    // MARK: - The "Read" trigger logic
    private func checkCompletion() {
        // If already completed, do nothing
        guard article.completionState != .completed else { return }
        
        // If they scrolled to bottom AND spent enough time reading
        if hasReachedBottom, timeSpent >= minTimeRequired {
            justCompleted = true
            article.completionState = .completed
            
            // Haptic Feedback for reward
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
            
            // Re-hide the completion label after 3 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    justCompleted = false
                }
            }
        }
    }
}

// SwiftUI Preview hook specifically for Bindable Data
#Preview {
    let mockArticle = MockLearnData.articles[0]
    return NavigationStack {
        ArticleDetailView(article: mockArticle)
    }
}
