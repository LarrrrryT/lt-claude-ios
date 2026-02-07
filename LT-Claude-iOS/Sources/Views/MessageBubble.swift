import SwiftUI

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if !message.isFromUser {
                    Text("Claude")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(message.content)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(message.isFromUser ? Color.blue : Color(.systemGray5))
                    .foregroundColor(message.isFromUser ? .white : .primary)
                    .cornerRadius(20)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !message.isFromUser {
                Spacer(minLength: 60)
            }
        }
    }
}

#Preview {
    VStack {
        MessageBubble(message: ChatMessage(content: "Hello!", isFromUser: true))
        MessageBubble(message: ChatMessage(content: "Hi there! How can I help you?", isFromUser: false))
    }
    .padding()
}
