import SwiftUI

struct EntitlementsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.warmCream.ignoresSafeArea()
            VStack(spacing: 16) {
                SHBackButton { dismiss() }
                    .frame(maxWidth: .infinity,
                           alignment: .leading)
                    .padding(.horizontal, 24)
                    .padding(.top, 56)
                Text("Aarav\u{2019}s Entitlements")
                    .font(SHFont.serifHeadline(28))
                    .foregroundColor(Color.deepIndigo)
                    .padding(.horizontal, 24)
                Spacer()
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    NavigationStack {
        EntitlementsView()
    }
}
