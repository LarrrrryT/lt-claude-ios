import Foundation
import Combine

enum ConnectionStatus {
    case connected
    case disconnected
    case connecting
}

struct ChatMessage: Identifiable, Equatable {
    let id: UUID
    let content: String
    let isFromUser: Bool
    let timestamp: Date
    
    init(id: UUID = UUID(), content: String, isFromUser: Bool, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.isFromUser = isFromUser
        self.timestamp = timestamp
    }
}

@MainActor
class ChatManager: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    @Published var isLoading: Bool = false
    @Published var connectionStatus: ConnectionStatus = .disconnected
    @Published var errorMessage: String?
    
    private let baseURL: String
    private var apiKey: String = ""
    
    init(baseURL: String = "https://your-api.railway.app") {
        self.baseURL = baseURL
        loadAPIKey()
    }
    
    private func loadAPIKey() {
        if let key = UserDefaults.standard.string(forKey: "claude_api_key"), !key.isEmpty {
            self.apiKey = key
            self.connectionStatus = .connected
        } else {
            self.connectionStatus = .disconnected
        }
    }
    
    func setAPIKey(_ key: String) {
        self.apiKey = key
        UserDefaults.standard.set(key, forKey: "claude_api_key")
        self.connectionStatus = key.isEmpty ? .disconnected : .connected
    }
    
    func sendMessage() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let userMessage = ChatMessage(content: trimmedText, isFromUser: true)
        messages.append(userMessage)
        inputText = ""
        isLoading = true
        
        Task {
            await fetchResponse(for: userMessage)
        }
    }
    
    private func fetchResponse(for message: ChatMessage) async {
        guard !apiKey.isEmpty else {
            errorMessage = "API key not set"
            isLoading = false
            return
        }
        
        // Build conversation context
        let conversation = messages.map { msg -> [String: Any] in
            return [
                "role": msg.isFromUser ? "user" : "assistant",
                "content": msg.content
            ]
        }
        
        guard let url = URL(string: "\(baseURL)/chat") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let body: [String: Any] = [
            "messages": conversation,
            "max_tokens": 1024,
            "temperature": 0.7
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorMessage = "Server error"
                isLoading = false
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let content = json["content"] as? String ?? json["message"] as? String {
                let assistantMessage = ChatMessage(content: content, isFromUser: false)
                messages.append(assistantMessage)
            } else {
                throw URLError(.badServerResponse)
            }
        } catch {
            errorMessage = error.localizedDescription
            let errorMessage = ChatMessage(
                content: "Sorry, I couldn't get a response. Please check your API key and try again.",
                isFromUser: false
            )
            messages.append(errorMessage)
        }
        
        isLoading = false
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}
