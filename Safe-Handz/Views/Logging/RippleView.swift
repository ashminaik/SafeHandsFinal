import SwiftUI

struct RippleView: View {
    let startDate: Date

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = timeline.date
                    .timeIntervalSince(startDate)
                let center = CGPoint(
                    x: size.width / 2,
                    y: size.height / 2
                )
                let maxRadius = max(size.width, size.height) * 0.7

                // Draw 3 concentric ripples staggered in time
                for i in 0..<3 {
                    let delay = Double(i) * 0.15
                    let ringElapsed = elapsed - delay
                    guard ringElapsed > 0 else { continue }
                    let duration: Double = 0.9
                    let progress = min(ringElapsed / duration, 1.0)
                    let radius = maxRadius * progress
                    let opacity = (1.0 - progress) * 0.6

                    let rect = CGRect(
                        x: center.x - radius,
                        y: center.y - radius,
                        width: radius * 2,
                        height: radius * 2
                    )
                    context.opacity = opacity
                    context.stroke(
                        Path(ellipseIn: rect),
                        with: .color(Color.softGreen),
                        lineWidth: 1.5
                    )
                }
            }
        }
        .ignoresSafeArea()
    }
}
