import SwiftUI

struct StatusBarView: View {
    let connectionStatus: ConnectionStatus
    
    var body: some View {
        HStack {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(statusText)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Spacer()
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
    }
    
    var statusColor: Color {
        switch connectionStatus {
        case .connected: return .green
        case .disconnected: return .red
        case .connecting: return .yellow
        }
    }
    
    var statusText: String {
        switch connectionStatus {
        case .connected: return "Connected"
        case .disconnected: return "Disconnected"
        case .connecting: return "Connecting..."
        }
    }
}

#Preview {
    VStack {
        StatusBarView(connectionStatus: .connected)
        StatusBarView(connectionStatus: .disconnected)
        StatusBarView(connectionStatus: .connecting)
    }
}
