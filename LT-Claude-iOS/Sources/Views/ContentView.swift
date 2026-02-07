import SwiftUI

struct ContentView: View {
    @EnvironmentObject var chatManager: ChatManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Status bar
                StatusBarView(connectionStatus: chatManager.connectionStatus)
                
                // Chat messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(chatManager.messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                        }
                        .padding()
                    }
                    .onChange(of: chatManager.messages.count) { _, _ in
                        if let lastMessage = chatManager.messages.last {
                            withAnimation {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input area
                MessageInputView(
                    text: $chatManager.inputText,
                    isLoading: chatManager.isLoading,
                    onSend: {
                        chatManager.sendMessage()
                    }
                )
            }
            .navigationTitle("Claude")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "gearshape")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "mic.circle")
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(ChatManager())
}
