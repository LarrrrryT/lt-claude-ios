import SwiftUI

struct MessageInputView: View {
    @Binding var text: String
    let isLoading: Bool
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.blue)
                }
                
                TextField("Message Claude...", text: $text, axis: .vertical)
                    .textFieldStyle(.plain)
                    .lineLimit(1...5)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                
                if isLoading {
                    ProgressView()
                        .padding(8)
                } else {
                    Button(action: onSend) {
                        Image(systemName: text.isEmpty ? "arrow.up.circle" : "arrow.up.circle.fill")
                            .font(.title)
                            .foregroundColor(text.isEmpty ? .gray : .blue)
                    }
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    MessageInputView(
        text: .constant(""),
        isLoading: false,
        onSend: {}
    )
}
