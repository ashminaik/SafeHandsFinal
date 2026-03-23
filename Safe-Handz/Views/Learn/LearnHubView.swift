import SwiftUI
import SwiftData

struct LearnHubView: View {
    @State private var searchText = ""
    
    // We will populate this with SwiftData later. For now, using our Mock Data for UI layout.
    private var articles: [Article] = MockLearnData.articles
    
    // Quick in-memory filter for the search bar
    private var filteredArticles: [Article] {
        if searchText.isEmpty {
            return articles
        } else {
            return articles.filter { article in
                article.title.localizedStandardContains(searchText) ||
                article.tags.contains(where: { $0.localizedStandardContains(searchText) })
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color for the whole screen
                Color.warmCream
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 32) {
                        
                        // MARK: - Progress Ring Section
                        LearningProgressCard(completed: 3)
                            .padding(.horizontal)
                            .padding(.top, 16)
                        
                        // MARK: - Start Here Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("What would you like to understand?")
                                    .font(SHFont.serif(20))
                                    .foregroundColor(Color.deepIndigo)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                StartHereCard(
                                    title: "Navigating the First Steps",
                                    subtitle: "5 min read",
                                    iconName: "book.pages.fill"
                                )
                                StartHereCard(
                                    title: "Sensory Processing Basics",
                                    subtitle: "3 min read",
                                    iconName: "heart.fill"
                                )
                            }
                            .padding(.horizontal)
                        }
                        
                        // MARK: - Recommended For You Section
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                Text("✨ Recommended for You")
                                    .font(SHFont.serif(20))
                                    .foregroundColor(Color.deepIndigo)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 12) {
                                // Displaying the first two as "Recommended"
                                ForEach(filteredArticles.prefix(2), id: \.id) { article in
                                    NavigationLink(destination: ArticleDetailView(article: article)) {
                                        ArticleRowCard(article: article)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // MARK: - Browse By Category Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Browse by Category")
                                .font(SHFont.serif(20))
                                .foregroundColor(Color.deepIndigo)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    CategoryGridItem(category: .education, iconName: "book.closed.fill")
                                    CategoryGridItem(category: .guide, iconName: "map.fill")
                                    CategoryGridItem(category: .activities, iconName: "figure.play")
                                    CategoryGridItem(category: .health, iconName: "heart.text.square.fill")
                                    CategoryGridItem(category: .legal, iconName: "doc.text.fill")
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 20) // Give space for the drop shadow to render without clipping
                            }
                        }
                        
                        Spacer()
                            .frame(height: 40) // Bottom padding
                    }
                }
            }
            .navigationTitle("Learning Hub")
            .searchable(text: $searchText, prompt: "Search articles, guides, tips...")
            // Add a Bookmark button to the top right
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Action to view saved articles
                    }) {
                        Image(systemName: "bookmark")
                            .foregroundColor(Color.deepIndigo)
                    }
                }
            }
        }
    }
}

#Preview {
    LearnHubView()
}
