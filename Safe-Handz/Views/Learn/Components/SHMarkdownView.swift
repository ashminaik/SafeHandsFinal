import SwiftUI

struct SHMarkdownView: View {
    let markdown: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) { // Increased paragraph spacing
            let lines = markdown.components(separatedBy: .newlines)
            
            ForEach(0..<lines.count, id: \.self) { index in
                let line = lines[index].trimmingCharacters(in: .whitespaces)
                
                if line.hasPrefix("### ") {
                    Text(line.dropFirst(4).trimmingCharacters(in: .whitespaces))
                        .font(SHFont.semibold(20)) // Slightly larger
                        .foregroundColor(Color.deepIndigo)
                        .padding(.top, 12)
                        .tracking(0.3)
                } else if line.hasPrefix("## ") {
                    Text(line.dropFirst(3).trimmingCharacters(in: .whitespaces))
                        .font(SHFont.serif(24))
                        .foregroundColor(Color.deepIndigo)
                        .padding(.top, 20)
                        .lineSpacing(4)
                } else if line.hasPrefix("# ") {
                    Text(line.dropFirst(2).trimmingCharacters(in: .whitespaces))
                        .font(SHFont.serif(30))
                        .foregroundColor(Color.deepIndigo)
                        .padding(.top, 24)
                        .lineSpacing(6)
                } else if line.hasPrefix("- ") || line.hasPrefix("* ") {
                    HStack(alignment: .top, spacing: 12) {
                        Text("•")
                            .font(SHFont.body(18))
                            .foregroundColor(Color.warmShadow) // Calmer bullet color
                            .offset(y: -2)
                        
                        Text(line.dropFirst(2).trimmingCharacters(in: .whitespaces))
                            .font(SHFont.medium(17)) // More readable body
                            .foregroundColor(Color(hex: "4A4540")) // Darker grey for pure reading
                            .lineSpacing(8)
                    }
                    .padding(.leading, 8)
                } else if line.hasPrefix("> ") {
                    // Pull Quote implementation
                    HStack(spacing: 0) {
                        Rectangle()
                            .fill(Color.warmShadow)
                            .frame(width: 4)
                        
                        Text(line.dropFirst(2).trimmingCharacters(in: .whitespaces))
                            .font(SHFont.serif(18).italic())
                            .foregroundColor(Color.deepIndigo.opacity(0.8))
                            .lineSpacing(6)
                            .padding(.leading, 16)
                            .padding(.vertical, 8)
                    }
                    .padding(.vertical, 12)
                } else if !line.isEmpty {
                    Text(line)
                        .font(SHFont.medium(17)) // Taller base font
                        .foregroundColor(Color(hex: "4A4540")) // Optimum contrast, not pure black
                        .lineSpacing(10) // Extreme line spacing for cognitive comfort
                }
            }
        }
    }
}
