import SwiftUI

@main
struct ClaudeApp: App {
    @StateObject private var chatManager = ChatManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(chatManager)
        }
    }
}
