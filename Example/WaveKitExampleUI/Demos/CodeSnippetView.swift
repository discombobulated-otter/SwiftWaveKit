import SwiftUI

struct CodeSnippetView: View {
    let code: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Implementation")
                    .font(.system(.caption, design: .rounded))
                    .fontWeight(.bold)
                    .foregroundColor(.gray)
                Spacer()
                Image(systemName: "swift")
                    .foregroundColor(.orange)
            }
            
            Text(code)
                .font(.system(.footnote, design: .monospaced))
                .foregroundColor(Color(red: 0.9, green: 0.9, blue: 0.95))
                .multilineTextAlignment(.leading)
                .lineSpacing(6)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color.black.opacity(0.4))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(Color.white.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal, 20)
    }
}
